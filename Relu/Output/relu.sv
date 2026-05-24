// Compiled by morty-0.9.0 / 2026-02-04 22:04:13.818211178 -06:00:00

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
`define __COMPAREFN_V__

module std_compareFN #(parameter expWidth = 8, parameter sigWidth = 24, parameter numWidth = 32) (
    input clk,
    input reset,
    input go,
    input [(expWidth + sigWidth - 1):0] left,
    input [(expWidth + sigWidth - 1):0] right,
    input signaling,
    output logic lt,
    output logic eq,
    output logic gt,
    output logic unordered,
    output logic [4:0] exceptionFlags,
    output done
);

    // Intermediate signals for recoded formats
    wire [(expWidth + sigWidth):0] l_recoded, r_recoded;

    // Convert 'left' and 'right' from standard to recoded format
    fNToRecFN #(expWidth, sigWidth) convert_l(
        .in(left),
        .out(l_recoded)
    );

    fNToRecFN #(expWidth, sigWidth) convert_r(
        .in(right),
        .out(r_recoded)
    );

    // Intermediate signals for comparison outputs
    wire comp_lt, comp_eq, comp_gt, comp_unordered;
    wire [4:0] comp_exceptionFlags;

    // Compare recoded numbers
    compareRecFN #(expWidth, sigWidth) comparator(
        .a(l_recoded),
        .b(r_recoded),
        .signaling(signaling),
        .lt(comp_lt),
        .eq(comp_eq),
        .gt(comp_gt),
        .unordered(comp_unordered),
        .exceptionFlags(comp_exceptionFlags)
    );

    logic done_buf[1:0];

    assign done = done_buf[1];

    // If the done buffer is empty and go is high, execution just started.
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

    // Capture the comparison results
    always_ff @(posedge clk) begin
        if (reset) begin
            lt <= 0;
            eq <= 0;
            gt <= 0;
            unordered <= 0;
            exceptionFlags <= 0;
        end else if (go) begin
            lt <= comp_lt;
            eq <= comp_eq;
            gt <= comp_gt;
            unordered <= comp_unordered;
            exceptionFlags <= comp_exceptionFlags;
        end else begin
            lt <= lt;
            eq <= eq;
            gt <= gt;
            unordered <= unordered;
            exceptionFlags <= exceptionFlags;
        end
    end

endmodule


 /* __COMPAREFN_V__ */
`define __ADDFN_V__


/*============================================================================

This Verilog include file is part of the Berkeley HardFloat IEEE Floating-
Point Arithmetic Package, Release 1, by John R. Hauser.

Copyright 2019 The Regents of the University of California.  All rights
reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

 1. Redistributions of source code must retain the above copyright notice,
    this list of conditions, and the following disclaimer.

 2. Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions, and the following disclaimer in the documentation
    and/or other materials provided with the distribution.

 3. Neither the name of the University nor the names of its contributors may
    be used to endorse or promote products derived from this software without
    specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS "AS IS", AND ANY
EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, ARE
DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

=============================================================================*/

/*----------------------------------------------------------------------------
*----------------------------------------------------------------------------*/
`define round_near_even   3'b000
`define round_minMag      3'b001
`define round_min         3'b010
`define round_max         3'b011
`define round_near_maxMag 3'b100
`define round_odd         3'b110

/*----------------------------------------------------------------------------
*----------------------------------------------------------------------------*/
`define floatControlWidth 1
`define flControl_tininessBeforeRounding 1'b0
`define flControl_tininessAfterRounding  1'b1

/*----------------------------------------------------------------------------
*----------------------------------------------------------------------------*/
`define flRoundOpt_sigMSBitAlwaysZero  1
`define flRoundOpt_subnormsAlwaysExact 2
`define flRoundOpt_neverUnderflows     4
`define flRoundOpt_neverOverflows      8



module std_addFN #(parameter expWidth = 8, parameter sigWidth = 24, parameter numWidth = 32) (
    input clk,
    input reset,
    input go,
    input [(1 - 1):0] control,
    input subOp,
    input [(expWidth + sigWidth - 1):0] left,
    input [(expWidth + sigWidth - 1):0] right,
    input [2:0] roundingMode,
    output logic [(expWidth + sigWidth - 1):0] out,
    output logic [4:0] exceptionFlags,
    output done
);

    // Intermediate signals for recoded formats
    wire [(expWidth + sigWidth):0] l_recoded, r_recoded;

    // Convert 'a' and 'b' from standard to recoded format
    fNToRecFN #(expWidth, sigWidth) convert_l(
        .in(left),
        .out(l_recoded)
    );

    fNToRecFN #(expWidth, sigWidth) convert_r(
        .in(right),
        .out(r_recoded)
    );

    // Intermediate signals after the adder
    wire [(expWidth + sigWidth):0] res_recoded;
    wire [4:0] except_flag;

    // Compute recoded numbers
    addRecFN #(expWidth, sigWidth) adder(
        .control(control),
        .subOp(subOp),
        .a(l_recoded),
        .b(r_recoded),
        .roundingMode(roundingMode),
        .out(res_recoded),
        .exceptionFlags(except_flag)
    );

    wire [(expWidth + sigWidth - 1):0] res_std;

    // Convert the result back to standard format
    recFNToFN #(expWidth, sigWidth) convert_res(
        .in(res_recoded),
        .out(res_std)
    );

    logic done_buf[1:0];

    assign done = done_buf[1];

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

    // Compute the output and save it into out
    always_ff @(posedge clk) begin
        if (reset) begin
            out <= 0;
        end else if (go) begin
            out <= res_std;
        end else begin
            out <= out;
        end
    end

endmodule


 /* __ADDFN_V__ */
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

/*============================================================================

This Verilog source file is part of the Berkeley HardFloat IEEE Floating-Point
Arithmetic Package, Release 1, by John R. Hauser.

Copyright 2019 The Regents of the University of California.  All rights
reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

 1. Redistributions of source code must retain the above copyright notice,
    this list of conditions, and the following disclaimer.

 2. Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions, and the following disclaimer in the documentation
    and/or other materials provided with the distribution.

 3. Neither the name of the University nor the names of its contributors may
    be used to endorse or promote products derived from this software without
    specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS "AS IS", AND ANY
EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, ARE
DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

=============================================================================*/

/*----------------------------------------------------------------------------
*----------------------------------------------------------------------------*/

module
    recFNToFN#(parameter expWidth = 3, parameter sigWidth = 3) (
        input [(expWidth + sigWidth):0] in,
        output [(expWidth + sigWidth - 1):0] out
    );

/*============================================================================

This Verilog include file is part of the Berkeley HardFloat IEEE Floating-
Point Arithmetic Package, Release 1, by John R. Hauser.

Copyright 2019 The Regents of the University of California.  All rights
reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

 1. Redistributions of source code must retain the above copyright notice,
    this list of conditions, and the following disclaimer.

 2. Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions, and the following disclaimer in the documentation
    and/or other materials provided with the distribution.

 3. Neither the name of the University nor the names of its contributors may
    be used to endorse or promote products derived from this software without
    specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS "AS IS", AND ANY
EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, ARE
DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

=============================================================================*/

/*----------------------------------------------------------------------------
*----------------------------------------------------------------------------*/

function integer clog2;
    input integer a;

    begin
        a = a - 1;
        for (clog2 = 0; a > 0; clog2 = clog2 + 1) a = a>>1;
    end

endfunction



    /*------------------------------------------------------------------------
    *------------------------------------------------------------------------*/
    localparam [expWidth:0] minNormExp = (1<<(expWidth - 1)) + 2;
    localparam normDistWidth = clog2(sigWidth);
    /*------------------------------------------------------------------------
    *------------------------------------------------------------------------*/
    wire isNaN, isInf, isZero, sign;
    wire signed [(expWidth + 1):0] sExp;
    wire [sigWidth:0] sig;
    recFNToRawFN#(expWidth, sigWidth)
        recFNToRawFN(in, isNaN, isInf, isZero, sign, sExp, sig);
    wire isSubnormal = (sExp < minNormExp);
    /*------------------------------------------------------------------------
    *------------------------------------------------------------------------*/
    wire [(normDistWidth - 1):0] denormShiftDist = minNormExp - 1 - sExp;
    wire [(expWidth - 1):0] expOut =
        (isSubnormal ? 0 : sExp - minNormExp + 1)
            | (isNaN || isInf ? {expWidth{1'b1}} : 0);
    wire [(sigWidth - 2):0] fractOut =
        isSubnormal ? (sig>>1)>>denormShiftDist : isInf ? 0 : sig;
    assign out = {sign, expOut, fractOut};

endmodule


/*============================================================================

This Verilog source file is part of the Berkeley HardFloat IEEE Floating-Point
Arithmetic Package, Release 1, by John R. Hauser.

Copyright 2019 The Regents of the University of California.  All rights
reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

 1. Redistributions of source code must retain the above copyright notice,
    this list of conditions, and the following disclaimer.

 2. Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions, and the following disclaimer in the documentation
    and/or other materials provided with the distribution.

 3. Neither the name of the University nor the names of its contributors may
    be used to endorse or promote products derived from this software without
    specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS "AS IS", AND ANY
EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, ARE
DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

=============================================================================*/


/*============================================================================

This Verilog include file is part of the Berkeley HardFloat IEEE Floating-
Point Arithmetic Package, Release 1, by John R. Hauser.

Copyright 2019 The Regents of the University of California.  All rights
reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

 1. Redistributions of source code must retain the above copyright notice,
    this list of conditions, and the following disclaimer.

 2. Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions, and the following disclaimer in the documentation
    and/or other materials provided with the distribution.

 3. Neither the name of the University nor the names of its contributors may
    be used to endorse or promote products derived from this software without
    specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS "AS IS", AND ANY
EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, ARE
DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

=============================================================================*/

/*----------------------------------------------------------------------------
*----------------------------------------------------------------------------*/
`define round_near_even   3'b000
`define round_minMag      3'b001
`define round_min         3'b010
`define round_max         3'b011
`define round_near_maxMag 3'b100
`define round_odd         3'b110

/*----------------------------------------------------------------------------
*----------------------------------------------------------------------------*/
`define floatControlWidth 1
`define flControl_tininessBeforeRounding 1'b0
`define flControl_tininessAfterRounding  1'b1

/*----------------------------------------------------------------------------
*----------------------------------------------------------------------------*/
`define flRoundOpt_sigMSBitAlwaysZero  1
`define flRoundOpt_subnormsAlwaysExact 2
`define flRoundOpt_neverUnderflows     4
`define flRoundOpt_neverOverflows      8



/*============================================================================

This Verilog include file is part of the Berkeley HardFloat IEEE Floating-
Point Arithmetic Package, Release 1, by John R. Hauser.

Copyright 2019 The Regents of the University of California.  All rights
reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

 1. Redistributions of source code must retain the above copyright notice,
    this list of conditions, and the following disclaimer.

 2. Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions, and the following disclaimer in the documentation
    and/or other materials provided with the distribution.

 3. Neither the name of the University nor the names of its contributors may
    be used to endorse or promote products derived from this software without
    specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS "AS IS", AND ANY
EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, ARE
DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

=============================================================================*/

/*----------------------------------------------------------------------------
*----------------------------------------------------------------------------*/
`define flControl_default `flControl_tininessAfterRounding

/*----------------------------------------------------------------------------
*----------------------------------------------------------------------------*/
//`define HardFloat_propagateNaNPayloads

/*----------------------------------------------------------------------------
*----------------------------------------------------------------------------*/
`define HardFloat_signDefaultNaN 0
`define HardFloat_fractDefaultNaN(sigWidth) {1'b1, {((sigWidth) - 2){1'b0}}}



/*----------------------------------------------------------------------------
*----------------------------------------------------------------------------*/

module
    addRecFNToRaw#(parameter expWidth = 3, parameter sigWidth = 3) (
        input [(1 - 1):0] control,
        input subOp,
        input [(expWidth + sigWidth):0] a,
        input [(expWidth + sigWidth):0] b,
        input [2:0] roundingMode,
        output invalidExc,
        output out_isNaN,
        output out_isInf,
        output out_isZero,
        output out_sign,
        output signed [(expWidth + 1):0] out_sExp,
        output [(sigWidth + 2):0] out_sig
    );

/*============================================================================

This Verilog include file is part of the Berkeley HardFloat IEEE Floating-
Point Arithmetic Package, Release 1, by John R. Hauser.

Copyright 2019 The Regents of the University of California.  All rights
reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

 1. Redistributions of source code must retain the above copyright notice,
    this list of conditions, and the following disclaimer.

 2. Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions, and the following disclaimer in the documentation
    and/or other materials provided with the distribution.

 3. Neither the name of the University nor the names of its contributors may
    be used to endorse or promote products derived from this software without
    specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS "AS IS", AND ANY
EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, ARE
DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

=============================================================================*/

/*----------------------------------------------------------------------------
*----------------------------------------------------------------------------*/

function integer clog2;
    input integer a;

    begin
        a = a - 1;
        for (clog2 = 0; a > 0; clog2 = clog2 + 1) a = a>>1;
    end

endfunction



    /*------------------------------------------------------------------------
    *------------------------------------------------------------------------*/
    localparam alignDistWidth = clog2(sigWidth);
    /*------------------------------------------------------------------------
    *------------------------------------------------------------------------*/
    wire isNaNA, isInfA, isZeroA, signA;
    wire signed [(expWidth + 1):0] sExpA;
    wire [sigWidth:0] sigA;
    recFNToRawFN#(expWidth, sigWidth)
        recFNToRawFN_a(a, isNaNA, isInfA, isZeroA, signA, sExpA, sigA);
    wire isSigNaNA;
    isSigNaNRecFN#(expWidth, sigWidth) isSigNaN_a(a, isSigNaNA);
    wire isNaNB, isInfB, isZeroB, signB;
    wire signed [(expWidth + 1):0] sExpB;
    wire [sigWidth:0] sigB;
    recFNToRawFN#(expWidth, sigWidth)
        recFNToRawFN_b(b, isNaNB, isInfB, isZeroB, signB, sExpB, sigB);
    wire effSignB = subOp ? !signB : signB;
    wire isSigNaNB;
    isSigNaNRecFN#(expWidth, sigWidth) isSigNaN_b(b, isSigNaNB);
    /*------------------------------------------------------------------------
    *------------------------------------------------------------------------*/
    wire eqSigns = (signA == effSignB);
    wire notEqSigns_signZero = (roundingMode == 3'b010) ? 1 : 0;
    wire signed [(expWidth + 1):0] sDiffExps = sExpA - sExpB;
    wire [(alignDistWidth - 1):0] modNatAlignDist =
        (sDiffExps < 0) ? sExpB - sExpA : sDiffExps;
    wire isMaxAlign =
        (sDiffExps>>>alignDistWidth != 0)
            && ((sDiffExps>>>alignDistWidth != -1)
                    || (sDiffExps[(alignDistWidth - 1):0] == 0));
    wire [(alignDistWidth - 1):0] alignDist =
        isMaxAlign ? (1<<alignDistWidth) - 1 : modNatAlignDist;
    wire closeSubMags = !eqSigns && !isMaxAlign && (modNatAlignDist <= 1);
    /*------------------------------------------------------------------------
    *------------------------------------------------------------------------*/
    wire signed [(sigWidth + 2):0] close_alignedSigA =
          ((0 <= sDiffExps) &&  sDiffExps[0] ? sigA<<2 : 0)
        | ((0 <= sDiffExps) && !sDiffExps[0] ? sigA<<1 : 0)
        | ((sDiffExps < 0)                   ? sigA    : 0);
    wire signed [(sigWidth + 2):0] close_sSigSum =
        close_alignedSigA - (sigB<<1);
    wire [(sigWidth + 1):0] close_sigSum =
        (close_sSigSum < 0) ? -close_sSigSum : close_sSigSum;
    wire [(sigWidth + 1 + (sigWidth & 1)):0] close_adjustedSigSum =
        close_sigSum<<(sigWidth & 1);
    wire [(sigWidth + 1)/2:0] close_reduced2SigSum;
    compressBy2#(sigWidth + 2 + (sigWidth & 1))
        compressBy2_close_sigSum(close_adjustedSigSum, close_reduced2SigSum);
    wire [(alignDistWidth - 1):0] close_normDistReduced2;
    countLeadingZeros#((sigWidth + 3)/2, alignDistWidth)
        countLeadingZeros_close(close_reduced2SigSum, close_normDistReduced2);
    wire [(alignDistWidth - 1):0] close_nearNormDist =
        close_normDistReduced2<<1;
    wire [(sigWidth + 2):0] close_sigOut =
        (close_sigSum<<close_nearNormDist)<<1;
    wire close_totalCancellation =
        !(|close_sigOut[(sigWidth + 2):(sigWidth + 1)]);
    wire close_notTotalCancellation_signOut = signA ^ (close_sSigSum < 0);
    /*------------------------------------------------------------------------
    *------------------------------------------------------------------------*/
    wire far_signOut = (sDiffExps < 0) ? effSignB : signA;
    wire [(sigWidth - 1):0] far_sigLarger  = (sDiffExps < 0) ? sigB : sigA;
    wire [(sigWidth - 1):0] far_sigSmaller = (sDiffExps < 0) ? sigA : sigB;
    wire [(sigWidth + 4):0] far_mainAlignedSigSmaller =
        {far_sigSmaller, 5'b0}>>alignDist;
    wire [(sigWidth + 1)/4:0] far_reduced4SigSmaller;
    compressBy4#(sigWidth + 2)
        compressBy4_far_sigSmaller(
            {far_sigSmaller, 2'b00}, far_reduced4SigSmaller);
    wire [(sigWidth + 1)/4:0] far_roundExtraMask;
    lowMaskHiLo#(alignDistWidth - 2, (sigWidth + 5)/4, 0)
        lowMask_far_roundExtraMask(
            alignDist[(alignDistWidth - 1):2], far_roundExtraMask);
    wire [(sigWidth + 2):0] far_alignedSigSmaller =
        {far_mainAlignedSigSmaller>>3,
         (|far_mainAlignedSigSmaller[2:0])
             || (|(far_reduced4SigSmaller & far_roundExtraMask))};
    wire far_subMags = !eqSigns;
    wire [(sigWidth + 3):0] far_negAlignedSigSmaller =
        far_subMags ? {1'b1, ~far_alignedSigSmaller}
            : {1'b0, far_alignedSigSmaller};
    wire [(sigWidth + 3):0] far_sigSum =
        (far_sigLarger<<3) + far_negAlignedSigSmaller + far_subMags;
    wire [(sigWidth + 2):0] far_sigOut =
        far_subMags ? far_sigSum : far_sigSum>>1 | far_sigSum[0];
    /*------------------------------------------------------------------------
    *------------------------------------------------------------------------*/
    wire notSigNaN_invalidExc = isInfA && isInfB && !eqSigns;
    wire notNaN_isInfOut = isInfA || isInfB;
    wire addZeros = isZeroA && isZeroB;
    wire notNaN_specialCase = notNaN_isInfOut || addZeros;
    wire notNaN_isZeroOut =
        addZeros
            || (!notNaN_isInfOut && closeSubMags && close_totalCancellation);
    wire notNaN_signOut =
           (eqSigns                      && signA              )
        || (isInfA                       && signA              )
        || (isInfB                       && effSignB           )
        || (notNaN_isZeroOut && !eqSigns && notEqSigns_signZero)
        || (!notNaN_specialCase && closeSubMags && !close_totalCancellation
                                        && close_notTotalCancellation_signOut)
        || (!notNaN_specialCase && !closeSubMags && far_signOut);
    wire signed [(expWidth + 1):0] common_sExpOut =
        (closeSubMags || (sDiffExps < 0) ? sExpB : sExpA)
            - (closeSubMags ? close_nearNormDist : far_subMags);
    wire [(sigWidth + 2):0] common_sigOut =
        closeSubMags ? close_sigOut : far_sigOut;
    /*------------------------------------------------------------------------
    *------------------------------------------------------------------------*/
    assign invalidExc = isSigNaNA || isSigNaNB || notSigNaN_invalidExc;
    assign out_isInf = notNaN_isInfOut;
    assign out_isZero = notNaN_isZeroOut;
    assign out_sExp = common_sExpOut;
assign out_isNaN = isNaNA || isNaNB;
    assign out_sign = notNaN_signOut;
    assign out_sig = common_sigOut;


endmodule

/*----------------------------------------------------------------------------
*----------------------------------------------------------------------------*/

module
    addRecFN#(parameter expWidth = 3, parameter sigWidth = 3) (
        input [(1 - 1):0] control,
        input subOp,
        input [(expWidth + sigWidth):0] a,
        input [(expWidth + sigWidth):0] b,
        input [2:0] roundingMode,
        output [(expWidth + sigWidth):0] out,
        output [4:0] exceptionFlags
    );

    /*------------------------------------------------------------------------
    *------------------------------------------------------------------------*/
    wire invalidExc, out_isNaN, out_isInf, out_isZero, out_sign;
    wire signed [(expWidth + 1):0] out_sExp;
    wire [(sigWidth + 2):0] out_sig;
    addRecFNToRaw#(expWidth, sigWidth)
        addRecFNToRaw(
            control,
            subOp,
            a,
            b,
            roundingMode,
            invalidExc,
            out_isNaN,
            out_isInf,
            out_isZero,
            out_sign,
            out_sExp,
            out_sig
        );
    /*------------------------------------------------------------------------
    *------------------------------------------------------------------------*/
    roundRawFNToRecFN#(expWidth, sigWidth, 2)
        roundRawOut(
            control,
            invalidExc,
            1'b0,
            out_isNaN,
            out_isInf,
            out_isZero,
            out_sign,
            out_sExp,
            out_sig,
            roundingMode,
            out,
            exceptionFlags
        );

endmodule


/*============================================================================

This Verilog source file is part of the Berkeley HardFloat IEEE Floating-Point
Arithmetic Package, Release 1, by John R. Hauser.

Copyright 2019 The Regents of the University of California.  All rights
reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

 1. Redistributions of source code must retain the above copyright notice,
    this list of conditions, and the following disclaimer.

 2. Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions, and the following disclaimer in the documentation
    and/or other materials provided with the distribution.

 3. Neither the name of the University nor the names of its contributors may
    be used to endorse or promote products derived from this software without
    specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS "AS IS", AND ANY
EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, ARE
DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

=============================================================================*/

/*----------------------------------------------------------------------------
*----------------------------------------------------------------------------*/

module
    compareRecFN#(parameter expWidth = 3, parameter sigWidth = 3) (
        input [(expWidth + sigWidth):0] a,
        input [(expWidth + sigWidth):0] b,
        input signaling,
        output lt,
        output eq,
        output gt,
        output unordered,
        output [4:0] exceptionFlags
    );

    /*------------------------------------------------------------------------
    *------------------------------------------------------------------------*/
    wire isNaNA, isInfA, isZeroA, signA;
    wire signed [(expWidth + 1):0] sExpA;
    wire [sigWidth:0] sigA;
    recFNToRawFN#(expWidth, sigWidth)
        recFNToRawFN_a(a, isNaNA, isInfA, isZeroA, signA, sExpA, sigA);
    wire isSigNaNA;
    isSigNaNRecFN#(expWidth, sigWidth) isSigNaN_a(a, isSigNaNA);
    wire isNaNB, isInfB, isZeroB, signB;
    wire signed [(expWidth + 1):0] sExpB;
    wire [sigWidth:0] sigB;
    recFNToRawFN#(expWidth, sigWidth)
        recFNToRawFN_b(b, isNaNB, isInfB, isZeroB, signB, sExpB, sigB);
    wire isSigNaNB;
    isSigNaNRecFN#(expWidth, sigWidth) isSigNaN_b(b, isSigNaNB);
    /*------------------------------------------------------------------------
    *------------------------------------------------------------------------*/
    wire ordered = !isNaNA && !isNaNB;
    wire bothInfs  = isInfA  && isInfB;
    wire bothZeros = isZeroA && isZeroB;
    wire eqExps = (sExpA == sExpB);
    wire common_ltMags = (sExpA < sExpB) || (eqExps && (sigA < sigB));
    wire common_eqMags = eqExps && (sigA == sigB);
    wire ordered_lt =
        !bothZeros
            && ((signA && !signB)
                    || (!bothInfs
                            && ((signA && !common_ltMags && !common_eqMags)
                                    || (!signB && common_ltMags))));
    wire ordered_eq =
        bothZeros || ((signA == signB) && (bothInfs || common_eqMags));
    /*------------------------------------------------------------------------
    *------------------------------------------------------------------------*/
    wire invalid = isSigNaNA || isSigNaNB || (signaling && !ordered);
    assign lt = ordered && ordered_lt;
    assign eq = ordered && ordered_eq;
    assign gt = ordered && !ordered_lt && !ordered_eq;
    assign unordered = !ordered;
    assign exceptionFlags = {invalid, 4'b0};

endmodule


/*============================================================================

This Verilog source file is part of the Berkeley HardFloat IEEE Floating-Point
Arithmetic Package, Release 1, by John R. Hauser.

Copyright 2019 The Regents of the University of California.  All rights
reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

 1. Redistributions of source code must retain the above copyright notice,
    this list of conditions, and the following disclaimer.

 2. Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions, and the following disclaimer in the documentation
    and/or other materials provided with the distribution.

 3. Neither the name of the University nor the names of its contributors may
    be used to endorse or promote products derived from this software without
    specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS "AS IS", AND ANY
EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, ARE
DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

=============================================================================*/

/*----------------------------------------------------------------------------
*----------------------------------------------------------------------------*/

module
    isSigNaNRecFN#(parameter expWidth = 3, parameter sigWidth = 3) (
        input [(expWidth + sigWidth):0] in, output isSigNaN
    );

    wire isNaN =
        (in[(expWidth + sigWidth - 1):(expWidth + sigWidth - 3)] == 'b111);
    assign isSigNaN = isNaN && !in[sigWidth - 2];

endmodule


/*============================================================================

This Verilog source file is part of the Berkeley HardFloat IEEE Floating-Point
Arithmetic Package, Release 1, by John R. Hauser.

Copyright 2019 The Regents of the University of California.  All rights
reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

 1. Redistributions of source code must retain the above copyright notice,
    this list of conditions, and the following disclaimer.

 2. Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions, and the following disclaimer in the documentation
    and/or other materials provided with the distribution.

 3. Neither the name of the University nor the names of its contributors may
    be used to endorse or promote products derived from this software without
    specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS "AS IS", AND ANY
EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, ARE
DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

=============================================================================*/

/*----------------------------------------------------------------------------
*----------------------------------------------------------------------------*/

module
    fNToRecFN#(parameter expWidth = 3, parameter sigWidth = 3) (
        input [(expWidth + sigWidth - 1):0] in,
        output [(expWidth + sigWidth):0] out
    );

/*============================================================================

This Verilog include file is part of the Berkeley HardFloat IEEE Floating-
Point Arithmetic Package, Release 1, by John R. Hauser.

Copyright 2019 The Regents of the University of California.  All rights
reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

 1. Redistributions of source code must retain the above copyright notice,
    this list of conditions, and the following disclaimer.

 2. Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions, and the following disclaimer in the documentation
    and/or other materials provided with the distribution.

 3. Neither the name of the University nor the names of its contributors may
    be used to endorse or promote products derived from this software without
    specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS "AS IS", AND ANY
EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, ARE
DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

=============================================================================*/

/*----------------------------------------------------------------------------
*----------------------------------------------------------------------------*/

function integer clog2;
    input integer a;

    begin
        a = a - 1;
        for (clog2 = 0; a > 0; clog2 = clog2 + 1) a = a>>1;
    end

endfunction



    /*------------------------------------------------------------------------
    *------------------------------------------------------------------------*/
    localparam normDistWidth = clog2(sigWidth);
    /*------------------------------------------------------------------------
    *------------------------------------------------------------------------*/
    wire sign;
    wire [(expWidth - 1):0] expIn;
    wire [(sigWidth - 2):0] fractIn;
    assign {sign, expIn, fractIn} = in;
    wire isZeroExpIn = (expIn == 0);
    wire isZeroFractIn = (fractIn == 0);
    /*------------------------------------------------------------------------
    *------------------------------------------------------------------------*/
    wire [(normDistWidth - 1):0] normDist;
    countLeadingZeros#(sigWidth - 1, normDistWidth)
        countLeadingZeros(fractIn, normDist);
    wire [(sigWidth - 2):0] subnormFract = (fractIn<<normDist)<<1;
    wire [expWidth:0] adjustedExp =
        (isZeroExpIn ? normDist ^ ((1<<(expWidth + 1)) - 1) : expIn)
            + ((1<<(expWidth - 1)) | (isZeroExpIn ? 2 : 1));
    wire isZero = isZeroExpIn && isZeroFractIn;
    wire isSpecial = (adjustedExp[expWidth:(expWidth - 1)] == 'b11);
    /*------------------------------------------------------------------------
    *------------------------------------------------------------------------*/
    wire [expWidth:0] exp;
    assign exp[expWidth:(expWidth - 2)] =
        isSpecial ? {2'b11, !isZeroFractIn}
            : isZero ? 3'b000 : adjustedExp[expWidth:(expWidth - 2)];
    assign exp[(expWidth - 3):0] = adjustedExp;
    assign out = {sign, exp, isZeroExpIn ? subnormFract : fractIn};

endmodule

module std_float_const #(
    parameter REP = 32,
    parameter WIDTH = 32,
    parameter VALUE = 32
) (
   output logic [WIDTH-1:0] out
);
assign out = VALUE;
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
    $readmemh({DATA, "/mem_3.dat"}, mem_3.mem);
    $readmemh({DATA, "/mem_2.dat"}, mem_2.mem);
    $readmemh({DATA, "/mem_1.dat"}, mem_1.mem);
    $readmemh({DATA, "/mem_0.dat"}, mem_0.mem);
end
`endif

final begin
    $writememh({DATA, "/mem_3.out"}, mem_3.mem);
    $writememh({DATA, "/mem_2.out"}, mem_2.mem);
    $writememh({DATA, "/mem_1.out"}, mem_1.mem);
    $writememh({DATA, "/mem_0.out"}, mem_0.mem);
end
logic mem_3_clk;
logic mem_3_reset;
logic [8:0] mem_3_addr0;
logic mem_3_content_en;
logic mem_3_write_en;
logic [31:0] mem_3_write_data;
logic [31:0] mem_3_read_data;
logic mem_3_done;
logic mem_2_clk;
logic mem_2_reset;
logic [8:0] mem_2_addr0;
logic mem_2_content_en;
logic mem_2_write_en;
logic [31:0] mem_2_write_data;
logic [31:0] mem_2_read_data;
logic mem_2_done;
logic mem_1_clk;
logic mem_1_reset;
logic [8:0] mem_1_addr0;
logic mem_1_content_en;
logic mem_1_write_en;
logic [31:0] mem_1_write_data;
logic [31:0] mem_1_read_data;
logic mem_1_done;
logic mem_0_clk;
logic mem_0_reset;
logic [8:0] mem_0_addr0;
logic mem_0_content_en;
logic mem_0_write_en;
logic [31:0] mem_0_write_data;
logic [31:0] mem_0_read_data;
logic mem_0_done;
logic forward_instance_clk;
logic forward_instance_reset;
logic forward_instance_go;
logic forward_instance_done;
logic [31:0] forward_instance_arg_mem_0_read_data;
logic forward_instance_arg_mem_0_done;
logic [31:0] forward_instance_arg_mem_1_write_data;
logic [31:0] forward_instance_arg_mem_3_read_data;
logic [31:0] forward_instance_arg_mem_2_read_data;
logic [31:0] forward_instance_arg_mem_1_read_data;
logic forward_instance_arg_mem_0_content_en;
logic [8:0] forward_instance_arg_mem_3_addr0;
logic [31:0] forward_instance_arg_mem_3_write_data;
logic [8:0] forward_instance_arg_mem_0_addr0;
logic forward_instance_arg_mem_3_content_en;
logic forward_instance_arg_mem_0_write_en;
logic forward_instance_arg_mem_3_done;
logic forward_instance_arg_mem_1_done;
logic forward_instance_arg_mem_3_write_en;
logic [8:0] forward_instance_arg_mem_2_addr0;
logic forward_instance_arg_mem_2_done;
logic [31:0] forward_instance_arg_mem_0_write_data;
logic forward_instance_arg_mem_2_content_en;
logic forward_instance_arg_mem_1_write_en;
logic forward_instance_arg_mem_2_write_en;
logic [8:0] forward_instance_arg_mem_1_addr0;
logic forward_instance_arg_mem_1_content_en;
logic [31:0] forward_instance_arg_mem_2_write_data;
logic invoke0_go_in;
logic invoke0_go_out;
logic invoke0_done_in;
logic invoke0_done_out;
seq_mem_d1 # (
    .IDX_SIZE(9),
    .SIZE(300),
    .WIDTH(32)
) mem_3 (
    .addr0(mem_3_addr0),
    .clk(mem_3_clk),
    .content_en(mem_3_content_en),
    .done(mem_3_done),
    .read_data(mem_3_read_data),
    .reset(mem_3_reset),
    .write_data(mem_3_write_data),
    .write_en(mem_3_write_en)
);
seq_mem_d1 # (
    .IDX_SIZE(9),
    .SIZE(300),
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
    .IDX_SIZE(9),
    .SIZE(300),
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
    .IDX_SIZE(9),
    .SIZE(300),
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
forward forward_instance (
    .arg_mem_0_addr0(forward_instance_arg_mem_0_addr0),
    .arg_mem_0_content_en(forward_instance_arg_mem_0_content_en),
    .arg_mem_0_done(forward_instance_arg_mem_0_done),
    .arg_mem_0_read_data(forward_instance_arg_mem_0_read_data),
    .arg_mem_0_write_data(forward_instance_arg_mem_0_write_data),
    .arg_mem_0_write_en(forward_instance_arg_mem_0_write_en),
    .arg_mem_1_addr0(forward_instance_arg_mem_1_addr0),
    .arg_mem_1_content_en(forward_instance_arg_mem_1_content_en),
    .arg_mem_1_done(forward_instance_arg_mem_1_done),
    .arg_mem_1_read_data(forward_instance_arg_mem_1_read_data),
    .arg_mem_1_write_data(forward_instance_arg_mem_1_write_data),
    .arg_mem_1_write_en(forward_instance_arg_mem_1_write_en),
    .arg_mem_2_addr0(forward_instance_arg_mem_2_addr0),
    .arg_mem_2_content_en(forward_instance_arg_mem_2_content_en),
    .arg_mem_2_done(forward_instance_arg_mem_2_done),
    .arg_mem_2_read_data(forward_instance_arg_mem_2_read_data),
    .arg_mem_2_write_data(forward_instance_arg_mem_2_write_data),
    .arg_mem_2_write_en(forward_instance_arg_mem_2_write_en),
    .arg_mem_3_addr0(forward_instance_arg_mem_3_addr0),
    .arg_mem_3_content_en(forward_instance_arg_mem_3_content_en),
    .arg_mem_3_done(forward_instance_arg_mem_3_done),
    .arg_mem_3_read_data(forward_instance_arg_mem_3_read_data),
    .arg_mem_3_write_data(forward_instance_arg_mem_3_write_data),
    .arg_mem_3_write_en(forward_instance_arg_mem_3_write_en),
    .clk(forward_instance_clk),
    .done(forward_instance_done),
    .go(forward_instance_go),
    .reset(forward_instance_reset)
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
wire _guard19 = invoke0_go_out;
wire _guard20 = invoke0_go_out;
wire _guard21 = invoke0_go_out;
wire _guard22 = invoke0_go_out;
wire _guard23 = invoke0_go_out;
wire _guard24 = invoke0_go_out;
assign done = _guard1;
assign mem_2_write_en =
  _guard2 ? forward_instance_arg_mem_2_write_en :
  1'd0;
assign mem_2_clk = clk;
assign mem_2_addr0 = forward_instance_arg_mem_2_addr0;
assign mem_2_content_en =
  _guard4 ? forward_instance_arg_mem_2_content_en :
  1'd0;
assign mem_2_reset = reset;
assign mem_2_write_data = forward_instance_arg_mem_2_write_data;
assign invoke0_go_in = go;
assign mem_1_write_en =
  _guard6 ? forward_instance_arg_mem_1_write_en :
  1'd0;
assign mem_1_clk = clk;
assign mem_1_addr0 = forward_instance_arg_mem_1_addr0;
assign mem_1_content_en =
  _guard8 ? forward_instance_arg_mem_1_content_en :
  1'd0;
assign mem_1_reset = reset;
assign mem_1_write_data = forward_instance_arg_mem_1_write_data;
assign forward_instance_arg_mem_0_read_data =
  _guard10 ? mem_0_read_data :
  32'd0;
assign forward_instance_arg_mem_0_done =
  _guard11 ? mem_0_done :
  1'd0;
assign forward_instance_arg_mem_3_read_data =
  _guard12 ? mem_3_read_data :
  32'd0;
assign forward_instance_arg_mem_1_read_data =
  _guard13 ? mem_1_read_data :
  32'd0;
assign forward_instance_clk = clk;
assign forward_instance_arg_mem_3_done =
  _guard14 ? mem_3_done :
  1'd0;
assign forward_instance_reset = reset;
assign forward_instance_go = _guard15;
assign forward_instance_arg_mem_1_done =
  _guard16 ? mem_1_done :
  1'd0;
assign forward_instance_arg_mem_2_done =
  _guard17 ? mem_2_done :
  1'd0;
assign invoke0_done_in = forward_instance_done;
assign mem_0_write_en =
  _guard18 ? forward_instance_arg_mem_0_write_en :
  1'd0;
assign mem_0_clk = clk;
assign mem_0_addr0 = forward_instance_arg_mem_0_addr0;
assign mem_0_content_en =
  _guard20 ? forward_instance_arg_mem_0_content_en :
  1'd0;
assign mem_0_reset = reset;
assign mem_3_write_en =
  _guard21 ? forward_instance_arg_mem_3_write_en :
  1'd0;
assign mem_3_clk = clk;
assign mem_3_addr0 = forward_instance_arg_mem_3_addr0;
assign mem_3_content_en =
  _guard23 ? forward_instance_arg_mem_3_content_en :
  1'd0;
assign mem_3_reset = reset;
assign mem_3_write_data = forward_instance_arg_mem_3_write_data;
// COMPONENT END: main
endmodule
module relu4d_0(
  input logic clk,
  input logic reset,
  input logic go,
  output logic done,
  output logic [8:0] arg_mem_1_addr0,
  output logic arg_mem_1_content_en,
  output logic arg_mem_1_write_en,
  output logic [31:0] arg_mem_1_write_data,
  input logic [31:0] arg_mem_1_read_data,
  input logic arg_mem_1_done,
  output logic [8:0] arg_mem_0_addr0,
  output logic arg_mem_0_content_en,
  output logic arg_mem_0_write_en,
  output logic [31:0] arg_mem_0_write_data,
  input logic [31:0] arg_mem_0_read_data,
  input logic arg_mem_0_done
);
// COMPONENT START: relu4d_0
logic [31:0] cst_0_out;
logic [31:0] std_slice_1_in;
logic [8:0] std_slice_1_out;
logic [31:0] std_add_9_left;
logic [31:0] std_add_9_right;
logic [31:0] std_add_9_out;
logic [31:0] muli_5_reg_in;
logic muli_5_reg_write_en;
logic muli_5_reg_clk;
logic muli_5_reg_reset;
logic [31:0] muli_5_reg_out;
logic muli_5_reg_done;
logic std_mult_pipe_5_clk;
logic std_mult_pipe_5_reset;
logic std_mult_pipe_5_go;
logic [31:0] std_mult_pipe_5_left;
logic [31:0] std_mult_pipe_5_right;
logic [31:0] std_mult_pipe_5_out;
logic std_mult_pipe_5_done;
logic std_mux_0_cond;
logic [31:0] std_mux_0_tru;
logic [31:0] std_mux_0_fal;
logic [31:0] std_mux_0_out;
logic std_and_0_left;
logic std_and_0_right;
logic std_and_0_out;
logic std_or_0_left;
logic std_or_0_right;
logic std_or_0_out;
logic unordered_port_0_reg_in;
logic unordered_port_0_reg_write_en;
logic unordered_port_0_reg_clk;
logic unordered_port_0_reg_reset;
logic unordered_port_0_reg_out;
logic unordered_port_0_reg_done;
logic compare_port_0_reg_in;
logic compare_port_0_reg_write_en;
logic compare_port_0_reg_clk;
logic compare_port_0_reg_reset;
logic compare_port_0_reg_out;
logic compare_port_0_reg_done;
logic cmpf_0_reg_in;
logic cmpf_0_reg_write_en;
logic cmpf_0_reg_clk;
logic cmpf_0_reg_reset;
logic cmpf_0_reg_out;
logic cmpf_0_reg_done;
logic std_compareFN_0_clk;
logic std_compareFN_0_reset;
logic std_compareFN_0_go;
logic [31:0] std_compareFN_0_left;
logic [31:0] std_compareFN_0_right;
logic std_compareFN_0_signaling;
logic std_compareFN_0_lt;
logic std_compareFN_0_eq;
logic std_compareFN_0_gt;
logic std_compareFN_0_unordered;
logic [4:0] std_compareFN_0_exceptionFlags;
logic std_compareFN_0_done;
logic [31:0] for_3_induction_var_reg_in;
logic for_3_induction_var_reg_write_en;
logic for_3_induction_var_reg_clk;
logic for_3_induction_var_reg_reset;
logic [31:0] for_3_induction_var_reg_out;
logic for_3_induction_var_reg_done;
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
logic [3:0] idx_in;
logic idx_write_en;
logic idx_clk;
logic idx_reset;
logic [3:0] idx_out;
logic idx_done;
logic cond_reg_in;
logic cond_reg_write_en;
logic cond_reg_clk;
logic cond_reg_reset;
logic cond_reg_out;
logic cond_reg_done;
logic [3:0] adder_left;
logic [3:0] adder_right;
logic [3:0] adder_out;
logic [3:0] lt_left;
logic [3:0] lt_right;
logic lt_out;
logic [3:0] idx0_in;
logic idx0_write_en;
logic idx0_clk;
logic idx0_reset;
logic [3:0] idx0_out;
logic idx0_done;
logic cond_reg0_in;
logic cond_reg0_write_en;
logic cond_reg0_clk;
logic cond_reg0_reset;
logic cond_reg0_out;
logic cond_reg0_done;
logic [3:0] adder0_left;
logic [3:0] adder0_right;
logic [3:0] adder0_out;
logic [3:0] lt0_left;
logic [3:0] lt0_right;
logic lt0_out;
logic [1:0] idx1_in;
logic idx1_write_en;
logic idx1_clk;
logic idx1_reset;
logic [1:0] idx1_out;
logic idx1_done;
logic cond_reg1_in;
logic cond_reg1_write_en;
logic cond_reg1_clk;
logic cond_reg1_reset;
logic cond_reg1_out;
logic cond_reg1_done;
logic [1:0] adder1_left;
logic [1:0] adder1_right;
logic [1:0] adder1_out;
logic [1:0] lt1_left;
logic [1:0] lt1_right;
logic lt1_out;
logic [3:0] fsm_in;
logic fsm_write_en;
logic fsm_clk;
logic fsm_reset;
logic [3:0] fsm_out;
logic fsm_done;
logic ud_out;
logic [3:0] adder2_left;
logic [3:0] adder2_right;
logic [3:0] adder2_out;
logic ud0_out;
logic [3:0] adder3_left;
logic [3:0] adder3_right;
logic [3:0] adder3_out;
logic ud1_out;
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
logic bb0_6_go_in;
logic bb0_6_go_out;
logic bb0_6_done_in;
logic bb0_6_done_out;
logic bb0_7_go_in;
logic bb0_7_go_out;
logic bb0_7_done_in;
logic bb0_7_done_out;
logic bb0_15_go_in;
logic bb0_15_go_out;
logic bb0_15_done_in;
logic bb0_15_done_out;
logic invoke2_go_in;
logic invoke2_go_out;
logic invoke2_done_in;
logic invoke2_done_out;
logic invoke3_go_in;
logic invoke3_go_out;
logic invoke3_done_in;
logic invoke3_done_out;
logic invoke16_go_in;
logic invoke16_go_out;
logic invoke16_done_in;
logic invoke16_done_out;
logic invoke17_go_in;
logic invoke17_go_out;
logic invoke17_done_in;
logic invoke17_done_out;
logic invoke18_go_in;
logic invoke18_go_out;
logic invoke18_done_in;
logic invoke18_done_out;
logic invoke19_go_in;
logic invoke19_go_out;
logic invoke19_done_in;
logic invoke19_done_out;
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
logic early_reset_static_par_thread_go_in;
logic early_reset_static_par_thread_go_out;
logic early_reset_static_par_thread_done_in;
logic early_reset_static_par_thread_done_out;
logic early_reset_static_seq_go_in;
logic early_reset_static_seq_go_out;
logic early_reset_static_seq_done_in;
logic early_reset_static_seq_done_out;
logic early_reset_static_seq0_go_in;
logic early_reset_static_seq0_go_out;
logic early_reset_static_seq0_done_in;
logic early_reset_static_seq0_done_out;
logic wrapper_early_reset_static_par_thread_go_in;
logic wrapper_early_reset_static_par_thread_go_out;
logic wrapper_early_reset_static_par_thread_done_in;
logic wrapper_early_reset_static_par_thread_done_out;
logic wrapper_early_reset_static_seq_go_in;
logic wrapper_early_reset_static_seq_go_out;
logic wrapper_early_reset_static_seq_done_in;
logic wrapper_early_reset_static_seq_done_out;
logic wrapper_early_reset_static_seq0_go_in;
logic wrapper_early_reset_static_seq0_go_out;
logic wrapper_early_reset_static_seq0_done_in;
logic wrapper_early_reset_static_seq0_done_out;
logic tdcc_go_in;
logic tdcc_go_out;
logic tdcc_done_in;
logic tdcc_done_out;
std_float_const # (
    .REP(0),
    .VALUE(0),
    .WIDTH(32)
) cst_0 (
    .out(cst_0_out)
);
std_slice # (
    .IN_WIDTH(32),
    .OUT_WIDTH(9)
) std_slice_1 (
    .in(std_slice_1_in),
    .out(std_slice_1_out)
);
std_add # (
    .WIDTH(32)
) std_add_9 (
    .left(std_add_9_left),
    .out(std_add_9_out),
    .right(std_add_9_right)
);
std_reg # (
    .WIDTH(32)
) muli_5_reg (
    .clk(muli_5_reg_clk),
    .done(muli_5_reg_done),
    .in(muli_5_reg_in),
    .out(muli_5_reg_out),
    .reset(muli_5_reg_reset),
    .write_en(muli_5_reg_write_en)
);
std_mult_pipe # (
    .WIDTH(32)
) std_mult_pipe_5 (
    .clk(std_mult_pipe_5_clk),
    .done(std_mult_pipe_5_done),
    .go(std_mult_pipe_5_go),
    .left(std_mult_pipe_5_left),
    .out(std_mult_pipe_5_out),
    .reset(std_mult_pipe_5_reset),
    .right(std_mult_pipe_5_right)
);
std_mux # (
    .WIDTH(32)
) std_mux_0 (
    .cond(std_mux_0_cond),
    .fal(std_mux_0_fal),
    .out(std_mux_0_out),
    .tru(std_mux_0_tru)
);
std_and # (
    .WIDTH(1)
) std_and_0 (
    .left(std_and_0_left),
    .out(std_and_0_out),
    .right(std_and_0_right)
);
std_or # (
    .WIDTH(1)
) std_or_0 (
    .left(std_or_0_left),
    .out(std_or_0_out),
    .right(std_or_0_right)
);
std_reg # (
    .WIDTH(1)
) unordered_port_0_reg (
    .clk(unordered_port_0_reg_clk),
    .done(unordered_port_0_reg_done),
    .in(unordered_port_0_reg_in),
    .out(unordered_port_0_reg_out),
    .reset(unordered_port_0_reg_reset),
    .write_en(unordered_port_0_reg_write_en)
);
std_reg # (
    .WIDTH(1)
) compare_port_0_reg (
    .clk(compare_port_0_reg_clk),
    .done(compare_port_0_reg_done),
    .in(compare_port_0_reg_in),
    .out(compare_port_0_reg_out),
    .reset(compare_port_0_reg_reset),
    .write_en(compare_port_0_reg_write_en)
);
std_reg # (
    .WIDTH(1)
) cmpf_0_reg (
    .clk(cmpf_0_reg_clk),
    .done(cmpf_0_reg_done),
    .in(cmpf_0_reg_in),
    .out(cmpf_0_reg_out),
    .reset(cmpf_0_reg_reset),
    .write_en(cmpf_0_reg_write_en)
);
std_compareFN # (
    .expWidth(8),
    .numWidth(32),
    .sigWidth(24)
) std_compareFN_0 (
    .clk(std_compareFN_0_clk),
    .done(std_compareFN_0_done),
    .eq(std_compareFN_0_eq),
    .exceptionFlags(std_compareFN_0_exceptionFlags),
    .go(std_compareFN_0_go),
    .gt(std_compareFN_0_gt),
    .left(std_compareFN_0_left),
    .lt(std_compareFN_0_lt),
    .reset(std_compareFN_0_reset),
    .right(std_compareFN_0_right),
    .signaling(std_compareFN_0_signaling),
    .unordered(std_compareFN_0_unordered)
);
std_reg # (
    .WIDTH(32)
) for_3_induction_var_reg (
    .clk(for_3_induction_var_reg_clk),
    .done(for_3_induction_var_reg_done),
    .in(for_3_induction_var_reg_in),
    .out(for_3_induction_var_reg_out),
    .reset(for_3_induction_var_reg_reset),
    .write_en(for_3_induction_var_reg_write_en)
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
    .WIDTH(4)
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
    .WIDTH(4)
) adder (
    .left(adder_left),
    .out(adder_out),
    .right(adder_right)
);
std_lt # (
    .WIDTH(4)
) lt (
    .left(lt_left),
    .out(lt_out),
    .right(lt_right)
);
std_reg # (
    .WIDTH(4)
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
    .WIDTH(4)
) adder0 (
    .left(adder0_left),
    .out(adder0_out),
    .right(adder0_right)
);
std_lt # (
    .WIDTH(4)
) lt0 (
    .left(lt0_left),
    .out(lt0_out),
    .right(lt0_right)
);
std_reg # (
    .WIDTH(2)
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
    .WIDTH(2)
) adder1 (
    .left(adder1_left),
    .out(adder1_out),
    .right(adder1_right)
);
std_lt # (
    .WIDTH(2)
) lt1 (
    .left(lt1_left),
    .out(lt1_out),
    .right(lt1_right)
);
std_reg # (
    .WIDTH(4)
) fsm (
    .clk(fsm_clk),
    .done(fsm_done),
    .in(fsm_in),
    .out(fsm_out),
    .reset(fsm_reset),
    .write_en(fsm_write_en)
);
undef # (
    .WIDTH(1)
) ud (
    .out(ud_out)
);
std_add # (
    .WIDTH(4)
) adder2 (
    .left(adder2_left),
    .out(adder2_out),
    .right(adder2_right)
);
undef # (
    .WIDTH(1)
) ud0 (
    .out(ud0_out)
);
std_add # (
    .WIDTH(4)
) adder3 (
    .left(adder3_left),
    .out(adder3_out),
    .right(adder3_right)
);
undef # (
    .WIDTH(1)
) ud1 (
    .out(ud1_out)
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
) bb0_6_go (
    .in(bb0_6_go_in),
    .out(bb0_6_go_out)
);
std_wire # (
    .WIDTH(1)
) bb0_6_done (
    .in(bb0_6_done_in),
    .out(bb0_6_done_out)
);
std_wire # (
    .WIDTH(1)
) bb0_7_go (
    .in(bb0_7_go_in),
    .out(bb0_7_go_out)
);
std_wire # (
    .WIDTH(1)
) bb0_7_done (
    .in(bb0_7_done_in),
    .out(bb0_7_done_out)
);
std_wire # (
    .WIDTH(1)
) bb0_15_go (
    .in(bb0_15_go_in),
    .out(bb0_15_go_out)
);
std_wire # (
    .WIDTH(1)
) bb0_15_done (
    .in(bb0_15_done_in),
    .out(bb0_15_done_out)
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
) invoke3_go (
    .in(invoke3_go_in),
    .out(invoke3_go_out)
);
std_wire # (
    .WIDTH(1)
) invoke3_done (
    .in(invoke3_done_in),
    .out(invoke3_done_out)
);
std_wire # (
    .WIDTH(1)
) invoke16_go (
    .in(invoke16_go_in),
    .out(invoke16_go_out)
);
std_wire # (
    .WIDTH(1)
) invoke16_done (
    .in(invoke16_done_in),
    .out(invoke16_done_out)
);
std_wire # (
    .WIDTH(1)
) invoke17_go (
    .in(invoke17_go_in),
    .out(invoke17_go_out)
);
std_wire # (
    .WIDTH(1)
) invoke17_done (
    .in(invoke17_done_in),
    .out(invoke17_done_out)
);
std_wire # (
    .WIDTH(1)
) invoke18_go (
    .in(invoke18_go_in),
    .out(invoke18_go_out)
);
std_wire # (
    .WIDTH(1)
) invoke18_done (
    .in(invoke18_done_in),
    .out(invoke18_done_out)
);
std_wire # (
    .WIDTH(1)
) invoke19_go (
    .in(invoke19_go_in),
    .out(invoke19_go_out)
);
std_wire # (
    .WIDTH(1)
) invoke19_done (
    .in(invoke19_done_in),
    .out(invoke19_done_out)
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
) early_reset_static_par_thread_go (
    .in(early_reset_static_par_thread_go_in),
    .out(early_reset_static_par_thread_go_out)
);
std_wire # (
    .WIDTH(1)
) early_reset_static_par_thread_done (
    .in(early_reset_static_par_thread_done_in),
    .out(early_reset_static_par_thread_done_out)
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
) early_reset_static_seq0_go (
    .in(early_reset_static_seq0_go_in),
    .out(early_reset_static_seq0_go_out)
);
std_wire # (
    .WIDTH(1)
) early_reset_static_seq0_done (
    .in(early_reset_static_seq0_done_in),
    .out(early_reset_static_seq0_done_out)
);
std_wire # (
    .WIDTH(1)
) wrapper_early_reset_static_par_thread_go (
    .in(wrapper_early_reset_static_par_thread_go_in),
    .out(wrapper_early_reset_static_par_thread_go_out)
);
std_wire # (
    .WIDTH(1)
) wrapper_early_reset_static_par_thread_done (
    .in(wrapper_early_reset_static_par_thread_done_in),
    .out(wrapper_early_reset_static_par_thread_done_out)
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
) wrapper_early_reset_static_seq0_go (
    .in(wrapper_early_reset_static_seq0_go_in),
    .out(wrapper_early_reset_static_seq0_go_out)
);
std_wire # (
    .WIDTH(1)
) wrapper_early_reset_static_seq0_done (
    .in(wrapper_early_reset_static_seq0_done_in),
    .out(wrapper_early_reset_static_seq0_done_out)
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
wire _guard1 = bb0_7_go_out;
wire _guard2 = bb0_7_go_out;
wire _guard3 = init_repeat1_go_out;
wire _guard4 = incr_repeat1_go_out;
wire _guard5 = _guard3 | _guard4;
wire _guard6 = init_repeat1_go_out;
wire _guard7 = incr_repeat1_go_out;
wire _guard8 = incr_repeat1_go_out;
wire _guard9 = incr_repeat1_go_out;
wire _guard10 = bb0_6_done_out;
wire _guard11 = ~_guard10;
wire _guard12 = fsm0_out == 5'd7;
wire _guard13 = _guard11 & _guard12;
wire _guard14 = tdcc_go_out;
wire _guard15 = _guard13 & _guard14;
wire _guard16 = init_repeat_done_out;
wire _guard17 = ~_guard16;
wire _guard18 = fsm0_out == 5'd5;
wire _guard19 = _guard17 & _guard18;
wire _guard20 = tdcc_go_out;
wire _guard21 = _guard19 & _guard20;
wire _guard22 = tdcc_done_out;
wire _guard23 = bb0_15_go_out;
wire _guard24 = bb0_6_go_out;
wire _guard25 = bb0_6_go_out;
wire _guard26 = bb0_6_go_out;
wire _guard27 = bb0_15_go_out;
wire _guard28 = bb0_15_go_out;
wire _guard29 = bb0_15_go_out;
wire _guard30 = incr_repeat_go_out;
wire _guard31 = incr_repeat_go_out;
wire _guard32 = fsm_out != 4'd11;
wire _guard33 = early_reset_static_seq_go_out;
wire _guard34 = _guard32 & _guard33;
wire _guard35 = fsm_out == 4'd11;
wire _guard36 = early_reset_static_seq_go_out;
wire _guard37 = _guard35 & _guard36;
wire _guard38 = _guard34 | _guard37;
wire _guard39 = fsm_out != 4'd11;
wire _guard40 = early_reset_static_seq0_go_out;
wire _guard41 = _guard39 & _guard40;
wire _guard42 = _guard38 | _guard41;
wire _guard43 = fsm_out == 4'd11;
wire _guard44 = early_reset_static_seq0_go_out;
wire _guard45 = _guard43 & _guard44;
wire _guard46 = _guard42 | _guard45;
wire _guard47 = fsm_out == 4'd11;
wire _guard48 = early_reset_static_seq_go_out;
wire _guard49 = _guard47 & _guard48;
wire _guard50 = fsm_out == 4'd11;
wire _guard51 = early_reset_static_seq0_go_out;
wire _guard52 = _guard50 & _guard51;
wire _guard53 = _guard49 | _guard52;
wire _guard54 = fsm_out != 4'd11;
wire _guard55 = early_reset_static_seq_go_out;
wire _guard56 = _guard54 & _guard55;
wire _guard57 = fsm_out != 4'd11;
wire _guard58 = early_reset_static_seq0_go_out;
wire _guard59 = _guard57 & _guard58;
wire _guard60 = bb0_15_done_out;
wire _guard61 = ~_guard60;
wire _guard62 = fsm0_out == 5'd10;
wire _guard63 = _guard61 & _guard62;
wire _guard64 = tdcc_go_out;
wire _guard65 = _guard63 & _guard64;
wire _guard66 = invoke18_done_out;
wire _guard67 = ~_guard66;
wire _guard68 = fsm0_out == 5'd15;
wire _guard69 = _guard67 & _guard68;
wire _guard70 = tdcc_go_out;
wire _guard71 = _guard69 & _guard70;
wire _guard72 = incr_repeat1_done_out;
wire _guard73 = ~_guard72;
wire _guard74 = fsm0_out == 5'd16;
wire _guard75 = _guard73 & _guard74;
wire _guard76 = tdcc_go_out;
wire _guard77 = _guard75 & _guard76;
wire _guard78 = bb0_15_go_out;
wire _guard79 = bb0_15_go_out;
wire _guard80 = bb0_15_go_out;
wire _guard81 = init_repeat1_go_out;
wire _guard82 = incr_repeat1_go_out;
wire _guard83 = _guard81 | _guard82;
wire _guard84 = incr_repeat1_go_out;
wire _guard85 = init_repeat1_go_out;
wire _guard86 = incr_repeat1_go_out;
wire _guard87 = incr_repeat1_go_out;
wire _guard88 = invoke2_done_out;
wire _guard89 = ~_guard88;
wire _guard90 = fsm0_out == 5'd2;
wire _guard91 = _guard89 & _guard90;
wire _guard92 = tdcc_go_out;
wire _guard93 = _guard91 & _guard92;
wire _guard94 = wrapper_early_reset_static_par_thread_done_out;
wire _guard95 = ~_guard94;
wire _guard96 = fsm0_out == 5'd0;
wire _guard97 = _guard95 & _guard96;
wire _guard98 = tdcc_go_out;
wire _guard99 = _guard97 & _guard98;
wire _guard100 = fsm_out >= 4'd4;
wire _guard101 = fsm_out < 4'd7;
wire _guard102 = _guard100 & _guard101;
wire _guard103 = fsm_out >= 4'd8;
wire _guard104 = fsm_out < 4'd11;
wire _guard105 = _guard103 & _guard104;
wire _guard106 = _guard102 | _guard105;
wire _guard107 = early_reset_static_seq_go_out;
wire _guard108 = _guard106 & _guard107;
wire _guard109 = fsm_out >= 4'd4;
wire _guard110 = fsm_out < 4'd7;
wire _guard111 = _guard109 & _guard110;
wire _guard112 = fsm_out >= 4'd8;
wire _guard113 = fsm_out < 4'd11;
wire _guard114 = _guard112 & _guard113;
wire _guard115 = _guard111 | _guard114;
wire _guard116 = early_reset_static_seq0_go_out;
wire _guard117 = _guard115 & _guard116;
wire _guard118 = _guard108 | _guard117;
wire _guard119 = fsm_out < 4'd3;
wire _guard120 = early_reset_static_seq_go_out;
wire _guard121 = _guard119 & _guard120;
wire _guard122 = fsm_out < 4'd3;
wire _guard123 = early_reset_static_seq0_go_out;
wire _guard124 = _guard122 & _guard123;
wire _guard125 = _guard121 | _guard124;
wire _guard126 = fsm_out < 4'd3;
wire _guard127 = fsm_out >= 4'd4;
wire _guard128 = fsm_out < 4'd7;
wire _guard129 = _guard127 & _guard128;
wire _guard130 = _guard126 | _guard129;
wire _guard131 = fsm_out >= 4'd8;
wire _guard132 = fsm_out < 4'd11;
wire _guard133 = _guard131 & _guard132;
wire _guard134 = _guard130 | _guard133;
wire _guard135 = early_reset_static_seq_go_out;
wire _guard136 = _guard134 & _guard135;
wire _guard137 = fsm_out < 4'd3;
wire _guard138 = fsm_out >= 4'd4;
wire _guard139 = fsm_out < 4'd7;
wire _guard140 = _guard138 & _guard139;
wire _guard141 = _guard137 | _guard140;
wire _guard142 = fsm_out >= 4'd8;
wire _guard143 = fsm_out < 4'd11;
wire _guard144 = _guard142 & _guard143;
wire _guard145 = _guard141 | _guard144;
wire _guard146 = early_reset_static_seq0_go_out;
wire _guard147 = _guard145 & _guard146;
wire _guard148 = _guard136 | _guard147;
wire _guard149 = fsm_out < 4'd3;
wire _guard150 = early_reset_static_seq_go_out;
wire _guard151 = _guard149 & _guard150;
wire _guard152 = fsm_out < 4'd3;
wire _guard153 = early_reset_static_seq0_go_out;
wire _guard154 = _guard152 & _guard153;
wire _guard155 = _guard151 | _guard154;
wire _guard156 = fsm_out >= 4'd8;
wire _guard157 = fsm_out < 4'd11;
wire _guard158 = _guard156 & _guard157;
wire _guard159 = early_reset_static_seq_go_out;
wire _guard160 = _guard158 & _guard159;
wire _guard161 = fsm_out >= 4'd8;
wire _guard162 = fsm_out < 4'd11;
wire _guard163 = _guard161 & _guard162;
wire _guard164 = early_reset_static_seq0_go_out;
wire _guard165 = _guard163 & _guard164;
wire _guard166 = _guard160 | _guard165;
wire _guard167 = fsm_out >= 4'd4;
wire _guard168 = fsm_out < 4'd7;
wire _guard169 = _guard167 & _guard168;
wire _guard170 = early_reset_static_seq_go_out;
wire _guard171 = _guard169 & _guard170;
wire _guard172 = fsm_out >= 4'd4;
wire _guard173 = fsm_out < 4'd7;
wire _guard174 = _guard172 & _guard173;
wire _guard175 = early_reset_static_seq0_go_out;
wire _guard176 = _guard174 & _guard175;
wire _guard177 = _guard171 | _guard176;
wire _guard178 = init_repeat0_go_out;
wire _guard179 = incr_repeat0_go_out;
wire _guard180 = _guard178 | _guard179;
wire _guard181 = init_repeat0_go_out;
wire _guard182 = incr_repeat0_go_out;
wire _guard183 = invoke16_go_out;
wire _guard184 = bb0_6_go_out;
wire _guard185 = bb0_15_go_out;
wire _guard186 = _guard184 | _guard185;
wire _guard187 = fsm_out >= 4'd4;
wire _guard188 = fsm_out < 4'd7;
wire _guard189 = _guard187 & _guard188;
wire _guard190 = fsm_out >= 4'd8;
wire _guard191 = fsm_out < 4'd11;
wire _guard192 = _guard190 & _guard191;
wire _guard193 = _guard189 | _guard192;
wire _guard194 = early_reset_static_seq_go_out;
wire _guard195 = _guard193 & _guard194;
wire _guard196 = _guard186 | _guard195;
wire _guard197 = fsm_out >= 4'd4;
wire _guard198 = fsm_out < 4'd7;
wire _guard199 = _guard197 & _guard198;
wire _guard200 = fsm_out >= 4'd8;
wire _guard201 = fsm_out < 4'd11;
wire _guard202 = _guard200 & _guard201;
wire _guard203 = _guard199 | _guard202;
wire _guard204 = early_reset_static_seq0_go_out;
wire _guard205 = _guard203 & _guard204;
wire _guard206 = _guard196 | _guard205;
wire _guard207 = invoke18_go_out;
wire _guard208 = invoke17_go_out;
wire _guard209 = invoke19_go_out;
wire _guard210 = bb0_6_go_out;
wire _guard211 = bb0_15_go_out;
wire _guard212 = _guard210 | _guard211;
wire _guard213 = invoke16_go_out;
wire _guard214 = invoke17_go_out;
wire _guard215 = _guard213 | _guard214;
wire _guard216 = invoke18_go_out;
wire _guard217 = _guard215 | _guard216;
wire _guard218 = invoke19_go_out;
wire _guard219 = _guard217 | _guard218;
wire _guard220 = fsm_out >= 4'd4;
wire _guard221 = fsm_out < 4'd7;
wire _guard222 = _guard220 & _guard221;
wire _guard223 = early_reset_static_seq_go_out;
wire _guard224 = _guard222 & _guard223;
wire _guard225 = fsm_out >= 4'd4;
wire _guard226 = fsm_out < 4'd7;
wire _guard227 = _guard225 & _guard226;
wire _guard228 = early_reset_static_seq0_go_out;
wire _guard229 = _guard227 & _guard228;
wire _guard230 = _guard224 | _guard229;
wire _guard231 = fsm_out >= 4'd8;
wire _guard232 = fsm_out < 4'd11;
wire _guard233 = _guard231 & _guard232;
wire _guard234 = early_reset_static_seq_go_out;
wire _guard235 = _guard233 & _guard234;
wire _guard236 = fsm_out >= 4'd8;
wire _guard237 = fsm_out < 4'd11;
wire _guard238 = _guard236 & _guard237;
wire _guard239 = early_reset_static_seq0_go_out;
wire _guard240 = _guard238 & _guard239;
wire _guard241 = _guard235 | _guard240;
wire _guard242 = bb0_7_go_out;
wire _guard243 = bb0_7_go_out;
wire _guard244 = invoke3_go_out;
wire _guard245 = invoke16_go_out;
wire _guard246 = _guard244 | _guard245;
wire _guard247 = invoke3_go_out;
wire _guard248 = invoke16_go_out;
wire _guard249 = init_repeat1_done_out;
wire _guard250 = ~_guard249;
wire _guard251 = fsm0_out == 5'd1;
wire _guard252 = _guard250 & _guard251;
wire _guard253 = tdcc_go_out;
wire _guard254 = _guard252 & _guard253;
wire _guard255 = wrapper_early_reset_static_seq0_go_out;
wire _guard256 = bb0_7_go_out;
wire _guard257 = bb0_7_go_out;
wire _guard258 = init_repeat0_go_out;
wire _guard259 = incr_repeat0_go_out;
wire _guard260 = _guard258 | _guard259;
wire _guard261 = init_repeat0_go_out;
wire _guard262 = incr_repeat0_go_out;
wire _guard263 = wrapper_early_reset_static_seq0_done_out;
wire _guard264 = ~_guard263;
wire _guard265 = fsm0_out == 5'd9;
wire _guard266 = _guard264 & _guard265;
wire _guard267 = tdcc_go_out;
wire _guard268 = _guard266 & _guard267;
wire _guard269 = bb0_7_go_out;
wire _guard270 = bb0_7_go_out;
wire _guard271 = incr_repeat_done_out;
wire _guard272 = ~_guard271;
wire _guard273 = fsm0_out == 5'd12;
wire _guard274 = _guard272 & _guard273;
wire _guard275 = tdcc_go_out;
wire _guard276 = _guard274 & _guard275;
wire _guard277 = cond_reg1_done;
wire _guard278 = idx1_done;
wire _guard279 = _guard277 & _guard278;
wire _guard280 = early_reset_static_seq_go_out;
wire _guard281 = early_reset_static_seq_go_out;
wire _guard282 = fsm0_out == 5'd18;
wire _guard283 = fsm0_out == 5'd0;
wire _guard284 = wrapper_early_reset_static_par_thread_done_out;
wire _guard285 = _guard283 & _guard284;
wire _guard286 = tdcc_go_out;
wire _guard287 = _guard285 & _guard286;
wire _guard288 = _guard282 | _guard287;
wire _guard289 = fsm0_out == 5'd1;
wire _guard290 = init_repeat1_done_out;
wire _guard291 = cond_reg1_out;
wire _guard292 = _guard290 & _guard291;
wire _guard293 = _guard289 & _guard292;
wire _guard294 = tdcc_go_out;
wire _guard295 = _guard293 & _guard294;
wire _guard296 = _guard288 | _guard295;
wire _guard297 = fsm0_out == 5'd16;
wire _guard298 = incr_repeat1_done_out;
wire _guard299 = cond_reg1_out;
wire _guard300 = _guard298 & _guard299;
wire _guard301 = _guard297 & _guard300;
wire _guard302 = tdcc_go_out;
wire _guard303 = _guard301 & _guard302;
wire _guard304 = _guard296 | _guard303;
wire _guard305 = fsm0_out == 5'd2;
wire _guard306 = invoke2_done_out;
wire _guard307 = _guard305 & _guard306;
wire _guard308 = tdcc_go_out;
wire _guard309 = _guard307 & _guard308;
wire _guard310 = _guard304 | _guard309;
wire _guard311 = fsm0_out == 5'd3;
wire _guard312 = init_repeat0_done_out;
wire _guard313 = cond_reg0_out;
wire _guard314 = _guard312 & _guard313;
wire _guard315 = _guard311 & _guard314;
wire _guard316 = tdcc_go_out;
wire _guard317 = _guard315 & _guard316;
wire _guard318 = _guard310 | _guard317;
wire _guard319 = fsm0_out == 5'd14;
wire _guard320 = incr_repeat0_done_out;
wire _guard321 = cond_reg0_out;
wire _guard322 = _guard320 & _guard321;
wire _guard323 = _guard319 & _guard322;
wire _guard324 = tdcc_go_out;
wire _guard325 = _guard323 & _guard324;
wire _guard326 = _guard318 | _guard325;
wire _guard327 = fsm0_out == 5'd4;
wire _guard328 = invoke3_done_out;
wire _guard329 = _guard327 & _guard328;
wire _guard330 = tdcc_go_out;
wire _guard331 = _guard329 & _guard330;
wire _guard332 = _guard326 | _guard331;
wire _guard333 = fsm0_out == 5'd5;
wire _guard334 = init_repeat_done_out;
wire _guard335 = cond_reg_out;
wire _guard336 = _guard334 & _guard335;
wire _guard337 = _guard333 & _guard336;
wire _guard338 = tdcc_go_out;
wire _guard339 = _guard337 & _guard338;
wire _guard340 = _guard332 | _guard339;
wire _guard341 = fsm0_out == 5'd12;
wire _guard342 = incr_repeat_done_out;
wire _guard343 = cond_reg_out;
wire _guard344 = _guard342 & _guard343;
wire _guard345 = _guard341 & _guard344;
wire _guard346 = tdcc_go_out;
wire _guard347 = _guard345 & _guard346;
wire _guard348 = _guard340 | _guard347;
wire _guard349 = fsm0_out == 5'd6;
wire _guard350 = wrapper_early_reset_static_seq_done_out;
wire _guard351 = _guard349 & _guard350;
wire _guard352 = tdcc_go_out;
wire _guard353 = _guard351 & _guard352;
wire _guard354 = _guard348 | _guard353;
wire _guard355 = fsm0_out == 5'd7;
wire _guard356 = bb0_6_done_out;
wire _guard357 = _guard355 & _guard356;
wire _guard358 = tdcc_go_out;
wire _guard359 = _guard357 & _guard358;
wire _guard360 = _guard354 | _guard359;
wire _guard361 = fsm0_out == 5'd8;
wire _guard362 = bb0_7_done_out;
wire _guard363 = _guard361 & _guard362;
wire _guard364 = tdcc_go_out;
wire _guard365 = _guard363 & _guard364;
wire _guard366 = _guard360 | _guard365;
wire _guard367 = fsm0_out == 5'd9;
wire _guard368 = wrapper_early_reset_static_seq0_done_out;
wire _guard369 = _guard367 & _guard368;
wire _guard370 = tdcc_go_out;
wire _guard371 = _guard369 & _guard370;
wire _guard372 = _guard366 | _guard371;
wire _guard373 = fsm0_out == 5'd10;
wire _guard374 = bb0_15_done_out;
wire _guard375 = _guard373 & _guard374;
wire _guard376 = tdcc_go_out;
wire _guard377 = _guard375 & _guard376;
wire _guard378 = _guard372 | _guard377;
wire _guard379 = fsm0_out == 5'd11;
wire _guard380 = invoke16_done_out;
wire _guard381 = _guard379 & _guard380;
wire _guard382 = tdcc_go_out;
wire _guard383 = _guard381 & _guard382;
wire _guard384 = _guard378 | _guard383;
wire _guard385 = fsm0_out == 5'd5;
wire _guard386 = init_repeat_done_out;
wire _guard387 = cond_reg_out;
wire _guard388 = ~_guard387;
wire _guard389 = _guard386 & _guard388;
wire _guard390 = _guard385 & _guard389;
wire _guard391 = tdcc_go_out;
wire _guard392 = _guard390 & _guard391;
wire _guard393 = _guard384 | _guard392;
wire _guard394 = fsm0_out == 5'd12;
wire _guard395 = incr_repeat_done_out;
wire _guard396 = cond_reg_out;
wire _guard397 = ~_guard396;
wire _guard398 = _guard395 & _guard397;
wire _guard399 = _guard394 & _guard398;
wire _guard400 = tdcc_go_out;
wire _guard401 = _guard399 & _guard400;
wire _guard402 = _guard393 | _guard401;
wire _guard403 = fsm0_out == 5'd13;
wire _guard404 = invoke17_done_out;
wire _guard405 = _guard403 & _guard404;
wire _guard406 = tdcc_go_out;
wire _guard407 = _guard405 & _guard406;
wire _guard408 = _guard402 | _guard407;
wire _guard409 = fsm0_out == 5'd3;
wire _guard410 = init_repeat0_done_out;
wire _guard411 = cond_reg0_out;
wire _guard412 = ~_guard411;
wire _guard413 = _guard410 & _guard412;
wire _guard414 = _guard409 & _guard413;
wire _guard415 = tdcc_go_out;
wire _guard416 = _guard414 & _guard415;
wire _guard417 = _guard408 | _guard416;
wire _guard418 = fsm0_out == 5'd14;
wire _guard419 = incr_repeat0_done_out;
wire _guard420 = cond_reg0_out;
wire _guard421 = ~_guard420;
wire _guard422 = _guard419 & _guard421;
wire _guard423 = _guard418 & _guard422;
wire _guard424 = tdcc_go_out;
wire _guard425 = _guard423 & _guard424;
wire _guard426 = _guard417 | _guard425;
wire _guard427 = fsm0_out == 5'd15;
wire _guard428 = invoke18_done_out;
wire _guard429 = _guard427 & _guard428;
wire _guard430 = tdcc_go_out;
wire _guard431 = _guard429 & _guard430;
wire _guard432 = _guard426 | _guard431;
wire _guard433 = fsm0_out == 5'd1;
wire _guard434 = init_repeat1_done_out;
wire _guard435 = cond_reg1_out;
wire _guard436 = ~_guard435;
wire _guard437 = _guard434 & _guard436;
wire _guard438 = _guard433 & _guard437;
wire _guard439 = tdcc_go_out;
wire _guard440 = _guard438 & _guard439;
wire _guard441 = _guard432 | _guard440;
wire _guard442 = fsm0_out == 5'd16;
wire _guard443 = incr_repeat1_done_out;
wire _guard444 = cond_reg1_out;
wire _guard445 = ~_guard444;
wire _guard446 = _guard443 & _guard445;
wire _guard447 = _guard442 & _guard446;
wire _guard448 = tdcc_go_out;
wire _guard449 = _guard447 & _guard448;
wire _guard450 = _guard441 | _guard449;
wire _guard451 = fsm0_out == 5'd17;
wire _guard452 = invoke19_done_out;
wire _guard453 = _guard451 & _guard452;
wire _guard454 = tdcc_go_out;
wire _guard455 = _guard453 & _guard454;
wire _guard456 = _guard450 | _guard455;
wire _guard457 = fsm0_out == 5'd0;
wire _guard458 = wrapper_early_reset_static_par_thread_done_out;
wire _guard459 = _guard457 & _guard458;
wire _guard460 = tdcc_go_out;
wire _guard461 = _guard459 & _guard460;
wire _guard462 = fsm0_out == 5'd3;
wire _guard463 = init_repeat0_done_out;
wire _guard464 = cond_reg0_out;
wire _guard465 = ~_guard464;
wire _guard466 = _guard463 & _guard465;
wire _guard467 = _guard462 & _guard466;
wire _guard468 = tdcc_go_out;
wire _guard469 = _guard467 & _guard468;
wire _guard470 = fsm0_out == 5'd14;
wire _guard471 = incr_repeat0_done_out;
wire _guard472 = cond_reg0_out;
wire _guard473 = ~_guard472;
wire _guard474 = _guard471 & _guard473;
wire _guard475 = _guard470 & _guard474;
wire _guard476 = tdcc_go_out;
wire _guard477 = _guard475 & _guard476;
wire _guard478 = _guard469 | _guard477;
wire _guard479 = fsm0_out == 5'd17;
wire _guard480 = invoke19_done_out;
wire _guard481 = _guard479 & _guard480;
wire _guard482 = tdcc_go_out;
wire _guard483 = _guard481 & _guard482;
wire _guard484 = fsm0_out == 5'd15;
wire _guard485 = invoke18_done_out;
wire _guard486 = _guard484 & _guard485;
wire _guard487 = tdcc_go_out;
wire _guard488 = _guard486 & _guard487;
wire _guard489 = fsm0_out == 5'd18;
wire _guard490 = fsm0_out == 5'd2;
wire _guard491 = invoke2_done_out;
wire _guard492 = _guard490 & _guard491;
wire _guard493 = tdcc_go_out;
wire _guard494 = _guard492 & _guard493;
wire _guard495 = fsm0_out == 5'd5;
wire _guard496 = init_repeat_done_out;
wire _guard497 = cond_reg_out;
wire _guard498 = ~_guard497;
wire _guard499 = _guard496 & _guard498;
wire _guard500 = _guard495 & _guard499;
wire _guard501 = tdcc_go_out;
wire _guard502 = _guard500 & _guard501;
wire _guard503 = fsm0_out == 5'd12;
wire _guard504 = incr_repeat_done_out;
wire _guard505 = cond_reg_out;
wire _guard506 = ~_guard505;
wire _guard507 = _guard504 & _guard506;
wire _guard508 = _guard503 & _guard507;
wire _guard509 = tdcc_go_out;
wire _guard510 = _guard508 & _guard509;
wire _guard511 = _guard502 | _guard510;
wire _guard512 = fsm0_out == 5'd13;
wire _guard513 = invoke17_done_out;
wire _guard514 = _guard512 & _guard513;
wire _guard515 = tdcc_go_out;
wire _guard516 = _guard514 & _guard515;
wire _guard517 = fsm0_out == 5'd4;
wire _guard518 = invoke3_done_out;
wire _guard519 = _guard517 & _guard518;
wire _guard520 = tdcc_go_out;
wire _guard521 = _guard519 & _guard520;
wire _guard522 = fsm0_out == 5'd11;
wire _guard523 = invoke16_done_out;
wire _guard524 = _guard522 & _guard523;
wire _guard525 = tdcc_go_out;
wire _guard526 = _guard524 & _guard525;
wire _guard527 = fsm0_out == 5'd1;
wire _guard528 = init_repeat1_done_out;
wire _guard529 = cond_reg1_out;
wire _guard530 = _guard528 & _guard529;
wire _guard531 = _guard527 & _guard530;
wire _guard532 = tdcc_go_out;
wire _guard533 = _guard531 & _guard532;
wire _guard534 = fsm0_out == 5'd16;
wire _guard535 = incr_repeat1_done_out;
wire _guard536 = cond_reg1_out;
wire _guard537 = _guard535 & _guard536;
wire _guard538 = _guard534 & _guard537;
wire _guard539 = tdcc_go_out;
wire _guard540 = _guard538 & _guard539;
wire _guard541 = _guard533 | _guard540;
wire _guard542 = fsm0_out == 5'd7;
wire _guard543 = bb0_6_done_out;
wire _guard544 = _guard542 & _guard543;
wire _guard545 = tdcc_go_out;
wire _guard546 = _guard544 & _guard545;
wire _guard547 = fsm0_out == 5'd9;
wire _guard548 = wrapper_early_reset_static_seq0_done_out;
wire _guard549 = _guard547 & _guard548;
wire _guard550 = tdcc_go_out;
wire _guard551 = _guard549 & _guard550;
wire _guard552 = fsm0_out == 5'd6;
wire _guard553 = wrapper_early_reset_static_seq_done_out;
wire _guard554 = _guard552 & _guard553;
wire _guard555 = tdcc_go_out;
wire _guard556 = _guard554 & _guard555;
wire _guard557 = fsm0_out == 5'd10;
wire _guard558 = bb0_15_done_out;
wire _guard559 = _guard557 & _guard558;
wire _guard560 = tdcc_go_out;
wire _guard561 = _guard559 & _guard560;
wire _guard562 = fsm0_out == 5'd3;
wire _guard563 = init_repeat0_done_out;
wire _guard564 = cond_reg0_out;
wire _guard565 = _guard563 & _guard564;
wire _guard566 = _guard562 & _guard565;
wire _guard567 = tdcc_go_out;
wire _guard568 = _guard566 & _guard567;
wire _guard569 = fsm0_out == 5'd14;
wire _guard570 = incr_repeat0_done_out;
wire _guard571 = cond_reg0_out;
wire _guard572 = _guard570 & _guard571;
wire _guard573 = _guard569 & _guard572;
wire _guard574 = tdcc_go_out;
wire _guard575 = _guard573 & _guard574;
wire _guard576 = _guard568 | _guard575;
wire _guard577 = fsm0_out == 5'd5;
wire _guard578 = init_repeat_done_out;
wire _guard579 = cond_reg_out;
wire _guard580 = _guard578 & _guard579;
wire _guard581 = _guard577 & _guard580;
wire _guard582 = tdcc_go_out;
wire _guard583 = _guard581 & _guard582;
wire _guard584 = fsm0_out == 5'd12;
wire _guard585 = incr_repeat_done_out;
wire _guard586 = cond_reg_out;
wire _guard587 = _guard585 & _guard586;
wire _guard588 = _guard584 & _guard587;
wire _guard589 = tdcc_go_out;
wire _guard590 = _guard588 & _guard589;
wire _guard591 = _guard583 | _guard590;
wire _guard592 = fsm0_out == 5'd1;
wire _guard593 = init_repeat1_done_out;
wire _guard594 = cond_reg1_out;
wire _guard595 = ~_guard594;
wire _guard596 = _guard593 & _guard595;
wire _guard597 = _guard592 & _guard596;
wire _guard598 = tdcc_go_out;
wire _guard599 = _guard597 & _guard598;
wire _guard600 = fsm0_out == 5'd16;
wire _guard601 = incr_repeat1_done_out;
wire _guard602 = cond_reg1_out;
wire _guard603 = ~_guard602;
wire _guard604 = _guard601 & _guard603;
wire _guard605 = _guard600 & _guard604;
wire _guard606 = tdcc_go_out;
wire _guard607 = _guard605 & _guard606;
wire _guard608 = _guard599 | _guard607;
wire _guard609 = fsm0_out == 5'd8;
wire _guard610 = bb0_7_done_out;
wire _guard611 = _guard609 & _guard610;
wire _guard612 = tdcc_go_out;
wire _guard613 = _guard611 & _guard612;
wire _guard614 = cond_reg0_done;
wire _guard615 = idx0_done;
wire _guard616 = _guard614 & _guard615;
wire _guard617 = init_repeat_go_out;
wire _guard618 = incr_repeat_go_out;
wire _guard619 = _guard617 | _guard618;
wire _guard620 = incr_repeat_go_out;
wire _guard621 = init_repeat_go_out;
wire _guard622 = early_reset_static_seq0_go_out;
wire _guard623 = early_reset_static_seq0_go_out;
wire _guard624 = invoke17_done_out;
wire _guard625 = ~_guard624;
wire _guard626 = fsm0_out == 5'd13;
wire _guard627 = _guard625 & _guard626;
wire _guard628 = tdcc_go_out;
wire _guard629 = _guard627 & _guard628;
wire _guard630 = cond_reg_done;
wire _guard631 = idx_done;
wire _guard632 = _guard630 & _guard631;
wire _guard633 = cond_reg_done;
wire _guard634 = idx_done;
wire _guard635 = _guard633 & _guard634;
wire _guard636 = cond_reg0_done;
wire _guard637 = idx0_done;
wire _guard638 = _guard636 & _guard637;
wire _guard639 = signal_reg_out;
wire _guard640 = incr_repeat0_go_out;
wire _guard641 = incr_repeat0_go_out;
wire _guard642 = invoke16_done_out;
wire _guard643 = ~_guard642;
wire _guard644 = fsm0_out == 5'd11;
wire _guard645 = _guard643 & _guard644;
wire _guard646 = tdcc_go_out;
wire _guard647 = _guard645 & _guard646;
wire _guard648 = init_repeat0_done_out;
wire _guard649 = ~_guard648;
wire _guard650 = fsm0_out == 5'd3;
wire _guard651 = _guard649 & _guard650;
wire _guard652 = tdcc_go_out;
wire _guard653 = _guard651 & _guard652;
wire _guard654 = incr_repeat0_done_out;
wire _guard655 = ~_guard654;
wire _guard656 = fsm0_out == 5'd14;
wire _guard657 = _guard655 & _guard656;
wire _guard658 = tdcc_go_out;
wire _guard659 = _guard657 & _guard658;
wire _guard660 = wrapper_early_reset_static_seq_go_out;
wire _guard661 = signal_reg_out;
wire _guard662 = _guard0 & _guard0;
wire _guard663 = signal_reg_out;
wire _guard664 = ~_guard663;
wire _guard665 = _guard662 & _guard664;
wire _guard666 = wrapper_early_reset_static_par_thread_go_out;
wire _guard667 = _guard665 & _guard666;
wire _guard668 = _guard661 | _guard667;
wire _guard669 = fsm_out == 4'd11;
wire _guard670 = _guard669 & _guard0;
wire _guard671 = signal_reg_out;
wire _guard672 = ~_guard671;
wire _guard673 = _guard670 & _guard672;
wire _guard674 = wrapper_early_reset_static_seq_go_out;
wire _guard675 = _guard673 & _guard674;
wire _guard676 = _guard668 | _guard675;
wire _guard677 = fsm_out == 4'd11;
wire _guard678 = _guard677 & _guard0;
wire _guard679 = signal_reg_out;
wire _guard680 = ~_guard679;
wire _guard681 = _guard678 & _guard680;
wire _guard682 = wrapper_early_reset_static_seq0_go_out;
wire _guard683 = _guard681 & _guard682;
wire _guard684 = _guard676 | _guard683;
wire _guard685 = _guard0 & _guard0;
wire _guard686 = signal_reg_out;
wire _guard687 = ~_guard686;
wire _guard688 = _guard685 & _guard687;
wire _guard689 = wrapper_early_reset_static_par_thread_go_out;
wire _guard690 = _guard688 & _guard689;
wire _guard691 = fsm_out == 4'd11;
wire _guard692 = _guard691 & _guard0;
wire _guard693 = signal_reg_out;
wire _guard694 = ~_guard693;
wire _guard695 = _guard692 & _guard694;
wire _guard696 = wrapper_early_reset_static_seq_go_out;
wire _guard697 = _guard695 & _guard696;
wire _guard698 = _guard690 | _guard697;
wire _guard699 = fsm_out == 4'd11;
wire _guard700 = _guard699 & _guard0;
wire _guard701 = signal_reg_out;
wire _guard702 = ~_guard701;
wire _guard703 = _guard700 & _guard702;
wire _guard704 = wrapper_early_reset_static_seq0_go_out;
wire _guard705 = _guard703 & _guard704;
wire _guard706 = _guard698 | _guard705;
wire _guard707 = signal_reg_out;
wire _guard708 = cond_reg1_done;
wire _guard709 = idx1_done;
wire _guard710 = _guard708 & _guard709;
wire _guard711 = wrapper_early_reset_static_par_thread_go_out;
wire _guard712 = bb0_6_go_out;
wire _guard713 = bb0_15_go_out;
wire _guard714 = _guard712 | _guard713;
wire _guard715 = fsm_out == 4'd3;
wire _guard716 = fsm_out == 4'd7;
wire _guard717 = _guard715 | _guard716;
wire _guard718 = fsm_out == 4'd11;
wire _guard719 = _guard717 | _guard718;
wire _guard720 = early_reset_static_seq_go_out;
wire _guard721 = _guard719 & _guard720;
wire _guard722 = fsm_out == 4'd3;
wire _guard723 = fsm_out == 4'd7;
wire _guard724 = _guard722 | _guard723;
wire _guard725 = fsm_out == 4'd11;
wire _guard726 = _guard724 | _guard725;
wire _guard727 = early_reset_static_seq0_go_out;
wire _guard728 = _guard726 & _guard727;
wire _guard729 = _guard721 | _guard728;
wire _guard730 = fsm_out == 4'd3;
wire _guard731 = fsm_out == 4'd7;
wire _guard732 = _guard730 | _guard731;
wire _guard733 = fsm_out == 4'd11;
wire _guard734 = _guard732 | _guard733;
wire _guard735 = early_reset_static_seq_go_out;
wire _guard736 = _guard734 & _guard735;
wire _guard737 = fsm_out == 4'd3;
wire _guard738 = fsm_out == 4'd7;
wire _guard739 = _guard737 | _guard738;
wire _guard740 = fsm_out == 4'd11;
wire _guard741 = _guard739 | _guard740;
wire _guard742 = early_reset_static_seq0_go_out;
wire _guard743 = _guard741 & _guard742;
wire _guard744 = _guard736 | _guard743;
wire _guard745 = invoke18_go_out;
wire _guard746 = early_reset_static_par_thread_go_out;
wire _guard747 = _guard745 | _guard746;
wire _guard748 = early_reset_static_par_thread_go_out;
wire _guard749 = invoke18_go_out;
wire _guard750 = signal_reg_out;
wire _guard751 = bb0_7_go_out;
wire _guard752 = bb0_7_go_out;
wire _guard753 = invoke19_done_out;
wire _guard754 = ~_guard753;
wire _guard755 = fsm0_out == 5'd17;
wire _guard756 = _guard754 & _guard755;
wire _guard757 = tdcc_go_out;
wire _guard758 = _guard756 & _guard757;
wire _guard759 = fsm0_out == 5'd18;
wire _guard760 = invoke2_go_out;
wire _guard761 = invoke17_go_out;
wire _guard762 = _guard760 | _guard761;
wire _guard763 = invoke2_go_out;
wire _guard764 = invoke17_go_out;
wire _guard765 = incr_repeat_go_out;
wire _guard766 = incr_repeat_go_out;
wire _guard767 = bb0_7_done_out;
wire _guard768 = ~_guard767;
wire _guard769 = fsm0_out == 5'd8;
wire _guard770 = _guard768 & _guard769;
wire _guard771 = tdcc_go_out;
wire _guard772 = _guard770 & _guard771;
wire _guard773 = invoke3_done_out;
wire _guard774 = ~_guard773;
wire _guard775 = fsm0_out == 5'd4;
wire _guard776 = _guard774 & _guard775;
wire _guard777 = tdcc_go_out;
wire _guard778 = _guard776 & _guard777;
wire _guard779 = invoke19_go_out;
wire _guard780 = early_reset_static_par_thread_go_out;
wire _guard781 = _guard779 | _guard780;
wire _guard782 = early_reset_static_par_thread_go_out;
wire _guard783 = invoke19_go_out;
wire _guard784 = wrapper_early_reset_static_seq_done_out;
wire _guard785 = ~_guard784;
wire _guard786 = fsm0_out == 5'd6;
wire _guard787 = _guard785 & _guard786;
wire _guard788 = tdcc_go_out;
wire _guard789 = _guard787 & _guard788;
wire _guard790 = signal_reg_out;
wire _guard791 = bb0_7_go_out;
wire _guard792 = std_compareFN_0_done;
wire _guard793 = ~_guard792;
wire _guard794 = bb0_7_go_out;
wire _guard795 = _guard793 & _guard794;
wire _guard796 = bb0_7_go_out;
wire _guard797 = bb0_7_go_out;
wire _guard798 = init_repeat_go_out;
wire _guard799 = incr_repeat_go_out;
wire _guard800 = _guard798 | _guard799;
wire _guard801 = init_repeat_go_out;
wire _guard802 = incr_repeat_go_out;
wire _guard803 = incr_repeat0_go_out;
wire _guard804 = incr_repeat0_go_out;
assign unordered_port_0_reg_write_en =
  _guard1 ? std_compareFN_0_done :
  1'd0;
assign unordered_port_0_reg_clk = clk;
assign unordered_port_0_reg_reset = reset;
assign unordered_port_0_reg_in = std_compareFN_0_unordered;
assign cond_reg1_write_en = _guard5;
assign cond_reg1_clk = clk;
assign cond_reg1_reset = reset;
assign cond_reg1_in =
  _guard6 ? 1'd1 :
  _guard7 ? lt1_out :
  1'd0;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard7, _guard6})) begin
    $fatal(2, "Multiple assignment to port `cond_reg1.in'.");
end
end
assign adder1_left =
  _guard8 ? idx1_out :
  2'd0;
assign adder1_right =
  _guard9 ? 2'd1 :
  2'd0;
assign bb0_6_go_in = _guard15;
assign init_repeat_go_in = _guard21;
assign done = _guard22;
assign arg_mem_1_write_data = std_mux_0_out;
assign arg_mem_0_content_en = _guard24;
assign arg_mem_0_addr0 = std_slice_1_out;
assign arg_mem_0_write_en =
  _guard26 ? 1'd0 :
  1'd0;
assign arg_mem_1_write_en = _guard27;
assign arg_mem_1_addr0 = std_slice_1_out;
assign arg_mem_1_content_en = _guard29;
assign adder_left =
  _guard30 ? idx_out :
  4'd0;
assign adder_right =
  _guard31 ? 4'd1 :
  4'd0;
assign fsm_write_en = _guard46;
assign fsm_clk = clk;
assign fsm_reset = reset;
assign fsm_in =
  _guard53 ? 4'd0 :
  _guard56 ? adder2_out :
  _guard59 ? adder3_out :
  4'd0;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard59, _guard56, _guard53})) begin
    $fatal(2, "Multiple assignment to port `fsm.in'.");
end
end
assign bb0_15_go_in = _guard65;
assign invoke18_go_in = _guard71;
assign incr_repeat1_go_in = _guard77;
assign std_mux_0_cond = cmpf_0_reg_out;
assign std_mux_0_tru = arg_mem_0_read_data;
assign std_mux_0_fal = cst_0_out;
assign idx1_write_en = _guard83;
assign idx1_clk = clk;
assign idx1_reset = reset;
assign idx1_in =
  _guard84 ? adder1_out :
  _guard85 ? 2'd0 :
  2'd0;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard85, _guard84})) begin
    $fatal(2, "Multiple assignment to port `idx1.in'.");
end
end
assign lt1_left =
  _guard86 ? adder1_out :
  2'd0;
assign lt1_right =
  _guard87 ? 2'd3 :
  2'd0;
assign invoke2_go_in = _guard93;
assign wrapper_early_reset_static_par_thread_go_in = _guard99;
assign std_mult_pipe_5_clk = clk;
assign std_mult_pipe_5_left =
  _guard118 ? std_add_9_out :
  _guard125 ? for_3_induction_var_reg_out :
  'x;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard125, _guard118})) begin
    $fatal(2, "Multiple assignment to port `std_mult_pipe_5.left'.");
end
end
assign std_mult_pipe_5_reset = reset;
assign std_mult_pipe_5_go = _guard148;
assign std_mult_pipe_5_right =
  _guard155 ? 32'd300 :
  _guard166 ? 32'd10 :
  _guard177 ? 32'd100 :
  'x;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard177, _guard166, _guard155})) begin
    $fatal(2, "Multiple assignment to port `std_mult_pipe_5.right'.");
end
end
assign cond_reg0_write_en = _guard180;
assign cond_reg0_clk = clk;
assign cond_reg0_reset = reset;
assign cond_reg0_in =
  _guard181 ? 1'd1 :
  _guard182 ? lt0_out :
  1'd0;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard182, _guard181})) begin
    $fatal(2, "Multiple assignment to port `cond_reg0.in'.");
end
end
assign std_add_9_left =
  _guard183 ? for_0_induction_var_reg_out :
  _guard206 ? muli_5_reg_out :
  _guard207 ? for_2_induction_var_reg_out :
  _guard208 ? for_1_induction_var_reg_out :
  _guard209 ? for_3_induction_var_reg_out :
  'x;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard209, _guard208, _guard207, _guard206, _guard183})) begin
    $fatal(2, "Multiple assignment to port `std_add_9.left'.");
end
end
assign std_add_9_right =
  _guard212 ? for_0_induction_var_reg_out :
  _guard219 ? 32'd1 :
  _guard230 ? for_2_induction_var_reg_out :
  _guard241 ? for_1_induction_var_reg_out :
  'x;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard241, _guard230, _guard219, _guard212})) begin
    $fatal(2, "Multiple assignment to port `std_add_9.right'.");
end
end
assign std_and_0_left =
  _guard242 ? compare_port_0_reg_done :
  1'd0;
assign std_and_0_right =
  _guard243 ? unordered_port_0_reg_done :
  1'd0;
assign for_0_induction_var_reg_write_en = _guard246;
assign for_0_induction_var_reg_clk = clk;
assign for_0_induction_var_reg_reset = reset;
assign for_0_induction_var_reg_in =
  _guard247 ? 32'd0 :
  _guard248 ? std_add_9_out :
  'x;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard248, _guard247})) begin
    $fatal(2, "Multiple assignment to port `for_0_induction_var_reg.in'.");
end
end
assign init_repeat1_go_in = _guard254;
assign early_reset_static_seq0_go_in = _guard255;
assign compare_port_0_reg_write_en =
  _guard256 ? std_compareFN_0_done :
  1'd0;
assign compare_port_0_reg_clk = clk;
assign compare_port_0_reg_reset = reset;
assign compare_port_0_reg_in = std_compareFN_0_gt;
assign idx0_write_en = _guard260;
assign idx0_clk = clk;
assign idx0_reset = reset;
assign idx0_in =
  _guard261 ? 4'd0 :
  _guard262 ? adder0_out :
  4'd0;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard262, _guard261})) begin
    $fatal(2, "Multiple assignment to port `idx0.in'.");
end
end
assign wrapper_early_reset_static_seq0_go_in = _guard268;
assign std_or_0_left = compare_port_0_reg_out;
assign std_or_0_right = unordered_port_0_reg_out;
assign invoke16_done_in = for_0_induction_var_reg_done;
assign invoke18_done_in = for_2_induction_var_reg_done;
assign incr_repeat_go_in = _guard276;
assign init_repeat1_done_in = _guard279;
assign tdcc_go_in = go;
assign adder2_left =
  _guard280 ? fsm_out :
  4'd0;
assign adder2_right =
  _guard281 ? 4'd1 :
  4'd0;
assign fsm0_write_en = _guard456;
assign fsm0_clk = clk;
assign fsm0_reset = reset;
assign fsm0_in =
  _guard461 ? 5'd1 :
  _guard478 ? 5'd15 :
  _guard483 ? 5'd18 :
  _guard488 ? 5'd16 :
  _guard489 ? 5'd0 :
  _guard494 ? 5'd3 :
  _guard511 ? 5'd13 :
  _guard516 ? 5'd14 :
  _guard521 ? 5'd5 :
  _guard526 ? 5'd12 :
  _guard541 ? 5'd2 :
  _guard546 ? 5'd8 :
  _guard551 ? 5'd10 :
  _guard556 ? 5'd7 :
  _guard561 ? 5'd11 :
  _guard576 ? 5'd4 :
  _guard591 ? 5'd6 :
  _guard608 ? 5'd17 :
  _guard613 ? 5'd9 :
  5'd0;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard613, _guard608, _guard591, _guard576, _guard561, _guard556, _guard551, _guard546, _guard541, _guard526, _guard521, _guard516, _guard511, _guard494, _guard489, _guard488, _guard483, _guard478, _guard461})) begin
    $fatal(2, "Multiple assignment to port `fsm0.in'.");
end
end
assign invoke3_done_in = for_0_induction_var_reg_done;
assign incr_repeat0_done_in = _guard616;
assign idx_write_en = _guard619;
assign idx_clk = clk;
assign idx_reset = reset;
assign idx_in =
  _guard620 ? adder_out :
  _guard621 ? 4'd0 :
  4'd0;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard621, _guard620})) begin
    $fatal(2, "Multiple assignment to port `idx.in'.");
end
end
assign adder3_left =
  _guard622 ? fsm_out :
  4'd0;
assign adder3_right =
  _guard623 ? 4'd1 :
  4'd0;
assign invoke17_go_in = _guard629;
assign init_repeat_done_in = _guard632;
assign incr_repeat_done_in = _guard635;
assign init_repeat0_done_in = _guard638;
assign wrapper_early_reset_static_seq_done_in = _guard639;
assign adder0_left =
  _guard640 ? idx0_out :
  4'd0;
assign adder0_right =
  _guard641 ? 4'd1 :
  4'd0;
assign bb0_7_done_in = cmpf_0_reg_done;
assign invoke16_go_in = _guard647;
assign invoke19_done_in = for_3_induction_var_reg_done;
assign init_repeat0_go_in = _guard653;
assign incr_repeat0_go_in = _guard659;
assign early_reset_static_seq_go_in = _guard660;
assign signal_reg_write_en = _guard684;
assign signal_reg_clk = clk;
assign signal_reg_reset = reset;
assign signal_reg_in =
  _guard706 ? 1'd1 :
  _guard707 ? 1'd0 :
  1'd0;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard707, _guard706})) begin
    $fatal(2, "Multiple assignment to port `signal_reg.in'.");
end
end
assign bb0_6_done_in = arg_mem_0_done;
assign invoke2_done_in = for_1_induction_var_reg_done;
assign incr_repeat1_done_in = _guard710;
assign early_reset_static_par_thread_go_in = _guard711;
assign std_slice_1_in = std_add_9_out;
assign muli_5_reg_write_en = _guard729;
assign muli_5_reg_clk = clk;
assign muli_5_reg_reset = reset;
assign muli_5_reg_in = std_mult_pipe_5_out;
assign for_2_induction_var_reg_write_en = _guard747;
assign for_2_induction_var_reg_clk = clk;
assign for_2_induction_var_reg_reset = reset;
assign for_2_induction_var_reg_in =
  _guard748 ? 32'd0 :
  _guard749 ? std_add_9_out :
  'x;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard749, _guard748})) begin
    $fatal(2, "Multiple assignment to port `for_2_induction_var_reg.in'.");
end
end
assign wrapper_early_reset_static_par_thread_done_in = _guard750;
assign cmpf_0_reg_write_en =
  _guard751 ? std_and_0_out :
  1'd0;
assign cmpf_0_reg_clk = clk;
assign cmpf_0_reg_reset = reset;
assign cmpf_0_reg_in = std_or_0_out;
assign invoke17_done_in = for_1_induction_var_reg_done;
assign invoke19_go_in = _guard758;
assign early_reset_static_seq_done_in = ud0_out;
assign tdcc_done_in = _guard759;
assign for_1_induction_var_reg_write_en = _guard762;
assign for_1_induction_var_reg_clk = clk;
assign for_1_induction_var_reg_reset = reset;
assign for_1_induction_var_reg_in =
  _guard763 ? 32'd0 :
  _guard764 ? std_add_9_out :
  'x;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard764, _guard763})) begin
    $fatal(2, "Multiple assignment to port `for_1_induction_var_reg.in'.");
end
end
assign lt_left =
  _guard765 ? adder_out :
  4'd0;
assign lt_right =
  _guard766 ? 4'd10 :
  4'd0;
assign bb0_7_go_in = _guard772;
assign invoke3_go_in = _guard778;
assign for_3_induction_var_reg_write_en = _guard781;
assign for_3_induction_var_reg_clk = clk;
assign for_3_induction_var_reg_reset = reset;
assign for_3_induction_var_reg_in =
  _guard782 ? 32'd0 :
  _guard783 ? std_add_9_out :
  'x;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard783, _guard782})) begin
    $fatal(2, "Multiple assignment to port `for_3_induction_var_reg.in'.");
end
end
assign bb0_15_done_in = arg_mem_1_done;
assign early_reset_static_par_thread_done_in = ud_out;
assign early_reset_static_seq0_done_in = ud1_out;
assign wrapper_early_reset_static_seq_go_in = _guard789;
assign wrapper_early_reset_static_seq0_done_in = _guard790;
assign std_compareFN_0_clk = clk;
assign std_compareFN_0_left =
  _guard791 ? arg_mem_0_read_data :
  32'd0;
assign std_compareFN_0_reset = reset;
assign std_compareFN_0_go = _guard795;
assign std_compareFN_0_signaling = _guard796;
assign std_compareFN_0_right =
  _guard797 ? cst_0_out :
  32'd0;
assign cond_reg_write_en = _guard800;
assign cond_reg_clk = clk;
assign cond_reg_reset = reset;
assign cond_reg_in =
  _guard801 ? 1'd1 :
  _guard802 ? lt_out :
  1'd0;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard802, _guard801})) begin
    $fatal(2, "Multiple assignment to port `cond_reg.in'.");
end
end
assign lt0_left =
  _guard803 ? adder0_out :
  4'd0;
assign lt0_right =
  _guard804 ? 4'd10 :
  4'd0;
// COMPONENT END: relu4d_0
endmodule
module forward(
  input logic clk,
  input logic reset,
  input logic go,
  output logic done,
  output logic [8:0] arg_mem_3_addr0,
  output logic arg_mem_3_content_en,
  output logic arg_mem_3_write_en,
  output logic [31:0] arg_mem_3_write_data,
  input logic [31:0] arg_mem_3_read_data,
  input logic arg_mem_3_done,
  output logic [8:0] arg_mem_2_addr0,
  output logic arg_mem_2_content_en,
  output logic arg_mem_2_write_en,
  output logic [31:0] arg_mem_2_write_data,
  input logic [31:0] arg_mem_2_read_data,
  input logic arg_mem_2_done,
  output logic [8:0] arg_mem_1_addr0,
  output logic arg_mem_1_content_en,
  output logic arg_mem_1_write_en,
  output logic [31:0] arg_mem_1_write_data,
  input logic [31:0] arg_mem_1_read_data,
  input logic arg_mem_1_done,
  output logic [8:0] arg_mem_0_addr0,
  output logic arg_mem_0_content_en,
  output logic arg_mem_0_write_en,
  output logic [31:0] arg_mem_0_write_data,
  input logic [31:0] arg_mem_0_read_data,
  input logic arg_mem_0_done
);
// COMPONENT START: forward
logic [31:0] std_slice_2_in;
logic [8:0] std_slice_2_out;
logic [31:0] std_add_12_left;
logic [31:0] std_add_12_right;
logic [31:0] std_add_12_out;
logic [31:0] muli_8_reg_in;
logic muli_8_reg_write_en;
logic muli_8_reg_clk;
logic muli_8_reg_reset;
logic [31:0] muli_8_reg_out;
logic muli_8_reg_done;
logic std_mult_pipe_8_clk;
logic std_mult_pipe_8_reset;
logic std_mult_pipe_8_go;
logic [31:0] std_mult_pipe_8_left;
logic [31:0] std_mult_pipe_8_right;
logic [31:0] std_mult_pipe_8_out;
logic std_mult_pipe_8_done;
logic [31:0] addf_0_reg_in;
logic addf_0_reg_write_en;
logic addf_0_reg_clk;
logic addf_0_reg_reset;
logic [31:0] addf_0_reg_out;
logic addf_0_reg_done;
logic std_addFN_0_clk;
logic std_addFN_0_reset;
logic std_addFN_0_go;
logic std_addFN_0_control;
logic std_addFN_0_subOp;
logic [31:0] std_addFN_0_left;
logic [31:0] std_addFN_0_right;
logic [2:0] std_addFN_0_roundingMode;
logic [31:0] std_addFN_0_out;
logic [4:0] std_addFN_0_exceptionFlags;
logic std_addFN_0_done;
logic [31:0] for_3_induction_var_reg_in;
logic for_3_induction_var_reg_write_en;
logic for_3_induction_var_reg_clk;
logic for_3_induction_var_reg_reset;
logic [31:0] for_3_induction_var_reg_out;
logic for_3_induction_var_reg_done;
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
logic relu4d_0_instance_clk;
logic relu4d_0_instance_reset;
logic relu4d_0_instance_go;
logic relu4d_0_instance_done;
logic [31:0] relu4d_0_instance_arg_mem_0_read_data;
logic relu4d_0_instance_arg_mem_0_done;
logic [31:0] relu4d_0_instance_arg_mem_1_write_data;
logic [31:0] relu4d_0_instance_arg_mem_1_read_data;
logic relu4d_0_instance_arg_mem_0_content_en;
logic [8:0] relu4d_0_instance_arg_mem_0_addr0;
logic relu4d_0_instance_arg_mem_0_write_en;
logic relu4d_0_instance_arg_mem_1_done;
logic [31:0] relu4d_0_instance_arg_mem_0_write_data;
logic relu4d_0_instance_arg_mem_1_write_en;
logic [8:0] relu4d_0_instance_arg_mem_1_addr0;
logic relu4d_0_instance_arg_mem_1_content_en;
logic [3:0] idx_in;
logic idx_write_en;
logic idx_clk;
logic idx_reset;
logic [3:0] idx_out;
logic idx_done;
logic cond_reg_in;
logic cond_reg_write_en;
logic cond_reg_clk;
logic cond_reg_reset;
logic cond_reg_out;
logic cond_reg_done;
logic [3:0] adder_left;
logic [3:0] adder_right;
logic [3:0] adder_out;
logic [3:0] lt_left;
logic [3:0] lt_right;
logic lt_out;
logic [3:0] idx0_in;
logic idx0_write_en;
logic idx0_clk;
logic idx0_reset;
logic [3:0] idx0_out;
logic idx0_done;
logic cond_reg0_in;
logic cond_reg0_write_en;
logic cond_reg0_clk;
logic cond_reg0_reset;
logic cond_reg0_out;
logic cond_reg0_done;
logic [3:0] adder0_left;
logic [3:0] adder0_right;
logic [3:0] adder0_out;
logic [3:0] lt0_left;
logic [3:0] lt0_right;
logic lt0_out;
logic [1:0] idx1_in;
logic idx1_write_en;
logic idx1_clk;
logic idx1_reset;
logic [1:0] idx1_out;
logic idx1_done;
logic cond_reg1_in;
logic cond_reg1_write_en;
logic cond_reg1_clk;
logic cond_reg1_reset;
logic cond_reg1_out;
logic cond_reg1_done;
logic [1:0] adder1_left;
logic [1:0] adder1_right;
logic [1:0] adder1_out;
logic [1:0] lt1_left;
logic [1:0] lt1_right;
logic lt1_out;
logic [3:0] fsm_in;
logic fsm_write_en;
logic fsm_clk;
logic fsm_reset;
logic [3:0] fsm_out;
logic fsm_done;
logic ud_out;
logic [3:0] adder2_left;
logic [3:0] adder2_right;
logic [3:0] adder2_out;
logic ud0_out;
logic [3:0] adder3_left;
logic [3:0] adder3_right;
logic [3:0] adder3_out;
logic ud1_out;
logic [3:0] adder4_left;
logic [3:0] adder4_right;
logic [3:0] adder4_out;
logic ud2_out;
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
logic bb0_6_go_in;
logic bb0_6_go_out;
logic bb0_6_done_in;
logic bb0_6_done_out;
logic bb0_13_go_in;
logic bb0_13_go_out;
logic bb0_13_done_in;
logic bb0_13_done_out;
logic bb0_14_go_in;
logic bb0_14_go_out;
logic bb0_14_done_in;
logic bb0_14_done_out;
logic bb0_21_go_in;
logic bb0_21_go_out;
logic bb0_21_done_in;
logic bb0_21_done_out;
logic invoke2_go_in;
logic invoke2_go_out;
logic invoke2_done_in;
logic invoke2_done_out;
logic invoke3_go_in;
logic invoke3_go_out;
logic invoke3_done_in;
logic invoke3_done_out;
logic invoke22_go_in;
logic invoke22_go_out;
logic invoke22_done_in;
logic invoke22_done_out;
logic invoke23_go_in;
logic invoke23_go_out;
logic invoke23_done_in;
logic invoke23_done_out;
logic invoke24_go_in;
logic invoke24_go_out;
logic invoke24_done_in;
logic invoke24_done_out;
logic invoke25_go_in;
logic invoke25_go_out;
logic invoke25_done_in;
logic invoke25_done_out;
logic invoke26_go_in;
logic invoke26_go_out;
logic invoke26_done_in;
logic invoke26_done_out;
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
logic early_reset_static_par_thread_go_in;
logic early_reset_static_par_thread_go_out;
logic early_reset_static_par_thread_done_in;
logic early_reset_static_par_thread_done_out;
logic early_reset_static_seq_go_in;
logic early_reset_static_seq_go_out;
logic early_reset_static_seq_done_in;
logic early_reset_static_seq_done_out;
logic early_reset_static_seq0_go_in;
logic early_reset_static_seq0_go_out;
logic early_reset_static_seq0_done_in;
logic early_reset_static_seq0_done_out;
logic early_reset_static_seq1_go_in;
logic early_reset_static_seq1_go_out;
logic early_reset_static_seq1_done_in;
logic early_reset_static_seq1_done_out;
logic wrapper_early_reset_static_par_thread_go_in;
logic wrapper_early_reset_static_par_thread_go_out;
logic wrapper_early_reset_static_par_thread_done_in;
logic wrapper_early_reset_static_par_thread_done_out;
logic wrapper_early_reset_static_seq_go_in;
logic wrapper_early_reset_static_seq_go_out;
logic wrapper_early_reset_static_seq_done_in;
logic wrapper_early_reset_static_seq_done_out;
logic wrapper_early_reset_static_seq0_go_in;
logic wrapper_early_reset_static_seq0_go_out;
logic wrapper_early_reset_static_seq0_done_in;
logic wrapper_early_reset_static_seq0_done_out;
logic wrapper_early_reset_static_seq1_go_in;
logic wrapper_early_reset_static_seq1_go_out;
logic wrapper_early_reset_static_seq1_done_in;
logic wrapper_early_reset_static_seq1_done_out;
logic tdcc_go_in;
logic tdcc_go_out;
logic tdcc_done_in;
logic tdcc_done_out;
std_slice # (
    .IN_WIDTH(32),
    .OUT_WIDTH(9)
) std_slice_2 (
    .in(std_slice_2_in),
    .out(std_slice_2_out)
);
std_add # (
    .WIDTH(32)
) std_add_12 (
    .left(std_add_12_left),
    .out(std_add_12_out),
    .right(std_add_12_right)
);
std_reg # (
    .WIDTH(32)
) muli_8_reg (
    .clk(muli_8_reg_clk),
    .done(muli_8_reg_done),
    .in(muli_8_reg_in),
    .out(muli_8_reg_out),
    .reset(muli_8_reg_reset),
    .write_en(muli_8_reg_write_en)
);
std_mult_pipe # (
    .WIDTH(32)
) std_mult_pipe_8 (
    .clk(std_mult_pipe_8_clk),
    .done(std_mult_pipe_8_done),
    .go(std_mult_pipe_8_go),
    .left(std_mult_pipe_8_left),
    .out(std_mult_pipe_8_out),
    .reset(std_mult_pipe_8_reset),
    .right(std_mult_pipe_8_right)
);
std_reg # (
    .WIDTH(32)
) addf_0_reg (
    .clk(addf_0_reg_clk),
    .done(addf_0_reg_done),
    .in(addf_0_reg_in),
    .out(addf_0_reg_out),
    .reset(addf_0_reg_reset),
    .write_en(addf_0_reg_write_en)
);
std_addFN # (
    .expWidth(8),
    .numWidth(32),
    .sigWidth(24)
) std_addFN_0 (
    .clk(std_addFN_0_clk),
    .control(std_addFN_0_control),
    .done(std_addFN_0_done),
    .exceptionFlags(std_addFN_0_exceptionFlags),
    .go(std_addFN_0_go),
    .left(std_addFN_0_left),
    .out(std_addFN_0_out),
    .reset(std_addFN_0_reset),
    .right(std_addFN_0_right),
    .roundingMode(std_addFN_0_roundingMode),
    .subOp(std_addFN_0_subOp)
);
std_reg # (
    .WIDTH(32)
) for_3_induction_var_reg (
    .clk(for_3_induction_var_reg_clk),
    .done(for_3_induction_var_reg_done),
    .in(for_3_induction_var_reg_in),
    .out(for_3_induction_var_reg_out),
    .reset(for_3_induction_var_reg_reset),
    .write_en(for_3_induction_var_reg_write_en)
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
relu4d_0 relu4d_0_instance (
    .arg_mem_0_addr0(relu4d_0_instance_arg_mem_0_addr0),
    .arg_mem_0_content_en(relu4d_0_instance_arg_mem_0_content_en),
    .arg_mem_0_done(relu4d_0_instance_arg_mem_0_done),
    .arg_mem_0_read_data(relu4d_0_instance_arg_mem_0_read_data),
    .arg_mem_0_write_data(relu4d_0_instance_arg_mem_0_write_data),
    .arg_mem_0_write_en(relu4d_0_instance_arg_mem_0_write_en),
    .arg_mem_1_addr0(relu4d_0_instance_arg_mem_1_addr0),
    .arg_mem_1_content_en(relu4d_0_instance_arg_mem_1_content_en),
    .arg_mem_1_done(relu4d_0_instance_arg_mem_1_done),
    .arg_mem_1_read_data(relu4d_0_instance_arg_mem_1_read_data),
    .arg_mem_1_write_data(relu4d_0_instance_arg_mem_1_write_data),
    .arg_mem_1_write_en(relu4d_0_instance_arg_mem_1_write_en),
    .clk(relu4d_0_instance_clk),
    .done(relu4d_0_instance_done),
    .go(relu4d_0_instance_go),
    .reset(relu4d_0_instance_reset)
);
std_reg # (
    .WIDTH(4)
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
    .WIDTH(4)
) adder (
    .left(adder_left),
    .out(adder_out),
    .right(adder_right)
);
std_lt # (
    .WIDTH(4)
) lt (
    .left(lt_left),
    .out(lt_out),
    .right(lt_right)
);
std_reg # (
    .WIDTH(4)
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
    .WIDTH(4)
) adder0 (
    .left(adder0_left),
    .out(adder0_out),
    .right(adder0_right)
);
std_lt # (
    .WIDTH(4)
) lt0 (
    .left(lt0_left),
    .out(lt0_out),
    .right(lt0_right)
);
std_reg # (
    .WIDTH(2)
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
    .WIDTH(2)
) adder1 (
    .left(adder1_left),
    .out(adder1_out),
    .right(adder1_right)
);
std_lt # (
    .WIDTH(2)
) lt1 (
    .left(lt1_left),
    .out(lt1_out),
    .right(lt1_right)
);
std_reg # (
    .WIDTH(4)
) fsm (
    .clk(fsm_clk),
    .done(fsm_done),
    .in(fsm_in),
    .out(fsm_out),
    .reset(fsm_reset),
    .write_en(fsm_write_en)
);
undef # (
    .WIDTH(1)
) ud (
    .out(ud_out)
);
std_add # (
    .WIDTH(4)
) adder2 (
    .left(adder2_left),
    .out(adder2_out),
    .right(adder2_right)
);
undef # (
    .WIDTH(1)
) ud0 (
    .out(ud0_out)
);
std_add # (
    .WIDTH(4)
) adder3 (
    .left(adder3_left),
    .out(adder3_out),
    .right(adder3_right)
);
undef # (
    .WIDTH(1)
) ud1 (
    .out(ud1_out)
);
std_add # (
    .WIDTH(4)
) adder4 (
    .left(adder4_left),
    .out(adder4_out),
    .right(adder4_right)
);
undef # (
    .WIDTH(1)
) ud2 (
    .out(ud2_out)
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
) bb0_6_go (
    .in(bb0_6_go_in),
    .out(bb0_6_go_out)
);
std_wire # (
    .WIDTH(1)
) bb0_6_done (
    .in(bb0_6_done_in),
    .out(bb0_6_done_out)
);
std_wire # (
    .WIDTH(1)
) bb0_13_go (
    .in(bb0_13_go_in),
    .out(bb0_13_go_out)
);
std_wire # (
    .WIDTH(1)
) bb0_13_done (
    .in(bb0_13_done_in),
    .out(bb0_13_done_out)
);
std_wire # (
    .WIDTH(1)
) bb0_14_go (
    .in(bb0_14_go_in),
    .out(bb0_14_go_out)
);
std_wire # (
    .WIDTH(1)
) bb0_14_done (
    .in(bb0_14_done_in),
    .out(bb0_14_done_out)
);
std_wire # (
    .WIDTH(1)
) bb0_21_go (
    .in(bb0_21_go_in),
    .out(bb0_21_go_out)
);
std_wire # (
    .WIDTH(1)
) bb0_21_done (
    .in(bb0_21_done_in),
    .out(bb0_21_done_out)
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
) invoke3_go (
    .in(invoke3_go_in),
    .out(invoke3_go_out)
);
std_wire # (
    .WIDTH(1)
) invoke3_done (
    .in(invoke3_done_in),
    .out(invoke3_done_out)
);
std_wire # (
    .WIDTH(1)
) invoke22_go (
    .in(invoke22_go_in),
    .out(invoke22_go_out)
);
std_wire # (
    .WIDTH(1)
) invoke22_done (
    .in(invoke22_done_in),
    .out(invoke22_done_out)
);
std_wire # (
    .WIDTH(1)
) invoke23_go (
    .in(invoke23_go_in),
    .out(invoke23_go_out)
);
std_wire # (
    .WIDTH(1)
) invoke23_done (
    .in(invoke23_done_in),
    .out(invoke23_done_out)
);
std_wire # (
    .WIDTH(1)
) invoke24_go (
    .in(invoke24_go_in),
    .out(invoke24_go_out)
);
std_wire # (
    .WIDTH(1)
) invoke24_done (
    .in(invoke24_done_in),
    .out(invoke24_done_out)
);
std_wire # (
    .WIDTH(1)
) invoke25_go (
    .in(invoke25_go_in),
    .out(invoke25_go_out)
);
std_wire # (
    .WIDTH(1)
) invoke25_done (
    .in(invoke25_done_in),
    .out(invoke25_done_out)
);
std_wire # (
    .WIDTH(1)
) invoke26_go (
    .in(invoke26_go_in),
    .out(invoke26_go_out)
);
std_wire # (
    .WIDTH(1)
) invoke26_done (
    .in(invoke26_done_in),
    .out(invoke26_done_out)
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
) early_reset_static_par_thread_go (
    .in(early_reset_static_par_thread_go_in),
    .out(early_reset_static_par_thread_go_out)
);
std_wire # (
    .WIDTH(1)
) early_reset_static_par_thread_done (
    .in(early_reset_static_par_thread_done_in),
    .out(early_reset_static_par_thread_done_out)
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
) early_reset_static_seq0_go (
    .in(early_reset_static_seq0_go_in),
    .out(early_reset_static_seq0_go_out)
);
std_wire # (
    .WIDTH(1)
) early_reset_static_seq0_done (
    .in(early_reset_static_seq0_done_in),
    .out(early_reset_static_seq0_done_out)
);
std_wire # (
    .WIDTH(1)
) early_reset_static_seq1_go (
    .in(early_reset_static_seq1_go_in),
    .out(early_reset_static_seq1_go_out)
);
std_wire # (
    .WIDTH(1)
) early_reset_static_seq1_done (
    .in(early_reset_static_seq1_done_in),
    .out(early_reset_static_seq1_done_out)
);
std_wire # (
    .WIDTH(1)
) wrapper_early_reset_static_par_thread_go (
    .in(wrapper_early_reset_static_par_thread_go_in),
    .out(wrapper_early_reset_static_par_thread_go_out)
);
std_wire # (
    .WIDTH(1)
) wrapper_early_reset_static_par_thread_done (
    .in(wrapper_early_reset_static_par_thread_done_in),
    .out(wrapper_early_reset_static_par_thread_done_out)
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
) wrapper_early_reset_static_seq0_go (
    .in(wrapper_early_reset_static_seq0_go_in),
    .out(wrapper_early_reset_static_seq0_go_out)
);
std_wire # (
    .WIDTH(1)
) wrapper_early_reset_static_seq0_done (
    .in(wrapper_early_reset_static_seq0_done_in),
    .out(wrapper_early_reset_static_seq0_done_out)
);
std_wire # (
    .WIDTH(1)
) wrapper_early_reset_static_seq1_go (
    .in(wrapper_early_reset_static_seq1_go_in),
    .out(wrapper_early_reset_static_seq1_go_out)
);
std_wire # (
    .WIDTH(1)
) wrapper_early_reset_static_seq1_done (
    .in(wrapper_early_reset_static_seq1_done_in),
    .out(wrapper_early_reset_static_seq1_done_out)
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
wire _guard1 = init_repeat1_go_out;
wire _guard2 = incr_repeat1_go_out;
wire _guard3 = _guard1 | _guard2;
wire _guard4 = init_repeat1_go_out;
wire _guard5 = incr_repeat1_go_out;
wire _guard6 = incr_repeat1_go_out;
wire _guard7 = incr_repeat1_go_out;
wire _guard8 = bb0_6_done_out;
wire _guard9 = ~_guard8;
wire _guard10 = fsm0_out == 5'd7;
wire _guard11 = _guard9 & _guard10;
wire _guard12 = tdcc_go_out;
wire _guard13 = _guard11 & _guard12;
wire _guard14 = init_repeat_done_out;
wire _guard15 = ~_guard14;
wire _guard16 = fsm0_out == 5'd5;
wire _guard17 = _guard15 & _guard16;
wire _guard18 = tdcc_go_out;
wire _guard19 = _guard17 & _guard18;
wire _guard20 = fsm_out == 4'd3;
wire _guard21 = fsm_out == 4'd7;
wire _guard22 = _guard20 | _guard21;
wire _guard23 = fsm_out == 4'd11;
wire _guard24 = _guard22 | _guard23;
wire _guard25 = early_reset_static_seq_go_out;
wire _guard26 = _guard24 & _guard25;
wire _guard27 = fsm_out == 4'd3;
wire _guard28 = fsm_out == 4'd7;
wire _guard29 = _guard27 | _guard28;
wire _guard30 = fsm_out == 4'd11;
wire _guard31 = _guard29 | _guard30;
wire _guard32 = early_reset_static_seq0_go_out;
wire _guard33 = _guard31 & _guard32;
wire _guard34 = _guard26 | _guard33;
wire _guard35 = fsm_out == 4'd3;
wire _guard36 = fsm_out == 4'd7;
wire _guard37 = _guard35 | _guard36;
wire _guard38 = fsm_out == 4'd11;
wire _guard39 = _guard37 | _guard38;
wire _guard40 = early_reset_static_seq1_go_out;
wire _guard41 = _guard39 & _guard40;
wire _guard42 = _guard34 | _guard41;
wire _guard43 = fsm_out == 4'd3;
wire _guard44 = fsm_out == 4'd7;
wire _guard45 = _guard43 | _guard44;
wire _guard46 = fsm_out == 4'd11;
wire _guard47 = _guard45 | _guard46;
wire _guard48 = early_reset_static_seq_go_out;
wire _guard49 = _guard47 & _guard48;
wire _guard50 = fsm_out == 4'd3;
wire _guard51 = fsm_out == 4'd7;
wire _guard52 = _guard50 | _guard51;
wire _guard53 = fsm_out == 4'd11;
wire _guard54 = _guard52 | _guard53;
wire _guard55 = early_reset_static_seq0_go_out;
wire _guard56 = _guard54 & _guard55;
wire _guard57 = _guard49 | _guard56;
wire _guard58 = fsm_out == 4'd3;
wire _guard59 = fsm_out == 4'd7;
wire _guard60 = _guard58 | _guard59;
wire _guard61 = fsm_out == 4'd11;
wire _guard62 = _guard60 | _guard61;
wire _guard63 = early_reset_static_seq1_go_out;
wire _guard64 = _guard62 & _guard63;
wire _guard65 = _guard57 | _guard64;
wire _guard66 = tdcc_done_out;
wire _guard67 = bb0_6_go_out;
wire _guard68 = invoke26_go_out;
wire _guard69 = bb0_21_go_out;
wire _guard70 = bb0_21_go_out;
wire _guard71 = bb0_6_go_out;
wire _guard72 = bb0_21_go_out;
wire _guard73 = invoke26_go_out;
wire _guard74 = bb0_6_go_out;
wire _guard75 = bb0_21_go_out;
wire _guard76 = invoke26_go_out;
wire _guard77 = invoke26_go_out;
wire _guard78 = invoke26_go_out;
wire _guard79 = bb0_13_go_out;
wire _guard80 = invoke26_go_out;
wire _guard81 = bb0_13_go_out;
wire _guard82 = bb0_13_go_out;
wire _guard83 = invoke26_go_out;
wire _guard84 = incr_repeat_go_out;
wire _guard85 = incr_repeat_go_out;
wire _guard86 = fsm_out != 4'd11;
wire _guard87 = early_reset_static_seq_go_out;
wire _guard88 = _guard86 & _guard87;
wire _guard89 = fsm_out == 4'd11;
wire _guard90 = early_reset_static_seq_go_out;
wire _guard91 = _guard89 & _guard90;
wire _guard92 = _guard88 | _guard91;
wire _guard93 = fsm_out != 4'd11;
wire _guard94 = early_reset_static_seq0_go_out;
wire _guard95 = _guard93 & _guard94;
wire _guard96 = _guard92 | _guard95;
wire _guard97 = fsm_out == 4'd11;
wire _guard98 = early_reset_static_seq0_go_out;
wire _guard99 = _guard97 & _guard98;
wire _guard100 = _guard96 | _guard99;
wire _guard101 = fsm_out != 4'd11;
wire _guard102 = early_reset_static_seq1_go_out;
wire _guard103 = _guard101 & _guard102;
wire _guard104 = _guard100 | _guard103;
wire _guard105 = fsm_out == 4'd11;
wire _guard106 = early_reset_static_seq1_go_out;
wire _guard107 = _guard105 & _guard106;
wire _guard108 = _guard104 | _guard107;
wire _guard109 = fsm_out != 4'd11;
wire _guard110 = early_reset_static_seq1_go_out;
wire _guard111 = _guard109 & _guard110;
wire _guard112 = fsm_out == 4'd11;
wire _guard113 = early_reset_static_seq_go_out;
wire _guard114 = _guard112 & _guard113;
wire _guard115 = fsm_out == 4'd11;
wire _guard116 = early_reset_static_seq0_go_out;
wire _guard117 = _guard115 & _guard116;
wire _guard118 = _guard114 | _guard117;
wire _guard119 = fsm_out == 4'd11;
wire _guard120 = early_reset_static_seq1_go_out;
wire _guard121 = _guard119 & _guard120;
wire _guard122 = _guard118 | _guard121;
wire _guard123 = fsm_out != 4'd11;
wire _guard124 = early_reset_static_seq_go_out;
wire _guard125 = _guard123 & _guard124;
wire _guard126 = fsm_out != 4'd11;
wire _guard127 = early_reset_static_seq0_go_out;
wire _guard128 = _guard126 & _guard127;
wire _guard129 = incr_repeat1_done_out;
wire _guard130 = ~_guard129;
wire _guard131 = fsm0_out == 5'd18;
wire _guard132 = _guard130 & _guard131;
wire _guard133 = tdcc_go_out;
wire _guard134 = _guard132 & _guard133;
wire _guard135 = bb0_14_done_out;
wire _guard136 = ~_guard135;
wire _guard137 = fsm0_out == 5'd10;
wire _guard138 = _guard136 & _guard137;
wire _guard139 = tdcc_go_out;
wire _guard140 = _guard138 & _guard139;
wire _guard141 = init_repeat1_go_out;
wire _guard142 = incr_repeat1_go_out;
wire _guard143 = _guard141 | _guard142;
wire _guard144 = incr_repeat1_go_out;
wire _guard145 = init_repeat1_go_out;
wire _guard146 = incr_repeat1_go_out;
wire _guard147 = incr_repeat1_go_out;
wire _guard148 = early_reset_static_seq1_go_out;
wire _guard149 = early_reset_static_seq1_go_out;
wire _guard150 = invoke2_done_out;
wire _guard151 = ~_guard150;
wire _guard152 = fsm0_out == 5'd2;
wire _guard153 = _guard151 & _guard152;
wire _guard154 = tdcc_go_out;
wire _guard155 = _guard153 & _guard154;
wire _guard156 = wrapper_early_reset_static_par_thread_done_out;
wire _guard157 = ~_guard156;
wire _guard158 = fsm0_out == 5'd0;
wire _guard159 = _guard157 & _guard158;
wire _guard160 = tdcc_go_out;
wire _guard161 = _guard159 & _guard160;
wire _guard162 = init_repeat0_go_out;
wire _guard163 = incr_repeat0_go_out;
wire _guard164 = _guard162 | _guard163;
wire _guard165 = init_repeat0_go_out;
wire _guard166 = incr_repeat0_go_out;
wire _guard167 = invoke3_go_out;
wire _guard168 = invoke22_go_out;
wire _guard169 = _guard167 | _guard168;
wire _guard170 = invoke3_go_out;
wire _guard171 = invoke22_go_out;
wire _guard172 = init_repeat1_done_out;
wire _guard173 = ~_guard172;
wire _guard174 = fsm0_out == 5'd1;
wire _guard175 = _guard173 & _guard174;
wire _guard176 = tdcc_go_out;
wire _guard177 = _guard175 & _guard176;
wire _guard178 = wrapper_early_reset_static_seq0_go_out;
wire _guard179 = signal_reg_out;
wire _guard180 = init_repeat0_go_out;
wire _guard181 = incr_repeat0_go_out;
wire _guard182 = _guard180 | _guard181;
wire _guard183 = init_repeat0_go_out;
wire _guard184 = incr_repeat0_go_out;
wire _guard185 = wrapper_early_reset_static_seq0_done_out;
wire _guard186 = ~_guard185;
wire _guard187 = fsm0_out == 5'd8;
wire _guard188 = _guard186 & _guard187;
wire _guard189 = tdcc_go_out;
wire _guard190 = _guard188 & _guard189;
wire _guard191 = invoke23_done_out;
wire _guard192 = ~_guard191;
wire _guard193 = fsm0_out == 5'd15;
wire _guard194 = _guard192 & _guard193;
wire _guard195 = tdcc_go_out;
wire _guard196 = _guard194 & _guard195;
wire _guard197 = incr_repeat_done_out;
wire _guard198 = ~_guard197;
wire _guard199 = fsm0_out == 5'd14;
wire _guard200 = _guard198 & _guard199;
wire _guard201 = tdcc_go_out;
wire _guard202 = _guard200 & _guard201;
wire _guard203 = cond_reg1_done;
wire _guard204 = idx1_done;
wire _guard205 = _guard203 & _guard204;
wire _guard206 = wrapper_early_reset_static_seq1_go_out;
wire _guard207 = bb0_14_go_out;
wire _guard208 = bb0_14_go_out;
wire _guard209 = early_reset_static_seq_go_out;
wire _guard210 = early_reset_static_seq_go_out;
wire _guard211 = fsm0_out == 5'd21;
wire _guard212 = fsm0_out == 5'd0;
wire _guard213 = wrapper_early_reset_static_par_thread_done_out;
wire _guard214 = _guard212 & _guard213;
wire _guard215 = tdcc_go_out;
wire _guard216 = _guard214 & _guard215;
wire _guard217 = _guard211 | _guard216;
wire _guard218 = fsm0_out == 5'd1;
wire _guard219 = init_repeat1_done_out;
wire _guard220 = cond_reg1_out;
wire _guard221 = _guard219 & _guard220;
wire _guard222 = _guard218 & _guard221;
wire _guard223 = tdcc_go_out;
wire _guard224 = _guard222 & _guard223;
wire _guard225 = _guard217 | _guard224;
wire _guard226 = fsm0_out == 5'd18;
wire _guard227 = incr_repeat1_done_out;
wire _guard228 = cond_reg1_out;
wire _guard229 = _guard227 & _guard228;
wire _guard230 = _guard226 & _guard229;
wire _guard231 = tdcc_go_out;
wire _guard232 = _guard230 & _guard231;
wire _guard233 = _guard225 | _guard232;
wire _guard234 = fsm0_out == 5'd2;
wire _guard235 = invoke2_done_out;
wire _guard236 = _guard234 & _guard235;
wire _guard237 = tdcc_go_out;
wire _guard238 = _guard236 & _guard237;
wire _guard239 = _guard233 | _guard238;
wire _guard240 = fsm0_out == 5'd3;
wire _guard241 = init_repeat0_done_out;
wire _guard242 = cond_reg0_out;
wire _guard243 = _guard241 & _guard242;
wire _guard244 = _guard240 & _guard243;
wire _guard245 = tdcc_go_out;
wire _guard246 = _guard244 & _guard245;
wire _guard247 = _guard239 | _guard246;
wire _guard248 = fsm0_out == 5'd16;
wire _guard249 = incr_repeat0_done_out;
wire _guard250 = cond_reg0_out;
wire _guard251 = _guard249 & _guard250;
wire _guard252 = _guard248 & _guard251;
wire _guard253 = tdcc_go_out;
wire _guard254 = _guard252 & _guard253;
wire _guard255 = _guard247 | _guard254;
wire _guard256 = fsm0_out == 5'd4;
wire _guard257 = invoke3_done_out;
wire _guard258 = _guard256 & _guard257;
wire _guard259 = tdcc_go_out;
wire _guard260 = _guard258 & _guard259;
wire _guard261 = _guard255 | _guard260;
wire _guard262 = fsm0_out == 5'd5;
wire _guard263 = init_repeat_done_out;
wire _guard264 = cond_reg_out;
wire _guard265 = _guard263 & _guard264;
wire _guard266 = _guard262 & _guard265;
wire _guard267 = tdcc_go_out;
wire _guard268 = _guard266 & _guard267;
wire _guard269 = _guard261 | _guard268;
wire _guard270 = fsm0_out == 5'd14;
wire _guard271 = incr_repeat_done_out;
wire _guard272 = cond_reg_out;
wire _guard273 = _guard271 & _guard272;
wire _guard274 = _guard270 & _guard273;
wire _guard275 = tdcc_go_out;
wire _guard276 = _guard274 & _guard275;
wire _guard277 = _guard269 | _guard276;
wire _guard278 = fsm0_out == 5'd6;
wire _guard279 = wrapper_early_reset_static_seq_done_out;
wire _guard280 = _guard278 & _guard279;
wire _guard281 = tdcc_go_out;
wire _guard282 = _guard280 & _guard281;
wire _guard283 = _guard277 | _guard282;
wire _guard284 = fsm0_out == 5'd7;
wire _guard285 = bb0_6_done_out;
wire _guard286 = _guard284 & _guard285;
wire _guard287 = tdcc_go_out;
wire _guard288 = _guard286 & _guard287;
wire _guard289 = _guard283 | _guard288;
wire _guard290 = fsm0_out == 5'd8;
wire _guard291 = wrapper_early_reset_static_seq0_done_out;
wire _guard292 = _guard290 & _guard291;
wire _guard293 = tdcc_go_out;
wire _guard294 = _guard292 & _guard293;
wire _guard295 = _guard289 | _guard294;
wire _guard296 = fsm0_out == 5'd9;
wire _guard297 = bb0_13_done_out;
wire _guard298 = _guard296 & _guard297;
wire _guard299 = tdcc_go_out;
wire _guard300 = _guard298 & _guard299;
wire _guard301 = _guard295 | _guard300;
wire _guard302 = fsm0_out == 5'd10;
wire _guard303 = bb0_14_done_out;
wire _guard304 = _guard302 & _guard303;
wire _guard305 = tdcc_go_out;
wire _guard306 = _guard304 & _guard305;
wire _guard307 = _guard301 | _guard306;
wire _guard308 = fsm0_out == 5'd11;
wire _guard309 = wrapper_early_reset_static_seq1_done_out;
wire _guard310 = _guard308 & _guard309;
wire _guard311 = tdcc_go_out;
wire _guard312 = _guard310 & _guard311;
wire _guard313 = _guard307 | _guard312;
wire _guard314 = fsm0_out == 5'd12;
wire _guard315 = bb0_21_done_out;
wire _guard316 = _guard314 & _guard315;
wire _guard317 = tdcc_go_out;
wire _guard318 = _guard316 & _guard317;
wire _guard319 = _guard313 | _guard318;
wire _guard320 = fsm0_out == 5'd13;
wire _guard321 = invoke22_done_out;
wire _guard322 = _guard320 & _guard321;
wire _guard323 = tdcc_go_out;
wire _guard324 = _guard322 & _guard323;
wire _guard325 = _guard319 | _guard324;
wire _guard326 = fsm0_out == 5'd5;
wire _guard327 = init_repeat_done_out;
wire _guard328 = cond_reg_out;
wire _guard329 = ~_guard328;
wire _guard330 = _guard327 & _guard329;
wire _guard331 = _guard326 & _guard330;
wire _guard332 = tdcc_go_out;
wire _guard333 = _guard331 & _guard332;
wire _guard334 = _guard325 | _guard333;
wire _guard335 = fsm0_out == 5'd14;
wire _guard336 = incr_repeat_done_out;
wire _guard337 = cond_reg_out;
wire _guard338 = ~_guard337;
wire _guard339 = _guard336 & _guard338;
wire _guard340 = _guard335 & _guard339;
wire _guard341 = tdcc_go_out;
wire _guard342 = _guard340 & _guard341;
wire _guard343 = _guard334 | _guard342;
wire _guard344 = fsm0_out == 5'd15;
wire _guard345 = invoke23_done_out;
wire _guard346 = _guard344 & _guard345;
wire _guard347 = tdcc_go_out;
wire _guard348 = _guard346 & _guard347;
wire _guard349 = _guard343 | _guard348;
wire _guard350 = fsm0_out == 5'd3;
wire _guard351 = init_repeat0_done_out;
wire _guard352 = cond_reg0_out;
wire _guard353 = ~_guard352;
wire _guard354 = _guard351 & _guard353;
wire _guard355 = _guard350 & _guard354;
wire _guard356 = tdcc_go_out;
wire _guard357 = _guard355 & _guard356;
wire _guard358 = _guard349 | _guard357;
wire _guard359 = fsm0_out == 5'd16;
wire _guard360 = incr_repeat0_done_out;
wire _guard361 = cond_reg0_out;
wire _guard362 = ~_guard361;
wire _guard363 = _guard360 & _guard362;
wire _guard364 = _guard359 & _guard363;
wire _guard365 = tdcc_go_out;
wire _guard366 = _guard364 & _guard365;
wire _guard367 = _guard358 | _guard366;
wire _guard368 = fsm0_out == 5'd17;
wire _guard369 = invoke24_done_out;
wire _guard370 = _guard368 & _guard369;
wire _guard371 = tdcc_go_out;
wire _guard372 = _guard370 & _guard371;
wire _guard373 = _guard367 | _guard372;
wire _guard374 = fsm0_out == 5'd1;
wire _guard375 = init_repeat1_done_out;
wire _guard376 = cond_reg1_out;
wire _guard377 = ~_guard376;
wire _guard378 = _guard375 & _guard377;
wire _guard379 = _guard374 & _guard378;
wire _guard380 = tdcc_go_out;
wire _guard381 = _guard379 & _guard380;
wire _guard382 = _guard373 | _guard381;
wire _guard383 = fsm0_out == 5'd18;
wire _guard384 = incr_repeat1_done_out;
wire _guard385 = cond_reg1_out;
wire _guard386 = ~_guard385;
wire _guard387 = _guard384 & _guard386;
wire _guard388 = _guard383 & _guard387;
wire _guard389 = tdcc_go_out;
wire _guard390 = _guard388 & _guard389;
wire _guard391 = _guard382 | _guard390;
wire _guard392 = fsm0_out == 5'd19;
wire _guard393 = invoke25_done_out;
wire _guard394 = _guard392 & _guard393;
wire _guard395 = tdcc_go_out;
wire _guard396 = _guard394 & _guard395;
wire _guard397 = _guard391 | _guard396;
wire _guard398 = fsm0_out == 5'd20;
wire _guard399 = invoke26_done_out;
wire _guard400 = _guard398 & _guard399;
wire _guard401 = tdcc_go_out;
wire _guard402 = _guard400 & _guard401;
wire _guard403 = _guard397 | _guard402;
wire _guard404 = fsm0_out == 5'd0;
wire _guard405 = wrapper_early_reset_static_par_thread_done_out;
wire _guard406 = _guard404 & _guard405;
wire _guard407 = tdcc_go_out;
wire _guard408 = _guard406 & _guard407;
wire _guard409 = fsm0_out == 5'd5;
wire _guard410 = init_repeat_done_out;
wire _guard411 = cond_reg_out;
wire _guard412 = ~_guard411;
wire _guard413 = _guard410 & _guard412;
wire _guard414 = _guard409 & _guard413;
wire _guard415 = tdcc_go_out;
wire _guard416 = _guard414 & _guard415;
wire _guard417 = fsm0_out == 5'd14;
wire _guard418 = incr_repeat_done_out;
wire _guard419 = cond_reg_out;
wire _guard420 = ~_guard419;
wire _guard421 = _guard418 & _guard420;
wire _guard422 = _guard417 & _guard421;
wire _guard423 = tdcc_go_out;
wire _guard424 = _guard422 & _guard423;
wire _guard425 = _guard416 | _guard424;
wire _guard426 = fsm0_out == 5'd17;
wire _guard427 = invoke24_done_out;
wire _guard428 = _guard426 & _guard427;
wire _guard429 = tdcc_go_out;
wire _guard430 = _guard428 & _guard429;
wire _guard431 = fsm0_out == 5'd15;
wire _guard432 = invoke23_done_out;
wire _guard433 = _guard431 & _guard432;
wire _guard434 = tdcc_go_out;
wire _guard435 = _guard433 & _guard434;
wire _guard436 = fsm0_out == 5'd21;
wire _guard437 = fsm0_out == 5'd2;
wire _guard438 = invoke2_done_out;
wire _guard439 = _guard437 & _guard438;
wire _guard440 = tdcc_go_out;
wire _guard441 = _guard439 & _guard440;
wire _guard442 = fsm0_out == 5'd12;
wire _guard443 = bb0_21_done_out;
wire _guard444 = _guard442 & _guard443;
wire _guard445 = tdcc_go_out;
wire _guard446 = _guard444 & _guard445;
wire _guard447 = fsm0_out == 5'd13;
wire _guard448 = invoke22_done_out;
wire _guard449 = _guard447 & _guard448;
wire _guard450 = tdcc_go_out;
wire _guard451 = _guard449 & _guard450;
wire _guard452 = fsm0_out == 5'd4;
wire _guard453 = invoke3_done_out;
wire _guard454 = _guard452 & _guard453;
wire _guard455 = tdcc_go_out;
wire _guard456 = _guard454 & _guard455;
wire _guard457 = fsm0_out == 5'd11;
wire _guard458 = wrapper_early_reset_static_seq1_done_out;
wire _guard459 = _guard457 & _guard458;
wire _guard460 = tdcc_go_out;
wire _guard461 = _guard459 & _guard460;
wire _guard462 = fsm0_out == 5'd1;
wire _guard463 = init_repeat1_done_out;
wire _guard464 = cond_reg1_out;
wire _guard465 = _guard463 & _guard464;
wire _guard466 = _guard462 & _guard465;
wire _guard467 = tdcc_go_out;
wire _guard468 = _guard466 & _guard467;
wire _guard469 = fsm0_out == 5'd18;
wire _guard470 = incr_repeat1_done_out;
wire _guard471 = cond_reg1_out;
wire _guard472 = _guard470 & _guard471;
wire _guard473 = _guard469 & _guard472;
wire _guard474 = tdcc_go_out;
wire _guard475 = _guard473 & _guard474;
wire _guard476 = _guard468 | _guard475;
wire _guard477 = fsm0_out == 5'd7;
wire _guard478 = bb0_6_done_out;
wire _guard479 = _guard477 & _guard478;
wire _guard480 = tdcc_go_out;
wire _guard481 = _guard479 & _guard480;
wire _guard482 = fsm0_out == 5'd9;
wire _guard483 = bb0_13_done_out;
wire _guard484 = _guard482 & _guard483;
wire _guard485 = tdcc_go_out;
wire _guard486 = _guard484 & _guard485;
wire _guard487 = fsm0_out == 5'd6;
wire _guard488 = wrapper_early_reset_static_seq_done_out;
wire _guard489 = _guard487 & _guard488;
wire _guard490 = tdcc_go_out;
wire _guard491 = _guard489 & _guard490;
wire _guard492 = fsm0_out == 5'd10;
wire _guard493 = bb0_14_done_out;
wire _guard494 = _guard492 & _guard493;
wire _guard495 = tdcc_go_out;
wire _guard496 = _guard494 & _guard495;
wire _guard497 = fsm0_out == 5'd20;
wire _guard498 = invoke26_done_out;
wire _guard499 = _guard497 & _guard498;
wire _guard500 = tdcc_go_out;
wire _guard501 = _guard499 & _guard500;
wire _guard502 = fsm0_out == 5'd1;
wire _guard503 = init_repeat1_done_out;
wire _guard504 = cond_reg1_out;
wire _guard505 = ~_guard504;
wire _guard506 = _guard503 & _guard505;
wire _guard507 = _guard502 & _guard506;
wire _guard508 = tdcc_go_out;
wire _guard509 = _guard507 & _guard508;
wire _guard510 = fsm0_out == 5'd18;
wire _guard511 = incr_repeat1_done_out;
wire _guard512 = cond_reg1_out;
wire _guard513 = ~_guard512;
wire _guard514 = _guard511 & _guard513;
wire _guard515 = _guard510 & _guard514;
wire _guard516 = tdcc_go_out;
wire _guard517 = _guard515 & _guard516;
wire _guard518 = _guard509 | _guard517;
wire _guard519 = fsm0_out == 5'd3;
wire _guard520 = init_repeat0_done_out;
wire _guard521 = cond_reg0_out;
wire _guard522 = _guard520 & _guard521;
wire _guard523 = _guard519 & _guard522;
wire _guard524 = tdcc_go_out;
wire _guard525 = _guard523 & _guard524;
wire _guard526 = fsm0_out == 5'd16;
wire _guard527 = incr_repeat0_done_out;
wire _guard528 = cond_reg0_out;
wire _guard529 = _guard527 & _guard528;
wire _guard530 = _guard526 & _guard529;
wire _guard531 = tdcc_go_out;
wire _guard532 = _guard530 & _guard531;
wire _guard533 = _guard525 | _guard532;
wire _guard534 = fsm0_out == 5'd5;
wire _guard535 = init_repeat_done_out;
wire _guard536 = cond_reg_out;
wire _guard537 = _guard535 & _guard536;
wire _guard538 = _guard534 & _guard537;
wire _guard539 = tdcc_go_out;
wire _guard540 = _guard538 & _guard539;
wire _guard541 = fsm0_out == 5'd14;
wire _guard542 = incr_repeat_done_out;
wire _guard543 = cond_reg_out;
wire _guard544 = _guard542 & _guard543;
wire _guard545 = _guard541 & _guard544;
wire _guard546 = tdcc_go_out;
wire _guard547 = _guard545 & _guard546;
wire _guard548 = _guard540 | _guard547;
wire _guard549 = fsm0_out == 5'd19;
wire _guard550 = invoke25_done_out;
wire _guard551 = _guard549 & _guard550;
wire _guard552 = tdcc_go_out;
wire _guard553 = _guard551 & _guard552;
wire _guard554 = fsm0_out == 5'd3;
wire _guard555 = init_repeat0_done_out;
wire _guard556 = cond_reg0_out;
wire _guard557 = ~_guard556;
wire _guard558 = _guard555 & _guard557;
wire _guard559 = _guard554 & _guard558;
wire _guard560 = tdcc_go_out;
wire _guard561 = _guard559 & _guard560;
wire _guard562 = fsm0_out == 5'd16;
wire _guard563 = incr_repeat0_done_out;
wire _guard564 = cond_reg0_out;
wire _guard565 = ~_guard564;
wire _guard566 = _guard563 & _guard565;
wire _guard567 = _guard562 & _guard566;
wire _guard568 = tdcc_go_out;
wire _guard569 = _guard567 & _guard568;
wire _guard570 = _guard561 | _guard569;
wire _guard571 = fsm0_out == 5'd8;
wire _guard572 = wrapper_early_reset_static_seq0_done_out;
wire _guard573 = _guard571 & _guard572;
wire _guard574 = tdcc_go_out;
wire _guard575 = _guard573 & _guard574;
wire _guard576 = cond_reg0_done;
wire _guard577 = idx0_done;
wire _guard578 = _guard576 & _guard577;
wire _guard579 = bb0_14_go_out;
wire _guard580 = bb0_14_go_out;
wire _guard581 = std_addFN_0_done;
wire _guard582 = ~_guard581;
wire _guard583 = bb0_14_go_out;
wire _guard584 = _guard582 & _guard583;
wire _guard585 = bb0_14_go_out;
wire _guard586 = invoke26_go_out;
wire _guard587 = invoke26_go_out;
wire _guard588 = invoke26_go_out;
wire _guard589 = invoke26_go_out;
wire _guard590 = init_repeat_go_out;
wire _guard591 = incr_repeat_go_out;
wire _guard592 = _guard590 | _guard591;
wire _guard593 = incr_repeat_go_out;
wire _guard594 = init_repeat_go_out;
wire _guard595 = early_reset_static_seq0_go_out;
wire _guard596 = early_reset_static_seq0_go_out;
wire _guard597 = cond_reg_done;
wire _guard598 = idx_done;
wire _guard599 = _guard597 & _guard598;
wire _guard600 = cond_reg_done;
wire _guard601 = idx_done;
wire _guard602 = _guard600 & _guard601;
wire _guard603 = cond_reg0_done;
wire _guard604 = idx0_done;
wire _guard605 = _guard603 & _guard604;
wire _guard606 = signal_reg_out;
wire _guard607 = bb0_6_go_out;
wire _guard608 = bb0_13_go_out;
wire _guard609 = _guard607 | _guard608;
wire _guard610 = bb0_21_go_out;
wire _guard611 = _guard609 | _guard610;
wire _guard612 = incr_repeat0_go_out;
wire _guard613 = incr_repeat0_go_out;
wire _guard614 = init_repeat0_done_out;
wire _guard615 = ~_guard614;
wire _guard616 = fsm0_out == 5'd3;
wire _guard617 = _guard615 & _guard616;
wire _guard618 = tdcc_go_out;
wire _guard619 = _guard617 & _guard618;
wire _guard620 = incr_repeat0_done_out;
wire _guard621 = ~_guard620;
wire _guard622 = fsm0_out == 5'd16;
wire _guard623 = _guard621 & _guard622;
wire _guard624 = tdcc_go_out;
wire _guard625 = _guard623 & _guard624;
wire _guard626 = wrapper_early_reset_static_seq_go_out;
wire _guard627 = signal_reg_out;
wire _guard628 = _guard0 & _guard0;
wire _guard629 = signal_reg_out;
wire _guard630 = ~_guard629;
wire _guard631 = _guard628 & _guard630;
wire _guard632 = wrapper_early_reset_static_par_thread_go_out;
wire _guard633 = _guard631 & _guard632;
wire _guard634 = _guard627 | _guard633;
wire _guard635 = fsm_out == 4'd11;
wire _guard636 = _guard635 & _guard0;
wire _guard637 = signal_reg_out;
wire _guard638 = ~_guard637;
wire _guard639 = _guard636 & _guard638;
wire _guard640 = wrapper_early_reset_static_seq_go_out;
wire _guard641 = _guard639 & _guard640;
wire _guard642 = _guard634 | _guard641;
wire _guard643 = fsm_out == 4'd11;
wire _guard644 = _guard643 & _guard0;
wire _guard645 = signal_reg_out;
wire _guard646 = ~_guard645;
wire _guard647 = _guard644 & _guard646;
wire _guard648 = wrapper_early_reset_static_seq0_go_out;
wire _guard649 = _guard647 & _guard648;
wire _guard650 = _guard642 | _guard649;
wire _guard651 = fsm_out == 4'd11;
wire _guard652 = _guard651 & _guard0;
wire _guard653 = signal_reg_out;
wire _guard654 = ~_guard653;
wire _guard655 = _guard652 & _guard654;
wire _guard656 = wrapper_early_reset_static_seq1_go_out;
wire _guard657 = _guard655 & _guard656;
wire _guard658 = _guard650 | _guard657;
wire _guard659 = _guard0 & _guard0;
wire _guard660 = signal_reg_out;
wire _guard661 = ~_guard660;
wire _guard662 = _guard659 & _guard661;
wire _guard663 = wrapper_early_reset_static_par_thread_go_out;
wire _guard664 = _guard662 & _guard663;
wire _guard665 = fsm_out == 4'd11;
wire _guard666 = _guard665 & _guard0;
wire _guard667 = signal_reg_out;
wire _guard668 = ~_guard667;
wire _guard669 = _guard666 & _guard668;
wire _guard670 = wrapper_early_reset_static_seq_go_out;
wire _guard671 = _guard669 & _guard670;
wire _guard672 = _guard664 | _guard671;
wire _guard673 = fsm_out == 4'd11;
wire _guard674 = _guard673 & _guard0;
wire _guard675 = signal_reg_out;
wire _guard676 = ~_guard675;
wire _guard677 = _guard674 & _guard676;
wire _guard678 = wrapper_early_reset_static_seq0_go_out;
wire _guard679 = _guard677 & _guard678;
wire _guard680 = _guard672 | _guard679;
wire _guard681 = fsm_out == 4'd11;
wire _guard682 = _guard681 & _guard0;
wire _guard683 = signal_reg_out;
wire _guard684 = ~_guard683;
wire _guard685 = _guard682 & _guard684;
wire _guard686 = wrapper_early_reset_static_seq1_go_out;
wire _guard687 = _guard685 & _guard686;
wire _guard688 = _guard680 | _guard687;
wire _guard689 = signal_reg_out;
wire _guard690 = cond_reg1_done;
wire _guard691 = idx1_done;
wire _guard692 = _guard690 & _guard691;
wire _guard693 = wrapper_early_reset_static_par_thread_go_out;
wire _guard694 = invoke24_go_out;
wire _guard695 = early_reset_static_par_thread_go_out;
wire _guard696 = _guard694 | _guard695;
wire _guard697 = early_reset_static_par_thread_go_out;
wire _guard698 = invoke24_go_out;
wire _guard699 = signal_reg_out;
wire _guard700 = bb0_21_done_out;
wire _guard701 = ~_guard700;
wire _guard702 = fsm0_out == 5'd12;
wire _guard703 = _guard701 & _guard702;
wire _guard704 = tdcc_go_out;
wire _guard705 = _guard703 & _guard704;
wire _guard706 = invoke26_done_out;
wire _guard707 = ~_guard706;
wire _guard708 = fsm0_out == 5'd20;
wire _guard709 = _guard707 & _guard708;
wire _guard710 = tdcc_go_out;
wire _guard711 = _guard709 & _guard710;
wire _guard712 = fsm_out < 4'd3;
wire _guard713 = early_reset_static_seq_go_out;
wire _guard714 = _guard712 & _guard713;
wire _guard715 = fsm_out < 4'd3;
wire _guard716 = early_reset_static_seq0_go_out;
wire _guard717 = _guard715 & _guard716;
wire _guard718 = _guard714 | _guard717;
wire _guard719 = fsm_out < 4'd3;
wire _guard720 = early_reset_static_seq1_go_out;
wire _guard721 = _guard719 & _guard720;
wire _guard722 = _guard718 | _guard721;
wire _guard723 = fsm_out >= 4'd4;
wire _guard724 = fsm_out < 4'd7;
wire _guard725 = _guard723 & _guard724;
wire _guard726 = fsm_out >= 4'd8;
wire _guard727 = fsm_out < 4'd11;
wire _guard728 = _guard726 & _guard727;
wire _guard729 = _guard725 | _guard728;
wire _guard730 = early_reset_static_seq_go_out;
wire _guard731 = _guard729 & _guard730;
wire _guard732 = fsm_out >= 4'd4;
wire _guard733 = fsm_out < 4'd7;
wire _guard734 = _guard732 & _guard733;
wire _guard735 = fsm_out >= 4'd8;
wire _guard736 = fsm_out < 4'd11;
wire _guard737 = _guard735 & _guard736;
wire _guard738 = _guard734 | _guard737;
wire _guard739 = early_reset_static_seq0_go_out;
wire _guard740 = _guard738 & _guard739;
wire _guard741 = _guard731 | _guard740;
wire _guard742 = fsm_out >= 4'd4;
wire _guard743 = fsm_out < 4'd7;
wire _guard744 = _guard742 & _guard743;
wire _guard745 = fsm_out >= 4'd8;
wire _guard746 = fsm_out < 4'd11;
wire _guard747 = _guard745 & _guard746;
wire _guard748 = _guard744 | _guard747;
wire _guard749 = early_reset_static_seq1_go_out;
wire _guard750 = _guard748 & _guard749;
wire _guard751 = _guard741 | _guard750;
wire _guard752 = fsm_out < 4'd3;
wire _guard753 = fsm_out >= 4'd4;
wire _guard754 = fsm_out < 4'd7;
wire _guard755 = _guard753 & _guard754;
wire _guard756 = _guard752 | _guard755;
wire _guard757 = fsm_out >= 4'd8;
wire _guard758 = fsm_out < 4'd11;
wire _guard759 = _guard757 & _guard758;
wire _guard760 = _guard756 | _guard759;
wire _guard761 = early_reset_static_seq_go_out;
wire _guard762 = _guard760 & _guard761;
wire _guard763 = fsm_out < 4'd3;
wire _guard764 = fsm_out >= 4'd4;
wire _guard765 = fsm_out < 4'd7;
wire _guard766 = _guard764 & _guard765;
wire _guard767 = _guard763 | _guard766;
wire _guard768 = fsm_out >= 4'd8;
wire _guard769 = fsm_out < 4'd11;
wire _guard770 = _guard768 & _guard769;
wire _guard771 = _guard767 | _guard770;
wire _guard772 = early_reset_static_seq0_go_out;
wire _guard773 = _guard771 & _guard772;
wire _guard774 = _guard762 | _guard773;
wire _guard775 = fsm_out < 4'd3;
wire _guard776 = fsm_out >= 4'd4;
wire _guard777 = fsm_out < 4'd7;
wire _guard778 = _guard776 & _guard777;
wire _guard779 = _guard775 | _guard778;
wire _guard780 = fsm_out >= 4'd8;
wire _guard781 = fsm_out < 4'd11;
wire _guard782 = _guard780 & _guard781;
wire _guard783 = _guard779 | _guard782;
wire _guard784 = early_reset_static_seq1_go_out;
wire _guard785 = _guard783 & _guard784;
wire _guard786 = _guard774 | _guard785;
wire _guard787 = fsm_out < 4'd3;
wire _guard788 = early_reset_static_seq_go_out;
wire _guard789 = _guard787 & _guard788;
wire _guard790 = fsm_out < 4'd3;
wire _guard791 = early_reset_static_seq0_go_out;
wire _guard792 = _guard790 & _guard791;
wire _guard793 = _guard789 | _guard792;
wire _guard794 = fsm_out < 4'd3;
wire _guard795 = early_reset_static_seq1_go_out;
wire _guard796 = _guard794 & _guard795;
wire _guard797 = _guard793 | _guard796;
wire _guard798 = fsm_out >= 4'd8;
wire _guard799 = fsm_out < 4'd11;
wire _guard800 = _guard798 & _guard799;
wire _guard801 = early_reset_static_seq_go_out;
wire _guard802 = _guard800 & _guard801;
wire _guard803 = fsm_out >= 4'd8;
wire _guard804 = fsm_out < 4'd11;
wire _guard805 = _guard803 & _guard804;
wire _guard806 = early_reset_static_seq0_go_out;
wire _guard807 = _guard805 & _guard806;
wire _guard808 = _guard802 | _guard807;
wire _guard809 = fsm_out >= 4'd8;
wire _guard810 = fsm_out < 4'd11;
wire _guard811 = _guard809 & _guard810;
wire _guard812 = early_reset_static_seq1_go_out;
wire _guard813 = _guard811 & _guard812;
wire _guard814 = _guard808 | _guard813;
wire _guard815 = fsm_out >= 4'd4;
wire _guard816 = fsm_out < 4'd7;
wire _guard817 = _guard815 & _guard816;
wire _guard818 = early_reset_static_seq_go_out;
wire _guard819 = _guard817 & _guard818;
wire _guard820 = fsm_out >= 4'd4;
wire _guard821 = fsm_out < 4'd7;
wire _guard822 = _guard820 & _guard821;
wire _guard823 = early_reset_static_seq0_go_out;
wire _guard824 = _guard822 & _guard823;
wire _guard825 = _guard819 | _guard824;
wire _guard826 = fsm_out >= 4'd4;
wire _guard827 = fsm_out < 4'd7;
wire _guard828 = _guard826 & _guard827;
wire _guard829 = early_reset_static_seq1_go_out;
wire _guard830 = _guard828 & _guard829;
wire _guard831 = _guard825 | _guard830;
wire _guard832 = fsm0_out == 5'd21;
wire _guard833 = wrapper_early_reset_static_seq1_done_out;
wire _guard834 = ~_guard833;
wire _guard835 = fsm0_out == 5'd11;
wire _guard836 = _guard834 & _guard835;
wire _guard837 = tdcc_go_out;
wire _guard838 = _guard836 & _guard837;
wire _guard839 = invoke2_go_out;
wire _guard840 = invoke23_go_out;
wire _guard841 = _guard839 | _guard840;
wire _guard842 = invoke2_go_out;
wire _guard843 = invoke23_go_out;
wire _guard844 = incr_repeat_go_out;
wire _guard845 = incr_repeat_go_out;
wire _guard846 = invoke3_done_out;
wire _guard847 = ~_guard846;
wire _guard848 = fsm0_out == 5'd4;
wire _guard849 = _guard847 & _guard848;
wire _guard850 = tdcc_go_out;
wire _guard851 = _guard849 & _guard850;
wire _guard852 = invoke25_go_out;
wire _guard853 = early_reset_static_par_thread_go_out;
wire _guard854 = _guard852 | _guard853;
wire _guard855 = early_reset_static_par_thread_go_out;
wire _guard856 = invoke25_go_out;
wire _guard857 = wrapper_early_reset_static_seq_done_out;
wire _guard858 = ~_guard857;
wire _guard859 = fsm0_out == 5'd6;
wire _guard860 = _guard858 & _guard859;
wire _guard861 = tdcc_go_out;
wire _guard862 = _guard860 & _guard861;
wire _guard863 = signal_reg_out;
wire _guard864 = invoke24_done_out;
wire _guard865 = ~_guard864;
wire _guard866 = fsm0_out == 5'd17;
wire _guard867 = _guard865 & _guard866;
wire _guard868 = tdcc_go_out;
wire _guard869 = _guard867 & _guard868;
wire _guard870 = bb0_6_go_out;
wire _guard871 = bb0_13_go_out;
wire _guard872 = _guard870 | _guard871;
wire _guard873 = bb0_21_go_out;
wire _guard874 = _guard872 | _guard873;
wire _guard875 = fsm_out >= 4'd4;
wire _guard876 = fsm_out < 4'd7;
wire _guard877 = _guard875 & _guard876;
wire _guard878 = fsm_out >= 4'd8;
wire _guard879 = fsm_out < 4'd11;
wire _guard880 = _guard878 & _guard879;
wire _guard881 = _guard877 | _guard880;
wire _guard882 = early_reset_static_seq_go_out;
wire _guard883 = _guard881 & _guard882;
wire _guard884 = _guard874 | _guard883;
wire _guard885 = fsm_out >= 4'd4;
wire _guard886 = fsm_out < 4'd7;
wire _guard887 = _guard885 & _guard886;
wire _guard888 = fsm_out >= 4'd8;
wire _guard889 = fsm_out < 4'd11;
wire _guard890 = _guard888 & _guard889;
wire _guard891 = _guard887 | _guard890;
wire _guard892 = early_reset_static_seq0_go_out;
wire _guard893 = _guard891 & _guard892;
wire _guard894 = _guard884 | _guard893;
wire _guard895 = fsm_out >= 4'd4;
wire _guard896 = fsm_out < 4'd7;
wire _guard897 = _guard895 & _guard896;
wire _guard898 = fsm_out >= 4'd8;
wire _guard899 = fsm_out < 4'd11;
wire _guard900 = _guard898 & _guard899;
wire _guard901 = _guard897 | _guard900;
wire _guard902 = early_reset_static_seq1_go_out;
wire _guard903 = _guard901 & _guard902;
wire _guard904 = _guard894 | _guard903;
wire _guard905 = invoke22_go_out;
wire _guard906 = invoke24_go_out;
wire _guard907 = invoke23_go_out;
wire _guard908 = invoke25_go_out;
wire _guard909 = bb0_6_go_out;
wire _guard910 = bb0_13_go_out;
wire _guard911 = _guard909 | _guard910;
wire _guard912 = bb0_21_go_out;
wire _guard913 = _guard911 | _guard912;
wire _guard914 = invoke22_go_out;
wire _guard915 = invoke23_go_out;
wire _guard916 = _guard914 | _guard915;
wire _guard917 = invoke24_go_out;
wire _guard918 = _guard916 | _guard917;
wire _guard919 = invoke25_go_out;
wire _guard920 = _guard918 | _guard919;
wire _guard921 = fsm_out >= 4'd4;
wire _guard922 = fsm_out < 4'd7;
wire _guard923 = _guard921 & _guard922;
wire _guard924 = early_reset_static_seq_go_out;
wire _guard925 = _guard923 & _guard924;
wire _guard926 = fsm_out >= 4'd4;
wire _guard927 = fsm_out < 4'd7;
wire _guard928 = _guard926 & _guard927;
wire _guard929 = early_reset_static_seq0_go_out;
wire _guard930 = _guard928 & _guard929;
wire _guard931 = _guard925 | _guard930;
wire _guard932 = fsm_out >= 4'd4;
wire _guard933 = fsm_out < 4'd7;
wire _guard934 = _guard932 & _guard933;
wire _guard935 = early_reset_static_seq1_go_out;
wire _guard936 = _guard934 & _guard935;
wire _guard937 = _guard931 | _guard936;
wire _guard938 = fsm_out >= 4'd8;
wire _guard939 = fsm_out < 4'd11;
wire _guard940 = _guard938 & _guard939;
wire _guard941 = early_reset_static_seq_go_out;
wire _guard942 = _guard940 & _guard941;
wire _guard943 = fsm_out >= 4'd8;
wire _guard944 = fsm_out < 4'd11;
wire _guard945 = _guard943 & _guard944;
wire _guard946 = early_reset_static_seq0_go_out;
wire _guard947 = _guard945 & _guard946;
wire _guard948 = _guard942 | _guard947;
wire _guard949 = fsm_out >= 4'd8;
wire _guard950 = fsm_out < 4'd11;
wire _guard951 = _guard949 & _guard950;
wire _guard952 = early_reset_static_seq1_go_out;
wire _guard953 = _guard951 & _guard952;
wire _guard954 = _guard948 | _guard953;
wire _guard955 = init_repeat_go_out;
wire _guard956 = incr_repeat_go_out;
wire _guard957 = _guard955 | _guard956;
wire _guard958 = init_repeat_go_out;
wire _guard959 = incr_repeat_go_out;
wire _guard960 = incr_repeat0_go_out;
wire _guard961 = incr_repeat0_go_out;
wire _guard962 = bb0_13_done_out;
wire _guard963 = ~_guard962;
wire _guard964 = fsm0_out == 5'd9;
wire _guard965 = _guard963 & _guard964;
wire _guard966 = tdcc_go_out;
wire _guard967 = _guard965 & _guard966;
wire _guard968 = invoke22_done_out;
wire _guard969 = ~_guard968;
wire _guard970 = fsm0_out == 5'd13;
wire _guard971 = _guard969 & _guard970;
wire _guard972 = tdcc_go_out;
wire _guard973 = _guard971 & _guard972;
wire _guard974 = invoke25_done_out;
wire _guard975 = ~_guard974;
wire _guard976 = fsm0_out == 5'd19;
wire _guard977 = _guard975 & _guard976;
wire _guard978 = tdcc_go_out;
wire _guard979 = _guard977 & _guard978;
assign cond_reg1_write_en = _guard3;
assign cond_reg1_clk = clk;
assign cond_reg1_reset = reset;
assign cond_reg1_in =
  _guard4 ? 1'd1 :
  _guard5 ? lt1_out :
  1'd0;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard5, _guard4})) begin
    $fatal(2, "Multiple assignment to port `cond_reg1.in'.");
end
end
assign adder1_left =
  _guard6 ? idx1_out :
  2'd0;
assign adder1_right =
  _guard7 ? 2'd1 :
  2'd0;
assign bb0_6_go_in = _guard13;
assign init_repeat_go_in = _guard19;
assign muli_8_reg_write_en = _guard42;
assign muli_8_reg_clk = clk;
assign muli_8_reg_reset = reset;
assign muli_8_reg_in = std_mult_pipe_8_out;
assign done = _guard66;
assign arg_mem_0_content_en = _guard67;
assign arg_mem_3_addr0 =
  _guard68 ? relu4d_0_instance_arg_mem_0_addr0 :
  _guard69 ? std_slice_2_out :
  'x;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard69, _guard68})) begin
    $fatal(2, "Multiple assignment to port `_this.arg_mem_3_addr0'.");
end
end
assign arg_mem_3_write_data = addf_0_reg_out;
assign arg_mem_0_addr0 = std_slice_2_out;
assign arg_mem_3_content_en =
  _guard72 ? 1'd1 :
  _guard73 ? relu4d_0_instance_arg_mem_0_content_en :
  1'd0;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard73, _guard72})) begin
    $fatal(2, "Multiple assignment to port `_this.arg_mem_3_content_en'.");
end
end
assign arg_mem_0_write_en =
  _guard74 ? 1'd0 :
  1'd0;
assign arg_mem_3_write_en =
  _guard75 ? 1'd1 :
  _guard76 ? relu4d_0_instance_arg_mem_0_write_en :
  1'd0;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard76, _guard75})) begin
    $fatal(2, "Multiple assignment to port `_this.arg_mem_3_write_en'.");
end
end
assign arg_mem_2_addr0 = relu4d_0_instance_arg_mem_1_addr0;
assign arg_mem_2_content_en =
  _guard78 ? relu4d_0_instance_arg_mem_1_content_en :
  1'd0;
assign arg_mem_1_write_en =
  _guard79 ? 1'd0 :
  1'd0;
assign arg_mem_2_write_en =
  _guard80 ? relu4d_0_instance_arg_mem_1_write_en :
  1'd0;
assign arg_mem_1_addr0 = std_slice_2_out;
assign arg_mem_1_content_en = _guard82;
assign arg_mem_2_write_data = relu4d_0_instance_arg_mem_1_write_data;
assign adder_left =
  _guard84 ? idx_out :
  4'd0;
assign adder_right =
  _guard85 ? 4'd1 :
  4'd0;
assign fsm_write_en = _guard108;
assign fsm_clk = clk;
assign fsm_reset = reset;
assign fsm_in =
  _guard111 ? adder4_out :
  _guard122 ? 4'd0 :
  _guard125 ? adder2_out :
  _guard128 ? adder3_out :
  4'd0;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard128, _guard125, _guard122, _guard111})) begin
    $fatal(2, "Multiple assignment to port `fsm.in'.");
end
end
assign incr_repeat1_go_in = _guard134;
assign bb0_14_go_in = _guard140;
assign idx1_write_en = _guard143;
assign idx1_clk = clk;
assign idx1_reset = reset;
assign idx1_in =
  _guard144 ? adder1_out :
  _guard145 ? 2'd0 :
  2'd0;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard145, _guard144})) begin
    $fatal(2, "Multiple assignment to port `idx1.in'.");
end
end
assign lt1_left =
  _guard146 ? adder1_out :
  2'd0;
assign lt1_right =
  _guard147 ? 2'd3 :
  2'd0;
assign adder4_left =
  _guard148 ? fsm_out :
  4'd0;
assign adder4_right =
  _guard149 ? 4'd1 :
  4'd0;
assign invoke2_go_in = _guard155;
assign wrapper_early_reset_static_par_thread_go_in = _guard161;
assign cond_reg0_write_en = _guard164;
assign cond_reg0_clk = clk;
assign cond_reg0_reset = reset;
assign cond_reg0_in =
  _guard165 ? 1'd1 :
  _guard166 ? lt0_out :
  1'd0;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard166, _guard165})) begin
    $fatal(2, "Multiple assignment to port `cond_reg0.in'.");
end
end
assign for_0_induction_var_reg_write_en = _guard169;
assign for_0_induction_var_reg_clk = clk;
assign for_0_induction_var_reg_reset = reset;
assign for_0_induction_var_reg_in =
  _guard170 ? 32'd0 :
  _guard171 ? std_add_12_out :
  'x;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard171, _guard170})) begin
    $fatal(2, "Multiple assignment to port `for_0_induction_var_reg.in'.");
end
end
assign init_repeat1_go_in = _guard177;
assign early_reset_static_seq0_go_in = _guard178;
assign invoke26_done_in = relu4d_0_instance_done;
assign wrapper_early_reset_static_seq1_done_in = _guard179;
assign idx0_write_en = _guard182;
assign idx0_clk = clk;
assign idx0_reset = reset;
assign idx0_in =
  _guard183 ? 4'd0 :
  _guard184 ? adder0_out :
  4'd0;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard184, _guard183})) begin
    $fatal(2, "Multiple assignment to port `idx0.in'.");
end
end
assign wrapper_early_reset_static_seq0_go_in = _guard190;
assign bb0_13_done_in = arg_mem_1_done;
assign bb0_14_done_in = addf_0_reg_done;
assign invoke23_go_in = _guard196;
assign early_reset_static_seq1_done_in = ud2_out;
assign incr_repeat_go_in = _guard202;
assign init_repeat1_done_in = _guard205;
assign tdcc_go_in = go;
assign invoke23_done_in = for_1_induction_var_reg_done;
assign early_reset_static_seq1_go_in = _guard206;
assign addf_0_reg_write_en =
  _guard207 ? std_addFN_0_done :
  1'd0;
assign addf_0_reg_clk = clk;
assign addf_0_reg_reset = reset;
assign addf_0_reg_in = std_addFN_0_out;
assign adder2_left =
  _guard209 ? fsm_out :
  4'd0;
assign adder2_right =
  _guard210 ? 4'd1 :
  4'd0;
assign fsm0_write_en = _guard403;
assign fsm0_clk = clk;
assign fsm0_reset = reset;
assign fsm0_in =
  _guard408 ? 5'd1 :
  _guard425 ? 5'd15 :
  _guard430 ? 5'd18 :
  _guard435 ? 5'd16 :
  _guard436 ? 5'd0 :
  _guard441 ? 5'd3 :
  _guard446 ? 5'd13 :
  _guard451 ? 5'd14 :
  _guard456 ? 5'd5 :
  _guard461 ? 5'd12 :
  _guard476 ? 5'd2 :
  _guard481 ? 5'd8 :
  _guard486 ? 5'd10 :
  _guard491 ? 5'd7 :
  _guard496 ? 5'd11 :
  _guard501 ? 5'd21 :
  _guard518 ? 5'd19 :
  _guard533 ? 5'd4 :
  _guard548 ? 5'd6 :
  _guard553 ? 5'd20 :
  _guard570 ? 5'd17 :
  _guard575 ? 5'd9 :
  5'd0;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard575, _guard570, _guard553, _guard548, _guard533, _guard518, _guard501, _guard496, _guard491, _guard486, _guard481, _guard476, _guard461, _guard456, _guard451, _guard446, _guard441, _guard436, _guard435, _guard430, _guard425, _guard408})) begin
    $fatal(2, "Multiple assignment to port `fsm0.in'.");
end
end
assign invoke3_done_in = for_0_induction_var_reg_done;
assign incr_repeat0_done_in = _guard578;
assign std_addFN_0_roundingMode = 3'd0;
assign std_addFN_0_control = 1'd0;
assign std_addFN_0_clk = clk;
assign std_addFN_0_left =
  _guard579 ? arg_mem_0_read_data :
  32'd0;
assign std_addFN_0_subOp =
  _guard580 ? 1'd0 :
  1'd0;
assign std_addFN_0_reset = reset;
assign std_addFN_0_go = _guard584;
assign std_addFN_0_right =
  _guard585 ? arg_mem_1_read_data :
  32'd0;
assign relu4d_0_instance_arg_mem_0_read_data =
  _guard586 ? arg_mem_3_read_data :
  32'd0;
assign relu4d_0_instance_arg_mem_0_done =
  _guard587 ? arg_mem_3_done :
  1'd0;
assign relu4d_0_instance_clk = clk;
assign relu4d_0_instance_reset = reset;
assign relu4d_0_instance_go = _guard588;
assign relu4d_0_instance_arg_mem_1_done =
  _guard589 ? arg_mem_2_done :
  1'd0;
assign idx_write_en = _guard592;
assign idx_clk = clk;
assign idx_reset = reset;
assign idx_in =
  _guard593 ? adder_out :
  _guard594 ? 4'd0 :
  4'd0;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard594, _guard593})) begin
    $fatal(2, "Multiple assignment to port `idx.in'.");
end
end
assign adder3_left =
  _guard595 ? fsm_out :
  4'd0;
assign adder3_right =
  _guard596 ? 4'd1 :
  4'd0;
assign init_repeat_done_in = _guard599;
assign incr_repeat_done_in = _guard602;
assign init_repeat0_done_in = _guard605;
assign wrapper_early_reset_static_seq_done_in = _guard606;
assign std_slice_2_in = std_add_12_out;
assign adder0_left =
  _guard612 ? idx0_out :
  4'd0;
assign adder0_right =
  _guard613 ? 4'd1 :
  4'd0;
assign init_repeat0_go_in = _guard619;
assign incr_repeat0_go_in = _guard625;
assign early_reset_static_seq_go_in = _guard626;
assign signal_reg_write_en = _guard658;
assign signal_reg_clk = clk;
assign signal_reg_reset = reset;
assign signal_reg_in =
  _guard688 ? 1'd1 :
  _guard689 ? 1'd0 :
  1'd0;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard689, _guard688})) begin
    $fatal(2, "Multiple assignment to port `signal_reg.in'.");
end
end
assign bb0_6_done_in = arg_mem_0_done;
assign invoke2_done_in = for_1_induction_var_reg_done;
assign incr_repeat1_done_in = _guard692;
assign early_reset_static_par_thread_go_in = _guard693;
assign invoke24_done_in = for_2_induction_var_reg_done;
assign for_2_induction_var_reg_write_en = _guard696;
assign for_2_induction_var_reg_clk = clk;
assign for_2_induction_var_reg_reset = reset;
assign for_2_induction_var_reg_in =
  _guard697 ? 32'd0 :
  _guard698 ? std_add_12_out :
  'x;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard698, _guard697})) begin
    $fatal(2, "Multiple assignment to port `for_2_induction_var_reg.in'.");
end
end
assign wrapper_early_reset_static_par_thread_done_in = _guard699;
assign bb0_21_go_in = _guard705;
assign invoke22_done_in = for_0_induction_var_reg_done;
assign invoke26_go_in = _guard711;
assign std_mult_pipe_8_clk = clk;
assign std_mult_pipe_8_left =
  _guard722 ? for_3_induction_var_reg_out :
  _guard751 ? std_add_12_out :
  'x;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard751, _guard722})) begin
    $fatal(2, "Multiple assignment to port `std_mult_pipe_8.left'.");
end
end
assign std_mult_pipe_8_reset = reset;
assign std_mult_pipe_8_go = _guard786;
assign std_mult_pipe_8_right =
  _guard797 ? 32'd300 :
  _guard814 ? 32'd10 :
  _guard831 ? 32'd100 :
  'x;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard831, _guard814, _guard797})) begin
    $fatal(2, "Multiple assignment to port `std_mult_pipe_8.right'.");
end
end
assign early_reset_static_seq_done_in = ud0_out;
assign tdcc_done_in = _guard832;
assign wrapper_early_reset_static_seq1_go_in = _guard838;
assign for_1_induction_var_reg_write_en = _guard841;
assign for_1_induction_var_reg_clk = clk;
assign for_1_induction_var_reg_reset = reset;
assign for_1_induction_var_reg_in =
  _guard842 ? 32'd0 :
  _guard843 ? std_add_12_out :
  'x;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard843, _guard842})) begin
    $fatal(2, "Multiple assignment to port `for_1_induction_var_reg.in'.");
end
end
assign lt_left =
  _guard844 ? adder_out :
  4'd0;
assign lt_right =
  _guard845 ? 4'd10 :
  4'd0;
assign invoke3_go_in = _guard851;
assign bb0_21_done_in = arg_mem_3_done;
assign for_3_induction_var_reg_write_en = _guard854;
assign for_3_induction_var_reg_clk = clk;
assign for_3_induction_var_reg_reset = reset;
assign for_3_induction_var_reg_in =
  _guard855 ? 32'd0 :
  _guard856 ? std_add_12_out :
  'x;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard856, _guard855})) begin
    $fatal(2, "Multiple assignment to port `for_3_induction_var_reg.in'.");
end
end
assign early_reset_static_par_thread_done_in = ud_out;
assign early_reset_static_seq0_done_in = ud1_out;
assign wrapper_early_reset_static_seq_go_in = _guard862;
assign wrapper_early_reset_static_seq0_done_in = _guard863;
assign invoke24_go_in = _guard869;
assign std_add_12_left =
  _guard904 ? muli_8_reg_out :
  _guard905 ? for_0_induction_var_reg_out :
  _guard906 ? for_2_induction_var_reg_out :
  _guard907 ? for_1_induction_var_reg_out :
  _guard908 ? for_3_induction_var_reg_out :
  'x;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard908, _guard907, _guard906, _guard905, _guard904})) begin
    $fatal(2, "Multiple assignment to port `std_add_12.left'.");
end
end
assign std_add_12_right =
  _guard913 ? for_0_induction_var_reg_out :
  _guard920 ? 32'd1 :
  _guard937 ? for_2_induction_var_reg_out :
  _guard954 ? for_1_induction_var_reg_out :
  'x;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard954, _guard937, _guard920, _guard913})) begin
    $fatal(2, "Multiple assignment to port `std_add_12.right'.");
end
end
assign cond_reg_write_en = _guard957;
assign cond_reg_clk = clk;
assign cond_reg_reset = reset;
assign cond_reg_in =
  _guard958 ? 1'd1 :
  _guard959 ? lt_out :
  1'd0;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard959, _guard958})) begin
    $fatal(2, "Multiple assignment to port `cond_reg.in'.");
end
end
assign lt0_left =
  _guard960 ? adder0_out :
  4'd0;
assign lt0_right =
  _guard961 ? 4'd10 :
  4'd0;
assign bb0_13_go_in = _guard967;
assign invoke22_go_in = _guard973;
assign invoke25_go_in = _guard979;
assign invoke25_done_in = for_3_induction_var_reg_done;
// COMPONENT END: forward
endmodule

/*============================================================================

This Verilog source file is part of the Berkeley HardFloat IEEE Floating-Point
Arithmetic Package, Release 1, by John R. Hauser.

Copyright 2019 The Regents of the University of California.  All rights
reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

 1. Redistributions of source code must retain the above copyright notice,
    this list of conditions, and the following disclaimer.

 2. Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions, and the following disclaimer in the documentation
    and/or other materials provided with the distribution.

 3. Neither the name of the University nor the names of its contributors may
    be used to endorse or promote products derived from this software without
    specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS "AS IS", AND ANY
EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, ARE
DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

=============================================================================*/


/*============================================================================

This Verilog include file is part of the Berkeley HardFloat IEEE Floating-
Point Arithmetic Package, Release 1, by John R. Hauser.

Copyright 2019 The Regents of the University of California.  All rights
reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

 1. Redistributions of source code must retain the above copyright notice,
    this list of conditions, and the following disclaimer.

 2. Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions, and the following disclaimer in the documentation
    and/or other materials provided with the distribution.

 3. Neither the name of the University nor the names of its contributors may
    be used to endorse or promote products derived from this software without
    specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS "AS IS", AND ANY
EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, ARE
DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

=============================================================================*/

/*----------------------------------------------------------------------------
*----------------------------------------------------------------------------*/
`define round_near_even   3'b000
`define round_minMag      3'b001
`define round_min         3'b010
`define round_max         3'b011
`define round_near_maxMag 3'b100
`define round_odd         3'b110

/*----------------------------------------------------------------------------
*----------------------------------------------------------------------------*/
`define floatControlWidth 1
`define flControl_tininessBeforeRounding 1'b0
`define flControl_tininessAfterRounding  1'b1

/*----------------------------------------------------------------------------
*----------------------------------------------------------------------------*/
`define flRoundOpt_sigMSBitAlwaysZero  1
`define flRoundOpt_subnormsAlwaysExact 2
`define flRoundOpt_neverUnderflows     4
`define flRoundOpt_neverOverflows      8



/*============================================================================

This Verilog include file is part of the Berkeley HardFloat IEEE Floating-
Point Arithmetic Package, Release 1, by John R. Hauser.

Copyright 2019 The Regents of the University of California.  All rights
reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

 1. Redistributions of source code must retain the above copyright notice,
    this list of conditions, and the following disclaimer.

 2. Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions, and the following disclaimer in the documentation
    and/or other materials provided with the distribution.

 3. Neither the name of the University nor the names of its contributors may
    be used to endorse or promote products derived from this software without
    specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS "AS IS", AND ANY
EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, ARE
DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

=============================================================================*/

/*----------------------------------------------------------------------------
*----------------------------------------------------------------------------*/
`define flControl_default `flControl_tininessAfterRounding

/*----------------------------------------------------------------------------
*----------------------------------------------------------------------------*/
//`define HardFloat_propagateNaNPayloads

/*----------------------------------------------------------------------------
*----------------------------------------------------------------------------*/
`define HardFloat_signDefaultNaN 0
`define HardFloat_fractDefaultNaN(sigWidth) {1'b1, {((sigWidth) - 2){1'b0}}}



/*----------------------------------------------------------------------------
*----------------------------------------------------------------------------*/

module
    recFNToRawFN#(parameter expWidth = 3, parameter sigWidth = 3) (
        input [(expWidth + sigWidth):0] in,
        output isNaN,
        output isInf,
        output isZero,
        output sign,
        output signed [(expWidth + 1):0] sExp,
        output [sigWidth:0] sig
    );

    /*------------------------------------------------------------------------
    *------------------------------------------------------------------------*/
    wire [expWidth:0] exp;
    wire [(sigWidth - 2):0] fract;
    assign {sign, exp, fract} = in;
    wire isSpecial = (exp>>(expWidth - 1) == 'b11);
    /*------------------------------------------------------------------------
    *------------------------------------------------------------------------*/
    assign isNaN = isSpecial &&  exp[expWidth - 2];
    assign isInf = isSpecial && !exp[expWidth - 2];
    assign isZero = (exp>>(expWidth - 2) == 'b000);
    assign sExp = exp;
    assign sig = {1'b0, !isZero, fract};

endmodule

/*----------------------------------------------------------------------------
*----------------------------------------------------------------------------*/

module
    roundAnyRawFNToRecFN#(
        parameter inExpWidth = 3,
        parameter inSigWidth = 3,
        parameter outExpWidth = 3,
        parameter outSigWidth = 3,
        parameter options = 0
    ) (
        input [(1 - 1):0] control,
        input invalidExc,     // overrides 'infiniteExc' and 'in_*' inputs
        input infiniteExc,    // overrides 'in_*' inputs except 'in_sign'
        input in_isNaN,
        input in_isInf,
        input in_isZero,
        input in_sign,
        input signed [(inExpWidth + 1):0] in_sExp,   // limited range allowed
        input [inSigWidth:0] in_sig,
        input [2:0] roundingMode,
        output [(outExpWidth + outSigWidth):0] out,
        output [4:0] exceptionFlags
    );

    /*------------------------------------------------------------------------
    *------------------------------------------------------------------------*/
    localparam sigMSBitAlwaysZero =
        ((options & 1) != 0);
    localparam effectiveInSigWidth =
        sigMSBitAlwaysZero ? inSigWidth : inSigWidth + 1;
    localparam neverUnderflows =
        ((options
              & (4
                     | 2))
             != 0)
            || (inExpWidth < outExpWidth);
    localparam neverOverflows =
        ((options & 8) != 0)
            || (inExpWidth < outExpWidth);
    localparam adjustedExpWidth =
          (inExpWidth < outExpWidth) ? outExpWidth + 1
        : (inExpWidth == outExpWidth) ? inExpWidth + 2
        : inExpWidth + 3;
    localparam outNaNExp = 7<<(outExpWidth - 2);
    localparam outInfExp = 6<<(outExpWidth - 2);
    localparam outMaxFiniteExp = outInfExp - 1;
    localparam outMinNormExp = (1<<(outExpWidth - 1)) + 2;
    localparam outMinNonzeroExp = outMinNormExp - outSigWidth + 1;
    /*------------------------------------------------------------------------
    *------------------------------------------------------------------------*/
    wire roundingMode_near_even   = (roundingMode == 3'b000);
    wire roundingMode_minMag      = (roundingMode == 3'b001);
    wire roundingMode_min         = (roundingMode == 3'b010);
    wire roundingMode_max         = (roundingMode == 3'b011);
    wire roundingMode_near_maxMag = (roundingMode == 3'b100);
    wire roundingMode_odd         = (roundingMode == 3'b110);
    wire roundMagUp =
        (roundingMode_min && in_sign) || (roundingMode_max && !in_sign);
    /*------------------------------------------------------------------------
    *------------------------------------------------------------------------*/
    wire isNaNOut = invalidExc || (!infiniteExc && in_isNaN);
wire propagateNaNPayload = 0;

    wire signed [(adjustedExpWidth - 1):0] sAdjustedExp =
        in_sExp + ((1<<outExpWidth) - (1<<inExpWidth));
    wire [(outSigWidth + 2):0] adjustedSig;
    generate
        if (inSigWidth <= outSigWidth + 2) begin
            assign adjustedSig = in_sig<<(outSigWidth - inSigWidth + 2);
        end else begin
            assign adjustedSig =
                {in_sig[inSigWidth:(inSigWidth - outSigWidth - 1)],
                 |in_sig[(inSigWidth - outSigWidth - 2):0]};
        end
    endgenerate
    wire doShiftSigDown1 =
        sigMSBitAlwaysZero ? 0 : adjustedSig[outSigWidth + 2];
    /*------------------------------------------------------------------------
    *------------------------------------------------------------------------*/
    wire [outExpWidth:0] common_expOut;
    wire [(outSigWidth - 2):0] common_fractOut;
    wire common_overflow, common_totalUnderflow, common_underflow;
    wire common_inexact;
    generate
        if (
            neverOverflows && neverUnderflows
                && (effectiveInSigWidth <= outSigWidth)
        ) begin
            /*----------------------------------------------------------------
            *----------------------------------------------------------------*/
            assign common_expOut = sAdjustedExp + doShiftSigDown1;
            assign common_fractOut =
                doShiftSigDown1 ? adjustedSig>>3 : adjustedSig>>2;
            assign common_overflow       = 0;
            assign common_totalUnderflow = 0;
            assign common_underflow      = 0;
            assign common_inexact        = 0;
        end else begin
            /*----------------------------------------------------------------
            *----------------------------------------------------------------*/
            wire [(outSigWidth + 2):0] roundMask;
            if (neverUnderflows) begin
                assign roundMask = {doShiftSigDown1, 2'b11};
            end else begin
                wire [outSigWidth:0] roundMask_main;
                lowMaskLoHi#(
                    outExpWidth + 1,
                    outMinNormExp - outSigWidth - 1,
                    outMinNormExp
                ) lowMask_roundMask(
                        sAdjustedExp[outExpWidth:0]
                            | (propagateNaNPayload ? 1'b1<<outExpWidth : 1'b0),
                        roundMask_main
                    );
                assign roundMask = {roundMask_main | doShiftSigDown1, 2'b11};
            end
            wire [(outSigWidth + 2):0] shiftedRoundMask = roundMask>>1;
            wire [(outSigWidth + 2):0] roundPosMask =
                ~shiftedRoundMask & roundMask;
            wire roundPosBit =
                (|(adjustedSig[(outSigWidth + 2):3]
                       & roundPosMask[(outSigWidth + 2):3]))
                    || ((|(adjustedSig[2:0] & roundPosMask[2:0]))
                            && !propagateNaNPayload);
            wire anyRoundExtra =
                (|(adjustedSig[(outSigWidth + 2):3]
                       & shiftedRoundMask[(outSigWidth + 2):3]))
                    || ((|(adjustedSig[2:0] & shiftedRoundMask[2:0]))
                            && !propagateNaNPayload);
            wire anyRound = roundPosBit || anyRoundExtra;
            /*----------------------------------------------------------------
            *----------------------------------------------------------------*/
            wire roundIncr =
                ((roundingMode_near_even || roundingMode_near_maxMag)
                     && roundPosBit)
                    || (roundMagUp && anyRound);
            wire [(outSigWidth + 1):0] roundedSig =
                roundIncr
                    ? (((adjustedSig | roundMask)>>2) + 1)
                          & ~(roundingMode_near_even && roundPosBit
                                  && !anyRoundExtra
                                  ? roundMask>>1 : 0)
                    : (adjustedSig & ~roundMask)>>2
                          | (roundingMode_odd && anyRound
                                 ? roundPosMask>>1 : 0);
            wire signed [adjustedExpWidth:0] sExtAdjustedExp = sAdjustedExp;
            wire signed [adjustedExpWidth:0] sRoundedExp =
                sExtAdjustedExp + (roundedSig>>outSigWidth);
            /*----------------------------------------------------------------
            *----------------------------------------------------------------*/
            assign common_expOut = sRoundedExp;
            assign common_fractOut =
                doShiftSigDown1 ? roundedSig>>1 : roundedSig;
            assign common_overflow =
                neverOverflows ? 0 : (sRoundedExp>>>(outExpWidth - 1) >= 3);
            assign common_totalUnderflow =
                neverUnderflows ? 0 : (sRoundedExp < outMinNonzeroExp);
            /*----------------------------------------------------------------
            *----------------------------------------------------------------*/
            wire unboundedRange_roundPosBit =
                doShiftSigDown1 ? adjustedSig[2] : adjustedSig[1];
            wire unboundedRange_anyRound =
                (doShiftSigDown1 && adjustedSig[2]) || (|adjustedSig[1:0]);
            wire unboundedRange_roundIncr =
                ((roundingMode_near_even || roundingMode_near_maxMag)
                     && unboundedRange_roundPosBit)
                    || (roundMagUp && unboundedRange_anyRound);
            wire roundCarry =
                doShiftSigDown1
                    ? roundedSig[outSigWidth + 1] : roundedSig[outSigWidth];
            assign common_underflow =
                neverUnderflows ? 0
                    : common_totalUnderflow
                          || (anyRound && (sAdjustedExp>>>outExpWidth <= 0)
                                  && (doShiftSigDown1
                                          ? roundMask[3] : roundMask[2])
                                  && !(((control
                                           & 1'b1)
                                            != 0)
                                           && !(doShiftSigDown1 ? roundMask[4]
                                                    : roundMask[3])
                                           && roundCarry && roundPosBit
                                           && unboundedRange_roundIncr));
            /*----------------------------------------------------------------
            *----------------------------------------------------------------*/
            assign common_inexact = common_totalUnderflow || anyRound;
        end
    endgenerate
    /*------------------------------------------------------------------------
    *------------------------------------------------------------------------*/
    wire notNaN_isSpecialInfOut = infiniteExc || in_isInf;
    wire commonCase = !isNaNOut && !notNaN_isSpecialInfOut && !in_isZero;
    wire overflow  = commonCase && common_overflow;
    wire underflow = commonCase && common_underflow;
    wire inexact = overflow || (commonCase && common_inexact);
    /*------------------------------------------------------------------------
    *------------------------------------------------------------------------*/
    wire overflow_roundMagUp =
        roundingMode_near_even || roundingMode_near_maxMag || roundMagUp;
    wire pegMinNonzeroMagOut =
        commonCase && common_totalUnderflow
            && (roundMagUp || roundingMode_odd);
    wire pegMaxFiniteMagOut = overflow && !overflow_roundMagUp;
    wire notNaN_isInfOut =
        notNaN_isSpecialInfOut || (overflow && overflow_roundMagUp);
    /*------------------------------------------------------------------------
    *------------------------------------------------------------------------*/
wire signOut = isNaNOut ? 0 : in_sign;

    wire [outExpWidth:0] expOut =
        (common_expOut
             & ~(in_isZero || common_totalUnderflow ? 7<<(outExpWidth - 2) : 0)
             & ~(pegMinNonzeroMagOut               ? ~outMinNonzeroExp    : 0)
             & ~(pegMaxFiniteMagOut                ? 1<<(outExpWidth - 1) : 0)
             & ~(notNaN_isInfOut                   ? 1<<(outExpWidth - 2) : 0))
            | (pegMinNonzeroMagOut ? outMinNonzeroExp : 0)
            | (pegMaxFiniteMagOut  ? outMaxFiniteExp  : 0)
            | (notNaN_isInfOut     ? outInfExp        : 0)
            | (isNaNOut            ? outNaNExp        : 0);
wire [(outSigWidth - 2):0] fractOut =
          (isNaNOut ? {1'b1, {((outSigWidth) - 2){1'b0}}} : 0)
        | (!in_isZero && !common_totalUnderflow
               ? common_fractOut & {1'b1, {((outSigWidth) - 2){1'b0}}} : 0)
        | (!isNaNOut && !in_isZero && !common_totalUnderflow
               ? common_fractOut & ~{1'b1, {((outSigWidth) - 2){1'b0}}}
               : 0)
        | {(outSigWidth - 1){pegMaxFiniteMagOut}};

    assign out = {signOut, expOut, fractOut};
    assign exceptionFlags =
        {invalidExc, infiniteExc, overflow, underflow, inexact};

endmodule

/*----------------------------------------------------------------------------
*----------------------------------------------------------------------------*/

module
    roundRawFNToRecFN#(
        parameter expWidth = 3,
        parameter sigWidth = 3,
        parameter options = 0
    ) (
        input [(1 - 1):0] control,
        input invalidExc,     // overrides 'infiniteExc' and 'in_*' inputs
        input infiniteExc,    // overrides 'in_*' inputs except 'in_sign'
        input in_isNaN,
        input in_isInf,
        input in_isZero,
        input in_sign,
        input signed [(expWidth + 1):0] in_sExp,   // limited range allowed
        input [(sigWidth + 2):0] in_sig,
        input [2:0] roundingMode,
        output [(expWidth + sigWidth):0] out,
        output [4:0] exceptionFlags
    );

    roundAnyRawFNToRecFN#(expWidth, sigWidth + 2, expWidth, sigWidth, options)
        roundAnyRawFNToRecFN(
            control,
            invalidExc,
            infiniteExc,
            in_isNaN,
            in_isInf,
            in_isZero,
            in_sign,
            in_sExp,
            in_sig,
            roundingMode,
            out,
            exceptionFlags
        );

endmodule


/*============================================================================

This Verilog source file is part of the Berkeley HardFloat IEEE Floating-Point
Arithmetic Package, Release 1, by John R. Hauser.

Copyright 2019 The Regents of the University of California.  All rights
reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

 1. Redistributions of source code must retain the above copyright notice,
    this list of conditions, and the following disclaimer.

 2. Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions, and the following disclaimer in the documentation
    and/or other materials provided with the distribution.

 3. Neither the name of the University nor the names of its contributors may
    be used to endorse or promote products derived from this software without
    specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS "AS IS", AND ANY
EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, ARE
DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

=============================================================================*/

/*----------------------------------------------------------------------------
*----------------------------------------------------------------------------*/

module
    reverse#(parameter width = 1) (
        input [(width - 1):0] in, output [(width - 1):0] out
    );

    genvar ix;
    generate
        for (ix = 0; ix < width; ix = ix + 1) begin :Bit
            assign out[ix] = in[width - 1 - ix];
        end
    endgenerate

endmodule

/*----------------------------------------------------------------------------
*----------------------------------------------------------------------------*/

module
    lowMaskHiLo#(
        parameter inWidth = 1,
        parameter topBound = 1,
        parameter bottomBound = 0
    ) (
        input [(inWidth - 1):0] in,
        output [(topBound - bottomBound - 1):0] out
    );

    /*------------------------------------------------------------------------
    *------------------------------------------------------------------------*/
    localparam numInVals = 1<<inWidth;
    /*------------------------------------------------------------------------
    *------------------------------------------------------------------------*/
    wire signed [numInVals:0] c;
    assign c[numInVals] = 1;
    assign c[(numInVals - 1):0] = 0;
    wire [(topBound - bottomBound - 1):0] reverseOut =
        (c>>>in)>>(numInVals - topBound);
    reverse#(topBound - bottomBound) reverse(reverseOut, out);

endmodule

/*----------------------------------------------------------------------------
*----------------------------------------------------------------------------*/

module
    lowMaskLoHi#(
        parameter inWidth = 1,
        parameter topBound = 0,
        parameter bottomBound = 1
    ) (
        input [(inWidth - 1):0] in,
        output [(bottomBound - topBound - 1):0] out
    );

    /*------------------------------------------------------------------------
    *------------------------------------------------------------------------*/
    localparam numInVals = 1<<inWidth;
    /*------------------------------------------------------------------------
    *------------------------------------------------------------------------*/
    wire signed [numInVals:0] c;
    assign c[numInVals] = 1;
    assign c[(numInVals - 1):0] = 0;
    wire [(bottomBound - topBound - 1):0] reverseOut =
        (c>>>~in)>>(topBound + 1);
    reverse#(bottomBound - topBound) reverse(reverseOut, out);

endmodule

/*----------------------------------------------------------------------------
*----------------------------------------------------------------------------*/

module
    countLeadingZeros#(parameter inWidth = 1, parameter countWidth = 1) (
        input [(inWidth - 1):0] in, output [(countWidth - 1):0] count
    );

    wire [(inWidth - 1):0] reverseIn;
    reverse#(inWidth) reverse_in(in, reverseIn);
    wire [inWidth:0] oneLeastReverseIn =
        {1'b1, reverseIn} & ({1'b0, ~reverseIn} + 1);
    genvar ix;
    generate
        for (ix = 0; ix <= inWidth; ix = ix + 1) begin :Bit
            wire [(countWidth - 1):0] countSoFar;
            if (ix == 0) begin
                assign countSoFar = 0;
            end else begin
                assign countSoFar =
                    Bit[ix - 1].countSoFar | (oneLeastReverseIn[ix] ? ix : 0);
                if (ix == inWidth) assign count = countSoFar;
            end
        end
    endgenerate

endmodule

/*----------------------------------------------------------------------------
*----------------------------------------------------------------------------*/

module
    compressBy2#(parameter inWidth = 1) (
        input [(inWidth - 1):0] in, output [((inWidth - 1)/2):0] out
    );

    localparam maxBitNumReduced = (inWidth - 1)/2;
    genvar ix;
    generate
        for (ix = 0; ix < maxBitNumReduced; ix = ix + 1) begin :Bit
            assign out[ix] = |in[(ix*2 + 1):ix*2];
        end
    endgenerate
    assign out[maxBitNumReduced] = |in[(inWidth - 1):maxBitNumReduced*2];

endmodule

/*----------------------------------------------------------------------------
*----------------------------------------------------------------------------*/

module
    compressBy4#(parameter inWidth = 1) (
        input [(inWidth - 1):0] in, output [(inWidth - 1)/4:0] out
    );

    localparam maxBitNumReduced = (inWidth - 1)/4;
    genvar ix;
    generate
        for (ix = 0; ix < maxBitNumReduced; ix = ix + 1) begin :Bit
            assign out[ix] = |in[(ix*4 + 3):ix*4];
        end
    endgenerate
    assign out[maxBitNumReduced] = |in[(inWidth - 1):maxBitNumReduced*4];

endmodule

