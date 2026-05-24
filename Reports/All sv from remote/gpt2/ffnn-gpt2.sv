`timescale 1ns/1ps

// ============================================================
// FP32 ReLU (combinational; NaN passthrough)
// ============================================================
module fp32_relu (
  input  logic [31:0] in_fp32,
  output logic [31:0] out_fp32
);
  logic sign;
  logic [7:0] exp;
  logic [22:0] frac;
  logic is_nan;

  always_comb begin
    sign   = in_fp32[31];
    exp    = in_fp32[30:23];
    frac   = in_fp32[22:0];
    is_nan = (exp == 8'hFF) && (frac != 23'd0);

    if (is_nan)    out_fp32 = in_fp32;
    else if (sign) out_fp32 = 32'h0000_0000;
    else           out_fp32 = in_fp32;
  end
endmodule

// ============================================================
// Synthesizable FP32 multiply (simplified IEEE-754)
// - denormals flushed to zero
// - rounding = truncation
// - NaN/Inf/Zero handled
// 1-cycle latency with in_valid/out_valid
// ============================================================
module fp32_mul_synth (
  input  logic        clk,
  input  logic        reset,     // active-high
  input  logic        in_valid,
  input  logic [31:0] a,
  input  logic [31:0] b,
  output logic        out_valid,
  output logic [31:0] y
);
  // unpack
  logic sa, sb;
  logic [7:0] ea, eb;
  logic [22:0] fa, fb;

  logic a_is_zero, b_is_zero, a_is_inf, b_is_inf, a_is_nan, b_is_nan;
  logic a_is_den,  b_is_den;

  logic s;
  logic [8:0] e_sum;
  logic [23:0] ma, mb;
  logic [47:0] m_prod;
  logic [23:0] m_norm;

  logic [31:0] y_next;
  logic v_next;

  always_comb begin
    sa = a[31]; ea = a[30:23]; fa = a[22:0];
    sb = b[31]; eb = b[30:23]; fb = b[22:0];

    a_is_nan  = (ea == 8'hFF) && (fa != 0);
    b_is_nan  = (eb == 8'hFF) && (fb != 0);
    a_is_inf  = (ea == 8'hFF) && (fa == 0);
    b_is_inf  = (eb == 8'hFF) && (fb == 0);
    a_is_zero = (ea == 0) && (fa == 0);
    b_is_zero = (eb == 0) && (fb == 0);
    a_is_den  = (ea == 0) && (fa != 0);
    b_is_den  = (eb == 0) && (fb != 0);

    // flush denormals to zero
    if (a_is_den) a_is_zero = 1'b1;
    if (b_is_den) b_is_zero = 1'b1;

    y_next = 32'h0000_0000;
    v_next = in_valid;

    if (a_is_nan) begin
      y_next = a;
    end else if (b_is_nan) begin
      y_next = b;
    end else if ((a_is_inf && b_is_zero) || (b_is_inf && a_is_zero)) begin
      y_next = 32'h7FC0_0000; // NaN
    end else if (a_is_inf || b_is_inf) begin
      y_next = {sa ^ sb, 8'hFF, 23'd0}; // inf
    end else if (a_is_zero || b_is_zero) begin
      y_next = 32'h0000_0000;
    end else begin
      s = sa ^ sb;
      ma = {1'b1, fa};
      mb = {1'b1, fb};

      e_sum  = {1'b0, ea} + {1'b0, eb} - 9'd127;
      m_prod = ma * mb;

      if (m_prod[47]) begin
        m_norm = m_prod[47:24];
        e_sum  = e_sum + 9'd1;
      end else begin
        m_norm = m_prod[46:23];
      end

      if (e_sum[8] || (e_sum <= 9'd0)) begin
        y_next = 32'h0000_0000; // underflow
      end else if (e_sum >= 9'd255) begin
        y_next = {s, 8'hFF, 23'd0}; // overflow -> inf
      end else begin
        y_next = {s, e_sum[7:0], m_norm[22:0]};
      end
    end
  end

  always_ff @(posedge clk) begin
    if (reset) begin
      out_valid <= 1'b0;
      y         <= 32'h0000_0000;
    end else begin
      out_valid <= v_next;
      y         <= y_next;
    end
  end
endmodule

// ============================================================
// Synthesizable FP32 add (simplified IEEE-754)
// - denormals flushed to zero
// - rounding = truncation
// - NaN/Inf/Zero handled
// 1-cycle latency with in_valid/out_valid
// Vivado-safe: no 'int unsigned', no expression part-select, no disable
// ============================================================
module fp32_add_synth (
  input  logic        clk,
  input  logic        reset,     // active-high
  input  logic        in_valid,
  input  logic [31:0] a,
  input  logic [31:0] b,
  output logic        out_valid,
  output logic [31:0] y
);
  // unpack
  logic sa, sb;
  logic [7:0] ea, eb;
  logic [22:0] fa, fb;

  logic a_is_zero, b_is_zero, a_is_inf, b_is_inf, a_is_nan, b_is_nan;
  logic a_is_den,  b_is_den;

  // ordered big/small
  logic s_big, s_small;
  logic [7:0] e_big, e_small;
  logic [23:0] m_big, m_small;

  logic [24:0] m_small_shifted;
  logic [24:0] m_sum;
  logic s_out;
  logic [7:0] e_out;

  logic [24:0] tmp25;
  logic [23:0] m_out24;

  // Vivado-friendly loop vars
  integer i;
  integer shift_i;
  integer msb_i;
  integer shl_i;
  logic   found;

  logic [31:0] y_next;
  logic        v_next;

  always_comb begin
    sa = a[31]; ea = a[30:23]; fa = a[22:0];
    sb = b[31]; eb = b[30:23]; fb = b[22:0];

    a_is_nan  = (ea == 8'hFF) && (fa != 0);
    b_is_nan  = (eb == 8'hFF) && (fb != 0);
    a_is_inf  = (ea == 8'hFF) && (fa == 0);
    b_is_inf  = (eb == 8'hFF) && (fb == 0);
    a_is_zero = (ea == 0) && (fa == 0);
    b_is_zero = (eb == 0) && (fb == 0);
    a_is_den  = (ea == 0) && (fa != 0);
    b_is_den  = (eb == 0) && (fb != 0);

    // flush denormals to zero
    if (a_is_den) a_is_zero = 1'b1;
    if (b_is_den) b_is_zero = 1'b1;

    // defaults
    y_next = 32'h0000_0000;
    v_next = in_valid;

    // default loop vars
    shift_i = 0;
    msb_i   = 0;
    shl_i   = 0;
    found   = 1'b0;

    if (a_is_nan) begin
      y_next = a;
    end else if (b_is_nan) begin
      y_next = b;
    end else if (a_is_inf && b_is_inf) begin
      if (sa != sb) y_next = 32'h7FC0_0000; // inf + -inf = NaN
      else          y_next = {sa, 8'hFF, 23'd0};
    end else if (a_is_inf) begin
      y_next = {sa, 8'hFF, 23'd0};
    end else if (b_is_inf) begin
      y_next = {sb, 8'hFF, 23'd0};
    end else if (a_is_zero) begin
      y_next = b;
    end else if (b_is_zero) begin
      y_next = a;
    end else begin
      // choose bigger exponent (tie: bigger fraction)
      if ((ea > eb) || ((ea == eb) && (fa >= fb))) begin
        s_big   = sa; e_big   = ea; m_big   = {1'b1, fa};
        s_small = sb; e_small = eb; m_small = {1'b1, fb};
      end else begin
        s_big   = sb; e_big   = eb; m_big   = {1'b1, fb};
        s_small = sa; e_small = ea; m_small = {1'b1, fa};
      end

      // align small to big
      shift_i = e_big - e_small;
      if (shift_i >= 25) m_small_shifted = 25'd0;
      else               m_small_shifted = ({1'b0, m_small} >> shift_i);

      // add/sub
      if (s_big == s_small) begin
        m_sum = {1'b0, m_big} + m_small_shifted;
        s_out = s_big;
      end else begin
        m_sum = {1'b0, m_big} - m_small_shifted;
        s_out = s_big;
      end

      if (m_sum == 0) begin
        y_next = 32'h0000_0000;
      end else begin
        e_out = e_big;

        // carry case (addition)
        if (m_sum[24]) begin
          m_out24 = m_sum[24:1];
          if (e_out == 8'hFE) y_next = {s_out, 8'hFF, 23'd0};
          else                y_next = {s_out, (e_out + 8'd1), m_out24[22:0]};
        end else begin
          // find MSB in bits [23:0] without modifying loop var
          msb_i = 0;
          found = 1'b0;
          for (i = 23; i >= 0; i = i - 1) begin
            if (!found && m_sum[i]) begin
              msb_i = i;
              found = 1'b1;
            end
          end

          // shift left so MSB goes to bit 23
          shl_i = 23 - msb_i;
          if (shl_i < 0) shl_i = 0;

          if (e_out <= shl_i[7:0]) begin
            y_next = 32'h0000_0000; // underflow (flush)
          end else begin
            tmp25   = (m_sum << shl_i);
            m_out24 = tmp25[23:0];
            y_next  = {s_out, (e_out - shl_i[7:0]), m_out24[22:0]};
          end
        end
      end
    end
  end

  always_ff @(posedge clk) begin
    if (reset) begin
      out_valid <= 1'b0;
      y         <= 32'h0000_0000;
    end else begin
      out_valid <= v_next;
      y         <= y_next;
    end
  end
endmodule


// ============================================================
// TOP: main
// Implements Linear(64->48) + ReLU + Linear(48->4)
// Batch = 48 (input tensor is [48,64])
// ============================================================
module main (
  input  logic        clk,
  input  logic        reset,    // active-high
  input  logic        start,
  output logic        done,

  // Optional: read back Y results over a small interface (no huge I/O)
  input  logic [7:0]  y_rd_addr,   // 0..191
  output logic [31:0] y_rd_data
);
  localparam int BATCH = 48;
  localparam int IN    = 64;
  localparam int HID   = 48;
  localparam int OUT   = 4;

  // -------------------------
  // Internal memories
  // -------------------------
  // X: 48*64 = 3072
  logic [31:0] X_mem  [0:3071];
  // W1: 48*64 = 3072
  logic [31:0] W1_mem [0:3071];
  // b1: 48
  logic [31:0] b1_mem [0:47];
  // W2: 4*48 = 192
  logic [31:0] W2_mem [0:191];
  // b2: 4
  logic [31:0] b2_mem [0:3];

  // H1 scratch: 48*48 = 2304
  logic [31:0] H1_mem [0:2303];
  // Y output: 48*4 = 192
  logic [31:0] Y_mem  [0:191];

  // Optional sim init (remove if you dislike $readmemh)
  // For Vivado bitstream init, convert to BRAM init or load via AXI.
  initial begin
    // $readmemh("X.hex",  X_mem);
    // $readmemh("W1.hex", W1_mem);
    // $readmemh("b1.hex", b1_mem);
    // $readmemh("W2.hex", W2_mem);
    // $readmemh("b2.hex", b2_mem);
  end

  // Readback
  always_ff @(posedge clk) begin
    y_rd_data <= Y_mem[y_rd_addr];
  end

  // -------------------------
  // Address helpers
  // -------------------------
  function automatic int addr_x (input int n, input int k);
    addr_x = n*IN + k;
  endfunction
  function automatic int addr_w1 (input int o, input int k);
    addr_w1 = o*IN + k;
  endfunction
  function automatic int addr_h1 (input int n, input int o);
    addr_h1 = n*HID + o;
  endfunction
  function automatic int addr_w2 (input int o2, input int k);
    addr_w2 = o2*HID + k;
  endfunction
  function automatic int addr_y (input int n, input int o2);
    addr_y = n*OUT + o2;
  endfunction

  // -------------------------
  // Compute state
  // -------------------------
  int n, o, k;
  logic [31:0] acc;

  logic [31:0] op_a, op_b;
  logic [31:0] bias_reg;

  logic mul_in_valid, mul_out_valid;
  logic [31:0] mul_y;

  logic add_in_valid, add_out_valid;
  logic [31:0] add_y;

  logic addb_in_valid, addb_out_valid;
  logic [31:0] addb_y;

  fp32_mul_synth u_mul (
    .clk(clk), .reset(reset),
    .in_valid(mul_in_valid),
    .a(op_a), .b(op_b),
    .out_valid(mul_out_valid),
    .y(mul_y)
  );

  fp32_add_synth u_add (
    .clk(clk), .reset(reset),
    .in_valid(add_in_valid),
    .a(acc), .b(mul_y),
    .out_valid(add_out_valid),
    .y(add_y)
  );

  fp32_add_synth u_add_bias (
    .clk(clk), .reset(reset),
    .in_valid(addb_in_valid),
    .a(acc), .b(bias_reg),
    .out_valid(addb_out_valid),
    .y(addb_y)
  );

  logic [31:0] relu_y;
  fp32_relu u_relu (.in_fp32(addb_y), .out_fp32(relu_y));

  typedef enum logic [5:0] {
    S_IDLE              = 6'd0,

    // L1
    S_L1_RD             = 6'd1,
    S_L1_MUL_START      = 6'd2,
    S_L1_WAIT_MUL       = 6'd3,
    S_L1_ADD_START      = 6'd4,
    S_L1_WAIT_ADD       = 6'd5,
    S_L1_NEXT_K         = 6'd6,
    S_L1_BIAS_RD        = 6'd7,
    S_L1_BIAS_START     = 6'd8,
    S_L1_WAIT_BIAS      = 6'd9,
    S_L1_WRITE_H1       = 6'd10,
    S_L1_NEXT_O_N       = 6'd11,

    // L2
    S_L2_RD             = 6'd20,
    S_L2_MUL_START      = 6'd21,
    S_L2_WAIT_MUL       = 6'd22,
    S_L2_ADD_START      = 6'd23,
    S_L2_WAIT_ADD       = 6'd24,
    S_L2_NEXT_K         = 6'd25,
    S_L2_BIAS_RD        = 6'd26,
    S_L2_BIAS_START     = 6'd27,
    S_L2_WAIT_BIAS      = 6'd28,
    S_L2_WRITE_Y        = 6'd29,
    S_L2_NEXT_O2_N      = 6'd30,

    S_DONE              = 6'd63
  } state_t;

  state_t st;

  always_comb begin
    mul_in_valid  = 1'b0;
    add_in_valid  = 1'b0;
    addb_in_valid = 1'b0;
    done          = (st == S_DONE);

    case (st)
      S_L1_MUL_START:  mul_in_valid  = 1'b1;
      S_L1_ADD_START:  add_in_valid  = 1'b1;
      S_L1_BIAS_START: addb_in_valid = 1'b1;

      S_L2_MUL_START:  mul_in_valid  = 1'b1;
      S_L2_ADD_START:  add_in_valid  = 1'b1;
      S_L2_BIAS_START: addb_in_valid = 1'b1;

      default: ;
    endcase
  end

  always_ff @(posedge clk) begin
    if (reset) begin
      st  <= S_IDLE;
      n   <= 0; o <= 0; k <= 0;
      acc <= 32'h0000_0000;
      op_a <= 0; op_b <= 0; bias_reg <= 0;
    end else begin
      case (st)
        S_IDLE: begin
          if (start) begin
            n <= 0; o <= 0; k <= 0;
            acc <= 32'h0000_0000;
            st <= S_L1_RD;
          end
        end

        // ---------- L1 ----------
        S_L1_RD: begin
          op_a <= X_mem[addr_x(n,k)];
          op_b <= W1_mem[addr_w1(o,k)];
          st   <= S_L1_MUL_START;
        end
        S_L1_MUL_START: st <= S_L1_WAIT_MUL;
        S_L1_WAIT_MUL:  if (mul_out_valid) st <= S_L1_ADD_START;

        S_L1_ADD_START: st <= S_L1_WAIT_ADD;
        S_L1_WAIT_ADD: begin
          if (add_out_valid) begin
            acc <= add_y;
            st <= S_L1_NEXT_K;
          end
        end
        S_L1_NEXT_K: begin
          if (k == IN-1) st <= S_L1_BIAS_RD;
          else begin
            k <= k + 1;
            st <= S_L1_RD;
          end
        end
        S_L1_BIAS_RD: begin
          bias_reg <= b1_mem[o];
          st <= S_L1_BIAS_START;
        end
        S_L1_BIAS_START: st <= S_L1_WAIT_BIAS;
        S_L1_WAIT_BIAS: if (addb_out_valid) st <= S_L1_WRITE_H1;

        S_L1_WRITE_H1: begin
          H1_mem[addr_h1(n,o)] <= relu_y;
          st <= S_L1_NEXT_O_N;
        end
        S_L1_NEXT_O_N: begin
          if (o == HID-1) begin
            if (n == BATCH-1) begin
              n <= 0; o <= 0; k <= 0;
              acc <= 32'h0000_0000;
              st <= S_L2_RD;
            end else begin
              n <= n + 1;
              o <= 0; k <= 0;
              acc <= 32'h0000_0000;
              st <= S_L1_RD;
            end
          end else begin
            o <= o + 1;
            k <= 0;
            acc <= 32'h0000_0000;
            st <= S_L1_RD;
          end
        end

        // ---------- L2 ----------
        S_L2_RD: begin
          op_a <= H1_mem[addr_h1(n,k)];
          op_b <= W2_mem[addr_w2(o[2:0],k)];
          st <= S_L2_MUL_START;
        end
        S_L2_MUL_START: st <= S_L2_WAIT_MUL;
        S_L2_WAIT_MUL:  if (mul_out_valid) st <= S_L2_ADD_START;

        S_L2_ADD_START: st <= S_L2_WAIT_ADD;
        S_L2_WAIT_ADD: begin
          if (add_out_valid) begin
            acc <= add_y;
            st <= S_L2_NEXT_K;
          end
        end
        S_L2_NEXT_K: begin
          if (k == HID-1) st <= S_L2_BIAS_RD;
          else begin
            k <= k + 1;
            st <= S_L2_RD;
          end
        end
        S_L2_BIAS_RD: begin
          bias_reg <= b2_mem[o[2:0]];
          st <= S_L2_BIAS_START;
        end
        S_L2_BIAS_START: st <= S_L2_WAIT_BIAS;
        S_L2_WAIT_BIAS: if (addb_out_valid) st <= S_L2_WRITE_Y;

        S_L2_WRITE_Y: begin
          Y_mem[addr_y(n,o[2:0])] <= addb_y;
          st <= S_L2_NEXT_O2_N;
        end
        S_L2_NEXT_O2_N: begin
          if (o[2:0] == OUT-1) begin
            if (n == BATCH-1) st <= S_DONE;
            else begin
              n <= n + 1;
              o <= 0; k <= 0;
              acc <= 32'h0000_0000;
              st <= S_L2_RD;
            end
          end else begin
            o <= o + 1;
            k <= 0;
            acc <= 32'h0000_0000;
            st <= S_L2_RD;
          end
        end

        S_DONE: st <= S_IDLE;

        default: st <= S_IDLE;
      endcase
    end
  end

endmodule

