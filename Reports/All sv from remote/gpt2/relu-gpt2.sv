`timescale 1ns/1ps
`default_nettype none

module main #(
  parameter int N = 300
)(
  input  wire        clk,
  input  wire        rst_n,

  input  wire        start,
  output wire        done,

  // X read port
  output reg  [$clog2(N)-1:0] X_addr,
  input  wire [31:0]          X_rdata,

  // Y read port
  output reg  [$clog2(N)-1:0] Y_addr,
  input  wire [31:0]          Y_rdata,

  // O write port
  output reg                  O_we,
  output reg  [$clog2(N)-1:0] O_addr,
  output reg  [31:0]          O_wdata
);

  // ----------------------------
  // FP32 ReLU
  // ----------------------------
  function automatic [31:0] fp32_relu(input [31:0] x);
    logic sign;
    logic [7:0] exp;
    logic [22:0] frac;
    logic is_nan;
    begin
      sign = x[31];
      exp  = x[30:23];
      frac = x[22:0];
      is_nan = (exp == 8'hFF) && (frac != 23'd0);

      if (is_nan)        fp32_relu = x;               // propagate NaN
      else if (sign)     fp32_relu = 32'h0000_0000;   // negative -> +0
      else               fp32_relu = x;               // keep
    end
  endfunction

  // ----------------------------
  // IEEE-754 FP32 add (RNE)
  // Vivado-safe: declarations at top only
  // ----------------------------
  function automatic [31:0] fp32_add_rne(input [31:0] a, input [31:0] b);
    // Unpack
    logic sa, sb;
    logic [7:0] ea, eb;
    logic [22:0] fa, fb;

    logic a_is_nan, b_is_nan;
    logic a_is_inf, b_is_inf;
    logic a_is_zero, b_is_zero;

    // Mantissas with hidden bit
    logic [23:0] ma, mb;

    // Choose big/small
    logic s_big, s_sml;
    logic [7:0] e_big, e_sml;
    logic [23:0] m_big, m_sml;
    logic [7:0] ediff;

    // GRS-extended mantissas
    logic [26:0] m_big_grs;
    logic [26:0] m_sml_grs;

    logic [26:0] tmp_grs;
    logic sticky;

    // Add/sub
    logic [27:0] sum_ext;
    logic sum_sign;

    // Normalize/round
    logic [7:0]  e_norm;
    logic [26:0] m_norm;

    logic guard, roundb, stickyb;
    logic lsb;
    logic inc;

    logic [24:0] rounded;

    logic [22:0] frac_out;
    logic [7:0]  exp_out;
    logic        sign_out;

    integer sh;

    begin
      sa = a[31]; ea = a[30:23]; fa = a[22:0];
      sb = b[31]; eb = b[30:23]; fb = b[22:0];

      a_is_nan  = (ea == 8'hFF) && (fa != 0);
      b_is_nan  = (eb == 8'hFF) && (fb != 0);
      a_is_inf  = (ea == 8'hFF) && (fa == 0);
      b_is_inf  = (eb == 8'hFF) && (fb == 0);
      a_is_zero = (ea == 0) && (fa == 0);
      b_is_zero = (eb == 0) && (fb == 0);

      // Defaults
      fp32_add_rne = 32'h0000_0000;

      // NaN propagation
      if (a_is_nan) begin
        fp32_add_rne = a;
      end else if (b_is_nan) begin
        fp32_add_rne = b;
      end
      // Inf handling
      else if (a_is_inf && b_is_inf) begin
        if (sa != sb) fp32_add_rne = 32'h7FC0_0000; // inf + -inf => NaN
        else          fp32_add_rne = a;
      end else if (a_is_inf) begin
        fp32_add_rne = a;
      end else if (b_is_inf) begin
        fp32_add_rne = b;
      end
      // Zero shortcuts
      else if (a_is_zero) begin
        fp32_add_rne = b;
      end else if (b_is_zero) begin
        fp32_add_rne = a;
      end
      else begin
        // Build mantissas (hidden bit for normals)
        ma = (ea == 0) ? {1'b0, fa} : {1'b1, fa};
        mb = (eb == 0) ? {1'b0, fb} : {1'b1, fb};

        // Pick bigger magnitude by exponent then mantissa
        if ((ea > eb) || ((ea == eb) && (ma >= mb))) begin
          s_big = sa; e_big = ea; m_big = ma;
          s_sml = sb; e_sml = eb; m_sml = mb;
        end else begin
          s_big = sb; e_big = eb; m_big = mb;
          s_sml = sa; e_sml = ea; m_sml = ma;
        end

        ediff = e_big - e_sml;

        m_big_grs = {m_big, 3'b000};

        // Align smaller with sticky
        if (ediff == 0) begin
          m_sml_grs = {m_sml, 3'b000};
        end else if (ediff >= 27) begin
          m_sml_grs = 27'd0;
          m_sml_grs[0] = (m_sml != 0);
        end else begin
          tmp_grs = ({m_sml, 3'b000} >> ediff);
          sticky  = |({m_sml, 3'b000} & ((27'h7FFFFFF) >> (27-ediff)));
          m_sml_grs = tmp_grs;
          m_sml_grs[0] = m_sml_grs[0] | sticky;
        end

        // Add/sub based on sign
        if (s_big == s_sml) begin
          sum_ext  = {1'b0, m_big_grs} + {1'b0, m_sml_grs};
          sum_sign = s_big;
        end else begin
          sum_ext  = {1'b0, m_big_grs} - {1'b0, m_sml_grs};
          sum_sign = s_big;
        end

        if (sum_ext == 0) begin
          fp32_add_rne = 32'h0000_0000;
        end else begin
          e_norm = e_big;
          m_norm = sum_ext[26:0];

          // Carry from addition
          if (sum_ext[27]) begin
            m_norm = sum_ext[27:1];
            m_norm[0] = m_norm[0] | sum_ext[0]; // sticky
            e_norm = e_big + 1;
          end else begin
            // Normalize left (bounded)
            for (sh = 0; sh < 26; sh = sh + 1) begin
              if ((m_norm[26] == 1'b0) && (e_norm > 0)) begin
                m_norm = m_norm << 1;
                e_norm = e_norm - 1;
              end
            end
          end

          // Overflow => Inf
          if (e_norm >= 8'hFF) begin
            fp32_add_rne = {sum_sign, 8'hFF, 23'd0};
          end else begin
            guard   = m_norm[2];
            roundb  = m_norm[1];
            stickyb = m_norm[0];
            lsb     = m_norm[3]; // LSB of mantissa (ties-to-even)

            inc = guard && (roundb || stickyb || lsb);

            rounded = {1'b0, m_norm[26:3]} + inc;

            // Rounding overflow => renormalize
            if (rounded[24]) begin
              rounded = rounded >> 1;
              e_norm  = e_norm + 1;

              if (e_norm >= 8'hFF) begin
                fp32_add_rne = {sum_sign, 8'hFF, 23'd0};
              end else begin
                frac_out = rounded[22:0];
                exp_out  = e_norm;
                sign_out = sum_sign;
                fp32_add_rne = {sign_out, exp_out, frac_out};
              end
            end else begin
              // Normal/subnormal pack
              if (e_norm == 0) begin
                frac_out = rounded[22:0];
                exp_out  = 8'd0;
              end else begin
                frac_out = rounded[22:0];
                exp_out  = e_norm;
              end
              sign_out = sum_sign;
              fp32_add_rne = {sign_out, exp_out, frac_out};
            end
          end
        end
      end
    end
  endfunction

  // ----------------------------
  // FSM: assumes 1-cycle sync read
  // ----------------------------
  typedef enum logic [2:0] {
    S_IDLE  = 3'd0,
    S_ADDR  = 3'd1,
    S_CAP   = 3'd2,
    S_WRITE = 3'd3,
    S_NEXT  = 3'd4,
    S_DONE  = 3'd5
  } state_t;

  state_t st;
  reg [$clog2(N)-1:0] idx;

  reg [31:0] relu_reg;

  assign done = (st == S_DONE);

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      st      <= S_IDLE;
      idx     <= '0;
      X_addr  <= '0;
      Y_addr  <= '0;
      O_we    <= 1'b0;
      O_addr  <= '0;
      O_wdata <= 32'd0;
      relu_reg<= 32'd0;
    end else begin
      O_we <= 1'b0;

      case (st)
        S_IDLE: begin
          if (start) begin
            idx <= '0;
            st  <= S_ADDR;
          end
        end

        S_ADDR: begin
          X_addr <= idx;
          Y_addr <= idx;
          st     <= S_CAP;
        end

        S_CAP: begin
          relu_reg <= fp32_relu(fp32_add_rne(X_rdata, Y_rdata));
          st       <= S_WRITE;
        end

        S_WRITE: begin
          O_addr  <= idx;
          O_wdata <= relu_reg;
          O_we    <= 1'b1;
          st      <= S_NEXT;
        end

        S_NEXT: begin
          if (idx == N-1) st <= S_DONE;
          else begin
            idx <= idx + 1'b1;
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

`default_nettype wire

