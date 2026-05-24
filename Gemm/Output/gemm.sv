/* verilator lint_off MULTITOP */
/// =================== Unsigned, Fixed Point =========================
module std_fp_add #(
    parameter WIDTH = 32,
    parameter INT_WIDTH = 16,
    parameter FRAC_WIDTH = 16
) (
    input  logic [WIDTH-1:0] left,
    input  logic [WIDTH-1:0] right,
    output logic [WIDTH-1:0] out
);
  assign out = left + right;
endmodule

module std_fp_sub #(
    parameter WIDTH = 32,
    parameter INT_WIDTH = 16,
    parameter FRAC_WIDTH = 16
) (
    input  logic [WIDTH-1:0] left,
    input  logic [WIDTH-1:0] right,
    output logic [WIDTH-1:0] out
);
  assign out = left - right;
endmodule

module std_fp_mult_pipe #(
    parameter WIDTH = 32,
    parameter INT_WIDTH = 16,
    parameter FRAC_WIDTH = 16,
    parameter SIGNED = 0
) (
    input  logic [WIDTH-1:0] left,
    input  logic [WIDTH-1:0] right,
    input  logic             go,
    input  logic             clk,
    input  logic             reset,
    output logic [WIDTH-1:0] out,
    output logic             done
);
  logic [WIDTH-1:0]          rtmp;
  logic [WIDTH-1:0]          ltmp;
  logic [(WIDTH << 1) - 1:0] out_tmp;
  // Buffer used to walk through the 3 cycles of the pipeline.
  logic done_buf[1:0];

  assign done = done_buf[1];

  assign out = out_tmp[(WIDTH << 1) - INT_WIDTH - 1 : WIDTH - INT_WIDTH];

  // If the done buffer is completely empty and go is high then execution
  // just started.
  logic start;
  assign start = go;

  // Start sending the done signal.
  always_ff @(posedge clk) begin
    if (start)
      done_buf[0] <= 1;
    else
      done_buf[0] <= 0;
  end

  // Push the done signal through the pipeline.
  always_ff @(posedge clk) begin
    if (go) begin
      done_buf[1] <= done_buf[0];
    end else begin
      done_buf[1] <= 0;
    end
  end

  // Register the inputs
  always_ff @(posedge clk) begin
    if (reset) begin
      rtmp <= 0;
      ltmp <= 0;
    end else if (go) begin
      if (SIGNED) begin
        rtmp <= $signed(right);
        ltmp <= $signed(left);
      end else begin
        rtmp <= right;
        ltmp <= left;
      end
    end else begin
      rtmp <= 0;
      ltmp <= 0;
    end

  end

  // Compute the output and save it into out_tmp
  always_ff @(posedge clk) begin
    if (reset) begin
      out_tmp <= 0;
    end else if (go) begin
      if (SIGNED) begin
        // In the first cycle, this performs an invalid computation because
        // ltmp and rtmp only get their actual values in cycle 1
        out_tmp <= $signed(
          { {WIDTH{ltmp[WIDTH-1]}}, ltmp} *
          { {WIDTH{rtmp[WIDTH-1]}}, rtmp}
        );
      end else begin
        out_tmp <= ltmp * rtmp;
      end
    end else begin
      out_tmp <= out_tmp;
    end
  end
endmodule

/* verilator lint_off WIDTH */
module std_fp_div_pipe #(
  parameter WIDTH = 32,
  parameter INT_WIDTH = 16,
  parameter FRAC_WIDTH = 16
) (
    input  logic             go,
    input  logic             clk,
    input  logic             reset,
    input  logic [WIDTH-1:0] left,
    input  logic [WIDTH-1:0] right,
    output logic [WIDTH-1:0] out_remainder,
    output logic [WIDTH-1:0] out_quotient,
    output logic             done
);
    localparam ITERATIONS = WIDTH + FRAC_WIDTH;

    logic [WIDTH-1:0] quotient, quotient_next;
    logic [WIDTH:0] acc, acc_next;
    logic [$clog2(ITERATIONS)-1:0] idx;
    logic start, running, finished, dividend_is_zero;

    assign start = go && !running;
    assign dividend_is_zero = start && left == 0;
    assign finished = idx == ITERATIONS - 1 && running;

    always_ff @(posedge clk) begin
      if (reset || finished || dividend_is_zero)
        running <= 0;
      else if (start)
        running <= 1;
      else
        running <= running;
    end

    always @* begin
      if (acc >= {1'b0, right}) begin
        acc_next = acc - right;
        {acc_next, quotient_next} = {acc_next[WIDTH-1:0], quotient, 1'b1};
      end else begin
        {acc_next, quotient_next} = {acc, quotient} << 1;
      end
    end

    // `done` signaling
    always_ff @(posedge clk) begin
      if (dividend_is_zero || finished)
        done <= 1;
      else
        done <= 0;
    end

    always_ff @(posedge clk) begin
      if (running)
        idx <= idx + 1;
      else
        idx <= 0;
    end

    always_ff @(posedge clk) begin
      if (reset) begin
        out_quotient <= 0;
        out_remainder <= 0;
      end else if (start) begin
        out_quotient <= 0;
        out_remainder <= left;
      end else if (go == 0) begin
        out_quotient <= out_quotient;
        out_remainder <= out_remainder;
      end else if (dividend_is_zero) begin
        out_quotient <= 0;
        out_remainder <= 0;
      end else if (finished) begin
        out_quotient <= quotient_next;
        out_remainder <= out_remainder;
      end else begin
        out_quotient <= out_quotient;
        if (right <= out_remainder)
          out_remainder <= out_remainder - right;
        else
          out_remainder <= out_remainder;
      end
    end

    always_ff @(posedge clk) begin
      if (reset) begin
        acc <= 0;
        quotient <= 0;
      end else if (start) begin
        {acc, quotient} <= {{WIDTH{1'b0}}, left, 1'b0};
      end else begin
        acc <= acc_next;
        quotient <= quotient_next;
      end
    end
endmodule

module std_fp_gt #(
    parameter WIDTH = 32,
    parameter INT_WIDTH = 16,
    parameter FRAC_WIDTH = 16
) (
    input  logic [WIDTH-1:0] left,
    input  logic [WIDTH-1:0] right,
    output logic             out
);
  assign out = left > right;
endmodule

/// =================== Signed, Fixed Point =========================
module std_fp_sadd #(
    parameter WIDTH = 32,
    parameter INT_WIDTH = 16,
    parameter FRAC_WIDTH = 16
) (
    input  signed [WIDTH-1:0] left,
    input  signed [WIDTH-1:0] right,
    output signed [WIDTH-1:0] out
);
  assign out = $signed(left + right);
endmodule

module std_fp_ssub #(
    parameter WIDTH = 32,
    parameter INT_WIDTH = 16,
    parameter FRAC_WIDTH = 16
) (
    input  signed [WIDTH-1:0] left,
    input  signed [WIDTH-1:0] right,
    output signed [WIDTH-1:0] out
);

  assign out = $signed(left - right);
endmodule

module std_fp_smult_pipe #(
    parameter WIDTH = 32,
    parameter INT_WIDTH = 16,
    parameter FRAC_WIDTH = 16
) (
    input  [WIDTH-1:0]              left,
    input  [WIDTH-1:0]              right,
    input  logic                    reset,
    input  logic                    go,
    input  logic                    clk,
    output logic [WIDTH-1:0]        out,
    output logic                    done
);
  std_fp_mult_pipe #(
    .WIDTH(WIDTH),
    .INT_WIDTH(INT_WIDTH),
    .FRAC_WIDTH(FRAC_WIDTH),
    .SIGNED(1)
  ) comp (
    .clk(clk),
    .done(done),
    .reset(reset),
    .go(go),
    .left(left),
    .right(right),
    .out(out)
  );
endmodule

module std_fp_sdiv_pipe #(
    parameter WIDTH = 32,
    parameter INT_WIDTH = 16,
    parameter FRAC_WIDTH = 16
) (
    input                     clk,
    input                     go,
    input                     reset,
    input  signed [WIDTH-1:0] left,
    input  signed [WIDTH-1:0] right,
    output signed [WIDTH-1:0] out_quotient,
    output signed [WIDTH-1:0] out_remainder,
    output logic              done
);

  logic signed [WIDTH-1:0] left_abs, right_abs, comp_out_q, comp_out_r, right_save, out_rem_intermediate;

  // Registers to figure out how to transform outputs.
  logic different_signs, left_sign, right_sign;

  // Latch the value of control registers so that their available after
  // go signal becomes low.
  always_ff @(posedge clk) begin
    if (go) begin
      right_save <= right_abs;
      left_sign <= left[WIDTH-1];
      right_sign <= right[WIDTH-1];
    end else begin
      left_sign <= left_sign;
      right_save <= right_save;
      right_sign <= right_sign;
    end
  end

  assign right_abs = right[WIDTH-1] ? -right : right;
  assign left_abs = left[WIDTH-1] ? -left : left;

  assign different_signs = left_sign ^ right_sign;
  assign out_quotient = different_signs ? -comp_out_q : comp_out_q;

  // Remainder is computed as:
  //  t0 = |left| % |right|
  //  t1 = if left * right < 0 and t0 != 0 then |right| - t0 else t0
  //  rem = if right < 0 then -t1 else t1
  assign out_rem_intermediate = different_signs & |comp_out_r ? $signed(right_save - comp_out_r) : comp_out_r;
  assign out_remainder = right_sign ? -out_rem_intermediate : out_rem_intermediate;

  std_fp_div_pipe #(
    .WIDTH(WIDTH),
    .INT_WIDTH(INT_WIDTH),
    .FRAC_WIDTH(FRAC_WIDTH)
  ) comp (
    .reset(reset),
    .clk(clk),
    .done(done),
    .go(go),
    .left(left_abs),
    .right(right_abs),
    .out_quotient(comp_out_q),
    .out_remainder(comp_out_r)
  );
endmodule

module std_fp_sgt #(
    parameter WIDTH = 32,
    parameter INT_WIDTH = 16,
    parameter FRAC_WIDTH = 16
) (
    input  logic signed [WIDTH-1:0] left,
    input  logic signed [WIDTH-1:0] right,
    output logic signed             out
);
  assign out = $signed(left > right);
endmodule

module std_fp_slt #(
    parameter WIDTH = 32,
    parameter INT_WIDTH = 16,
    parameter FRAC_WIDTH = 16
) (
   input logic signed [WIDTH-1:0] left,
   input logic signed [WIDTH-1:0] right,
   output logic signed            out
);
  assign out = $signed(left < right);
endmodule

/// =================== Unsigned, Bitnum =========================
module std_mult_pipe #(
    parameter WIDTH = 32
) (
    input  logic [WIDTH-1:0] left,
    input  logic [WIDTH-1:0] right,
    input  logic             reset,
    input  logic             go,
    input  logic             clk,
    output logic [WIDTH-1:0] out,
    output logic             done
);
  std_fp_mult_pipe #(
    .WIDTH(WIDTH),
    .INT_WIDTH(WIDTH),
    .FRAC_WIDTH(0),
    .SIGNED(0)
  ) comp (
    .reset(reset),
    .clk(clk),
    .done(done),
    .go(go),
    .left(left),
    .right(right),
    .out(out)
  );
endmodule

module std_div_pipe #(
    parameter WIDTH = 32
) (
    input                    reset,
    input                    clk,
    input                    go,
    input        [WIDTH-1:0] left,
    input        [WIDTH-1:0] right,
    output logic [WIDTH-1:0] out_remainder,
    output logic [WIDTH-1:0] out_quotient,
    output logic             done
);

  logic [WIDTH-1:0] dividend;
  logic [(WIDTH-1)*2:0] divisor;
  logic [WIDTH-1:0] quotient;
  logic [WIDTH-1:0] quotient_msk;
  logic start, running, finished, dividend_is_zero;

  assign start = go && !running;
  assign finished = quotient_msk == 0 && running;
  assign dividend_is_zero = start && left == 0;

  always_ff @(posedge clk) begin
    // Early return if the divisor is zero.
    if (finished || dividend_is_zero)
      done <= 1;
    else
      done <= 0;
  end

  always_ff @(posedge clk) begin
    if (reset || finished || dividend_is_zero)
      running <= 0;
    else if (start)
      running <= 1;
    else
      running <= running;
  end

  // Outputs
  always_ff @(posedge clk) begin
    if (dividend_is_zero || start) begin
      out_quotient <= 0;
      out_remainder <= 0;
    end else if (finished) begin
      out_quotient <= quotient;
      out_remainder <= dividend;
    end else begin
      // Otherwise, explicitly latch the values.
      out_quotient <= out_quotient;
      out_remainder <= out_remainder;
    end
  end

  // Calculate the quotient mask.
  always_ff @(posedge clk) begin
    if (start)
      quotient_msk <= 1 << WIDTH - 1;
    else if (running)
      quotient_msk <= quotient_msk >> 1;
    else
      quotient_msk <= quotient_msk;
  end

  // Calculate the quotient.
  always_ff @(posedge clk) begin
    if (start)
      quotient <= 0;
    else if (divisor <= dividend)
      quotient <= quotient | quotient_msk;
    else
      quotient <= quotient;
  end

  // Calculate the dividend.
  always_ff @(posedge clk) begin
    if (start)
      dividend <= left;
    else if (divisor <= dividend)
      dividend <= dividend - divisor;
    else
      dividend <= dividend;
  end

  always_ff @(posedge clk) begin
    if (start) begin
      divisor <= right << WIDTH - 1;
    end else if (finished) begin
      divisor <= 0;
    end else begin
      divisor <= divisor >> 1;
    end
  end

  // Simulation self test against unsynthesizable implementation.
  `ifdef VERILATOR
    logic [WIDTH-1:0] l, r;
    always_ff @(posedge clk) begin
      if (go) begin
        l <= left;
        r <= right;
      end else begin
        l <= l;
        r <= r;
      end
    end

    always @(posedge clk) begin
      if (done && $unsigned(out_remainder) != $unsigned(l % r))
        $error(
          "\nstd_div_pipe (Remainder): Computed and golden outputs do not match!\n",
          "left: %0d", $unsigned(l),
          "  right: %0d\n", $unsigned(r),
          "expected: %0d", $unsigned(l % r),
          "  computed: %0d", $unsigned(out_remainder)
        );

      if (done && $unsigned(out_quotient) != $unsigned(l / r))
        $error(
          "\nstd_div_pipe (Quotient): Computed and golden outputs do not match!\n",
          "left: %0d", $unsigned(l),
          "  right: %0d\n", $unsigned(r),
          "expected: %0d", $unsigned(l / r),
          "  computed: %0d", $unsigned(out_quotient)
        );
    end
  `endif
endmodule

/// =================== Signed, Bitnum =========================
module std_sadd #(
    parameter WIDTH = 32
) (
    input  signed [WIDTH-1:0] left,
    input  signed [WIDTH-1:0] right,
    output signed [WIDTH-1:0] out
);
  assign out = $signed(left + right);
endmodule

module std_ssub #(
    parameter WIDTH = 32
) (
    input  signed [WIDTH-1:0] left,
    input  signed [WIDTH-1:0] right,
    output signed [WIDTH-1:0] out
);
  assign out = $signed(left - right);
endmodule

module std_smult_pipe #(
    parameter WIDTH = 32
) (
    input  logic                    reset,
    input  logic                    go,
    input  logic                    clk,
    input  signed       [WIDTH-1:0] left,
    input  signed       [WIDTH-1:0] right,
    output logic signed [WIDTH-1:0] out,
    output logic                    done
);
  std_fp_mult_pipe #(
    .WIDTH(WIDTH),
    .INT_WIDTH(WIDTH),
    .FRAC_WIDTH(0),
    .SIGNED(1)
  ) comp (
    .reset(reset),
    .clk(clk),
    .done(done),
    .go(go),
    .left(left),
    .right(right),
    .out(out)
  );
endmodule

/* verilator lint_off WIDTH */
module std_sdiv_pipe #(
    parameter WIDTH = 32
) (
    input                           reset,
    input                           clk,
    input                           go,
    input  logic signed [WIDTH-1:0] left,
    input  logic signed [WIDTH-1:0] right,
    output logic signed [WIDTH-1:0] out_quotient,
    output logic signed [WIDTH-1:0] out_remainder,
    output logic                    done
);

  logic signed [WIDTH-1:0] left_abs, right_abs, comp_out_q, comp_out_r, right_save, out_rem_intermediate;

  // Registers to figure out how to transform outputs.
  logic different_signs, left_sign, right_sign;

  // Latch the value of control registers so that their available after
  // go signal becomes low.
  always_ff @(posedge clk) begin
    if (go) begin
      right_save <= right_abs;
      left_sign <= left[WIDTH-1];
      right_sign <= right[WIDTH-1];
    end else begin
      left_sign <= left_sign;
      right_save <= right_save;
      right_sign <= right_sign;
    end
  end

  assign right_abs = right[WIDTH-1] ? -right : right;
  assign left_abs = left[WIDTH-1] ? -left : left;

  assign different_signs = left_sign ^ right_sign;
  assign out_quotient = different_signs ? -comp_out_q : comp_out_q;

  // Remainder is computed as:
  //  t0 = |left| % |right|
  //  t1 = if left * right < 0 and t0 != 0 then |right| - t0 else t0
  //  rem = if right < 0 then -t1 else t1
  assign out_rem_intermediate = different_signs & |comp_out_r ? $signed(right_save - comp_out_r) : comp_out_r;
  assign out_remainder = right_sign ? -out_rem_intermediate : out_rem_intermediate;

  std_div_pipe #(
    .WIDTH(WIDTH)
  ) comp (
    .reset(reset),
    .clk(clk),
    .done(done),
    .go(go),
    .left(left_abs),
    .right(right_abs),
    .out_quotient(comp_out_q),
    .out_remainder(comp_out_r)
  );

  // Simulation self test against unsynthesizable implementation.
  `ifdef VERILATOR
    logic signed [WIDTH-1:0] l, r;
    always_ff @(posedge clk) begin
      if (go) begin
        l <= left;
        r <= right;
      end else begin
        l <= l;
        r <= r;
      end
    end

    always @(posedge clk) begin
      if (done && out_quotient != $signed(l / r))
        $error(
          "\nstd_sdiv_pipe (Quotient): Computed and golden outputs do not match!\n",
          "left: %0d", l,
          "  right: %0d\n", r,
          "expected: %0d", $signed(l / r),
          "  computed: %0d", $signed(out_quotient),
        );
      if (done && out_remainder != $signed(((l % r) + r) % r))
        $error(
          "\nstd_sdiv_pipe (Remainder): Computed and golden outputs do not match!\n",
          "left: %0d", l,
          "  right: %0d\n", r,
          "expected: %0d", $signed(((l % r) + r) % r),
          "  computed: %0d", $signed(out_remainder),
        );
    end
  `endif
endmodule

module std_sgt #(
    parameter WIDTH = 32
) (
    input  signed [WIDTH-1:0] left,
    input  signed [WIDTH-1:0] right,
    output signed             out
);
  assign out = $signed(left > right);
endmodule

module std_slt #(
    parameter WIDTH = 32
) (
    input  signed [WIDTH-1:0] left,
    input  signed [WIDTH-1:0] right,
    output signed             out
);
  assign out = $signed(left < right);
endmodule

module std_seq #(
    parameter WIDTH = 32
) (
    input  signed [WIDTH-1:0] left,
    input  signed [WIDTH-1:0] right,
    output signed             out
);
  assign out = $signed(left == right);
endmodule

module std_sneq #(
    parameter WIDTH = 32
) (
    input  signed [WIDTH-1:0] left,
    input  signed [WIDTH-1:0] right,
    output signed             out
);
  assign out = $signed(left != right);
endmodule

module std_sge #(
    parameter WIDTH = 32
) (
    input  signed [WIDTH-1:0] left,
    input  signed [WIDTH-1:0] right,
    output signed             out
);
  assign out = $signed(left >= right);
endmodule

module std_sle #(
    parameter WIDTH = 32
) (
    input  signed [WIDTH-1:0] left,
    input  signed [WIDTH-1:0] right,
    output signed             out
);
  assign out = $signed(left <= right);
endmodule

module std_slsh #(
    parameter WIDTH = 32
) (
    input  signed [WIDTH-1:0] left,
    input  signed [WIDTH-1:0] right,
    output signed [WIDTH-1:0] out
);
  assign out = left <<< right;
endmodule

module std_srsh #(
    parameter WIDTH = 32
) (
    input  signed [WIDTH-1:0] left,
    input  signed [WIDTH-1:0] right,
    output signed [WIDTH-1:0] out
);
  assign out = left >>> right;
endmodule

// Signed extension
module std_signext #(
  parameter IN_WIDTH  = 32,
  parameter OUT_WIDTH = 32
) (
  input wire logic [IN_WIDTH-1:0]  in,
  output logic     [OUT_WIDTH-1:0] out
);
  localparam EXTEND = OUT_WIDTH - IN_WIDTH;
  assign out = { {EXTEND {in[IN_WIDTH-1]}}, in};

  `ifdef VERILATOR
    always_comb begin
      if (IN_WIDTH > OUT_WIDTH)
        $error(
          "std_signext: Output width less than input width\n",
          "IN_WIDTH: %0d", IN_WIDTH,
          "OUT_WIDTH: %0d", OUT_WIDTH
        );
    end
  `endif
endmodule

module std_const_mult #(
    parameter WIDTH = 32,
    parameter VALUE = 1
) (
    input  signed [WIDTH-1:0] in,
    output signed [WIDTH-1:0] out
);
  assign out = in * VALUE;
endmodule

/**
 * Core primitives for Calyx.
 * Implements core primitives used by the compiler.
 *
 * Conventions:
 * - All parameter names must be SNAKE_CASE and all caps.
 * - Port names must be snake_case, no caps.
 */

module std_slice #(
    parameter IN_WIDTH  = 32,
    parameter OUT_WIDTH = 32
) (
   input wire                   logic [ IN_WIDTH-1:0] in,
   output logic [OUT_WIDTH-1:0] out
);
  assign out = in[OUT_WIDTH-1:0];

  `ifdef VERILATOR
    always_comb begin
      if (IN_WIDTH < OUT_WIDTH)
        $error(
          "std_slice: Input width less than output width\n",
          "IN_WIDTH: %0d", IN_WIDTH,
          "OUT_WIDTH: %0d", OUT_WIDTH
        );
    end
  `endif
endmodule

module std_pad #(
    parameter IN_WIDTH  = 32,
    parameter OUT_WIDTH = 32
) (
   input wire logic [IN_WIDTH-1:0]  in,
   output logic     [OUT_WIDTH-1:0] out
);
  localparam EXTEND = OUT_WIDTH - IN_WIDTH;
  assign out = { {EXTEND {1'b0}}, in};

  `ifdef VERILATOR
    always_comb begin
      if (IN_WIDTH > OUT_WIDTH)
        $error(
          "std_pad: Output width less than input width\n",
          "IN_WIDTH: %0d", IN_WIDTH,
          "OUT_WIDTH: %0d", OUT_WIDTH
        );
    end
  `endif
endmodule

module std_cat #(
  parameter LEFT_WIDTH  = 32,
  parameter RIGHT_WIDTH = 32,
  parameter OUT_WIDTH = 64
) (
  input wire logic [LEFT_WIDTH-1:0] left,
  input wire logic [RIGHT_WIDTH-1:0] right,
  output logic [OUT_WIDTH-1:0] out
);
  assign out = {left, right};

  `ifdef VERILATOR
    always_comb begin
      if (LEFT_WIDTH + RIGHT_WIDTH != OUT_WIDTH)
        $error(
          "std_cat: Output width must equal sum of input widths\n",
          "LEFT_WIDTH: %0d", LEFT_WIDTH,
          "RIGHT_WIDTH: %0d", RIGHT_WIDTH,
          "OUT_WIDTH: %0d", OUT_WIDTH
        );
    end
  `endif
endmodule

module std_not #(
    parameter WIDTH = 32
) (
   input wire               logic [WIDTH-1:0] in,
   output logic [WIDTH-1:0] out
);
  assign out = ~in;
endmodule

module std_and #(
    parameter WIDTH = 32
) (
   input wire               logic [WIDTH-1:0] left,
   input wire               logic [WIDTH-1:0] right,
   output logic [WIDTH-1:0] out
);
  assign out = left & right;
endmodule

module std_or #(
    parameter WIDTH = 32
) (
   input wire               logic [WIDTH-1:0] left,
   input wire               logic [WIDTH-1:0] right,
   output logic [WIDTH-1:0] out
);
  assign out = left | right;
endmodule

module std_xor #(
    parameter WIDTH = 32
) (
   input wire               logic [WIDTH-1:0] left,
   input wire               logic [WIDTH-1:0] right,
   output logic [WIDTH-1:0] out
);
  assign out = left ^ right;
endmodule

module std_sub #(
    parameter WIDTH = 32
) (
   input wire               logic [WIDTH-1:0] left,
   input wire               logic [WIDTH-1:0] right,
   output logic [WIDTH-1:0] out
);
  assign out = left - right;
endmodule

module std_gt #(
    parameter WIDTH = 32
) (
   input wire   logic [WIDTH-1:0] left,
   input wire   logic [WIDTH-1:0] right,
   output logic out
);
  assign out = left > right;
endmodule

module std_lt #(
    parameter WIDTH = 32
) (
   input wire   logic [WIDTH-1:0] left,
   input wire   logic [WIDTH-1:0] right,
   output logic out
);
  assign out = left < right;
endmodule

module std_eq #(
    parameter WIDTH = 32
) (
   input wire   logic [WIDTH-1:0] left,
   input wire   logic [WIDTH-1:0] right,
   output logic out
);
  assign out = left == right;
endmodule

module std_neq #(
    parameter WIDTH = 32
) (
   input wire   logic [WIDTH-1:0] left,
   input wire   logic [WIDTH-1:0] right,
   output logic out
);
  assign out = left != right;
endmodule

module std_ge #(
    parameter WIDTH = 32
) (
    input wire   logic [WIDTH-1:0] left,
    input wire   logic [WIDTH-1:0] right,
    output logic out
);
  assign out = left >= right;
endmodule

module std_le #(
    parameter WIDTH = 32
) (
   input wire   logic [WIDTH-1:0] left,
   input wire   logic [WIDTH-1:0] right,
   output logic out
);
  assign out = left <= right;
endmodule

module std_rsh #(
    parameter WIDTH = 32
) (
   input wire               logic [WIDTH-1:0] left,
   input wire               logic [WIDTH-1:0] right,
   output logic [WIDTH-1:0] out
);
  assign out = left >> right;
endmodule

/// this primitive is intended to be used
/// for lowering purposes (not in source programs)
module std_mux #(
    parameter WIDTH = 32
) (
   input wire               logic cond,
   input wire               logic [WIDTH-1:0] tru,
   input wire               logic [WIDTH-1:0] fal,
   output logic [WIDTH-1:0] out
);
  assign out = cond ? tru : fal;
endmodule

module std_bit_slice #(
    parameter IN_WIDTH = 32,
    parameter START_IDX = 0,
    parameter END_IDX = 31,
    parameter OUT_WIDTH = 32
)(
   input wire logic [IN_WIDTH-1:0] in,
   output logic [OUT_WIDTH-1:0] out
);
  assign out = in[END_IDX:START_IDX];

  `ifdef VERILATOR
    always_comb begin
      if (START_IDX < 0 || END_IDX > IN_WIDTH-1)
        $error(
          "std_bit_slice: Slice range out of bounds\n",
          "IN_WIDTH: %0d", IN_WIDTH,
          "START_IDX: %0d", START_IDX,
          "END_IDX: %0d", END_IDX,
        );
    end
  `endif

endmodule

module std_skid_buffer #(
    parameter WIDTH = 32
)(
    input wire logic [WIDTH-1:0] in,
    input wire logic i_valid,
    input wire logic i_ready,
    input wire logic clk,
    input wire logic reset,
    output logic [WIDTH-1:0] out,
    output logic o_valid,
    output logic o_ready
);
  logic [WIDTH-1:0] val;
  logic bypass_rg;
  always @(posedge clk) begin
    // Reset  
    if (reset) begin      
      // Internal Registers
      val <= '0;     
      bypass_rg <= 1'b1;
    end   
    // Out of reset
    else begin      
      // Bypass state      
      if (bypass_rg) begin         
        if (!i_ready && i_valid) begin
          val <= in;          // Data skid happened, store to buffer
          bypass_rg <= 1'b0;  // To skid mode  
        end 
      end 
      // Skid state
      else begin         
        if (i_ready) begin
          bypass_rg <= 1'b1;  // Back to bypass mode           
        end
      end
    end
  end

  assign o_ready = bypass_rg;
  assign out = bypass_rg ? in : val;
  assign o_valid = bypass_rg ? i_valid : 1'b1;
endmodule

module std_bypass_reg #(
    parameter WIDTH = 32
)(
    input wire logic [WIDTH-1:0] in,
    input wire logic write_en,
    input wire logic clk,
    input wire logic reset,
    output logic [WIDTH-1:0] out,
    output logic done
);
  logic [WIDTH-1:0] val;
  assign out = write_en ? in : val;

  always_ff @(posedge clk) begin
    if (reset) begin
      val <= 0;
      done <= 0;
    end else if (write_en) begin
      val <= in;
      done <= 1'd1;
    end else done <= 1'd0;
  end
endmodule

/**
Implements a memory with sequential reads and writes.
- Both reads and writes take one cycle to perform.
- Attempting to read and write at the same time is an error.
- The out signal is registered to the last value requested by the read_en signal.
- The out signal is undefined once write_en is asserted.
*/
module seq_mem_d1 #(
    parameter WIDTH = 32,
    parameter SIZE = 16,
    parameter IDX_SIZE = 4
) (
   // Common signals
   input wire logic clk,
   input wire logic reset,
   input wire logic [IDX_SIZE-1:0] addr0,
   input wire logic content_en,
   output logic done,

   // Read signal
   output logic [ WIDTH-1:0] read_data,

   // Write signals
   input wire logic [ WIDTH-1:0] write_data,
   input wire logic write_en
);
  // Internal memory
  logic [WIDTH-1:0] mem[SIZE-1:0];

  // Register for the read output
  logic [WIDTH-1:0] read_out;
  assign read_data = read_out;

  // Read value from the memory
  always_ff @(posedge clk) begin
    if (reset) begin
      read_out <= '0;
    end else if (content_en && !write_en) begin
      /* verilator lint_off WIDTH */
      read_out <= mem[addr0];
    end else if (content_en && write_en) begin
      // Explicitly clobber the read output when a write is performed
      read_out <= 'x;
    end else begin
      read_out <= read_out;
    end
  end

  // Propagate the done signal
  always_ff @(posedge clk) begin
    if (reset) begin
      done <= '0;
    end else if (content_en) begin
      done <= '1;
    end else begin
      done <= '0;
    end
  end

  // Write value to the memory
  always_ff @(posedge clk) begin
    if (!reset && content_en && write_en)
      mem[addr0] <= write_data;
  end

  // Check for out of bounds access
  `ifdef VERILATOR
    always_comb begin
      if (content_en && !write_en)
        if (addr0 >= SIZE)
          $error(
            "comb_mem_d1: Out of bounds access\n",
            "addr0: %0d\n", addr0,
            "SIZE: %0d", SIZE
          );
    end
  `endif
endmodule

module seq_mem_d2 #(
    parameter WIDTH = 32,
    parameter D0_SIZE = 16,
    parameter D1_SIZE = 16,
    parameter D0_IDX_SIZE = 4,
    parameter D1_IDX_SIZE = 4
) (
   // Common signals
   input wire logic clk,
   input wire logic reset,
   input wire logic [D0_IDX_SIZE-1:0] addr0,
   input wire logic [D1_IDX_SIZE-1:0] addr1,
   input wire logic content_en,
   output logic done,

   // Read signal
   output logic [WIDTH-1:0] read_data,

   // Write signals
   input wire logic write_en,
   input wire logic [ WIDTH-1:0] write_data
);
  wire [D0_IDX_SIZE+D1_IDX_SIZE-1:0] addr;
  assign addr = addr0 * D1_SIZE + addr1;

  seq_mem_d1 #(.WIDTH(WIDTH), .SIZE(D0_SIZE * D1_SIZE), .IDX_SIZE(D0_IDX_SIZE+D1_IDX_SIZE)) mem
     (.clk(clk), .reset(reset), .addr0(addr),
    .content_en(content_en), .read_data(read_data), .write_data(write_data), .write_en(write_en),
    .done(done));
endmodule

module seq_mem_d3 #(
    parameter WIDTH = 32,
    parameter D0_SIZE = 16,
    parameter D1_SIZE = 16,
    parameter D2_SIZE = 16,
    parameter D0_IDX_SIZE = 4,
    parameter D1_IDX_SIZE = 4,
    parameter D2_IDX_SIZE = 4
) (
   // Common signals
   input wire logic clk,
   input wire logic reset,
   input wire logic [D0_IDX_SIZE-1:0] addr0,
   input wire logic [D1_IDX_SIZE-1:0] addr1,
   input wire logic [D2_IDX_SIZE-1:0] addr2,
   input wire logic content_en,
   output logic done,

   // Read signal
   output logic [WIDTH-1:0] read_data,

   // Write signals
   input wire logic write_en,
   input wire logic [ WIDTH-1:0] write_data
);
  wire [D0_IDX_SIZE+D1_IDX_SIZE+D2_IDX_SIZE-1:0] addr;
  assign addr = addr0 * (D1_SIZE * D2_SIZE) + addr1 * (D2_SIZE) + addr2;

  seq_mem_d1 #(.WIDTH(WIDTH), .SIZE(D0_SIZE * D1_SIZE * D2_SIZE), .IDX_SIZE(D0_IDX_SIZE+D1_IDX_SIZE+D2_IDX_SIZE)) mem
     (.clk(clk), .reset(reset), .addr0(addr),
    .content_en(content_en), .read_data(read_data), .write_data(write_data), .write_en(write_en),
    .done(done));
endmodule

module seq_mem_d4 #(
    parameter WIDTH = 32,
    parameter D0_SIZE = 16,
    parameter D1_SIZE = 16,
    parameter D2_SIZE = 16,
    parameter D3_SIZE = 16,
    parameter D0_IDX_SIZE = 4,
    parameter D1_IDX_SIZE = 4,
    parameter D2_IDX_SIZE = 4,
    parameter D3_IDX_SIZE = 4
) (
   // Common signals
   input wire logic clk,
   input wire logic reset,
   input wire logic [D0_IDX_SIZE-1:0] addr0,
   input wire logic [D1_IDX_SIZE-1:0] addr1,
   input wire logic [D2_IDX_SIZE-1:0] addr2,
   input wire logic [D3_IDX_SIZE-1:0] addr3,
   input wire logic content_en,
   output logic done,

   // Read signal
   output logic [WIDTH-1:0] read_data,

   // Write signals
   input wire logic write_en,
   input wire logic [ WIDTH-1:0] write_data
);
  wire [D0_IDX_SIZE+D1_IDX_SIZE+D2_IDX_SIZE+D3_IDX_SIZE-1:0] addr;
  assign addr = addr0 * (D1_SIZE * D2_SIZE * D3_SIZE) + addr1 * (D2_SIZE * D3_SIZE) + addr2 * (D3_SIZE) + addr3;

  seq_mem_d1 #(.WIDTH(WIDTH), .SIZE(D0_SIZE * D1_SIZE * D2_SIZE * D3_SIZE), .IDX_SIZE(D0_IDX_SIZE+D1_IDX_SIZE+D2_IDX_SIZE+D3_IDX_SIZE)) mem
     (.clk(clk), .reset(reset), .addr0(addr),
    .content_en(content_en), .read_data(read_data), .write_data(write_data), .write_en(write_en),
    .done(done));
endmodule

module undef #(
    parameter WIDTH = 32
) (
   output logic [WIDTH-1:0] out
);
assign out = 'x;
endmodule

module std_const #(
    parameter WIDTH = 32,
    parameter VALUE = 32
) (
   output logic [WIDTH-1:0] out
);
assign out = VALUE;
endmodule

module std_wire #(
    parameter WIDTH = 32
) (
   input wire logic [WIDTH-1:0] in,
   output logic [WIDTH-1:0] out
);
assign out = in;
endmodule

module std_add #(
    parameter WIDTH = 32
) (
   input wire logic [WIDTH-1:0] left,
   input wire logic [WIDTH-1:0] right,
   output logic [WIDTH-1:0] out
);
assign out = left + right;
endmodule

module std_lsh #(
    parameter WIDTH = 32
) (
   input wire logic [WIDTH-1:0] left,
   input wire logic [WIDTH-1:0] right,
   output logic [WIDTH-1:0] out
);
assign out = left << right;
endmodule

module std_reg #(
    parameter WIDTH = 32
) (
   input wire logic [WIDTH-1:0] in,
   input wire logic write_en,
   input wire logic clk,
   input wire logic reset,
   output logic [WIDTH-1:0] out,
   output logic done
);
always_ff @(posedge clk) begin
    if (reset) begin
       out <= 0;
       done <= 0;
    end else if (write_en) begin
      out <= in;
      done <= 1'd1;
    end else done <= 1'd0;
  end
endmodule

module init_one_reg #(
    parameter WIDTH = 32
) (
   input wire logic [WIDTH-1:0] in,
   input wire logic write_en,
   input wire logic clk,
   input wire logic reset,
   output logic [WIDTH-1:0] out,
   output logic done
);
always_ff @(posedge clk) begin
    if (reset) begin
       out <= 1;
       done <= 0;
    end else if (write_en) begin
      out <= in;
      done <= 1'd1;
    end else done <= 1'd0;
  end
endmodule

module main(
  input logic clk,
  input logic reset,
  input logic go,
  output logic done
);
// COMPONENT START: main
`ifndef SYNTHESIS
string DATA;
int CODE;
initial begin
    CODE = $value$plusargs("DATA=%s", DATA);
    $display("DATA (path to meminit files): %s", DATA);
    $readmemh({DATA, "/mem_2.dat"}, mem_2.mem);
    $readmemh({DATA, "/mem_1.dat"}, mem_1.mem);
    $readmemh({DATA, "/mem_0.dat"}, mem_0.mem);
end
final begin
    $writememh({DATA, "/mem_2.out"}, mem_2.mem);
    $writememh({DATA, "/mem_1.out"}, mem_1.mem);
    $writememh({DATA, "/mem_0.out"}, mem_0.mem);
end
`endif
logic mem_2_clk;
logic mem_2_reset;
logic [9:0] mem_2_addr0;
logic mem_2_content_en;
logic mem_2_write_en;
logic [31:0] mem_2_write_data;
logic [31:0] mem_2_read_data;
logic mem_2_done;
logic mem_1_clk;
logic mem_1_reset;
logic [9:0] mem_1_addr0;
logic mem_1_content_en;
logic mem_1_write_en;
logic [31:0] mem_1_write_data;
logic [31:0] mem_1_read_data;
logic mem_1_done;
logic mem_0_clk;
logic mem_0_reset;
logic [9:0] mem_0_addr0;
logic mem_0_content_en;
logic mem_0_write_en;
logic [31:0] mem_0_write_data;
logic [31:0] mem_0_read_data;
logic mem_0_done;
logic gemm_instance_clk;
logic gemm_instance_reset;
logic gemm_instance_go;
logic gemm_instance_done;
logic [31:0] gemm_instance_arg_mem_0_read_data;
logic gemm_instance_arg_mem_0_done;
logic [31:0] gemm_instance_arg_mem_1_write_data;
logic [31:0] gemm_instance_arg_mem_2_read_data;
logic [31:0] gemm_instance_arg_mem_1_read_data;
logic gemm_instance_arg_mem_0_content_en;
logic [9:0] gemm_instance_arg_mem_0_addr0;
logic gemm_instance_arg_mem_0_write_en;
logic [9:0] gemm_instance_arg_mem_2_addr0;
logic gemm_instance_arg_mem_2_done;
logic gemm_instance_arg_mem_1_done;
logic gemm_instance_arg_mem_2_content_en;
logic [31:0] gemm_instance_arg_mem_0_write_data;
logic gemm_instance_arg_mem_1_write_en;
logic gemm_instance_arg_mem_2_write_en;
logic [31:0] gemm_instance_arg_mem_2_write_data;
logic [9:0] gemm_instance_arg_mem_1_addr0;
logic gemm_instance_arg_mem_1_content_en;
logic invoke0_go_in;
logic invoke0_go_out;
logic invoke0_done_in;
logic invoke0_done_out;
seq_mem_d1 # (
    .IDX_SIZE(10),
    .SIZE(1024),
    .WIDTH(32)
) mem_2 (
    .addr0(mem_2_addr0),
    .clk(mem_2_clk),
    .content_en(mem_2_content_en),
    .done(mem_2_done),
    .read_data(mem_2_read_data),
    .reset(mem_2_reset),
    .write_data(mem_2_write_data),
    .write_en(mem_2_write_en)
);
seq_mem_d1 # (
    .IDX_SIZE(10),
    .SIZE(1024),
    .WIDTH(32)
) mem_1 (
    .addr0(mem_1_addr0),
    .clk(mem_1_clk),
    .content_en(mem_1_content_en),
    .done(mem_1_done),
    .read_data(mem_1_read_data),
    .reset(mem_1_reset),
    .write_data(mem_1_write_data),
    .write_en(mem_1_write_en)
);
seq_mem_d1 # (
    .IDX_SIZE(10),
    .SIZE(1024),
    .WIDTH(32)
) mem_0 (
    .addr0(mem_0_addr0),
    .clk(mem_0_clk),
    .content_en(mem_0_content_en),
    .done(mem_0_done),
    .read_data(mem_0_read_data),
    .reset(mem_0_reset),
    .write_data(mem_0_write_data),
    .write_en(mem_0_write_en)
);
gemm gemm_instance (
    .arg_mem_0_addr0(gemm_instance_arg_mem_0_addr0),
    .arg_mem_0_content_en(gemm_instance_arg_mem_0_content_en),
    .arg_mem_0_done(gemm_instance_arg_mem_0_done),
    .arg_mem_0_read_data(gemm_instance_arg_mem_0_read_data),
    .arg_mem_0_write_data(gemm_instance_arg_mem_0_write_data),
    .arg_mem_0_write_en(gemm_instance_arg_mem_0_write_en),
    .arg_mem_1_addr0(gemm_instance_arg_mem_1_addr0),
    .arg_mem_1_content_en(gemm_instance_arg_mem_1_content_en),
    .arg_mem_1_done(gemm_instance_arg_mem_1_done),
    .arg_mem_1_read_data(gemm_instance_arg_mem_1_read_data),
    .arg_mem_1_write_data(gemm_instance_arg_mem_1_write_data),
    .arg_mem_1_write_en(gemm_instance_arg_mem_1_write_en),
    .arg_mem_2_addr0(gemm_instance_arg_mem_2_addr0),
    .arg_mem_2_content_en(gemm_instance_arg_mem_2_content_en),
    .arg_mem_2_done(gemm_instance_arg_mem_2_done),
    .arg_mem_2_read_data(gemm_instance_arg_mem_2_read_data),
    .arg_mem_2_write_data(gemm_instance_arg_mem_2_write_data),
    .arg_mem_2_write_en(gemm_instance_arg_mem_2_write_en),
    .clk(gemm_instance_clk),
    .done(gemm_instance_done),
    .go(gemm_instance_go),
    .reset(gemm_instance_reset)
);
std_wire # (
    .WIDTH(1)
) invoke0_go (
    .in(invoke0_go_in),
    .out(invoke0_go_out)
);
std_wire # (
    .WIDTH(1)
) invoke0_done (
    .in(invoke0_done_in),
    .out(invoke0_done_out)
);
wire _guard0 = 1;
wire _guard1 = invoke0_done_out;
wire _guard2 = invoke0_go_out;
wire _guard3 = invoke0_go_out;
wire _guard4 = invoke0_go_out;
wire _guard5 = invoke0_go_out;
wire _guard6 = invoke0_go_out;
wire _guard7 = invoke0_go_out;
wire _guard8 = invoke0_go_out;
wire _guard9 = invoke0_go_out;
wire _guard10 = invoke0_go_out;
wire _guard11 = invoke0_go_out;
wire _guard12 = invoke0_go_out;
wire _guard13 = invoke0_go_out;
wire _guard14 = invoke0_go_out;
wire _guard15 = invoke0_go_out;
wire _guard16 = invoke0_go_out;
wire _guard17 = invoke0_go_out;
wire _guard18 = invoke0_go_out;
assign done = _guard1;
assign mem_2_write_en =
  _guard2 ? gemm_instance_arg_mem_2_write_en :
  1'd0;
assign mem_2_clk = clk;
assign mem_2_addr0 = gemm_instance_arg_mem_2_addr0;
assign mem_2_content_en =
  _guard4 ? gemm_instance_arg_mem_2_content_en :
  1'd0;
assign mem_2_reset = reset;
assign mem_2_write_data = gemm_instance_arg_mem_2_write_data;
assign invoke0_go_in = go;
assign mem_1_write_en =
  _guard6 ? gemm_instance_arg_mem_1_write_en :
  1'd0;
assign mem_1_clk = clk;
assign mem_1_addr0 = gemm_instance_arg_mem_1_addr0;
assign mem_1_content_en =
  _guard8 ? gemm_instance_arg_mem_1_content_en :
  1'd0;
assign mem_1_reset = reset;
assign invoke0_done_in = gemm_instance_done;
assign mem_0_write_en =
  _guard9 ? gemm_instance_arg_mem_0_write_en :
  1'd0;
assign mem_0_clk = clk;
assign mem_0_addr0 = gemm_instance_arg_mem_0_addr0;
assign mem_0_content_en =
  _guard11 ? gemm_instance_arg_mem_0_content_en :
  1'd0;
assign mem_0_reset = reset;
assign gemm_instance_arg_mem_0_read_data =
  _guard12 ? mem_0_read_data :
  32'd0;
assign gemm_instance_arg_mem_0_done =
  _guard13 ? mem_0_done :
  1'd0;
assign gemm_instance_arg_mem_2_read_data =
  _guard14 ? mem_2_read_data :
  32'd0;
assign gemm_instance_arg_mem_1_read_data =
  _guard15 ? mem_1_read_data :
  32'd0;
assign gemm_instance_clk = clk;
assign gemm_instance_reset = reset;
assign gemm_instance_go = _guard16;
assign gemm_instance_arg_mem_2_done =
  _guard17 ? mem_2_done :
  1'd0;
assign gemm_instance_arg_mem_1_done =
  _guard18 ? mem_1_done :
  1'd0;
// COMPONENT END: main
endmodule
module gemm(
  input logic clk,
  input logic reset,
  input logic go,
  output logic done,
  output logic [9:0] arg_mem_2_addr0,
  output logic arg_mem_2_content_en,
  output logic arg_mem_2_write_en,
  output logic [31:0] arg_mem_2_write_data,
  input logic [31:0] arg_mem_2_read_data,
  input logic arg_mem_2_done,
  output logic [9:0] arg_mem_1_addr0,
  output logic arg_mem_1_content_en,
  output logic arg_mem_1_write_en,
  output logic [31:0] arg_mem_1_write_data,
  input logic [31:0] arg_mem_1_read_data,
  input logic arg_mem_1_done,
  output logic [9:0] arg_mem_0_addr0,
  output logic arg_mem_0_content_en,
  output logic arg_mem_0_write_en,
  output logic [31:0] arg_mem_0_write_data,
  input logic [31:0] arg_mem_0_read_data,
  input logic arg_mem_0_done
);
// COMPONENT START: gemm
logic [31:0] std_slice_4_in;
logic [9:0] std_slice_4_out;
logic [31:0] std_add_7_left;
logic [31:0] std_add_7_right;
logic [31:0] std_add_7_out;
logic [31:0] std_lsh_3_left;
logic [31:0] std_lsh_3_right;
logic [31:0] std_lsh_3_out;
logic [64:0] std_slice_0_in;
logic [31:0] std_slice_0_out;
logic [64:0] std_add_3_left;
logic [64:0] std_add_3_right;
logic [64:0] std_add_3_out;
logic [63:0] std_signext_3_in;
logic [64:0] std_signext_3_out;
logic [31:0] std_signext_2_in;
logic [64:0] std_signext_2_out;
logic [31:0] load_0_reg_in;
logic load_0_reg_write_en;
logic load_0_reg_clk;
logic load_0_reg_reset;
logic [31:0] load_0_reg_out;
logic load_0_reg_done;
logic [63:0] muli_0_reg_in;
logic muli_0_reg_write_en;
logic muli_0_reg_clk;
logic muli_0_reg_reset;
logic [63:0] muli_0_reg_out;
logic muli_0_reg_done;
logic std_mult_pipe_0_clk;
logic std_mult_pipe_0_reset;
logic std_mult_pipe_0_go;
logic [63:0] std_mult_pipe_0_left;
logic [63:0] std_mult_pipe_0_right;
logic [63:0] std_mult_pipe_0_out;
logic std_mult_pipe_0_done;
logic [31:0] std_signext_1_in;
logic [63:0] std_signext_1_out;
logic [31:0] std_signext_0_in;
logic [63:0] std_signext_0_out;
logic [31:0] for_2_induction_var_reg_in;
logic for_2_induction_var_reg_write_en;
logic for_2_induction_var_reg_clk;
logic for_2_induction_var_reg_reset;
logic [31:0] for_2_induction_var_reg_out;
logic for_2_induction_var_reg_done;
logic [31:0] for_1_induction_var_reg_in;
logic for_1_induction_var_reg_write_en;
logic for_1_induction_var_reg_clk;
logic for_1_induction_var_reg_reset;
logic [31:0] for_1_induction_var_reg_out;
logic for_1_induction_var_reg_done;
logic [31:0] for_0_induction_var_reg_in;
logic for_0_induction_var_reg_write_en;
logic for_0_induction_var_reg_clk;
logic for_0_induction_var_reg_reset;
logic [31:0] for_0_induction_var_reg_out;
logic for_0_induction_var_reg_done;
logic [5:0] idx_in;
logic idx_write_en;
logic idx_clk;
logic idx_reset;
logic [5:0] idx_out;
logic idx_done;
logic cond_reg_in;
logic cond_reg_write_en;
logic cond_reg_clk;
logic cond_reg_reset;
logic cond_reg_out;
logic cond_reg_done;
logic [5:0] adder_left;
logic [5:0] adder_right;
logic [5:0] adder_out;
logic [5:0] lt_left;
logic [5:0] lt_right;
logic lt_out;
logic [5:0] idx0_in;
logic idx0_write_en;
logic idx0_clk;
logic idx0_reset;
logic [5:0] idx0_out;
logic idx0_done;
logic cond_reg0_in;
logic cond_reg0_write_en;
logic cond_reg0_clk;
logic cond_reg0_reset;
logic cond_reg0_out;
logic cond_reg0_done;
logic [5:0] adder0_left;
logic [5:0] adder0_right;
logic [5:0] adder0_out;
logic [5:0] lt0_left;
logic [5:0] lt0_right;
logic lt0_out;
logic [5:0] idx1_in;
logic idx1_write_en;
logic idx1_clk;
logic idx1_reset;
logic [5:0] idx1_out;
logic idx1_done;
logic cond_reg1_in;
logic cond_reg1_write_en;
logic cond_reg1_clk;
logic cond_reg1_reset;
logic cond_reg1_out;
logic cond_reg1_done;
logic [5:0] adder1_left;
logic [5:0] adder1_right;
logic [5:0] adder1_out;
logic [5:0] lt1_left;
logic [5:0] lt1_right;
logic lt1_out;
logic [2:0] fsm_in;
logic fsm_write_en;
logic fsm_clk;
logic fsm_reset;
logic [2:0] fsm_out;
logic fsm_done;
logic [2:0] adder2_left;
logic [2:0] adder2_right;
logic [2:0] adder2_out;
logic ud_out;
logic signal_reg_in;
logic signal_reg_write_en;
logic signal_reg_clk;
logic signal_reg_reset;
logic signal_reg_out;
logic signal_reg_done;
logic [4:0] fsm0_in;
logic fsm0_write_en;
logic fsm0_clk;
logic fsm0_reset;
logic [4:0] fsm0_out;
logic fsm0_done;
logic beg_spl_bb0_11_go_in;
logic beg_spl_bb0_11_go_out;
logic beg_spl_bb0_11_done_in;
logic beg_spl_bb0_11_done_out;
logic bb0_2_go_in;
logic bb0_2_go_out;
logic bb0_2_done_in;
logic bb0_2_done_out;
logic bb0_5_go_in;
logic bb0_5_go_out;
logic bb0_5_done_in;
logic bb0_5_done_out;
logic bb0_18_go_in;
logic bb0_18_go_out;
logic bb0_18_done_in;
logic bb0_18_done_out;
logic invoke0_go_in;
logic invoke0_go_out;
logic invoke0_done_in;
logic invoke0_done_out;
logic invoke1_go_in;
logic invoke1_go_out;
logic invoke1_done_in;
logic invoke1_done_out;
logic invoke2_go_in;
logic invoke2_go_out;
logic invoke2_done_in;
logic invoke2_done_out;
logic invoke5_go_in;
logic invoke5_go_out;
logic invoke5_done_in;
logic invoke5_done_out;
logic invoke6_go_in;
logic invoke6_go_out;
logic invoke6_done_in;
logic invoke6_done_out;
logic invoke7_go_in;
logic invoke7_go_out;
logic invoke7_done_in;
logic invoke7_done_out;
logic invoke8_go_in;
logic invoke8_go_out;
logic invoke8_done_in;
logic invoke8_done_out;
logic init_repeat_go_in;
logic init_repeat_go_out;
logic init_repeat_done_in;
logic init_repeat_done_out;
logic incr_repeat_go_in;
logic incr_repeat_go_out;
logic incr_repeat_done_in;
logic incr_repeat_done_out;
logic init_repeat0_go_in;
logic init_repeat0_go_out;
logic init_repeat0_done_in;
logic init_repeat0_done_out;
logic incr_repeat0_go_in;
logic incr_repeat0_go_out;
logic incr_repeat0_done_in;
logic incr_repeat0_done_out;
logic init_repeat1_go_in;
logic init_repeat1_go_out;
logic init_repeat1_done_in;
logic init_repeat1_done_out;
logic incr_repeat1_go_in;
logic incr_repeat1_go_out;
logic incr_repeat1_done_in;
logic incr_repeat1_done_out;
logic early_reset_static_seq_go_in;
logic early_reset_static_seq_go_out;
logic early_reset_static_seq_done_in;
logic early_reset_static_seq_done_out;
logic wrapper_early_reset_static_seq_go_in;
logic wrapper_early_reset_static_seq_go_out;
logic wrapper_early_reset_static_seq_done_in;
logic wrapper_early_reset_static_seq_done_out;
logic tdcc_go_in;
logic tdcc_go_out;
logic tdcc_done_in;
logic tdcc_done_out;
std_slice # (
    .IN_WIDTH(32),
    .OUT_WIDTH(10)
) std_slice_4 (
    .in(std_slice_4_in),
    .out(std_slice_4_out)
);
std_add # (
    .WIDTH(32)
) std_add_7 (
    .left(std_add_7_left),
    .out(std_add_7_out),
    .right(std_add_7_right)
);
std_lsh # (
    .WIDTH(32)
) std_lsh_3 (
    .left(std_lsh_3_left),
    .out(std_lsh_3_out),
    .right(std_lsh_3_right)
);
std_slice # (
    .IN_WIDTH(65),
    .OUT_WIDTH(32)
) std_slice_0 (
    .in(std_slice_0_in),
    .out(std_slice_0_out)
);
std_add # (
    .WIDTH(65)
) std_add_3 (
    .left(std_add_3_left),
    .out(std_add_3_out),
    .right(std_add_3_right)
);
std_signext # (
    .IN_WIDTH(64),
    .OUT_WIDTH(65)
) std_signext_3 (
    .in(std_signext_3_in),
    .out(std_signext_3_out)
);
std_signext # (
    .IN_WIDTH(32),
    .OUT_WIDTH(65)
) std_signext_2 (
    .in(std_signext_2_in),
    .out(std_signext_2_out)
);
std_reg # (
    .WIDTH(32)
) load_0_reg (
    .clk(load_0_reg_clk),
    .done(load_0_reg_done),
    .in(load_0_reg_in),
    .out(load_0_reg_out),
    .reset(load_0_reg_reset),
    .write_en(load_0_reg_write_en)
);
std_reg # (
    .WIDTH(64)
) muli_0_reg (
    .clk(muli_0_reg_clk),
    .done(muli_0_reg_done),
    .in(muli_0_reg_in),
    .out(muli_0_reg_out),
    .reset(muli_0_reg_reset),
    .write_en(muli_0_reg_write_en)
);
std_mult_pipe # (
    .WIDTH(64)
) std_mult_pipe_0 (
    .clk(std_mult_pipe_0_clk),
    .done(std_mult_pipe_0_done),
    .go(std_mult_pipe_0_go),
    .left(std_mult_pipe_0_left),
    .out(std_mult_pipe_0_out),
    .reset(std_mult_pipe_0_reset),
    .right(std_mult_pipe_0_right)
);
std_signext # (
    .IN_WIDTH(32),
    .OUT_WIDTH(64)
) std_signext_1 (
    .in(std_signext_1_in),
    .out(std_signext_1_out)
);
std_signext # (
    .IN_WIDTH(32),
    .OUT_WIDTH(64)
) std_signext_0 (
    .in(std_signext_0_in),
    .out(std_signext_0_out)
);
std_reg # (
    .WIDTH(32)
) for_2_induction_var_reg (
    .clk(for_2_induction_var_reg_clk),
    .done(for_2_induction_var_reg_done),
    .in(for_2_induction_var_reg_in),
    .out(for_2_induction_var_reg_out),
    .reset(for_2_induction_var_reg_reset),
    .write_en(for_2_induction_var_reg_write_en)
);
std_reg # (
    .WIDTH(32)
) for_1_induction_var_reg (
    .clk(for_1_induction_var_reg_clk),
    .done(for_1_induction_var_reg_done),
    .in(for_1_induction_var_reg_in),
    .out(for_1_induction_var_reg_out),
    .reset(for_1_induction_var_reg_reset),
    .write_en(for_1_induction_var_reg_write_en)
);
std_reg # (
    .WIDTH(32)
) for_0_induction_var_reg (
    .clk(for_0_induction_var_reg_clk),
    .done(for_0_induction_var_reg_done),
    .in(for_0_induction_var_reg_in),
    .out(for_0_induction_var_reg_out),
    .reset(for_0_induction_var_reg_reset),
    .write_en(for_0_induction_var_reg_write_en)
);
std_reg # (
    .WIDTH(6)
) idx (
    .clk(idx_clk),
    .done(idx_done),
    .in(idx_in),
    .out(idx_out),
    .reset(idx_reset),
    .write_en(idx_write_en)
);
std_reg # (
    .WIDTH(1)
) cond_reg (
    .clk(cond_reg_clk),
    .done(cond_reg_done),
    .in(cond_reg_in),
    .out(cond_reg_out),
    .reset(cond_reg_reset),
    .write_en(cond_reg_write_en)
);
std_add # (
    .WIDTH(6)
) adder (
    .left(adder_left),
    .out(adder_out),
    .right(adder_right)
);
std_lt # (
    .WIDTH(6)
) lt (
    .left(lt_left),
    .out(lt_out),
    .right(lt_right)
);
std_reg # (
    .WIDTH(6)
) idx0 (
    .clk(idx0_clk),
    .done(idx0_done),
    .in(idx0_in),
    .out(idx0_out),
    .reset(idx0_reset),
    .write_en(idx0_write_en)
);
std_reg # (
    .WIDTH(1)
) cond_reg0 (
    .clk(cond_reg0_clk),
    .done(cond_reg0_done),
    .in(cond_reg0_in),
    .out(cond_reg0_out),
    .reset(cond_reg0_reset),
    .write_en(cond_reg0_write_en)
);
std_add # (
    .WIDTH(6)
) adder0 (
    .left(adder0_left),
    .out(adder0_out),
    .right(adder0_right)
);
std_lt # (
    .WIDTH(6)
) lt0 (
    .left(lt0_left),
    .out(lt0_out),
    .right(lt0_right)
);
std_reg # (
    .WIDTH(6)
) idx1 (
    .clk(idx1_clk),
    .done(idx1_done),
    .in(idx1_in),
    .out(idx1_out),
    .reset(idx1_reset),
    .write_en(idx1_write_en)
);
std_reg # (
    .WIDTH(1)
) cond_reg1 (
    .clk(cond_reg1_clk),
    .done(cond_reg1_done),
    .in(cond_reg1_in),
    .out(cond_reg1_out),
    .reset(cond_reg1_reset),
    .write_en(cond_reg1_write_en)
);
std_add # (
    .WIDTH(6)
) adder1 (
    .left(adder1_left),
    .out(adder1_out),
    .right(adder1_right)
);
std_lt # (
    .WIDTH(6)
) lt1 (
    .left(lt1_left),
    .out(lt1_out),
    .right(lt1_right)
);
std_reg # (
    .WIDTH(3)
) fsm (
    .clk(fsm_clk),
    .done(fsm_done),
    .in(fsm_in),
    .out(fsm_out),
    .reset(fsm_reset),
    .write_en(fsm_write_en)
);
std_add # (
    .WIDTH(3)
) adder2 (
    .left(adder2_left),
    .out(adder2_out),
    .right(adder2_right)
);
undef # (
    .WIDTH(1)
) ud (
    .out(ud_out)
);
std_reg # (
    .WIDTH(1)
) signal_reg (
    .clk(signal_reg_clk),
    .done(signal_reg_done),
    .in(signal_reg_in),
    .out(signal_reg_out),
    .reset(signal_reg_reset),
    .write_en(signal_reg_write_en)
);
std_reg # (
    .WIDTH(5)
) fsm0 (
    .clk(fsm0_clk),
    .done(fsm0_done),
    .in(fsm0_in),
    .out(fsm0_out),
    .reset(fsm0_reset),
    .write_en(fsm0_write_en)
);
std_wire # (
    .WIDTH(1)
) beg_spl_bb0_11_go (
    .in(beg_spl_bb0_11_go_in),
    .out(beg_spl_bb0_11_go_out)
);
std_wire # (
    .WIDTH(1)
) beg_spl_bb0_11_done (
    .in(beg_spl_bb0_11_done_in),
    .out(beg_spl_bb0_11_done_out)
);
std_wire # (
    .WIDTH(1)
) bb0_2_go (
    .in(bb0_2_go_in),
    .out(bb0_2_go_out)
);
std_wire # (
    .WIDTH(1)
) bb0_2_done (
    .in(bb0_2_done_in),
    .out(bb0_2_done_out)
);
std_wire # (
    .WIDTH(1)
) bb0_5_go (
    .in(bb0_5_go_in),
    .out(bb0_5_go_out)
);
std_wire # (
    .WIDTH(1)
) bb0_5_done (
    .in(bb0_5_done_in),
    .out(bb0_5_done_out)
);
std_wire # (
    .WIDTH(1)
) bb0_18_go (
    .in(bb0_18_go_in),
    .out(bb0_18_go_out)
);
std_wire # (
    .WIDTH(1)
) bb0_18_done (
    .in(bb0_18_done_in),
    .out(bb0_18_done_out)
);
std_wire # (
    .WIDTH(1)
) invoke0_go (
    .in(invoke0_go_in),
    .out(invoke0_go_out)
);
std_wire # (
    .WIDTH(1)
) invoke0_done (
    .in(invoke0_done_in),
    .out(invoke0_done_out)
);
std_wire # (
    .WIDTH(1)
) invoke1_go (
    .in(invoke1_go_in),
    .out(invoke1_go_out)
);
std_wire # (
    .WIDTH(1)
) invoke1_done (
    .in(invoke1_done_in),
    .out(invoke1_done_out)
);
std_wire # (
    .WIDTH(1)
) invoke2_go (
    .in(invoke2_go_in),
    .out(invoke2_go_out)
);
std_wire # (
    .WIDTH(1)
) invoke2_done (
    .in(invoke2_done_in),
    .out(invoke2_done_out)
);
std_wire # (
    .WIDTH(1)
) invoke5_go (
    .in(invoke5_go_in),
    .out(invoke5_go_out)
);
std_wire # (
    .WIDTH(1)
) invoke5_done (
    .in(invoke5_done_in),
    .out(invoke5_done_out)
);
std_wire # (
    .WIDTH(1)
) invoke6_go (
    .in(invoke6_go_in),
    .out(invoke6_go_out)
);
std_wire # (
    .WIDTH(1)
) invoke6_done (
    .in(invoke6_done_in),
    .out(invoke6_done_out)
);
std_wire # (
    .WIDTH(1)
) invoke7_go (
    .in(invoke7_go_in),
    .out(invoke7_go_out)
);
std_wire # (
    .WIDTH(1)
) invoke7_done (
    .in(invoke7_done_in),
    .out(invoke7_done_out)
);
std_wire # (
    .WIDTH(1)
) invoke8_go (
    .in(invoke8_go_in),
    .out(invoke8_go_out)
);
std_wire # (
    .WIDTH(1)
) invoke8_done (
    .in(invoke8_done_in),
    .out(invoke8_done_out)
);
std_wire # (
    .WIDTH(1)
) init_repeat_go (
    .in(init_repeat_go_in),
    .out(init_repeat_go_out)
);
std_wire # (
    .WIDTH(1)
) init_repeat_done (
    .in(init_repeat_done_in),
    .out(init_repeat_done_out)
);
std_wire # (
    .WIDTH(1)
) incr_repeat_go (
    .in(incr_repeat_go_in),
    .out(incr_repeat_go_out)
);
std_wire # (
    .WIDTH(1)
) incr_repeat_done (
    .in(incr_repeat_done_in),
    .out(incr_repeat_done_out)
);
std_wire # (
    .WIDTH(1)
) init_repeat0_go (
    .in(init_repeat0_go_in),
    .out(init_repeat0_go_out)
);
std_wire # (
    .WIDTH(1)
) init_repeat0_done (
    .in(init_repeat0_done_in),
    .out(init_repeat0_done_out)
);
std_wire # (
    .WIDTH(1)
) incr_repeat0_go (
    .in(incr_repeat0_go_in),
    .out(incr_repeat0_go_out)
);
std_wire # (
    .WIDTH(1)
) incr_repeat0_done (
    .in(incr_repeat0_done_in),
    .out(incr_repeat0_done_out)
);
std_wire # (
    .WIDTH(1)
) init_repeat1_go (
    .in(init_repeat1_go_in),
    .out(init_repeat1_go_out)
);
std_wire # (
    .WIDTH(1)
) init_repeat1_done (
    .in(init_repeat1_done_in),
    .out(init_repeat1_done_out)
);
std_wire # (
    .WIDTH(1)
) incr_repeat1_go (
    .in(incr_repeat1_go_in),
    .out(incr_repeat1_go_out)
);
std_wire # (
    .WIDTH(1)
) incr_repeat1_done (
    .in(incr_repeat1_done_in),
    .out(incr_repeat1_done_out)
);
std_wire # (
    .WIDTH(1)
) early_reset_static_seq_go (
    .in(early_reset_static_seq_go_in),
    .out(early_reset_static_seq_go_out)
);
std_wire # (
    .WIDTH(1)
) early_reset_static_seq_done (
    .in(early_reset_static_seq_done_in),
    .out(early_reset_static_seq_done_out)
);
std_wire # (
    .WIDTH(1)
) wrapper_early_reset_static_seq_go (
    .in(wrapper_early_reset_static_seq_go_in),
    .out(wrapper_early_reset_static_seq_go_out)
);
std_wire # (
    .WIDTH(1)
) wrapper_early_reset_static_seq_done (
    .in(wrapper_early_reset_static_seq_done_in),
    .out(wrapper_early_reset_static_seq_done_out)
);
std_wire # (
    .WIDTH(1)
) tdcc_go (
    .in(tdcc_go_in),
    .out(tdcc_go_out)
);
std_wire # (
    .WIDTH(1)
) tdcc_done (
    .in(tdcc_done_in),
    .out(tdcc_done_out)
);
wire _guard0 = 1;
wire _guard1 = beg_spl_bb0_11_go_out;
wire _guard2 = bb0_2_go_out;
wire _guard3 = _guard1 | _guard2;
wire _guard4 = bb0_5_go_out;
wire _guard5 = _guard3 | _guard4;
wire _guard6 = bb0_18_go_out;
wire _guard7 = _guard5 | _guard6;
wire _guard8 = bb0_18_go_out;
wire _guard9 = init_repeat1_go_out;
wire _guard10 = incr_repeat1_go_out;
wire _guard11 = _guard9 | _guard10;
wire _guard12 = init_repeat1_go_out;
wire _guard13 = incr_repeat1_go_out;
wire _guard14 = incr_repeat1_go_out;
wire _guard15 = incr_repeat1_go_out;
wire _guard16 = init_repeat_done_out;
wire _guard17 = ~_guard16;
wire _guard18 = fsm0_out == 5'd5;
wire _guard19 = _guard17 & _guard18;
wire _guard20 = tdcc_go_out;
wire _guard21 = _guard19 & _guard20;
wire _guard22 = fsm_out < 3'd3;
wire _guard23 = early_reset_static_seq_go_out;
wire _guard24 = _guard22 & _guard23;
wire _guard25 = tdcc_done_out;
wire _guard26 = bb0_2_go_out;
wire _guard27 = bb0_2_go_out;
wire _guard28 = bb0_2_go_out;
wire _guard29 = beg_spl_bb0_11_go_out;
wire _guard30 = bb0_18_go_out;
wire _guard31 = _guard29 | _guard30;
wire _guard32 = beg_spl_bb0_11_go_out;
wire _guard33 = bb0_18_go_out;
wire _guard34 = _guard32 | _guard33;
wire _guard35 = bb0_5_go_out;
wire _guard36 = bb0_18_go_out;
wire _guard37 = beg_spl_bb0_11_go_out;
wire _guard38 = bb0_18_go_out;
wire _guard39 = bb0_5_go_out;
wire _guard40 = bb0_5_go_out;
wire _guard41 = incr_repeat_go_out;
wire _guard42 = incr_repeat_go_out;
wire _guard43 = fsm_out != 3'd3;
wire _guard44 = early_reset_static_seq_go_out;
wire _guard45 = _guard43 & _guard44;
wire _guard46 = fsm_out == 3'd3;
wire _guard47 = early_reset_static_seq_go_out;
wire _guard48 = _guard46 & _guard47;
wire _guard49 = _guard45 | _guard48;
wire _guard50 = fsm_out != 3'd3;
wire _guard51 = early_reset_static_seq_go_out;
wire _guard52 = _guard50 & _guard51;
wire _guard53 = fsm_out == 3'd3;
wire _guard54 = early_reset_static_seq_go_out;
wire _guard55 = _guard53 & _guard54;
wire _guard56 = beg_spl_bb0_11_done_out;
wire _guard57 = ~_guard56;
wire _guard58 = fsm0_out == 5'd9;
wire _guard59 = _guard57 & _guard58;
wire _guard60 = tdcc_go_out;
wire _guard61 = _guard59 & _guard60;
wire _guard62 = incr_repeat1_done_out;
wire _guard63 = ~_guard62;
wire _guard64 = fsm0_out == 5'd17;
wire _guard65 = _guard63 & _guard64;
wire _guard66 = tdcc_go_out;
wire _guard67 = _guard65 & _guard66;
wire _guard68 = init_repeat1_go_out;
wire _guard69 = incr_repeat1_go_out;
wire _guard70 = _guard68 | _guard69;
wire _guard71 = incr_repeat1_go_out;
wire _guard72 = init_repeat1_go_out;
wire _guard73 = incr_repeat1_go_out;
wire _guard74 = incr_repeat1_go_out;
wire _guard75 = invoke2_done_out;
wire _guard76 = ~_guard75;
wire _guard77 = fsm0_out == 5'd4;
wire _guard78 = _guard76 & _guard77;
wire _guard79 = tdcc_go_out;
wire _guard80 = _guard78 & _guard79;
wire _guard81 = invoke5_go_out;
wire _guard82 = invoke5_go_out;
wire _guard83 = init_repeat0_go_out;
wire _guard84 = incr_repeat0_go_out;
wire _guard85 = _guard83 | _guard84;
wire _guard86 = init_repeat0_go_out;
wire _guard87 = incr_repeat0_go_out;
wire _guard88 = invoke2_go_out;
wire _guard89 = invoke6_go_out;
wire _guard90 = _guard88 | _guard89;
wire _guard91 = invoke2_go_out;
wire _guard92 = invoke6_go_out;
wire _guard93 = bb0_2_done_out;
wire _guard94 = ~_guard93;
wire _guard95 = fsm0_out == 5'd6;
wire _guard96 = _guard94 & _guard95;
wire _guard97 = tdcc_go_out;
wire _guard98 = _guard96 & _guard97;
wire _guard99 = init_repeat1_done_out;
wire _guard100 = ~_guard99;
wire _guard101 = fsm0_out == 5'd1;
wire _guard102 = _guard100 & _guard101;
wire _guard103 = tdcc_go_out;
wire _guard104 = _guard102 & _guard103;
wire _guard105 = init_repeat0_go_out;
wire _guard106 = incr_repeat0_go_out;
wire _guard107 = _guard105 | _guard106;
wire _guard108 = incr_repeat0_go_out;
wire _guard109 = init_repeat0_go_out;
wire _guard110 = invoke5_done_out;
wire _guard111 = ~_guard110;
wire _guard112 = fsm0_out == 5'd10;
wire _guard113 = _guard111 & _guard112;
wire _guard114 = tdcc_go_out;
wire _guard115 = _guard113 & _guard114;
wire _guard116 = bb0_18_go_out;
wire _guard117 = bb0_18_go_out;
wire _guard118 = fsm_out == 3'd3;
wire _guard119 = early_reset_static_seq_go_out;
wire _guard120 = _guard118 & _guard119;
wire _guard121 = fsm_out == 3'd3;
wire _guard122 = early_reset_static_seq_go_out;
wire _guard123 = _guard121 & _guard122;
wire _guard124 = invoke0_done_out;
wire _guard125 = ~_guard124;
wire _guard126 = fsm0_out == 5'd0;
wire _guard127 = _guard125 & _guard126;
wire _guard128 = tdcc_go_out;
wire _guard129 = _guard127 & _guard128;
wire _guard130 = incr_repeat_done_out;
wire _guard131 = ~_guard130;
wire _guard132 = fsm0_out == 5'd13;
wire _guard133 = _guard131 & _guard132;
wire _guard134 = tdcc_go_out;
wire _guard135 = _guard133 & _guard134;
wire _guard136 = cond_reg1_done;
wire _guard137 = idx1_done;
wire _guard138 = _guard136 & _guard137;
wire _guard139 = early_reset_static_seq_go_out;
wire _guard140 = early_reset_static_seq_go_out;
wire _guard141 = fsm0_out == 5'd18;
wire _guard142 = fsm0_out == 5'd0;
wire _guard143 = invoke0_done_out;
wire _guard144 = _guard142 & _guard143;
wire _guard145 = tdcc_go_out;
wire _guard146 = _guard144 & _guard145;
wire _guard147 = _guard141 | _guard146;
wire _guard148 = fsm0_out == 5'd1;
wire _guard149 = init_repeat1_done_out;
wire _guard150 = cond_reg1_out;
wire _guard151 = _guard149 & _guard150;
wire _guard152 = _guard148 & _guard151;
wire _guard153 = tdcc_go_out;
wire _guard154 = _guard152 & _guard153;
wire _guard155 = _guard147 | _guard154;
wire _guard156 = fsm0_out == 5'd17;
wire _guard157 = incr_repeat1_done_out;
wire _guard158 = cond_reg1_out;
wire _guard159 = _guard157 & _guard158;
wire _guard160 = _guard156 & _guard159;
wire _guard161 = tdcc_go_out;
wire _guard162 = _guard160 & _guard161;
wire _guard163 = _guard155 | _guard162;
wire _guard164 = fsm0_out == 5'd2;
wire _guard165 = invoke1_done_out;
wire _guard166 = _guard164 & _guard165;
wire _guard167 = tdcc_go_out;
wire _guard168 = _guard166 & _guard167;
wire _guard169 = _guard163 | _guard168;
wire _guard170 = fsm0_out == 5'd3;
wire _guard171 = init_repeat0_done_out;
wire _guard172 = cond_reg0_out;
wire _guard173 = _guard171 & _guard172;
wire _guard174 = _guard170 & _guard173;
wire _guard175 = tdcc_go_out;
wire _guard176 = _guard174 & _guard175;
wire _guard177 = _guard169 | _guard176;
wire _guard178 = fsm0_out == 5'd15;
wire _guard179 = incr_repeat0_done_out;
wire _guard180 = cond_reg0_out;
wire _guard181 = _guard179 & _guard180;
wire _guard182 = _guard178 & _guard181;
wire _guard183 = tdcc_go_out;
wire _guard184 = _guard182 & _guard183;
wire _guard185 = _guard177 | _guard184;
wire _guard186 = fsm0_out == 5'd4;
wire _guard187 = invoke2_done_out;
wire _guard188 = _guard186 & _guard187;
wire _guard189 = tdcc_go_out;
wire _guard190 = _guard188 & _guard189;
wire _guard191 = _guard185 | _guard190;
wire _guard192 = fsm0_out == 5'd5;
wire _guard193 = init_repeat_done_out;
wire _guard194 = cond_reg_out;
wire _guard195 = _guard193 & _guard194;
wire _guard196 = _guard192 & _guard195;
wire _guard197 = tdcc_go_out;
wire _guard198 = _guard196 & _guard197;
wire _guard199 = _guard191 | _guard198;
wire _guard200 = fsm0_out == 5'd13;
wire _guard201 = incr_repeat_done_out;
wire _guard202 = cond_reg_out;
wire _guard203 = _guard201 & _guard202;
wire _guard204 = _guard200 & _guard203;
wire _guard205 = tdcc_go_out;
wire _guard206 = _guard204 & _guard205;
wire _guard207 = _guard199 | _guard206;
wire _guard208 = fsm0_out == 5'd6;
wire _guard209 = bb0_2_done_out;
wire _guard210 = _guard208 & _guard209;
wire _guard211 = tdcc_go_out;
wire _guard212 = _guard210 & _guard211;
wire _guard213 = _guard207 | _guard212;
wire _guard214 = fsm0_out == 5'd7;
wire _guard215 = bb0_5_done_out;
wire _guard216 = _guard214 & _guard215;
wire _guard217 = tdcc_go_out;
wire _guard218 = _guard216 & _guard217;
wire _guard219 = _guard213 | _guard218;
wire _guard220 = fsm0_out == 5'd8;
wire _guard221 = wrapper_early_reset_static_seq_done_out;
wire _guard222 = _guard220 & _guard221;
wire _guard223 = tdcc_go_out;
wire _guard224 = _guard222 & _guard223;
wire _guard225 = _guard219 | _guard224;
wire _guard226 = fsm0_out == 5'd9;
wire _guard227 = beg_spl_bb0_11_done_out;
wire _guard228 = _guard226 & _guard227;
wire _guard229 = tdcc_go_out;
wire _guard230 = _guard228 & _guard229;
wire _guard231 = _guard225 | _guard230;
wire _guard232 = fsm0_out == 5'd10;
wire _guard233 = invoke5_done_out;
wire _guard234 = _guard232 & _guard233;
wire _guard235 = tdcc_go_out;
wire _guard236 = _guard234 & _guard235;
wire _guard237 = _guard231 | _guard236;
wire _guard238 = fsm0_out == 5'd11;
wire _guard239 = bb0_18_done_out;
wire _guard240 = _guard238 & _guard239;
wire _guard241 = tdcc_go_out;
wire _guard242 = _guard240 & _guard241;
wire _guard243 = _guard237 | _guard242;
wire _guard244 = fsm0_out == 5'd12;
wire _guard245 = invoke6_done_out;
wire _guard246 = _guard244 & _guard245;
wire _guard247 = tdcc_go_out;
wire _guard248 = _guard246 & _guard247;
wire _guard249 = _guard243 | _guard248;
wire _guard250 = fsm0_out == 5'd5;
wire _guard251 = init_repeat_done_out;
wire _guard252 = cond_reg_out;
wire _guard253 = ~_guard252;
wire _guard254 = _guard251 & _guard253;
wire _guard255 = _guard250 & _guard254;
wire _guard256 = tdcc_go_out;
wire _guard257 = _guard255 & _guard256;
wire _guard258 = _guard249 | _guard257;
wire _guard259 = fsm0_out == 5'd13;
wire _guard260 = incr_repeat_done_out;
wire _guard261 = cond_reg_out;
wire _guard262 = ~_guard261;
wire _guard263 = _guard260 & _guard262;
wire _guard264 = _guard259 & _guard263;
wire _guard265 = tdcc_go_out;
wire _guard266 = _guard264 & _guard265;
wire _guard267 = _guard258 | _guard266;
wire _guard268 = fsm0_out == 5'd14;
wire _guard269 = invoke7_done_out;
wire _guard270 = _guard268 & _guard269;
wire _guard271 = tdcc_go_out;
wire _guard272 = _guard270 & _guard271;
wire _guard273 = _guard267 | _guard272;
wire _guard274 = fsm0_out == 5'd3;
wire _guard275 = init_repeat0_done_out;
wire _guard276 = cond_reg0_out;
wire _guard277 = ~_guard276;
wire _guard278 = _guard275 & _guard277;
wire _guard279 = _guard274 & _guard278;
wire _guard280 = tdcc_go_out;
wire _guard281 = _guard279 & _guard280;
wire _guard282 = _guard273 | _guard281;
wire _guard283 = fsm0_out == 5'd15;
wire _guard284 = incr_repeat0_done_out;
wire _guard285 = cond_reg0_out;
wire _guard286 = ~_guard285;
wire _guard287 = _guard284 & _guard286;
wire _guard288 = _guard283 & _guard287;
wire _guard289 = tdcc_go_out;
wire _guard290 = _guard288 & _guard289;
wire _guard291 = _guard282 | _guard290;
wire _guard292 = fsm0_out == 5'd16;
wire _guard293 = invoke8_done_out;
wire _guard294 = _guard292 & _guard293;
wire _guard295 = tdcc_go_out;
wire _guard296 = _guard294 & _guard295;
wire _guard297 = _guard291 | _guard296;
wire _guard298 = fsm0_out == 5'd1;
wire _guard299 = init_repeat1_done_out;
wire _guard300 = cond_reg1_out;
wire _guard301 = ~_guard300;
wire _guard302 = _guard299 & _guard301;
wire _guard303 = _guard298 & _guard302;
wire _guard304 = tdcc_go_out;
wire _guard305 = _guard303 & _guard304;
wire _guard306 = _guard297 | _guard305;
wire _guard307 = fsm0_out == 5'd17;
wire _guard308 = incr_repeat1_done_out;
wire _guard309 = cond_reg1_out;
wire _guard310 = ~_guard309;
wire _guard311 = _guard308 & _guard310;
wire _guard312 = _guard307 & _guard311;
wire _guard313 = tdcc_go_out;
wire _guard314 = _guard312 & _guard313;
wire _guard315 = _guard306 | _guard314;
wire _guard316 = fsm0_out == 5'd0;
wire _guard317 = invoke0_done_out;
wire _guard318 = _guard316 & _guard317;
wire _guard319 = tdcc_go_out;
wire _guard320 = _guard318 & _guard319;
wire _guard321 = fsm0_out == 5'd14;
wire _guard322 = invoke7_done_out;
wire _guard323 = _guard321 & _guard322;
wire _guard324 = tdcc_go_out;
wire _guard325 = _guard323 & _guard324;
wire _guard326 = fsm0_out == 5'd1;
wire _guard327 = init_repeat1_done_out;
wire _guard328 = cond_reg1_out;
wire _guard329 = ~_guard328;
wire _guard330 = _guard327 & _guard329;
wire _guard331 = _guard326 & _guard330;
wire _guard332 = tdcc_go_out;
wire _guard333 = _guard331 & _guard332;
wire _guard334 = fsm0_out == 5'd17;
wire _guard335 = incr_repeat1_done_out;
wire _guard336 = cond_reg1_out;
wire _guard337 = ~_guard336;
wire _guard338 = _guard335 & _guard337;
wire _guard339 = _guard334 & _guard338;
wire _guard340 = tdcc_go_out;
wire _guard341 = _guard339 & _guard340;
wire _guard342 = _guard333 | _guard341;
wire _guard343 = fsm0_out == 5'd3;
wire _guard344 = init_repeat0_done_out;
wire _guard345 = cond_reg0_out;
wire _guard346 = ~_guard345;
wire _guard347 = _guard344 & _guard346;
wire _guard348 = _guard343 & _guard347;
wire _guard349 = tdcc_go_out;
wire _guard350 = _guard348 & _guard349;
wire _guard351 = fsm0_out == 5'd15;
wire _guard352 = incr_repeat0_done_out;
wire _guard353 = cond_reg0_out;
wire _guard354 = ~_guard353;
wire _guard355 = _guard352 & _guard354;
wire _guard356 = _guard351 & _guard355;
wire _guard357 = tdcc_go_out;
wire _guard358 = _guard356 & _guard357;
wire _guard359 = _guard350 | _guard358;
wire _guard360 = fsm0_out == 5'd18;
wire _guard361 = fsm0_out == 5'd2;
wire _guard362 = invoke1_done_out;
wire _guard363 = _guard361 & _guard362;
wire _guard364 = tdcc_go_out;
wire _guard365 = _guard363 & _guard364;
wire _guard366 = fsm0_out == 5'd12;
wire _guard367 = invoke6_done_out;
wire _guard368 = _guard366 & _guard367;
wire _guard369 = tdcc_go_out;
wire _guard370 = _guard368 & _guard369;
wire _guard371 = fsm0_out == 5'd5;
wire _guard372 = init_repeat_done_out;
wire _guard373 = cond_reg_out;
wire _guard374 = ~_guard373;
wire _guard375 = _guard372 & _guard374;
wire _guard376 = _guard371 & _guard375;
wire _guard377 = tdcc_go_out;
wire _guard378 = _guard376 & _guard377;
wire _guard379 = fsm0_out == 5'd13;
wire _guard380 = incr_repeat_done_out;
wire _guard381 = cond_reg_out;
wire _guard382 = ~_guard381;
wire _guard383 = _guard380 & _guard382;
wire _guard384 = _guard379 & _guard383;
wire _guard385 = tdcc_go_out;
wire _guard386 = _guard384 & _guard385;
wire _guard387 = _guard378 | _guard386;
wire _guard388 = fsm0_out == 5'd4;
wire _guard389 = invoke2_done_out;
wire _guard390 = _guard388 & _guard389;
wire _guard391 = tdcc_go_out;
wire _guard392 = _guard390 & _guard391;
wire _guard393 = fsm0_out == 5'd11;
wire _guard394 = bb0_18_done_out;
wire _guard395 = _guard393 & _guard394;
wire _guard396 = tdcc_go_out;
wire _guard397 = _guard395 & _guard396;
wire _guard398 = fsm0_out == 5'd1;
wire _guard399 = init_repeat1_done_out;
wire _guard400 = cond_reg1_out;
wire _guard401 = _guard399 & _guard400;
wire _guard402 = _guard398 & _guard401;
wire _guard403 = tdcc_go_out;
wire _guard404 = _guard402 & _guard403;
wire _guard405 = fsm0_out == 5'd17;
wire _guard406 = incr_repeat1_done_out;
wire _guard407 = cond_reg1_out;
wire _guard408 = _guard406 & _guard407;
wire _guard409 = _guard405 & _guard408;
wire _guard410 = tdcc_go_out;
wire _guard411 = _guard409 & _guard410;
wire _guard412 = _guard404 | _guard411;
wire _guard413 = fsm0_out == 5'd7;
wire _guard414 = bb0_5_done_out;
wire _guard415 = _guard413 & _guard414;
wire _guard416 = tdcc_go_out;
wire _guard417 = _guard415 & _guard416;
wire _guard418 = fsm0_out == 5'd9;
wire _guard419 = beg_spl_bb0_11_done_out;
wire _guard420 = _guard418 & _guard419;
wire _guard421 = tdcc_go_out;
wire _guard422 = _guard420 & _guard421;
wire _guard423 = fsm0_out == 5'd6;
wire _guard424 = bb0_2_done_out;
wire _guard425 = _guard423 & _guard424;
wire _guard426 = tdcc_go_out;
wire _guard427 = _guard425 & _guard426;
wire _guard428 = fsm0_out == 5'd10;
wire _guard429 = invoke5_done_out;
wire _guard430 = _guard428 & _guard429;
wire _guard431 = tdcc_go_out;
wire _guard432 = _guard430 & _guard431;
wire _guard433 = fsm0_out == 5'd3;
wire _guard434 = init_repeat0_done_out;
wire _guard435 = cond_reg0_out;
wire _guard436 = _guard434 & _guard435;
wire _guard437 = _guard433 & _guard436;
wire _guard438 = tdcc_go_out;
wire _guard439 = _guard437 & _guard438;
wire _guard440 = fsm0_out == 5'd15;
wire _guard441 = incr_repeat0_done_out;
wire _guard442 = cond_reg0_out;
wire _guard443 = _guard441 & _guard442;
wire _guard444 = _guard440 & _guard443;
wire _guard445 = tdcc_go_out;
wire _guard446 = _guard444 & _guard445;
wire _guard447 = _guard439 | _guard446;
wire _guard448 = fsm0_out == 5'd5;
wire _guard449 = init_repeat_done_out;
wire _guard450 = cond_reg_out;
wire _guard451 = _guard449 & _guard450;
wire _guard452 = _guard448 & _guard451;
wire _guard453 = tdcc_go_out;
wire _guard454 = _guard452 & _guard453;
wire _guard455 = fsm0_out == 5'd13;
wire _guard456 = incr_repeat_done_out;
wire _guard457 = cond_reg_out;
wire _guard458 = _guard456 & _guard457;
wire _guard459 = _guard455 & _guard458;
wire _guard460 = tdcc_go_out;
wire _guard461 = _guard459 & _guard460;
wire _guard462 = _guard454 | _guard461;
wire _guard463 = fsm0_out == 5'd16;
wire _guard464 = invoke8_done_out;
wire _guard465 = _guard463 & _guard464;
wire _guard466 = tdcc_go_out;
wire _guard467 = _guard465 & _guard466;
wire _guard468 = fsm0_out == 5'd8;
wire _guard469 = wrapper_early_reset_static_seq_done_out;
wire _guard470 = _guard468 & _guard469;
wire _guard471 = tdcc_go_out;
wire _guard472 = _guard470 & _guard471;
wire _guard473 = invoke8_done_out;
wire _guard474 = ~_guard473;
wire _guard475 = fsm0_out == 5'd16;
wire _guard476 = _guard474 & _guard475;
wire _guard477 = tdcc_go_out;
wire _guard478 = _guard476 & _guard477;
wire _guard479 = cond_reg0_done;
wire _guard480 = idx0_done;
wire _guard481 = _guard479 & _guard480;
wire _guard482 = init_repeat_go_out;
wire _guard483 = incr_repeat_go_out;
wire _guard484 = _guard482 | _guard483;
wire _guard485 = incr_repeat_go_out;
wire _guard486 = init_repeat_go_out;
wire _guard487 = cond_reg_done;
wire _guard488 = idx_done;
wire _guard489 = _guard487 & _guard488;
wire _guard490 = cond_reg_done;
wire _guard491 = idx_done;
wire _guard492 = _guard490 & _guard491;
wire _guard493 = cond_reg0_done;
wire _guard494 = idx0_done;
wire _guard495 = _guard493 & _guard494;
wire _guard496 = signal_reg_out;
wire _guard497 = incr_repeat0_go_out;
wire _guard498 = incr_repeat0_go_out;
wire _guard499 = invoke1_done_out;
wire _guard500 = ~_guard499;
wire _guard501 = fsm0_out == 5'd2;
wire _guard502 = _guard500 & _guard501;
wire _guard503 = tdcc_go_out;
wire _guard504 = _guard502 & _guard503;
wire _guard505 = init_repeat0_done_out;
wire _guard506 = ~_guard505;
wire _guard507 = fsm0_out == 5'd3;
wire _guard508 = _guard506 & _guard507;
wire _guard509 = tdcc_go_out;
wire _guard510 = _guard508 & _guard509;
wire _guard511 = incr_repeat0_done_out;
wire _guard512 = ~_guard511;
wire _guard513 = fsm0_out == 5'd15;
wire _guard514 = _guard512 & _guard513;
wire _guard515 = tdcc_go_out;
wire _guard516 = _guard514 & _guard515;
wire _guard517 = wrapper_early_reset_static_seq_go_out;
wire _guard518 = fsm_out < 3'd3;
wire _guard519 = early_reset_static_seq_go_out;
wire _guard520 = _guard518 & _guard519;
wire _guard521 = fsm_out < 3'd3;
wire _guard522 = early_reset_static_seq_go_out;
wire _guard523 = _guard521 & _guard522;
wire _guard524 = fsm_out < 3'd3;
wire _guard525 = early_reset_static_seq_go_out;
wire _guard526 = _guard524 & _guard525;
wire _guard527 = signal_reg_out;
wire _guard528 = fsm_out == 3'd3;
wire _guard529 = _guard528 & _guard0;
wire _guard530 = signal_reg_out;
wire _guard531 = ~_guard530;
wire _guard532 = _guard529 & _guard531;
wire _guard533 = wrapper_early_reset_static_seq_go_out;
wire _guard534 = _guard532 & _guard533;
wire _guard535 = _guard527 | _guard534;
wire _guard536 = fsm_out == 3'd3;
wire _guard537 = _guard536 & _guard0;
wire _guard538 = signal_reg_out;
wire _guard539 = ~_guard538;
wire _guard540 = _guard537 & _guard539;
wire _guard541 = wrapper_early_reset_static_seq_go_out;
wire _guard542 = _guard540 & _guard541;
wire _guard543 = signal_reg_out;
wire _guard544 = cond_reg1_done;
wire _guard545 = idx1_done;
wire _guard546 = _guard544 & _guard545;
wire _guard547 = bb0_5_go_out;
wire _guard548 = beg_spl_bb0_11_go_out;
wire _guard549 = bb0_2_go_out;
wire _guard550 = _guard548 | _guard549;
wire _guard551 = bb0_18_go_out;
wire _guard552 = _guard550 | _guard551;
wire _guard553 = beg_spl_bb0_11_go_out;
wire _guard554 = bb0_2_go_out;
wire _guard555 = _guard553 | _guard554;
wire _guard556 = bb0_5_go_out;
wire _guard557 = _guard555 | _guard556;
wire _guard558 = bb0_18_go_out;
wire _guard559 = _guard557 | _guard558;
wire _guard560 = bb0_18_go_out;
wire _guard561 = invoke0_go_out;
wire _guard562 = invoke8_go_out;
wire _guard563 = _guard561 | _guard562;
wire _guard564 = invoke0_go_out;
wire _guard565 = invoke8_go_out;
wire _guard566 = bb0_18_done_out;
wire _guard567 = ~_guard566;
wire _guard568 = fsm0_out == 5'd11;
wire _guard569 = _guard567 & _guard568;
wire _guard570 = tdcc_go_out;
wire _guard571 = _guard569 & _guard570;
wire _guard572 = fsm0_out == 5'd18;
wire _guard573 = bb0_18_go_out;
wire _guard574 = invoke1_go_out;
wire _guard575 = invoke7_go_out;
wire _guard576 = _guard574 | _guard575;
wire _guard577 = invoke1_go_out;
wire _guard578 = invoke7_go_out;
wire _guard579 = incr_repeat_go_out;
wire _guard580 = incr_repeat_go_out;
wire _guard581 = invoke6_go_out;
wire _guard582 = beg_spl_bb0_11_go_out;
wire _guard583 = bb0_2_go_out;
wire _guard584 = _guard582 | _guard583;
wire _guard585 = bb0_5_go_out;
wire _guard586 = _guard584 | _guard585;
wire _guard587 = bb0_18_go_out;
wire _guard588 = _guard586 | _guard587;
wire _guard589 = invoke8_go_out;
wire _guard590 = invoke7_go_out;
wire _guard591 = bb0_2_go_out;
wire _guard592 = invoke6_go_out;
wire _guard593 = invoke7_go_out;
wire _guard594 = _guard592 | _guard593;
wire _guard595 = invoke8_go_out;
wire _guard596 = _guard594 | _guard595;
wire _guard597 = beg_spl_bb0_11_go_out;
wire _guard598 = bb0_5_go_out;
wire _guard599 = _guard597 | _guard598;
wire _guard600 = bb0_18_go_out;
wire _guard601 = _guard599 | _guard600;
wire _guard602 = invoke6_done_out;
wire _guard603 = ~_guard602;
wire _guard604 = fsm0_out == 5'd12;
wire _guard605 = _guard603 & _guard604;
wire _guard606 = tdcc_go_out;
wire _guard607 = _guard605 & _guard606;
wire _guard608 = wrapper_early_reset_static_seq_done_out;
wire _guard609 = ~_guard608;
wire _guard610 = fsm0_out == 5'd8;
wire _guard611 = _guard609 & _guard610;
wire _guard612 = tdcc_go_out;
wire _guard613 = _guard611 & _guard612;
wire _guard614 = fsm_out < 3'd3;
wire _guard615 = early_reset_static_seq_go_out;
wire _guard616 = _guard614 & _guard615;
wire _guard617 = init_repeat_go_out;
wire _guard618 = incr_repeat_go_out;
wire _guard619 = _guard617 | _guard618;
wire _guard620 = init_repeat_go_out;
wire _guard621 = incr_repeat_go_out;
wire _guard622 = incr_repeat0_go_out;
wire _guard623 = incr_repeat0_go_out;
wire _guard624 = bb0_5_done_out;
wire _guard625 = ~_guard624;
wire _guard626 = fsm0_out == 5'd7;
wire _guard627 = _guard625 & _guard626;
wire _guard628 = tdcc_go_out;
wire _guard629 = _guard627 & _guard628;
wire _guard630 = invoke7_done_out;
wire _guard631 = ~_guard630;
wire _guard632 = fsm0_out == 5'd14;
wire _guard633 = _guard631 & _guard632;
wire _guard634 = tdcc_go_out;
wire _guard635 = _guard633 & _guard634;
assign std_slice_4_in = std_add_7_out;
assign std_signext_3_in = muli_0_reg_out;
assign cond_reg1_write_en = _guard11;
assign cond_reg1_clk = clk;
assign cond_reg1_reset = reset;
assign cond_reg1_in =
  _guard12 ? 1'd1 :
  _guard13 ? lt1_out :
  1'd0;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard13, _guard12})) begin
    $fatal(2, "Multiple assignment to port `cond_reg1.in'.");
end
end
assign adder1_left =
  _guard14 ? idx1_out :
  6'd0;
assign adder1_right =
  _guard15 ? 6'd1 :
  6'd0;
assign invoke7_done_in = for_1_induction_var_reg_done;
assign init_repeat_go_in = _guard21;
assign std_signext_0_in = arg_mem_0_read_data;
assign done = _guard25;
assign arg_mem_0_content_en = _guard26;
assign arg_mem_0_addr0 = std_slice_4_out;
assign arg_mem_0_write_en =
  _guard28 ? 1'd0 :
  1'd0;
assign arg_mem_2_addr0 = std_slice_4_out;
assign arg_mem_2_content_en = _guard34;
assign arg_mem_1_write_en =
  _guard35 ? 1'd0 :
  1'd0;
assign arg_mem_2_write_en =
  _guard36 ? 1'd1 :
  _guard37 ? 1'd0 :
  1'd0;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard37, _guard36})) begin
    $fatal(2, "Multiple assignment to port `_this.arg_mem_2_write_en'.");
end
end
assign arg_mem_2_write_data = std_slice_0_out;
assign arg_mem_1_addr0 = std_slice_4_out;
assign arg_mem_1_content_en = _guard40;
assign adder_left =
  _guard41 ? idx_out :
  6'd0;
assign adder_right =
  _guard42 ? 6'd1 :
  6'd0;
assign fsm_write_en = _guard49;
assign fsm_clk = clk;
assign fsm_reset = reset;
assign fsm_in =
  _guard52 ? adder2_out :
  _guard55 ? 3'd0 :
  3'd0;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard55, _guard52})) begin
    $fatal(2, "Multiple assignment to port `fsm.in'.");
end
end
assign beg_spl_bb0_11_go_in = _guard61;
assign incr_repeat1_go_in = _guard67;
assign idx1_write_en = _guard70;
assign idx1_clk = clk;
assign idx1_reset = reset;
assign idx1_in =
  _guard71 ? adder1_out :
  _guard72 ? 6'd0 :
  6'd0;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard72, _guard71})) begin
    $fatal(2, "Multiple assignment to port `idx1.in'.");
end
end
assign lt1_left =
  _guard73 ? adder1_out :
  6'd0;
assign lt1_right =
  _guard74 ? 6'd32 :
  6'd0;
assign invoke2_go_in = _guard80;
assign load_0_reg_write_en = _guard81;
assign load_0_reg_clk = clk;
assign load_0_reg_reset = reset;
assign load_0_reg_in = arg_mem_2_read_data;
assign cond_reg0_write_en = _guard85;
assign cond_reg0_clk = clk;
assign cond_reg0_reset = reset;
assign cond_reg0_in =
  _guard86 ? 1'd1 :
  _guard87 ? lt0_out :
  1'd0;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard87, _guard86})) begin
    $fatal(2, "Multiple assignment to port `cond_reg0.in'.");
end
end
assign for_0_induction_var_reg_write_en = _guard90;
assign for_0_induction_var_reg_clk = clk;
assign for_0_induction_var_reg_reset = reset;
assign for_0_induction_var_reg_in =
  _guard91 ? 32'd0 :
  _guard92 ? std_add_7_out :
  'x;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard92, _guard91})) begin
    $fatal(2, "Multiple assignment to port `for_0_induction_var_reg.in'.");
end
end
assign bb0_2_go_in = _guard98;
assign init_repeat1_go_in = _guard104;
assign idx0_write_en = _guard107;
assign idx0_clk = clk;
assign idx0_reset = reset;
assign idx0_in =
  _guard108 ? adder0_out :
  _guard109 ? 6'd0 :
  6'd0;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard109, _guard108})) begin
    $fatal(2, "Multiple assignment to port `idx0.in'.");
end
end
assign invoke5_go_in = _guard115;
assign invoke5_done_in = load_0_reg_done;
assign std_add_3_left = std_signext_2_out;
assign std_add_3_right = std_signext_3_out;
assign muli_0_reg_write_en = _guard120;
assign muli_0_reg_clk = clk;
assign muli_0_reg_reset = reset;
assign muli_0_reg_in = std_mult_pipe_0_out;
assign invoke0_go_in = _guard129;
assign incr_repeat_go_in = _guard135;
assign init_repeat1_done_in = _guard138;
assign tdcc_go_in = go;
assign adder2_left =
  _guard139 ? fsm_out :
  3'd0;
assign adder2_right =
  _guard140 ? 3'd1 :
  3'd0;
assign fsm0_write_en = _guard315;
assign fsm0_clk = clk;
assign fsm0_reset = reset;
assign fsm0_in =
  _guard320 ? 5'd1 :
  _guard325 ? 5'd15 :
  _guard342 ? 5'd18 :
  _guard359 ? 5'd16 :
  _guard360 ? 5'd0 :
  _guard365 ? 5'd3 :
  _guard370 ? 5'd13 :
  _guard387 ? 5'd14 :
  _guard392 ? 5'd5 :
  _guard397 ? 5'd12 :
  _guard412 ? 5'd2 :
  _guard417 ? 5'd8 :
  _guard422 ? 5'd10 :
  _guard427 ? 5'd7 :
  _guard432 ? 5'd11 :
  _guard447 ? 5'd4 :
  _guard462 ? 5'd6 :
  _guard467 ? 5'd17 :
  _guard472 ? 5'd9 :
  5'd0;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard472, _guard467, _guard462, _guard447, _guard432, _guard427, _guard422, _guard417, _guard412, _guard397, _guard392, _guard387, _guard370, _guard365, _guard360, _guard359, _guard342, _guard325, _guard320})) begin
    $fatal(2, "Multiple assignment to port `fsm0.in'.");
end
end
assign bb0_18_done_in = arg_mem_2_done;
assign invoke8_go_in = _guard478;
assign incr_repeat0_done_in = _guard481;
assign idx_write_en = _guard484;
assign idx_clk = clk;
assign idx_reset = reset;
assign idx_in =
  _guard485 ? adder_out :
  _guard486 ? 6'd0 :
  6'd0;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard486, _guard485})) begin
    $fatal(2, "Multiple assignment to port `idx.in'.");
end
end
assign invoke8_done_in = for_2_induction_var_reg_done;
assign init_repeat_done_in = _guard489;
assign incr_repeat_done_in = _guard492;
assign init_repeat0_done_in = _guard495;
assign wrapper_early_reset_static_seq_done_in = _guard496;
assign adder0_left =
  _guard497 ? idx0_out :
  6'd0;
assign adder0_right =
  _guard498 ? 6'd1 :
  6'd0;
assign invoke0_done_in = for_2_induction_var_reg_done;
assign invoke1_go_in = _guard504;
assign invoke6_done_in = for_0_induction_var_reg_done;
assign init_repeat0_go_in = _guard510;
assign incr_repeat0_go_in = _guard516;
assign early_reset_static_seq_go_in = _guard517;
assign std_mult_pipe_0_clk = clk;
assign std_mult_pipe_0_left = std_signext_0_out;
assign std_mult_pipe_0_reset = reset;
assign std_mult_pipe_0_go = _guard523;
assign std_mult_pipe_0_right = std_signext_1_out;
assign signal_reg_write_en = _guard535;
assign signal_reg_clk = clk;
assign signal_reg_reset = reset;
assign signal_reg_in =
  _guard542 ? 1'd1 :
  _guard543 ? 1'd0 :
  1'd0;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard543, _guard542})) begin
    $fatal(2, "Multiple assignment to port `signal_reg.in'.");
end
end
assign bb0_5_done_in = arg_mem_1_done;
assign invoke2_done_in = for_0_induction_var_reg_done;
assign incr_repeat1_done_in = _guard546;
assign std_lsh_3_left =
  _guard547 ? for_0_induction_var_reg_out :
  _guard552 ? for_2_induction_var_reg_out :
  'x;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard552, _guard547})) begin
    $fatal(2, "Multiple assignment to port `std_lsh_3.left'.");
end
end
assign std_lsh_3_right = 32'd5;
assign std_slice_0_in = std_add_3_out;
assign for_2_induction_var_reg_write_en = _guard563;
assign for_2_induction_var_reg_clk = clk;
assign for_2_induction_var_reg_reset = reset;
assign for_2_induction_var_reg_in =
  _guard564 ? 32'd0 :
  _guard565 ? std_add_7_out :
  'x;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard565, _guard564})) begin
    $fatal(2, "Multiple assignment to port `for_2_induction_var_reg.in'.");
end
end
assign beg_spl_bb0_11_done_in = arg_mem_2_done;
assign bb0_2_done_in = arg_mem_0_done;
assign bb0_18_go_in = _guard571;
assign early_reset_static_seq_done_in = ud_out;
assign tdcc_done_in = _guard572;
assign std_signext_2_in = load_0_reg_out;
assign for_1_induction_var_reg_write_en = _guard576;
assign for_1_induction_var_reg_clk = clk;
assign for_1_induction_var_reg_reset = reset;
assign for_1_induction_var_reg_in =
  _guard577 ? 32'd0 :
  _guard578 ? std_add_7_out :
  'x;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard578, _guard577})) begin
    $fatal(2, "Multiple assignment to port `for_1_induction_var_reg.in'.");
end
end
assign lt_left =
  _guard579 ? adder_out :
  6'd0;
assign lt_right =
  _guard580 ? 6'd32 :
  6'd0;
assign std_add_7_left =
  _guard581 ? for_0_induction_var_reg_out :
  _guard588 ? std_lsh_3_out :
  _guard589 ? for_2_induction_var_reg_out :
  _guard590 ? for_1_induction_var_reg_out :
  'x;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard590, _guard589, _guard588, _guard581})) begin
    $fatal(2, "Multiple assignment to port `std_add_7.left'.");
end
end
assign std_add_7_right =
  _guard591 ? for_0_induction_var_reg_out :
  _guard596 ? 32'd1 :
  _guard601 ? for_1_induction_var_reg_out :
  'x;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard601, _guard596, _guard591})) begin
    $fatal(2, "Multiple assignment to port `std_add_7.right'.");
end
end
assign invoke1_done_in = for_1_induction_var_reg_done;
assign invoke6_go_in = _guard607;
assign wrapper_early_reset_static_seq_go_in = _guard613;
assign std_signext_1_in = arg_mem_1_read_data;
assign cond_reg_write_en = _guard619;
assign cond_reg_clk = clk;
assign cond_reg_reset = reset;
assign cond_reg_in =
  _guard620 ? 1'd1 :
  _guard621 ? lt_out :
  1'd0;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard621, _guard620})) begin
    $fatal(2, "Multiple assignment to port `cond_reg.in'.");
end
end
assign lt0_left =
  _guard622 ? adder0_out :
  6'd0;
assign lt0_right =
  _guard623 ? 6'd32 :
  6'd0;
assign bb0_5_go_in = _guard629;
assign invoke7_go_in = _guard635;
// COMPONENT END: gemm
endmodule
