`timescale 1ns/1ps
`default_nettype none

module main (
  input  wire        clk,
  input  wire        rst_n,

  input  wire        start,
  output wire        done,

  // X read port
  output reg  [8:0]  X_addr,
  input  wire [31:0] X_rdata,

  // Y read port
  output reg  [8:0]  Y_addr,
  input  wire [31:0] Y_rdata,

  // O write port
  output wire        O_we,
  output reg  [8:0]  O_addr,
  output reg  [31:0] O_wdata
);
  localparam int N = 300;

  // ------------------------------------------------------------
  // Big local buffers (resource-heavy, unoptimized)
  // Tools may infer BRAMs or lots of regs depending on settings.
  // ------------------------------------------------------------
  reg [31:0] Xbuf [0:N-1];
  reg [31:0] Ybuf [0:N-1];
  reg [31:0] Obuf [0:N-1];

  // ------------------------------------------------------------
  // ReLU for FP32 (synthesizable)
  // ------------------------------------------------------------
  function automatic [31:0] fp32_relu(input [31:0] x);
    logic sign;
    logic [7:0] exp;
    logic [22:0] frac;
    logic is_nan;
    begin
      sign = x[31];
      exp  = x[30:23];
      frac = x[22:0];
      is_nan = (exp == 8'hFF) && (frac != 0);

      if (is_nan)      fp32_relu = x;
      else if (sign)   fp32_relu = 32'h0000_0000;
      else             fp32_relu = x;
    end
  endfunction

  // ------------------------------------------------------------
  // FP32 adder IP wrapper (must be replaced/bound to vendor IP)
  // ------------------------------------------------------------
  localparam int ADD_LAT = 6; // deliberately longer to be "slow"

  reg         add_in_valid;
  reg  [31:0] add_a, add_b;
  wire        add_out_valid;
  wire [31:0] add_sum;

  fp32_add_ieee #(.LATENCY(ADD_LAT)) u_add (
    .clk       (clk),
    .rst_n     (rst_n),
    .in_valid  (add_in_valid),
    .a         (add_a),
    .b         (add_b),
    .out_valid (add_out_valid),
    .y         (add_sum)
  );

  // ------------------------------------------------------------
  // FSM (extra states for low Fmax, more registers)
  // ------------------------------------------------------------
  typedef enum logic [3:0] {
    S_IDLE        = 4'd0,

    // Stage 1: Read inputs into buffers
    S_RD_ADDR     = 4'd1,
    S_RD_CAPTURE  = 4'd2,
    S_RD_NEXT     = 4'd3,

    // Stage 2: Compute (buffered) into Obuf using FP adder
    S_EX_SETUP    = 4'd4,
    S_EX_LAUNCH   = 4'd5,
    S_EX_WAIT     = 4'd6,
    S_EX_STORE    = 4'd7,
    S_EX_NEXT     = 4'd8,

    // Stage 3: Write Obuf to output port
    S_WR_ADDR     = 4'd9,
    S_WR_DATA     = 4'd10,
    S_WR_NEXT     = 4'd11,

    S_DONE        = 4'd12
  } state_t;

  state_t st;

  reg [8:0] idx;

  // additional pipeline regs (wastes regs, helps timing)
  reg [31:0] x_r1, y_r1;
  reg [31:0] x_r2, y_r2;
  reg [31:0] sum_r1, sum_r2;
  reg [31:0] relu_r1, relu_r2;

  // Output controls
  assign O_we  = (st == S_WR_DATA);
  assign done  = (st == S_DONE);

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      st <= S_IDLE;
      idx <= 0;

      X_addr <= 0;
      Y_addr <= 0;

      O_addr <= 0;
      O_wdata <= 0;

      add_in_valid <= 0;
      add_a <= 0;
      add_b <= 0;

      x_r1 <= 0; y_r1 <= 0;
      x_r2 <= 0; y_r2 <= 0;
      sum_r1 <= 0; sum_r2 <= 0;
      relu_r1 <= 0; relu_r2 <= 0;
    end else begin
      // default
      add_in_valid <= 1'b0;

      case (st)
        // -------------------------
        S_IDLE: begin
          if (start) begin
            idx <= 0;
            st <= S_RD_ADDR;
          end
        end

        // -------------------------
        // Read X/Y into Xbuf/Ybuf
        // -------------------------
        S_RD_ADDR: begin
          X_addr <= idx;
          Y_addr <= idx;
          st <= S_RD_CAPTURE;
        end

        S_RD_CAPTURE: begin
          // extra regs for "slowness"
          x_r1 <= X_rdata;
          y_r1 <= Y_rdata;
          st <= S_RD_NEXT;
        end

        S_RD_NEXT: begin
          x_r2 <= x_r1;
          y_r2 <= y_r1;
          Xbuf[idx] <= x_r2;
          Ybuf[idx] <= y_r2;

          if (idx == N-1) begin
            idx <= 0;
            st <= S_EX_SETUP;
          end else begin
            idx <= idx + 1;
            st <= S_RD_ADDR;
          end
        end

        // -------------------------
        // Execute: Obuf[idx] = relu(Xbuf[idx] + Ybuf[idx])
        // -------------------------
        S_EX_SETUP: begin
          // stage regs (more latency)
          x_r1 <= Xbuf[idx];
          y_r1 <= Ybuf[idx];
          st <= S_EX_LAUNCH;
        end

        S_EX_LAUNCH: begin
          x_r2 <= x_r1;
          y_r2 <= y_r1;

          add_a <= x_r2;
          add_b <= y_r2;
          add_in_valid <= 1'b1;

          st <= S_EX_WAIT;
        end

        S_EX_WAIT: begin
          if (add_out_valid) begin
            sum_r1 <= add_sum;
            st <= S_EX_STORE;
          end
        end

        S_EX_STORE: begin
          sum_r2  <= sum_r1;
          relu_r1 <= fp32_relu(sum_r2);
          relu_r2 <= relu_r1;

          Obuf[idx] <= relu_r2;
          st <= S_EX_NEXT;
        end

        S_EX_NEXT: begin
          if (idx == N-1) begin
            idx <= 0;
            st <= S_WR_ADDR;
          end else begin
            idx <= idx + 1;
            st <= S_EX_SETUP;
          end
        end

        // -------------------------
        // Write Obuf back out
        // -------------------------
        S_WR_ADDR: begin
          O_addr <= idx;
          st <= S_WR_DATA;
        end

        S_WR_DATA: begin
          O_wdata <= Obuf[idx];
          st <= S_WR_NEXT;
        end

        S_WR_NEXT: begin
          if (idx == N-1) begin
            st <= S_DONE;
          end else begin
            idx <= idx + 1;
            st <= S_WR_ADDR;
          end
        end

        // -------------------------
        S_DONE: begin
          st <= S_IDLE;
        end

        default: st <= S_IDLE;
      endcase
    end
  end

endmodule


// ============================================================
// SYNTHESIZABLE FP32 ADDER BLACKBOX
// Bind/replace with vendor/library IP.
// ============================================================
module fp32_add_ieee #(
  parameter int LATENCY = 6
)(
  input  wire        clk,
  input  wire        rst_n,
  input  wire        in_valid,
  input  wire [31:0] a,
  input  wire [31:0] b,
  output wire        out_valid,
  output wire [31:0] y
);
  // Blackbox placeholder. Replace in your project.
  (* black_box *) wire _unused = clk ^ rst_n ^ in_valid ^ a[0] ^ b[0];
  assign out_valid = 1'b0;
  assign y         = 32'd0;
endmodule

`default_nettype wire

