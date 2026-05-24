`timescale 1ns/1ps

// ============================================================
// main: Fixed-point GELU polynomial (pure RTL, synthesizable)
// Implements: y = 0.5*x + 0.3989*x^2 + 0.0357*x^3
// Data format: signed Q16.16 in 32-bit words
// Tensor size: 300 elements (1*3*10*10)
// ============================================================
module main #(
  parameter int N = 300,
  parameter int FRAC = 16  // Q16.16
)(
  input  logic        clk,
  input  logic        rst_n,

  input  logic        start,
  output logic        done,

  // X read port
  output logic [8:0]  X_addr,
  input  logic [31:0] X_rdata,

  // Z write port
  output logic        Z_we,
  output logic [8:0]  Z_addr,
  output logic [31:0] Z_wdata
);

  // Q16.16 constants
  localparam logic signed [31:0] A_Q = 32'sd32768; // 0.5
  localparam logic signed [31:0] B_Q = 32'sd26143; // 0.3989
  localparam logic signed [31:0] C_Q = 32'sd2333;  // 0.0357

  typedef enum logic [3:0] {
    S_IDLE   = 4'd0,
    S_ADDR   = 4'd1,
    S_CAP    = 4'd2,
    S_X2     = 4'd3,
    S_X3     = 4'd4,
    S_AX     = 4'd5,
    S_BX2    = 4'd6,
    S_CX3    = 4'd7,
    S_SUM1   = 4'd8,
    S_SUM2   = 4'd9,
    S_WRITE  = 4'd10,
    S_DONE   = 4'd11
  } state_t;

  state_t st;
  logic [8:0] idx;

  // Fixed-point intermediates in Q16.16
  logic signed [31:0] x, x2, x3;
  logic signed [31:0] ax, bx2, cx3;
  logic signed [31:0] sum1, y;

  // Multiply helper: (Q16.16 * Q16.16) -> Q16.16 with rounding
  function automatic logic signed [31:0] qmul_q16_16(
    input logic signed [31:0] p,
    input logic signed [31:0] q
  );
    logic signed [63:0] prod;
    logic signed [63:0] rounded;
    begin
      prod = $signed(p) * $signed(q); // Q32.32
      // rounding: add 0.5 ulp at FRAC bit
      rounded = prod + (64'sd1 <<< (FRAC-1));
      qmul_q16_16 = $signed(rounded >>> FRAC); // back to Q16.16
    end
  endfunction

  // Saturating add helper (to 32-bit signed)
  function automatic logic signed [31:0] sat_add32(
    input logic signed [31:0] a,
    input logic signed [31:0] b
  );
    logic signed [32:0] s;
    begin
      s = $signed({a[31],a}) + $signed({b[31],b});
      if (s > 33'sd2147483647) sat_add32 = 32'sd2147483647;
      else if (s < -33'sd2147483648) sat_add32 = -32'sd2147483648;
      else sat_add32 = s[31:0];
    end
  endfunction

  // Defaults
  always_comb begin
    done   = 1'b0;
    Z_we   = 1'b0;
    Z_addr = idx;
    Z_wdata= y;

    case (st)
      S_WRITE: begin
        Z_we    = 1'b1;
        Z_addr  = idx;
        Z_wdata = y;
      end
      S_DONE: begin
        done = 1'b1; // 1-cycle pulse
      end
      default: begin end
    endcase
  end

  // Control / datapath
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      st     <= S_IDLE;
      idx    <= 9'd0;
      X_addr <= 9'd0;

      x   <= '0; x2  <= '0; x3  <= '0;
      ax  <= '0; bx2 <= '0; cx3 <= '0;
      sum1<= '0; y   <= '0;
    end else begin
      case (st)
        S_IDLE: begin
          if (start) begin
            idx    <= 9'd0;
            X_addr <= 9'd0;
            st     <= S_ADDR;
          end
        end

        // Present X address (assume 1-cycle read latency)
        S_ADDR: begin
          X_addr <= idx;
          st     <= S_CAP;
        end

        // Capture x
        S_CAP: begin
          x  <= $signed(X_rdata);
          st <= S_X2;
        end

        // x2 = x*x
        S_X2: begin
          x2 <= qmul_q16_16(x, x);
          st <= S_X3;
        end

        // x3 = x2*x
        S_X3: begin
          x3 <= qmul_q16_16(x2, x);
          st <= S_AX;
        end

        // ax = a*x
        S_AX: begin
          ax <= qmul_q16_16(A_Q, x);
          st <= S_BX2;
        end

        // bx2 = b*x2
        S_BX2: begin
          bx2 <= qmul_q16_16(B_Q, x2);
          st  <= S_CX3;
        end

        // cx3 = c*x3
        S_CX3: begin
          cx3 <= qmul_q16_16(C_Q, x3);
          st  <= S_SUM1;
        end

        // sum1 = ax + bx2
        S_SUM1: begin
          sum1 <= sat_add32(ax, bx2);
          st   <= S_SUM2;
        end

        // y = sum1 + cx3
        S_SUM2: begin
          y  <= sat_add32(sum1, cx3);
          st <= S_WRITE;
        end

        S_WRITE: begin
          if (idx == N-1) st <= S_DONE;
          else begin
            idx <= idx + 9'd1;
            st  <= S_ADDR;
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

