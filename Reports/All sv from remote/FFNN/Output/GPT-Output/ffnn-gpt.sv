`timescale 1ns/1ps

// -------------------------
// FP32 ReLU (Icarus-friendly)
// -------------------------
module fp32_relu (
  input  wire [31:0] in_fp32,
  output reg  [31:0] out_fp32
);
  reg sign;
  reg [7:0] exp;
  reg [22:0] frac;
  reg is_nan;

  always @* begin
    sign   = in_fp32[31];
    exp    = in_fp32[30:23];
    frac   = in_fp32[22:0];
    is_nan = (exp == 8'hFF) && (frac != 23'd0);

    if (is_nan)        out_fp32 = in_fp32;        // propagate NaN
    else if (sign)     out_fp32 = 32'h0000_0000;  // negative -> +0.0
    else               out_fp32 = in_fp32;        // positive -> unchanged
  end
endmodule

// -------------------------------------------------
// FP32 add stub (SIMULATION-ONLY)
// -------------------------------------------------
module fp32_add (
  input  wire        clk,
  input  wire        rst_n,
  input  wire        in_valid,
  input  wire [31:0] a,
  input  wire [31:0] b,
  output reg         out_valid,
  output reg  [31:0] y
);
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) out_valid <= 1'b0;
    else       out_valid <= in_valid;
  end

  // synthesis translate_off
  shortreal ar, br, yr;
  always @(posedge clk) begin
    if (in_valid) begin
      ar = $bitstoshortreal(a);
      br = $bitstoshortreal(b);
      yr = ar + br;
      y  <= $shortrealtobits(yr);
    end
  end
  // synthesis translate_on
endmodule

// -------------------------------------------------
// FP32 mul stub (SIMULATION-ONLY)
// -------------------------------------------------
module fp32_mul (
  input  wire        clk,
  input  wire        rst_n,
  input  wire        in_valid,
  input  wire [31:0] a,
  input  wire [31:0] b,
  output reg         out_valid,
  output reg  [31:0] y
);
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) out_valid <= 1'b0;
    else       out_valid <= in_valid;
  end

  // synthesis translate_off
  shortreal ar, br, yr;
  always @(posedge clk) begin
    if (in_valid) begin
      ar = $bitstoshortreal(a);
      br = $bitstoshortreal(b);
      yr = ar * br;
      y  <= $shortrealtobits(yr);
    end
  end
  // synthesis translate_on
endmodule

// -------------------------------------------------
// Top: FFNN 64 -> 48 -> 4 with ReLU between
//
// X: [48,64] fp32  (3072 entries)
// W1: [48,64] fp32 (3072 entries)
// b1: [48]    fp32
// W2: [4,48]  fp32 (192 entries)
// b2: [4]     fp32
//
// Scratch H1: [48,48] fp32 (2304 entries), 1R/1W
// Y: [48,4] fp32 (192 entries), write-only
// -------------------------------------------------
module ffnn_64_48_4_fp32 (
  input  wire clk,
  input  wire rst_n,

  input  wire start,
  output wire done,

  // X read
  output reg  [11:0] X_addr,
  input  wire [31:0] X_rdata,

  // W1 read
  output reg  [11:0] W1_addr,
  input  wire [31:0] W1_rdata,

  // b1 read
  output reg  [5:0]  b1_addr,
  input  wire [31:0] b1_rdata,

  // W2 read
  output reg  [7:0]  W2_addr,
  input  wire [31:0] W2_rdata,

  // b2 read
  output reg  [2:0]  b2_addr,
  input  wire [31:0] b2_rdata,

  // H1 scratch (1R/1W)
  output reg  [11:0] H1_raddr,
  input  wire [31:0] H1_rdata,
  output wire        H1_we,
  output reg  [11:0] H1_waddr,
  output reg  [31:0] H1_wdata,

  // Y output
  output wire        Y_we,
  output reg  [7:0]  Y_addr,
  output reg  [31:0] Y_wdata
);

  localparam integer BATCH = 48;
  localparam integer IN    = 64;
  localparam integer HID   = 48;
  localparam integer OUT   = 4;

  // indices
  reg [5:0] n;     // 0..47
  reg [5:0] o;     // 0..47 (or 0..3 in layer2)
  reg [6:0] k;     // 0..63 / 0..47

  // accumulator in fp32 bits
  reg [31:0] acc;

  // mul/add pipeline (1-cycle each for template scheduling)
  reg        mul_valid;
  reg [31:0] mul_a, mul_b;
  wire       mul_out_valid;
  wire [31:0] mul_y;

  fp32_mul u_mul (
    .clk(clk), .rst_n(rst_n),
    .in_valid(mul_valid),
    .a(mul_a), .b(mul_b),
    .out_valid(mul_out_valid),
    .y(mul_y)
  );

  reg        add_valid;
  reg [31:0] add_a, add_b;
  wire       add_out_valid;
  wire [31:0] add_y;

  fp32_add u_add (
    .clk(clk), .rst_n(rst_n),
    .in_valid(add_valid),
    .a(add_a), .b(add_b),
    .out_valid(add_out_valid),
    .y(add_y)
  );

  wire [31:0] relu_y;
  fp32_relu u_relu (.in_fp32(add_y), .out_fp32(relu_y));

  // write enables (single driver!)
  assign H1_we = (st == S_L1_WRITE_H1);
  assign Y_we  = (st == S_L2_WRITE_Y);
  assign done  = (st == S_DONE);

  // address helpers (row-major)
  function [11:0] addr_x;
    input [5:0] n_;
    input [6:0] k_;
    begin addr_x = n_*IN + k_; end // 48*64=3072
  endfunction
  function [11:0] addr_w1;
    input [5:0] o_;
    input [6:0] k_;
    begin addr_w1 = o_*IN + k_; end // 48*64=3072
  endfunction
  function [11:0] addr_h1;
    input [5:0] n_;
    input [5:0] o_;
    begin addr_h1 = n_*HID + o_; end // 48*48=2304
  endfunction
  function [7:0] addr_w2;
    input [2:0] o2_;
    input [5:0] k_;
    begin addr_w2 = o2_*HID + k_; end // 4*48=192
  endfunction
  function [7:0] addr_y;
    input [5:0] n_;
    input [2:0] o2_;
    begin addr_y = n_*OUT + o2_; end // 48*4=192
  endfunction

  // FSM
  localparam [4:0]
    S_IDLE        = 5'd0,

    // layer1 dot + bias + relu -> H1
    S_L1_INIT     = 5'd1,
    S_L1_ISSUE    = 5'd2,
    S_L1_MUL      = 5'd3,
    S_L1_ADD      = 5'd4,
    S_L1_NEXTK    = 5'd5,
    S_L1_BIAS_RD  = 5'd6,
    S_L1_BIAS_ADD = 5'd7,
    S_L1_WRITE_H1 = 5'd8,

    // layer2 dot + bias -> Y (relu NOT here in your earlier FFNN; if you want relu at end, say so)
    S_L2_INIT     = 5'd9,
    S_L2_ISSUE    = 5'd10,
    S_L2_MUL      = 5'd11,
    S_L2_ADD      = 5'd12,
    S_L2_NEXTK    = 5'd13,
    S_L2_BIAS_RD  = 5'd14,
    S_L2_BIAS_ADD = 5'd15,
    S_L2_WRITE_Y  = 5'd16,

    S_DONE        = 5'd17;

  reg [4:0] st;

  // drive mul/add controls (single always @* with defaults)
  always @* begin
    mul_valid = 1'b0;
    mul_a     = 32'd0;
    mul_b     = 32'd0;

    add_valid = 1'b0;
    add_a     = 32'd0;
    add_b     = 32'd0;

    // multiply stage
    if (st == S_L1_MUL) begin
      mul_valid = 1'b1;
      mul_a     = X_rdata;
      mul_b     = W1_rdata;
    end else if (st == S_L2_MUL) begin
      mul_valid = 1'b1;
      mul_a     = H1_rdata;
      mul_b     = W2_rdata;
    end

    // add stage: acc + mul_y
    if (st == S_L1_ADD || st == S_L2_ADD) begin
      add_valid = 1'b1;
      add_a     = acc;
      add_b     = mul_y;
    end

    // bias add stage: acc + bias
    if (st == S_L1_BIAS_ADD) begin
      add_valid = 1'b1;
      add_a     = acc;
      add_b     = b1_rdata;
    end else if (st == S_L2_BIAS_ADD) begin
      add_valid = 1'b1;
      add_a     = acc;
      add_b     = b2_rdata;
    end
  end

  // sequential control
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      st <= S_IDLE;

      n <= 0; o <= 0; k <= 0;
      acc <= 32'h0000_0000; // +0.0

      X_addr <= 0; W1_addr <= 0; b1_addr <= 0;
      H1_raddr <= 0; H1_waddr <= 0; H1_wdata <= 0;

      W2_addr <= 0; b2_addr <= 0;
      Y_addr <= 0; Y_wdata <= 0;
    end else begin
      case (st)
        S_IDLE: begin
          if (start) begin
            n <= 0;
            st <= S_L1_INIT;
          end
        end

        // ---------------- Layer 1: H1 = relu(X*W1^T + b1) ----------------
        S_L1_INIT: begin
          o <= 0;
          k <= 0;
          acc <= 32'h0000_0000; // +0.0
          st <= S_L1_ISSUE;
        end

        S_L1_ISSUE: begin
          X_addr  <= addr_x(n, k);
          W1_addr <= addr_w1(o, k);
          st <= S_L1_MUL;
        end

        S_L1_MUL: begin
          st <= S_L1_ADD;
        end

        S_L1_ADD: begin
          acc <= add_y;     // acc += X*W1
          st <= S_L1_NEXTK;
        end

        S_L1_NEXTK: begin
          if (k == IN-1) st <= S_L1_BIAS_RD;
          else begin
            k <= k + 1;
            st <= S_L1_ISSUE;
          end
        end

        S_L1_BIAS_RD: begin
          b1_addr <= o[5:0];
          st <= S_L1_BIAS_ADD;
        end

        S_L1_BIAS_ADD: begin
          acc <= add_y;   // acc + b1
          st <= S_L1_WRITE_H1;
        end

        S_L1_WRITE_H1: begin
          H1_waddr <= addr_h1(n, o);
          H1_wdata <= relu_y;

          if (o == HID-1) begin
            if (n == BATCH-1) begin
              n <= 0;
              st <= S_L2_INIT;
            end else begin
              n <= n + 1;
              st <= S_L1_INIT;
            end
          end else begin
            o <= o + 1;
            k <= 0;
            acc <= 32'h0000_0000;
            st <= S_L1_ISSUE;
          end
        end

        // ---------------- Layer 2: Y = H1*W2^T + b2 ----------------
        S_L2_INIT: begin
          o <= 0;  // use o[2:0] for 0..3
          k <= 0;
          acc <= 32'h0000_0000;
          st <= S_L2_ISSUE;
        end

        S_L2_ISSUE: begin
          H1_raddr <= addr_h1(n, k[5:0]);      // H1[n,k]
          W2_addr  <= addr_w2(o[2:0], k[5:0]); // W2[o2,k]
          st <= S_L2_MUL;
        end

        S_L2_MUL: begin
          st <= S_L2_ADD;
        end

        S_L2_ADD: begin
          acc <= add_y;
          st <= S_L2_NEXTK;
        end

        S_L2_NEXTK: begin
          if (k == HID-1) st <= S_L2_BIAS_RD;
          else begin
            k <= k + 1;
            st <= S_L2_ISSUE;
          end
        end

        S_L2_BIAS_RD: begin
          b2_addr <= o[2:0];
          st <= S_L2_BIAS_ADD;
        end

        S_L2_BIAS_ADD: begin
          acc <= add_y;
          st <= S_L2_WRITE_Y;
        end

        S_L2_WRITE_Y: begin
          Y_addr  <= addr_y(n, o[2:0]);
          Y_wdata <= acc;

          if (o[2:0] == OUT-1) begin
            if (n == BATCH-1) st <= S_DONE;
            else begin
              n <= n + 1;
              st <= S_L2_INIT;
            end
          end else begin
            o <= o + 1;
            k <= 0;
            acc <= 32'h0000_0000;
            st <= S_L2_ISSUE;
          end
        end

        S_DONE: begin
          st <= S_IDLE;
        end

        default: st <= S_IDLE;
      endcase
    end
  end

endmodule
