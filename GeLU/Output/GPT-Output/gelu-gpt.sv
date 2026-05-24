`timescale 1ns/1ps

// ---------------------------------------------
// GELU FP32 (SIMULATION-ONLY approximation)
// Implements PyTorch tanh-based approx:
// 0.5*z*(1 + tanh(sqrt(2/pi) * (z + 0.044715*z^3)))
// ---------------------------------------------
module fp32_gelu_approx (
  input  wire        clk,
  input  wire        rst_n,
  input  wire        in_valid,
  input  wire [31:0] in_fp32,
  output reg         out_valid,
  output reg  [31:0] out_fp32
);
  // 1-cycle valid pipeline
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) out_valid <= 1'b0;
    else       out_valid <= in_valid;
  end

  // simulation-only math
  // synthesis translate_off
  real z, t, y;
  real c0, c1;
  initial begin
    c0 = 0.7978845608028654;  // sqrt(2/pi)
    c1 = 0.044715;
  end

  function real tanh_real(input real x);
    // tanh(x) = (e^x - e^-x)/(e^x + e^-x)
    real ex, enx;
    begin
      ex  = $pow(2.718281828459045, x);
      enx = $pow(2.718281828459045, -x);
      tanh_real = (ex - enx) / (ex + enx);
    end
  endfunction

  shortreal zs, ys;
  always @(posedge clk) begin
    if (in_valid) begin
      zs = $bitstoshortreal(in_fp32);
      z  = zs;

      // t = sqrt(2/pi)*(z + 0.044715*z^3)
      t = c0 * (z + c1 * z * z * z);

      // y = 0.5*z*(1 + tanh(t))
      y = 0.5 * z * (1.0 + tanh_real(t));

      ys = y;
      out_fp32 <= $shortrealtobits(ys);
    end
  end
  // synthesis translate_on
endmodule

// ---------------------------------------------
// FP32 add (SIMULATION-ONLY)
// ---------------------------------------------
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

// ---------------------------------------------
// Top kernel: out[idx] = gelu(x[idx] + y[idx])
// Shape: 1*3*10*10 = 300 entries
// Memory ports: X/Y read, O write, start/done
// ---------------------------------------------
module add_gelu_1x3x10x10_fp32 (
  input  wire clk,
  input  wire rst_n,

  input  wire start,
  output wire done,

  // X read port (300 entries)
  output reg  [8:0]  X_addr,
  input  wire [31:0] X_rdata,

  // Y read port (300 entries)
  output reg  [8:0]  Y_addr,
  input  wire [31:0] Y_rdata,

  // O write port (300 entries)
  output wire        O_we,
  output reg  [8:0]  O_addr,
  output reg  [31:0] O_wdata
);

  localparam integer N = 300;

  // index counter
  reg [8:0] idx;

  // FSM
  localparam [2:0]
    S_IDLE   = 3'd0,
    S_ISSUE  = 3'd1,
    S_ADD    = 3'd2,
    S_GELU   = 3'd3,
    S_WRITE  = 3'd4,
    S_DONE   = 3'd5;

  reg [2:0] st;

  // FP units
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

  reg        gelu_valid;
  reg [31:0] gelu_in;
  wire       gelu_out_valid;
  wire [31:0] gelu_out;

  fp32_gelu_approx u_gelu (
    .clk(clk), .rst_n(rst_n),
    .in_valid(gelu_valid),
    .in_fp32(gelu_in),
    .out_valid(gelu_out_valid),
    .out_fp32(gelu_out)
  );

  // single-driver O_we and done
  assign O_we = (st == S_WRITE);
  assign done = (st == S_DONE);

  // drive FP inputs
  always @* begin
    add_valid  = 1'b0;
    add_a      = 32'd0;
    add_b      = 32'd0;

    gelu_valid = 1'b0;
    gelu_in    = 32'd0;

    if (st == S_ADD) begin
      add_valid = 1'b1;
      add_a     = X_rdata;
      add_b     = Y_rdata;
    end

    if (st == S_GELU) begin
      gelu_valid = 1'b1;
      gelu_in    = add_y;
    end
  end

  // control
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      st     <= S_IDLE;
      idx    <= 9'd0;

      X_addr <= 9'd0;
      Y_addr <= 9'd0;

      O_addr <= 9'd0;
      O_wdata<= 32'd0;
    end else begin
      case (st)
        S_IDLE: begin
          if (start) begin
            idx <= 9'd0;
            st  <= S_ISSUE;
          end
        end

        // present addresses (assume 1-cycle mem read in practice; for sim it’s fine)
        S_ISSUE: begin
          X_addr <= idx;
          Y_addr <= idx;
          st     <= S_ADD;
        end

        S_ADD: begin
          st <= S_GELU;
        end

        S_GELU: begin
          st <= S_WRITE;
        end

        S_WRITE: begin
          O_addr  <= idx;
          O_wdata <= gelu_out;

          if (idx == N-1) begin
            st <= S_DONE;
          end else begin
            idx <= idx + 9'd1;
            st  <= S_ISSUE;
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
