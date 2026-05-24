// Compiled by morty-0.9.0 / 2026-02-05 21:13:17.557063226 -06:00:00

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
`define __MULFN_V__


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



module std_mulFN #(parameter expWidth = 8, parameter sigWidth = 24, parameter numWidth = 32) (
    input clk,
    input reset,
    input go,
    input [(1 - 1):0] control,
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

    // Intermediate signals after the multiplier
    wire [(expWidth + sigWidth):0] res_recoded;
    wire [4:0] except_flag;

    // Compute recoded numbers
    mulRecFN #(expWidth, sigWidth) multiplier(
        .control(control),
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


 /* __MULFN_V__ */
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
logic gelu_instance_clk;
logic gelu_instance_reset;
logic gelu_instance_go;
logic gelu_instance_done;
logic [31:0] gelu_instance_arg_mem_0_read_data;
logic gelu_instance_arg_mem_0_done;
logic [31:0] gelu_instance_arg_mem_1_write_data;
logic [31:0] gelu_instance_arg_mem_1_read_data;
logic gelu_instance_arg_mem_0_content_en;
logic [8:0] gelu_instance_arg_mem_0_addr0;
logic gelu_instance_arg_mem_0_write_en;
logic gelu_instance_arg_mem_1_done;
logic [31:0] gelu_instance_arg_mem_0_write_data;
logic gelu_instance_arg_mem_1_write_en;
logic [8:0] gelu_instance_arg_mem_1_addr0;
logic gelu_instance_arg_mem_1_content_en;
logic invoke0_go_in;
logic invoke0_go_out;
logic invoke0_done_in;
logic invoke0_done_out;
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
gelu gelu_instance (
    .arg_mem_0_addr0(gelu_instance_arg_mem_0_addr0),
    .arg_mem_0_content_en(gelu_instance_arg_mem_0_content_en),
    .arg_mem_0_done(gelu_instance_arg_mem_0_done),
    .arg_mem_0_read_data(gelu_instance_arg_mem_0_read_data),
    .arg_mem_0_write_data(gelu_instance_arg_mem_0_write_data),
    .arg_mem_0_write_en(gelu_instance_arg_mem_0_write_en),
    .arg_mem_1_addr0(gelu_instance_arg_mem_1_addr0),
    .arg_mem_1_content_en(gelu_instance_arg_mem_1_content_en),
    .arg_mem_1_done(gelu_instance_arg_mem_1_done),
    .arg_mem_1_read_data(gelu_instance_arg_mem_1_read_data),
    .arg_mem_1_write_data(gelu_instance_arg_mem_1_write_data),
    .arg_mem_1_write_en(gelu_instance_arg_mem_1_write_en),
    .clk(gelu_instance_clk),
    .done(gelu_instance_done),
    .go(gelu_instance_go),
    .reset(gelu_instance_reset)
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
assign done = _guard1;
assign invoke0_go_in = go;
assign mem_1_write_en =
  _guard2 ? gelu_instance_arg_mem_1_write_en :
  1'd0;
assign mem_1_clk = clk;
assign mem_1_addr0 = gelu_instance_arg_mem_1_addr0;
assign mem_1_content_en =
  _guard4 ? gelu_instance_arg_mem_1_content_en :
  1'd0;
assign mem_1_reset = reset;
assign mem_1_write_data = gelu_instance_arg_mem_1_write_data;
assign gelu_instance_arg_mem_0_read_data =
  _guard6 ? mem_0_read_data :
  32'd0;
assign gelu_instance_arg_mem_0_done =
  _guard7 ? mem_0_done :
  1'd0;
assign gelu_instance_clk = clk;
assign gelu_instance_reset = reset;
assign gelu_instance_go = _guard8;
assign gelu_instance_arg_mem_1_done =
  _guard9 ? mem_1_done :
  1'd0;
assign invoke0_done_in = gelu_instance_done;
assign mem_0_write_en =
  _guard10 ? gelu_instance_arg_mem_0_write_en :
  1'd0;
assign mem_0_clk = clk;
assign mem_0_addr0 = gelu_instance_arg_mem_0_addr0;
assign mem_0_content_en =
  _guard12 ? gelu_instance_arg_mem_0_content_en :
  1'd0;
assign mem_0_reset = reset;
// COMPONENT END: main
endmodule
module gelu(
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
// COMPONENT START: gelu
logic [31:0] cst_3_out;
logic [31:0] cst_2_out;
logic [31:0] cst_1_out;
logic [31:0] cst_0_out;
logic [31:0] std_slice_17_in;
logic [8:0] std_slice_17_out;
logic [31:0] std_slice_15_in;
logic std_slice_15_out;
logic [31:0] std_add_16_left;
logic [31:0] std_add_16_right;
logic [31:0] std_add_16_out;
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
logic [31:0] addf_1_reg_in;
logic addf_1_reg_write_en;
logic addf_1_reg_clk;
logic addf_1_reg_reset;
logic [31:0] addf_1_reg_out;
logic addf_1_reg_done;
logic std_addFN_1_clk;
logic std_addFN_1_reset;
logic std_addFN_1_go;
logic std_addFN_1_control;
logic std_addFN_1_subOp;
logic [31:0] std_addFN_1_left;
logic [31:0] std_addFN_1_right;
logic [2:0] std_addFN_1_roundingMode;
logic [31:0] std_addFN_1_out;
logic [4:0] std_addFN_1_exceptionFlags;
logic std_addFN_1_done;
logic std_mulFN_4_clk;
logic std_mulFN_4_reset;
logic std_mulFN_4_go;
logic std_mulFN_4_control;
logic [31:0] std_mulFN_4_left;
logic [31:0] std_mulFN_4_right;
logic [2:0] std_mulFN_4_roundingMode;
logic [31:0] std_mulFN_4_out;
logic [4:0] std_mulFN_4_exceptionFlags;
logic std_mulFN_4_done;
logic [31:0] load_7_reg_in;
logic load_7_reg_write_en;
logic load_7_reg_clk;
logic load_7_reg_reset;
logic [31:0] load_7_reg_out;
logic load_7_reg_done;
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
logic std_mulFN_3_clk;
logic std_mulFN_3_reset;
logic std_mulFN_3_go;
logic std_mulFN_3_control;
logic [31:0] std_mulFN_3_left;
logic [31:0] std_mulFN_3_right;
logic [2:0] std_mulFN_3_roundingMode;
logic [31:0] std_mulFN_3_out;
logic [4:0] std_mulFN_3_exceptionFlags;
logic std_mulFN_3_done;
logic [31:0] mulf_2_reg_in;
logic mulf_2_reg_write_en;
logic mulf_2_reg_clk;
logic mulf_2_reg_reset;
logic [31:0] mulf_2_reg_out;
logic mulf_2_reg_done;
logic std_mulFN_2_clk;
logic std_mulFN_2_reset;
logic std_mulFN_2_go;
logic std_mulFN_2_control;
logic [31:0] std_mulFN_2_left;
logic [31:0] std_mulFN_2_right;
logic [2:0] std_mulFN_2_roundingMode;
logic [31:0] std_mulFN_2_out;
logic [4:0] std_mulFN_2_exceptionFlags;
logic std_mulFN_2_done;
logic mem_5_clk;
logic mem_5_reset;
logic mem_5_addr0;
logic mem_5_content_en;
logic mem_5_write_en;
logic [31:0] mem_5_write_data;
logic [31:0] mem_5_read_data;
logic mem_5_done;
logic mem_4_clk;
logic mem_4_reset;
logic mem_4_addr0;
logic mem_4_content_en;
logic mem_4_write_en;
logic [31:0] mem_4_write_data;
logic [31:0] mem_4_read_data;
logic mem_4_done;
logic mem_3_clk;
logic mem_3_reset;
logic mem_3_addr0;
logic mem_3_content_en;
logic mem_3_write_en;
logic [31:0] mem_3_write_data;
logic [31:0] mem_3_read_data;
logic mem_3_done;
logic mem_2_clk;
logic mem_2_reset;
logic mem_2_addr0;
logic mem_2_content_en;
logic mem_2_write_en;
logic [31:0] mem_2_write_data;
logic [31:0] mem_2_read_data;
logic mem_2_done;
logic std_mulFN_1_clk;
logic std_mulFN_1_reset;
logic std_mulFN_1_go;
logic std_mulFN_1_control;
logic [31:0] std_mulFN_1_left;
logic [31:0] std_mulFN_1_right;
logic [2:0] std_mulFN_1_roundingMode;
logic [31:0] std_mulFN_1_out;
logic [4:0] std_mulFN_1_exceptionFlags;
logic std_mulFN_1_done;
logic mem_1_clk;
logic mem_1_reset;
logic mem_1_addr0;
logic mem_1_content_en;
logic mem_1_write_en;
logic [31:0] mem_1_write_data;
logic [31:0] mem_1_read_data;
logic mem_1_done;
logic std_mulFN_0_clk;
logic std_mulFN_0_reset;
logic std_mulFN_0_go;
logic std_mulFN_0_control;
logic [31:0] std_mulFN_0_left;
logic [31:0] std_mulFN_0_right;
logic [2:0] std_mulFN_0_roundingMode;
logic [31:0] std_mulFN_0_out;
logic [4:0] std_mulFN_0_exceptionFlags;
logic std_mulFN_0_done;
logic mem_0_clk;
logic mem_0_reset;
logic mem_0_addr0;
logic mem_0_content_en;
logic mem_0_write_en;
logic [31:0] mem_0_write_data;
logic [31:0] mem_0_read_data;
logic mem_0_done;
logic [31:0] for_7_induction_var_reg_in;
logic for_7_induction_var_reg_write_en;
logic for_7_induction_var_reg_clk;
logic for_7_induction_var_reg_reset;
logic [31:0] for_7_induction_var_reg_out;
logic for_7_induction_var_reg_done;
logic [31:0] for_6_induction_var_reg_in;
logic for_6_induction_var_reg_write_en;
logic for_6_induction_var_reg_clk;
logic for_6_induction_var_reg_reset;
logic [31:0] for_6_induction_var_reg_out;
logic for_6_induction_var_reg_done;
logic [31:0] for_5_induction_var_reg_in;
logic for_5_induction_var_reg_write_en;
logic for_5_induction_var_reg_clk;
logic for_5_induction_var_reg_reset;
logic [31:0] for_5_induction_var_reg_out;
logic for_5_induction_var_reg_done;
logic [31:0] for_4_induction_var_reg_in;
logic for_4_induction_var_reg_write_en;
logic for_4_induction_var_reg_clk;
logic for_4_induction_var_reg_reset;
logic [31:0] for_4_induction_var_reg_out;
logic for_4_induction_var_reg_done;
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
logic [3:0] idx2_in;
logic idx2_write_en;
logic idx2_clk;
logic idx2_reset;
logic [3:0] idx2_out;
logic idx2_done;
logic cond_reg2_in;
logic cond_reg2_write_en;
logic cond_reg2_clk;
logic cond_reg2_reset;
logic cond_reg2_out;
logic cond_reg2_done;
logic [3:0] adder2_left;
logic [3:0] adder2_right;
logic [3:0] adder2_out;
logic [3:0] lt2_left;
logic [3:0] lt2_right;
logic lt2_out;
logic [3:0] idx3_in;
logic idx3_write_en;
logic idx3_clk;
logic idx3_reset;
logic [3:0] idx3_out;
logic idx3_done;
logic cond_reg3_in;
logic cond_reg3_write_en;
logic cond_reg3_clk;
logic cond_reg3_reset;
logic cond_reg3_out;
logic cond_reg3_done;
logic [3:0] adder3_left;
logic [3:0] adder3_right;
logic [3:0] adder3_out;
logic [3:0] lt3_left;
logic [3:0] lt3_right;
logic lt3_out;
logic [1:0] idx4_in;
logic idx4_write_en;
logic idx4_clk;
logic idx4_reset;
logic [1:0] idx4_out;
logic idx4_done;
logic cond_reg4_in;
logic cond_reg4_write_en;
logic cond_reg4_clk;
logic cond_reg4_reset;
logic cond_reg4_out;
logic cond_reg4_done;
logic [1:0] adder4_left;
logic [1:0] adder4_right;
logic [1:0] adder4_out;
logic [1:0] lt4_left;
logic [1:0] lt4_right;
logic lt4_out;
logic [3:0] fsm_in;
logic fsm_write_en;
logic fsm_clk;
logic fsm_reset;
logic [3:0] fsm_out;
logic fsm_done;
logic ud_out;
logic [3:0] adder5_left;
logic [3:0] adder5_right;
logic [3:0] adder5_out;
logic ud0_out;
logic ud1_out;
logic [3:0] adder6_left;
logic [3:0] adder6_right;
logic [3:0] adder6_out;
logic ud2_out;
logic [3:0] adder7_left;
logic [3:0] adder7_right;
logic [3:0] adder7_out;
logic ud3_out;
logic [3:0] adder8_left;
logic [3:0] adder8_right;
logic [3:0] adder8_out;
logic ud4_out;
logic [3:0] adder9_left;
logic [3:0] adder9_right;
logic [3:0] adder9_out;
logic ud5_out;
logic [3:0] adder10_left;
logic [3:0] adder10_right;
logic [3:0] adder10_out;
logic ud6_out;
logic [3:0] adder11_left;
logic [3:0] adder11_right;
logic [3:0] adder11_out;
logic ud7_out;
logic [3:0] adder12_left;
logic [3:0] adder12_right;
logic [3:0] adder12_out;
logic ud8_out;
logic signal_reg_in;
logic signal_reg_write_en;
logic signal_reg_clk;
logic signal_reg_reset;
logic signal_reg_out;
logic signal_reg_done;
logic [5:0] fsm0_in;
logic fsm0_write_en;
logic fsm0_clk;
logic fsm0_reset;
logic [5:0] fsm0_out;
logic fsm0_done;
logic bb0_6_go_in;
logic bb0_6_go_out;
logic bb0_6_done_in;
logic bb0_6_done_out;
logic bb0_13_go_in;
logic bb0_13_go_out;
logic bb0_13_done_in;
logic bb0_13_done_out;
logic bb0_16_go_in;
logic bb0_16_go_out;
logic bb0_16_done_in;
logic bb0_16_done_out;
logic bb0_20_go_in;
logic bb0_20_go_out;
logic bb0_20_done_in;
logic bb0_20_done_out;
logic bb0_27_go_in;
logic bb0_27_go_out;
logic bb0_27_done_in;
logic bb0_27_done_out;
logic bb0_30_go_in;
logic bb0_30_go_out;
logic bb0_30_done_in;
logic bb0_30_done_out;
logic bb0_31_go_in;
logic bb0_31_go_out;
logic bb0_31_done_in;
logic bb0_31_done_out;
logic bb0_34_go_in;
logic bb0_34_go_out;
logic bb0_34_done_in;
logic bb0_34_done_out;
logic bb0_35_go_in;
logic bb0_35_go_out;
logic bb0_35_done_in;
logic bb0_35_done_out;
logic bb0_42_go_in;
logic bb0_42_go_out;
logic bb0_42_done_in;
logic bb0_42_done_out;
logic invoke2_go_in;
logic invoke2_go_out;
logic invoke2_done_in;
logic invoke2_done_out;
logic invoke3_go_in;
logic invoke3_go_out;
logic invoke3_done_in;
logic invoke3_done_out;
logic invoke10_go_in;
logic invoke10_go_out;
logic invoke10_done_in;
logic invoke10_done_out;
logic invoke11_go_in;
logic invoke11_go_out;
logic invoke11_done_in;
logic invoke11_done_out;
logic invoke12_go_in;
logic invoke12_go_out;
logic invoke12_done_in;
logic invoke12_done_out;
logic invoke16_go_in;
logic invoke16_go_out;
logic invoke16_done_in;
logic invoke16_done_out;
logic invoke17_go_in;
logic invoke17_go_out;
logic invoke17_done_in;
logic invoke17_done_out;
logic invoke54_go_in;
logic invoke54_go_out;
logic invoke54_done_in;
logic invoke54_done_out;
logic invoke55_go_in;
logic invoke55_go_out;
logic invoke55_done_in;
logic invoke55_done_out;
logic invoke56_go_in;
logic invoke56_go_out;
logic invoke56_done_in;
logic invoke56_done_out;
logic invoke57_go_in;
logic invoke57_go_out;
logic invoke57_done_in;
logic invoke57_done_out;
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
logic init_repeat2_go_in;
logic init_repeat2_go_out;
logic init_repeat2_done_in;
logic init_repeat2_done_out;
logic incr_repeat2_go_in;
logic incr_repeat2_go_out;
logic incr_repeat2_done_in;
logic incr_repeat2_done_out;
logic init_repeat3_go_in;
logic init_repeat3_go_out;
logic init_repeat3_done_in;
logic init_repeat3_done_out;
logic incr_repeat3_go_in;
logic incr_repeat3_go_out;
logic incr_repeat3_done_in;
logic incr_repeat3_done_out;
logic init_repeat4_go_in;
logic init_repeat4_go_out;
logic init_repeat4_done_in;
logic init_repeat4_done_out;
logic incr_repeat4_go_in;
logic incr_repeat4_go_out;
logic incr_repeat4_done_in;
logic incr_repeat4_done_out;
logic early_reset_static_par_thread_go_in;
logic early_reset_static_par_thread_go_out;
logic early_reset_static_par_thread_done_in;
logic early_reset_static_par_thread_done_out;
logic early_reset_static_seq_go_in;
logic early_reset_static_seq_go_out;
logic early_reset_static_seq_done_in;
logic early_reset_static_seq_done_out;
logic early_reset_static_par_thread0_go_in;
logic early_reset_static_par_thread0_go_out;
logic early_reset_static_par_thread0_done_in;
logic early_reset_static_par_thread0_done_out;
logic early_reset_static_seq0_go_in;
logic early_reset_static_seq0_go_out;
logic early_reset_static_seq0_done_in;
logic early_reset_static_seq0_done_out;
logic early_reset_static_seq1_go_in;
logic early_reset_static_seq1_go_out;
logic early_reset_static_seq1_done_in;
logic early_reset_static_seq1_done_out;
logic early_reset_static_seq2_go_in;
logic early_reset_static_seq2_go_out;
logic early_reset_static_seq2_done_in;
logic early_reset_static_seq2_done_out;
logic early_reset_static_seq3_go_in;
logic early_reset_static_seq3_go_out;
logic early_reset_static_seq3_done_in;
logic early_reset_static_seq3_done_out;
logic early_reset_static_seq4_go_in;
logic early_reset_static_seq4_go_out;
logic early_reset_static_seq4_done_in;
logic early_reset_static_seq4_done_out;
logic early_reset_static_seq5_go_in;
logic early_reset_static_seq5_go_out;
logic early_reset_static_seq5_done_in;
logic early_reset_static_seq5_done_out;
logic early_reset_static_seq6_go_in;
logic early_reset_static_seq6_go_out;
logic early_reset_static_seq6_done_in;
logic early_reset_static_seq6_done_out;
logic wrapper_early_reset_static_par_thread_go_in;
logic wrapper_early_reset_static_par_thread_go_out;
logic wrapper_early_reset_static_par_thread_done_in;
logic wrapper_early_reset_static_par_thread_done_out;
logic wrapper_early_reset_static_seq_go_in;
logic wrapper_early_reset_static_seq_go_out;
logic wrapper_early_reset_static_seq_done_in;
logic wrapper_early_reset_static_seq_done_out;
logic wrapper_early_reset_static_par_thread0_go_in;
logic wrapper_early_reset_static_par_thread0_go_out;
logic wrapper_early_reset_static_par_thread0_done_in;
logic wrapper_early_reset_static_par_thread0_done_out;
logic wrapper_early_reset_static_seq0_go_in;
logic wrapper_early_reset_static_seq0_go_out;
logic wrapper_early_reset_static_seq0_done_in;
logic wrapper_early_reset_static_seq0_done_out;
logic wrapper_early_reset_static_seq1_go_in;
logic wrapper_early_reset_static_seq1_go_out;
logic wrapper_early_reset_static_seq1_done_in;
logic wrapper_early_reset_static_seq1_done_out;
logic wrapper_early_reset_static_seq2_go_in;
logic wrapper_early_reset_static_seq2_go_out;
logic wrapper_early_reset_static_seq2_done_in;
logic wrapper_early_reset_static_seq2_done_out;
logic wrapper_early_reset_static_seq3_go_in;
logic wrapper_early_reset_static_seq3_go_out;
logic wrapper_early_reset_static_seq3_done_in;
logic wrapper_early_reset_static_seq3_done_out;
logic wrapper_early_reset_static_seq4_go_in;
logic wrapper_early_reset_static_seq4_go_out;
logic wrapper_early_reset_static_seq4_done_in;
logic wrapper_early_reset_static_seq4_done_out;
logic wrapper_early_reset_static_seq5_go_in;
logic wrapper_early_reset_static_seq5_go_out;
logic wrapper_early_reset_static_seq5_done_in;
logic wrapper_early_reset_static_seq5_done_out;
logic wrapper_early_reset_static_seq6_go_in;
logic wrapper_early_reset_static_seq6_go_out;
logic wrapper_early_reset_static_seq6_done_in;
logic wrapper_early_reset_static_seq6_done_out;
logic tdcc_go_in;
logic tdcc_go_out;
logic tdcc_done_in;
logic tdcc_done_out;
std_float_const # (
    .REP(0),
    .VALUE(0),
    .WIDTH(32)
) cst_3 (
    .out(cst_3_out)
);
std_float_const # (
    .REP(0),
    .VALUE(1056964608),
    .WIDTH(32)
) cst_2 (
    .out(cst_2_out)
);
std_float_const # (
    .REP(0),
    .VALUE(1053572255),
    .WIDTH(32)
) cst_1 (
    .out(cst_1_out)
);
std_float_const # (
    .REP(0),
    .VALUE(1024604714),
    .WIDTH(32)
) cst_0 (
    .out(cst_0_out)
);
std_slice # (
    .IN_WIDTH(32),
    .OUT_WIDTH(9)
) std_slice_17 (
    .in(std_slice_17_in),
    .out(std_slice_17_out)
);
std_slice # (
    .IN_WIDTH(32),
    .OUT_WIDTH(1)
) std_slice_15 (
    .in(std_slice_15_in),
    .out(std_slice_15_out)
);
std_add # (
    .WIDTH(32)
) std_add_16 (
    .left(std_add_16_left),
    .out(std_add_16_out),
    .right(std_add_16_right)
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
) addf_1_reg (
    .clk(addf_1_reg_clk),
    .done(addf_1_reg_done),
    .in(addf_1_reg_in),
    .out(addf_1_reg_out),
    .reset(addf_1_reg_reset),
    .write_en(addf_1_reg_write_en)
);
std_addFN # (
    .expWidth(8),
    .numWidth(32),
    .sigWidth(24)
) std_addFN_1 (
    .clk(std_addFN_1_clk),
    .control(std_addFN_1_control),
    .done(std_addFN_1_done),
    .exceptionFlags(std_addFN_1_exceptionFlags),
    .go(std_addFN_1_go),
    .left(std_addFN_1_left),
    .out(std_addFN_1_out),
    .reset(std_addFN_1_reset),
    .right(std_addFN_1_right),
    .roundingMode(std_addFN_1_roundingMode),
    .subOp(std_addFN_1_subOp)
);
std_mulFN # (
    .expWidth(8),
    .numWidth(32),
    .sigWidth(24)
) std_mulFN_4 (
    .clk(std_mulFN_4_clk),
    .control(std_mulFN_4_control),
    .done(std_mulFN_4_done),
    .exceptionFlags(std_mulFN_4_exceptionFlags),
    .go(std_mulFN_4_go),
    .left(std_mulFN_4_left),
    .out(std_mulFN_4_out),
    .reset(std_mulFN_4_reset),
    .right(std_mulFN_4_right),
    .roundingMode(std_mulFN_4_roundingMode)
);
std_reg # (
    .WIDTH(32)
) load_7_reg (
    .clk(load_7_reg_clk),
    .done(load_7_reg_done),
    .in(load_7_reg_in),
    .out(load_7_reg_out),
    .reset(load_7_reg_reset),
    .write_en(load_7_reg_write_en)
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
std_mulFN # (
    .expWidth(8),
    .numWidth(32),
    .sigWidth(24)
) std_mulFN_3 (
    .clk(std_mulFN_3_clk),
    .control(std_mulFN_3_control),
    .done(std_mulFN_3_done),
    .exceptionFlags(std_mulFN_3_exceptionFlags),
    .go(std_mulFN_3_go),
    .left(std_mulFN_3_left),
    .out(std_mulFN_3_out),
    .reset(std_mulFN_3_reset),
    .right(std_mulFN_3_right),
    .roundingMode(std_mulFN_3_roundingMode)
);
std_reg # (
    .WIDTH(32)
) mulf_2_reg (
    .clk(mulf_2_reg_clk),
    .done(mulf_2_reg_done),
    .in(mulf_2_reg_in),
    .out(mulf_2_reg_out),
    .reset(mulf_2_reg_reset),
    .write_en(mulf_2_reg_write_en)
);
std_mulFN # (
    .expWidth(8),
    .numWidth(32),
    .sigWidth(24)
) std_mulFN_2 (
    .clk(std_mulFN_2_clk),
    .control(std_mulFN_2_control),
    .done(std_mulFN_2_done),
    .exceptionFlags(std_mulFN_2_exceptionFlags),
    .go(std_mulFN_2_go),
    .left(std_mulFN_2_left),
    .out(std_mulFN_2_out),
    .reset(std_mulFN_2_reset),
    .right(std_mulFN_2_right),
    .roundingMode(std_mulFN_2_roundingMode)
);
seq_mem_d1 # (
    .IDX_SIZE(1),
    .SIZE(1),
    .WIDTH(32)
) mem_5 (
    .addr0(mem_5_addr0),
    .clk(mem_5_clk),
    .content_en(mem_5_content_en),
    .done(mem_5_done),
    .read_data(mem_5_read_data),
    .reset(mem_5_reset),
    .write_data(mem_5_write_data),
    .write_en(mem_5_write_en)
);
seq_mem_d1 # (
    .IDX_SIZE(1),
    .SIZE(1),
    .WIDTH(32)
) mem_4 (
    .addr0(mem_4_addr0),
    .clk(mem_4_clk),
    .content_en(mem_4_content_en),
    .done(mem_4_done),
    .read_data(mem_4_read_data),
    .reset(mem_4_reset),
    .write_data(mem_4_write_data),
    .write_en(mem_4_write_en)
);
seq_mem_d1 # (
    .IDX_SIZE(1),
    .SIZE(1),
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
    .IDX_SIZE(1),
    .SIZE(1),
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
std_mulFN # (
    .expWidth(8),
    .numWidth(32),
    .sigWidth(24)
) std_mulFN_1 (
    .clk(std_mulFN_1_clk),
    .control(std_mulFN_1_control),
    .done(std_mulFN_1_done),
    .exceptionFlags(std_mulFN_1_exceptionFlags),
    .go(std_mulFN_1_go),
    .left(std_mulFN_1_left),
    .out(std_mulFN_1_out),
    .reset(std_mulFN_1_reset),
    .right(std_mulFN_1_right),
    .roundingMode(std_mulFN_1_roundingMode)
);
seq_mem_d1 # (
    .IDX_SIZE(1),
    .SIZE(1),
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
std_mulFN # (
    .expWidth(8),
    .numWidth(32),
    .sigWidth(24)
) std_mulFN_0 (
    .clk(std_mulFN_0_clk),
    .control(std_mulFN_0_control),
    .done(std_mulFN_0_done),
    .exceptionFlags(std_mulFN_0_exceptionFlags),
    .go(std_mulFN_0_go),
    .left(std_mulFN_0_left),
    .out(std_mulFN_0_out),
    .reset(std_mulFN_0_reset),
    .right(std_mulFN_0_right),
    .roundingMode(std_mulFN_0_roundingMode)
);
seq_mem_d1 # (
    .IDX_SIZE(1),
    .SIZE(1),
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
std_reg # (
    .WIDTH(32)
) for_7_induction_var_reg (
    .clk(for_7_induction_var_reg_clk),
    .done(for_7_induction_var_reg_done),
    .in(for_7_induction_var_reg_in),
    .out(for_7_induction_var_reg_out),
    .reset(for_7_induction_var_reg_reset),
    .write_en(for_7_induction_var_reg_write_en)
);
std_reg # (
    .WIDTH(32)
) for_6_induction_var_reg (
    .clk(for_6_induction_var_reg_clk),
    .done(for_6_induction_var_reg_done),
    .in(for_6_induction_var_reg_in),
    .out(for_6_induction_var_reg_out),
    .reset(for_6_induction_var_reg_reset),
    .write_en(for_6_induction_var_reg_write_en)
);
std_reg # (
    .WIDTH(32)
) for_5_induction_var_reg (
    .clk(for_5_induction_var_reg_clk),
    .done(for_5_induction_var_reg_done),
    .in(for_5_induction_var_reg_in),
    .out(for_5_induction_var_reg_out),
    .reset(for_5_induction_var_reg_reset),
    .write_en(for_5_induction_var_reg_write_en)
);
std_reg # (
    .WIDTH(32)
) for_4_induction_var_reg (
    .clk(for_4_induction_var_reg_clk),
    .done(for_4_induction_var_reg_done),
    .in(for_4_induction_var_reg_in),
    .out(for_4_induction_var_reg_out),
    .reset(for_4_induction_var_reg_reset),
    .write_en(for_4_induction_var_reg_write_en)
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
) idx2 (
    .clk(idx2_clk),
    .done(idx2_done),
    .in(idx2_in),
    .out(idx2_out),
    .reset(idx2_reset),
    .write_en(idx2_write_en)
);
std_reg # (
    .WIDTH(1)
) cond_reg2 (
    .clk(cond_reg2_clk),
    .done(cond_reg2_done),
    .in(cond_reg2_in),
    .out(cond_reg2_out),
    .reset(cond_reg2_reset),
    .write_en(cond_reg2_write_en)
);
std_add # (
    .WIDTH(4)
) adder2 (
    .left(adder2_left),
    .out(adder2_out),
    .right(adder2_right)
);
std_lt # (
    .WIDTH(4)
) lt2 (
    .left(lt2_left),
    .out(lt2_out),
    .right(lt2_right)
);
std_reg # (
    .WIDTH(4)
) idx3 (
    .clk(idx3_clk),
    .done(idx3_done),
    .in(idx3_in),
    .out(idx3_out),
    .reset(idx3_reset),
    .write_en(idx3_write_en)
);
std_reg # (
    .WIDTH(1)
) cond_reg3 (
    .clk(cond_reg3_clk),
    .done(cond_reg3_done),
    .in(cond_reg3_in),
    .out(cond_reg3_out),
    .reset(cond_reg3_reset),
    .write_en(cond_reg3_write_en)
);
std_add # (
    .WIDTH(4)
) adder3 (
    .left(adder3_left),
    .out(adder3_out),
    .right(adder3_right)
);
std_lt # (
    .WIDTH(4)
) lt3 (
    .left(lt3_left),
    .out(lt3_out),
    .right(lt3_right)
);
std_reg # (
    .WIDTH(2)
) idx4 (
    .clk(idx4_clk),
    .done(idx4_done),
    .in(idx4_in),
    .out(idx4_out),
    .reset(idx4_reset),
    .write_en(idx4_write_en)
);
std_reg # (
    .WIDTH(1)
) cond_reg4 (
    .clk(cond_reg4_clk),
    .done(cond_reg4_done),
    .in(cond_reg4_in),
    .out(cond_reg4_out),
    .reset(cond_reg4_reset),
    .write_en(cond_reg4_write_en)
);
std_add # (
    .WIDTH(2)
) adder4 (
    .left(adder4_left),
    .out(adder4_out),
    .right(adder4_right)
);
std_lt # (
    .WIDTH(2)
) lt4 (
    .left(lt4_left),
    .out(lt4_out),
    .right(lt4_right)
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
) adder5 (
    .left(adder5_left),
    .out(adder5_out),
    .right(adder5_right)
);
undef # (
    .WIDTH(1)
) ud0 (
    .out(ud0_out)
);
undef # (
    .WIDTH(1)
) ud1 (
    .out(ud1_out)
);
std_add # (
    .WIDTH(4)
) adder6 (
    .left(adder6_left),
    .out(adder6_out),
    .right(adder6_right)
);
undef # (
    .WIDTH(1)
) ud2 (
    .out(ud2_out)
);
std_add # (
    .WIDTH(4)
) adder7 (
    .left(adder7_left),
    .out(adder7_out),
    .right(adder7_right)
);
undef # (
    .WIDTH(1)
) ud3 (
    .out(ud3_out)
);
std_add # (
    .WIDTH(4)
) adder8 (
    .left(adder8_left),
    .out(adder8_out),
    .right(adder8_right)
);
undef # (
    .WIDTH(1)
) ud4 (
    .out(ud4_out)
);
std_add # (
    .WIDTH(4)
) adder9 (
    .left(adder9_left),
    .out(adder9_out),
    .right(adder9_right)
);
undef # (
    .WIDTH(1)
) ud5 (
    .out(ud5_out)
);
std_add # (
    .WIDTH(4)
) adder10 (
    .left(adder10_left),
    .out(adder10_out),
    .right(adder10_right)
);
undef # (
    .WIDTH(1)
) ud6 (
    .out(ud6_out)
);
std_add # (
    .WIDTH(4)
) adder11 (
    .left(adder11_left),
    .out(adder11_out),
    .right(adder11_right)
);
undef # (
    .WIDTH(1)
) ud7 (
    .out(ud7_out)
);
std_add # (
    .WIDTH(4)
) adder12 (
    .left(adder12_left),
    .out(adder12_out),
    .right(adder12_right)
);
undef # (
    .WIDTH(1)
) ud8 (
    .out(ud8_out)
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
    .WIDTH(6)
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
) bb0_16_go (
    .in(bb0_16_go_in),
    .out(bb0_16_go_out)
);
std_wire # (
    .WIDTH(1)
) bb0_16_done (
    .in(bb0_16_done_in),
    .out(bb0_16_done_out)
);
std_wire # (
    .WIDTH(1)
) bb0_20_go (
    .in(bb0_20_go_in),
    .out(bb0_20_go_out)
);
std_wire # (
    .WIDTH(1)
) bb0_20_done (
    .in(bb0_20_done_in),
    .out(bb0_20_done_out)
);
std_wire # (
    .WIDTH(1)
) bb0_27_go (
    .in(bb0_27_go_in),
    .out(bb0_27_go_out)
);
std_wire # (
    .WIDTH(1)
) bb0_27_done (
    .in(bb0_27_done_in),
    .out(bb0_27_done_out)
);
std_wire # (
    .WIDTH(1)
) bb0_30_go (
    .in(bb0_30_go_in),
    .out(bb0_30_go_out)
);
std_wire # (
    .WIDTH(1)
) bb0_30_done (
    .in(bb0_30_done_in),
    .out(bb0_30_done_out)
);
std_wire # (
    .WIDTH(1)
) bb0_31_go (
    .in(bb0_31_go_in),
    .out(bb0_31_go_out)
);
std_wire # (
    .WIDTH(1)
) bb0_31_done (
    .in(bb0_31_done_in),
    .out(bb0_31_done_out)
);
std_wire # (
    .WIDTH(1)
) bb0_34_go (
    .in(bb0_34_go_in),
    .out(bb0_34_go_out)
);
std_wire # (
    .WIDTH(1)
) bb0_34_done (
    .in(bb0_34_done_in),
    .out(bb0_34_done_out)
);
std_wire # (
    .WIDTH(1)
) bb0_35_go (
    .in(bb0_35_go_in),
    .out(bb0_35_go_out)
);
std_wire # (
    .WIDTH(1)
) bb0_35_done (
    .in(bb0_35_done_in),
    .out(bb0_35_done_out)
);
std_wire # (
    .WIDTH(1)
) bb0_42_go (
    .in(bb0_42_go_in),
    .out(bb0_42_go_out)
);
std_wire # (
    .WIDTH(1)
) bb0_42_done (
    .in(bb0_42_done_in),
    .out(bb0_42_done_out)
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
) invoke10_go (
    .in(invoke10_go_in),
    .out(invoke10_go_out)
);
std_wire # (
    .WIDTH(1)
) invoke10_done (
    .in(invoke10_done_in),
    .out(invoke10_done_out)
);
std_wire # (
    .WIDTH(1)
) invoke11_go (
    .in(invoke11_go_in),
    .out(invoke11_go_out)
);
std_wire # (
    .WIDTH(1)
) invoke11_done (
    .in(invoke11_done_in),
    .out(invoke11_done_out)
);
std_wire # (
    .WIDTH(1)
) invoke12_go (
    .in(invoke12_go_in),
    .out(invoke12_go_out)
);
std_wire # (
    .WIDTH(1)
) invoke12_done (
    .in(invoke12_done_in),
    .out(invoke12_done_out)
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
) invoke54_go (
    .in(invoke54_go_in),
    .out(invoke54_go_out)
);
std_wire # (
    .WIDTH(1)
) invoke54_done (
    .in(invoke54_done_in),
    .out(invoke54_done_out)
);
std_wire # (
    .WIDTH(1)
) invoke55_go (
    .in(invoke55_go_in),
    .out(invoke55_go_out)
);
std_wire # (
    .WIDTH(1)
) invoke55_done (
    .in(invoke55_done_in),
    .out(invoke55_done_out)
);
std_wire # (
    .WIDTH(1)
) invoke56_go (
    .in(invoke56_go_in),
    .out(invoke56_go_out)
);
std_wire # (
    .WIDTH(1)
) invoke56_done (
    .in(invoke56_done_in),
    .out(invoke56_done_out)
);
std_wire # (
    .WIDTH(1)
) invoke57_go (
    .in(invoke57_go_in),
    .out(invoke57_go_out)
);
std_wire # (
    .WIDTH(1)
) invoke57_done (
    .in(invoke57_done_in),
    .out(invoke57_done_out)
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
) init_repeat2_go (
    .in(init_repeat2_go_in),
    .out(init_repeat2_go_out)
);
std_wire # (
    .WIDTH(1)
) init_repeat2_done (
    .in(init_repeat2_done_in),
    .out(init_repeat2_done_out)
);
std_wire # (
    .WIDTH(1)
) incr_repeat2_go (
    .in(incr_repeat2_go_in),
    .out(incr_repeat2_go_out)
);
std_wire # (
    .WIDTH(1)
) incr_repeat2_done (
    .in(incr_repeat2_done_in),
    .out(incr_repeat2_done_out)
);
std_wire # (
    .WIDTH(1)
) init_repeat3_go (
    .in(init_repeat3_go_in),
    .out(init_repeat3_go_out)
);
std_wire # (
    .WIDTH(1)
) init_repeat3_done (
    .in(init_repeat3_done_in),
    .out(init_repeat3_done_out)
);
std_wire # (
    .WIDTH(1)
) incr_repeat3_go (
    .in(incr_repeat3_go_in),
    .out(incr_repeat3_go_out)
);
std_wire # (
    .WIDTH(1)
) incr_repeat3_done (
    .in(incr_repeat3_done_in),
    .out(incr_repeat3_done_out)
);
std_wire # (
    .WIDTH(1)
) init_repeat4_go (
    .in(init_repeat4_go_in),
    .out(init_repeat4_go_out)
);
std_wire # (
    .WIDTH(1)
) init_repeat4_done (
    .in(init_repeat4_done_in),
    .out(init_repeat4_done_out)
);
std_wire # (
    .WIDTH(1)
) incr_repeat4_go (
    .in(incr_repeat4_go_in),
    .out(incr_repeat4_go_out)
);
std_wire # (
    .WIDTH(1)
) incr_repeat4_done (
    .in(incr_repeat4_done_in),
    .out(incr_repeat4_done_out)
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
) early_reset_static_par_thread0_go (
    .in(early_reset_static_par_thread0_go_in),
    .out(early_reset_static_par_thread0_go_out)
);
std_wire # (
    .WIDTH(1)
) early_reset_static_par_thread0_done (
    .in(early_reset_static_par_thread0_done_in),
    .out(early_reset_static_par_thread0_done_out)
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
) early_reset_static_seq2_go (
    .in(early_reset_static_seq2_go_in),
    .out(early_reset_static_seq2_go_out)
);
std_wire # (
    .WIDTH(1)
) early_reset_static_seq2_done (
    .in(early_reset_static_seq2_done_in),
    .out(early_reset_static_seq2_done_out)
);
std_wire # (
    .WIDTH(1)
) early_reset_static_seq3_go (
    .in(early_reset_static_seq3_go_in),
    .out(early_reset_static_seq3_go_out)
);
std_wire # (
    .WIDTH(1)
) early_reset_static_seq3_done (
    .in(early_reset_static_seq3_done_in),
    .out(early_reset_static_seq3_done_out)
);
std_wire # (
    .WIDTH(1)
) early_reset_static_seq4_go (
    .in(early_reset_static_seq4_go_in),
    .out(early_reset_static_seq4_go_out)
);
std_wire # (
    .WIDTH(1)
) early_reset_static_seq4_done (
    .in(early_reset_static_seq4_done_in),
    .out(early_reset_static_seq4_done_out)
);
std_wire # (
    .WIDTH(1)
) early_reset_static_seq5_go (
    .in(early_reset_static_seq5_go_in),
    .out(early_reset_static_seq5_go_out)
);
std_wire # (
    .WIDTH(1)
) early_reset_static_seq5_done (
    .in(early_reset_static_seq5_done_in),
    .out(early_reset_static_seq5_done_out)
);
std_wire # (
    .WIDTH(1)
) early_reset_static_seq6_go (
    .in(early_reset_static_seq6_go_in),
    .out(early_reset_static_seq6_go_out)
);
std_wire # (
    .WIDTH(1)
) early_reset_static_seq6_done (
    .in(early_reset_static_seq6_done_in),
    .out(early_reset_static_seq6_done_out)
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
) wrapper_early_reset_static_par_thread0_go (
    .in(wrapper_early_reset_static_par_thread0_go_in),
    .out(wrapper_early_reset_static_par_thread0_go_out)
);
std_wire # (
    .WIDTH(1)
) wrapper_early_reset_static_par_thread0_done (
    .in(wrapper_early_reset_static_par_thread0_done_in),
    .out(wrapper_early_reset_static_par_thread0_done_out)
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
) wrapper_early_reset_static_seq2_go (
    .in(wrapper_early_reset_static_seq2_go_in),
    .out(wrapper_early_reset_static_seq2_go_out)
);
std_wire # (
    .WIDTH(1)
) wrapper_early_reset_static_seq2_done (
    .in(wrapper_early_reset_static_seq2_done_in),
    .out(wrapper_early_reset_static_seq2_done_out)
);
std_wire # (
    .WIDTH(1)
) wrapper_early_reset_static_seq3_go (
    .in(wrapper_early_reset_static_seq3_go_in),
    .out(wrapper_early_reset_static_seq3_go_out)
);
std_wire # (
    .WIDTH(1)
) wrapper_early_reset_static_seq3_done (
    .in(wrapper_early_reset_static_seq3_done_in),
    .out(wrapper_early_reset_static_seq3_done_out)
);
std_wire # (
    .WIDTH(1)
) wrapper_early_reset_static_seq4_go (
    .in(wrapper_early_reset_static_seq4_go_in),
    .out(wrapper_early_reset_static_seq4_go_out)
);
std_wire # (
    .WIDTH(1)
) wrapper_early_reset_static_seq4_done (
    .in(wrapper_early_reset_static_seq4_done_in),
    .out(wrapper_early_reset_static_seq4_done_out)
);
std_wire # (
    .WIDTH(1)
) wrapper_early_reset_static_seq5_go (
    .in(wrapper_early_reset_static_seq5_go_in),
    .out(wrapper_early_reset_static_seq5_go_out)
);
std_wire # (
    .WIDTH(1)
) wrapper_early_reset_static_seq5_done (
    .in(wrapper_early_reset_static_seq5_done_in),
    .out(wrapper_early_reset_static_seq5_done_out)
);
std_wire # (
    .WIDTH(1)
) wrapper_early_reset_static_seq6_go (
    .in(wrapper_early_reset_static_seq6_go_in),
    .out(wrapper_early_reset_static_seq6_go_out)
);
std_wire # (
    .WIDTH(1)
) wrapper_early_reset_static_seq6_done (
    .in(wrapper_early_reset_static_seq6_done_in),
    .out(wrapper_early_reset_static_seq6_done_out)
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
wire _guard1 = invoke16_go_out;
wire _guard2 = invoke55_go_out;
wire _guard3 = _guard1 | _guard2;
wire _guard4 = invoke16_go_out;
wire _guard5 = invoke55_go_out;
wire _guard6 = init_repeat1_go_out;
wire _guard7 = incr_repeat1_go_out;
wire _guard8 = _guard6 | _guard7;
wire _guard9 = init_repeat1_go_out;
wire _guard10 = incr_repeat1_go_out;
wire _guard11 = incr_repeat1_go_out;
wire _guard12 = incr_repeat1_go_out;
wire _guard13 = bb0_6_done_out;
wire _guard14 = ~_guard13;
wire _guard15 = fsm0_out == 6'd7;
wire _guard16 = _guard14 & _guard15;
wire _guard17 = tdcc_go_out;
wire _guard18 = _guard16 & _guard17;
wire _guard19 = bb0_20_done_out;
wire _guard20 = ~_guard19;
wire _guard21 = fsm0_out == 6'd25;
wire _guard22 = _guard20 & _guard21;
wire _guard23 = tdcc_go_out;
wire _guard24 = _guard22 & _guard23;
wire _guard25 = bb0_27_done_out;
wire _guard26 = ~_guard25;
wire _guard27 = fsm0_out == 6'd27;
wire _guard28 = _guard26 & _guard27;
wire _guard29 = tdcc_go_out;
wire _guard30 = _guard28 & _guard29;
wire _guard31 = init_repeat_done_out;
wire _guard32 = ~_guard31;
wire _guard33 = fsm0_out == 6'd5;
wire _guard34 = _guard32 & _guard33;
wire _guard35 = tdcc_go_out;
wire _guard36 = _guard34 & _guard35;
wire _guard37 = fsm_out == 4'd3;
wire _guard38 = fsm_out == 4'd7;
wire _guard39 = _guard37 | _guard38;
wire _guard40 = fsm_out == 4'd11;
wire _guard41 = _guard39 | _guard40;
wire _guard42 = early_reset_static_seq_go_out;
wire _guard43 = _guard41 & _guard42;
wire _guard44 = fsm_out == 4'd3;
wire _guard45 = fsm_out == 4'd7;
wire _guard46 = _guard44 | _guard45;
wire _guard47 = fsm_out == 4'd11;
wire _guard48 = _guard46 | _guard47;
wire _guard49 = early_reset_static_seq0_go_out;
wire _guard50 = _guard48 & _guard49;
wire _guard51 = _guard43 | _guard50;
wire _guard52 = fsm_out == 4'd7;
wire _guard53 = early_reset_static_seq3_go_out;
wire _guard54 = _guard52 & _guard53;
wire _guard55 = _guard51 | _guard54;
wire _guard56 = fsm_out == 4'd3;
wire _guard57 = fsm_out == 4'd7;
wire _guard58 = _guard56 | _guard57;
wire _guard59 = fsm_out == 4'd11;
wire _guard60 = _guard58 | _guard59;
wire _guard61 = early_reset_static_seq6_go_out;
wire _guard62 = _guard60 & _guard61;
wire _guard63 = _guard55 | _guard62;
wire _guard64 = bb0_20_go_out;
wire _guard65 = bb0_16_go_out;
wire _guard66 = bb0_34_go_out;
wire _guard67 = bb0_30_go_out;
wire _guard68 = bb0_20_go_out;
wire _guard69 = bb0_16_go_out;
wire _guard70 = fsm_out == 4'd7;
wire _guard71 = early_reset_static_seq3_go_out;
wire _guard72 = _guard70 & _guard71;
wire _guard73 = fsm_out == 4'd3;
wire _guard74 = fsm_out == 4'd7;
wire _guard75 = _guard73 | _guard74;
wire _guard76 = fsm_out == 4'd11;
wire _guard77 = _guard75 | _guard76;
wire _guard78 = early_reset_static_seq_go_out;
wire _guard79 = _guard77 & _guard78;
wire _guard80 = fsm_out == 4'd3;
wire _guard81 = fsm_out == 4'd7;
wire _guard82 = _guard80 | _guard81;
wire _guard83 = fsm_out == 4'd11;
wire _guard84 = _guard82 | _guard83;
wire _guard85 = early_reset_static_seq0_go_out;
wire _guard86 = _guard84 & _guard85;
wire _guard87 = _guard79 | _guard86;
wire _guard88 = fsm_out == 4'd3;
wire _guard89 = fsm_out == 4'd7;
wire _guard90 = _guard88 | _guard89;
wire _guard91 = fsm_out == 4'd11;
wire _guard92 = _guard90 | _guard91;
wire _guard93 = early_reset_static_seq6_go_out;
wire _guard94 = _guard92 & _guard93;
wire _guard95 = _guard87 | _guard94;
wire _guard96 = bb0_34_go_out;
wire _guard97 = bb0_30_go_out;
wire _guard98 = tdcc_done_out;
wire _guard99 = bb0_6_go_out;
wire _guard100 = bb0_42_go_out;
wire _guard101 = bb0_13_go_out;
wire _guard102 = bb0_13_go_out;
wire _guard103 = bb0_13_go_out;
wire _guard104 = bb0_6_go_out;
wire _guard105 = bb0_42_go_out;
wire _guard106 = _guard104 | _guard105;
wire _guard107 = bb0_6_go_out;
wire _guard108 = bb0_42_go_out;
wire _guard109 = _guard107 | _guard108;
wire _guard110 = bb0_6_go_out;
wire _guard111 = bb0_42_go_out;
wire _guard112 = _guard110 | _guard111;
wire _guard113 = incr_repeat_go_out;
wire _guard114 = incr_repeat_go_out;
wire _guard115 = fsm_out != 4'd11;
wire _guard116 = early_reset_static_seq_go_out;
wire _guard117 = _guard115 & _guard116;
wire _guard118 = fsm_out == 4'd11;
wire _guard119 = early_reset_static_seq_go_out;
wire _guard120 = _guard118 & _guard119;
wire _guard121 = _guard117 | _guard120;
wire _guard122 = fsm_out != 4'd11;
wire _guard123 = early_reset_static_seq0_go_out;
wire _guard124 = _guard122 & _guard123;
wire _guard125 = _guard121 | _guard124;
wire _guard126 = fsm_out == 4'd11;
wire _guard127 = early_reset_static_seq0_go_out;
wire _guard128 = _guard126 & _guard127;
wire _guard129 = _guard125 | _guard128;
wire _guard130 = fsm_out != 4'd2;
wire _guard131 = early_reset_static_seq1_go_out;
wire _guard132 = _guard130 & _guard131;
wire _guard133 = _guard129 | _guard132;
wire _guard134 = fsm_out == 4'd2;
wire _guard135 = early_reset_static_seq1_go_out;
wire _guard136 = _guard134 & _guard135;
wire _guard137 = _guard133 | _guard136;
wire _guard138 = fsm_out != 4'd4;
wire _guard139 = early_reset_static_seq2_go_out;
wire _guard140 = _guard138 & _guard139;
wire _guard141 = _guard137 | _guard140;
wire _guard142 = fsm_out == 4'd4;
wire _guard143 = early_reset_static_seq2_go_out;
wire _guard144 = _guard142 & _guard143;
wire _guard145 = _guard141 | _guard144;
wire _guard146 = fsm_out != 4'd7;
wire _guard147 = early_reset_static_seq3_go_out;
wire _guard148 = _guard146 & _guard147;
wire _guard149 = _guard145 | _guard148;
wire _guard150 = fsm_out == 4'd7;
wire _guard151 = early_reset_static_seq3_go_out;
wire _guard152 = _guard150 & _guard151;
wire _guard153 = _guard149 | _guard152;
wire _guard154 = fsm_out != 4'd3;
wire _guard155 = early_reset_static_seq4_go_out;
wire _guard156 = _guard154 & _guard155;
wire _guard157 = _guard153 | _guard156;
wire _guard158 = fsm_out == 4'd3;
wire _guard159 = early_reset_static_seq4_go_out;
wire _guard160 = _guard158 & _guard159;
wire _guard161 = _guard157 | _guard160;
wire _guard162 = fsm_out != 4'd3;
wire _guard163 = early_reset_static_seq5_go_out;
wire _guard164 = _guard162 & _guard163;
wire _guard165 = _guard161 | _guard164;
wire _guard166 = fsm_out == 4'd3;
wire _guard167 = early_reset_static_seq5_go_out;
wire _guard168 = _guard166 & _guard167;
wire _guard169 = _guard165 | _guard168;
wire _guard170 = fsm_out != 4'd11;
wire _guard171 = early_reset_static_seq6_go_out;
wire _guard172 = _guard170 & _guard171;
wire _guard173 = _guard169 | _guard172;
wire _guard174 = fsm_out == 4'd11;
wire _guard175 = early_reset_static_seq6_go_out;
wire _guard176 = _guard174 & _guard175;
wire _guard177 = _guard173 | _guard176;
wire _guard178 = fsm_out != 4'd3;
wire _guard179 = early_reset_static_seq4_go_out;
wire _guard180 = _guard178 & _guard179;
wire _guard181 = fsm_out != 4'd11;
wire _guard182 = early_reset_static_seq6_go_out;
wire _guard183 = _guard181 & _guard182;
wire _guard184 = fsm_out == 4'd11;
wire _guard185 = early_reset_static_seq_go_out;
wire _guard186 = _guard184 & _guard185;
wire _guard187 = fsm_out == 4'd11;
wire _guard188 = early_reset_static_seq0_go_out;
wire _guard189 = _guard187 & _guard188;
wire _guard190 = _guard186 | _guard189;
wire _guard191 = fsm_out == 4'd2;
wire _guard192 = early_reset_static_seq1_go_out;
wire _guard193 = _guard191 & _guard192;
wire _guard194 = _guard190 | _guard193;
wire _guard195 = fsm_out == 4'd4;
wire _guard196 = early_reset_static_seq2_go_out;
wire _guard197 = _guard195 & _guard196;
wire _guard198 = _guard194 | _guard197;
wire _guard199 = fsm_out == 4'd7;
wire _guard200 = early_reset_static_seq3_go_out;
wire _guard201 = _guard199 & _guard200;
wire _guard202 = _guard198 | _guard201;
wire _guard203 = fsm_out == 4'd3;
wire _guard204 = early_reset_static_seq4_go_out;
wire _guard205 = _guard203 & _guard204;
wire _guard206 = _guard202 | _guard205;
wire _guard207 = fsm_out == 4'd3;
wire _guard208 = early_reset_static_seq5_go_out;
wire _guard209 = _guard207 & _guard208;
wire _guard210 = _guard206 | _guard209;
wire _guard211 = fsm_out == 4'd11;
wire _guard212 = early_reset_static_seq6_go_out;
wire _guard213 = _guard211 & _guard212;
wire _guard214 = _guard210 | _guard213;
wire _guard215 = fsm_out != 4'd11;
wire _guard216 = early_reset_static_seq0_go_out;
wire _guard217 = _guard215 & _guard216;
wire _guard218 = fsm_out != 4'd11;
wire _guard219 = early_reset_static_seq_go_out;
wire _guard220 = _guard218 & _guard219;
wire _guard221 = fsm_out != 4'd3;
wire _guard222 = early_reset_static_seq5_go_out;
wire _guard223 = _guard221 & _guard222;
wire _guard224 = fsm_out != 4'd4;
wire _guard225 = early_reset_static_seq2_go_out;
wire _guard226 = _guard224 & _guard225;
wire _guard227 = fsm_out != 4'd2;
wire _guard228 = early_reset_static_seq1_go_out;
wire _guard229 = _guard227 & _guard228;
wire _guard230 = fsm_out != 4'd7;
wire _guard231 = early_reset_static_seq3_go_out;
wire _guard232 = _guard230 & _guard231;
wire _guard233 = early_reset_static_seq4_go_out;
wire _guard234 = early_reset_static_seq4_go_out;
wire _guard235 = early_reset_static_seq6_go_out;
wire _guard236 = early_reset_static_seq6_go_out;
wire _guard237 = bb0_42_done_out;
wire _guard238 = ~_guard237;
wire _guard239 = fsm0_out == 6'd35;
wire _guard240 = _guard238 & _guard239;
wire _guard241 = tdcc_go_out;
wire _guard242 = _guard240 & _guard241;
wire _guard243 = invoke54_done_out;
wire _guard244 = ~_guard243;
wire _guard245 = fsm0_out == 6'd36;
wire _guard246 = _guard244 & _guard245;
wire _guard247 = tdcc_go_out;
wire _guard248 = _guard246 & _guard247;
wire _guard249 = incr_repeat1_done_out;
wire _guard250 = ~_guard249;
wire _guard251 = fsm0_out == 6'd13;
wire _guard252 = _guard250 & _guard251;
wire _guard253 = tdcc_go_out;
wire _guard254 = _guard252 & _guard253;
wire _guard255 = signal_reg_out;
wire _guard256 = wrapper_early_reset_static_seq5_done_out;
wire _guard257 = ~_guard256;
wire _guard258 = fsm0_out == 6'd31;
wire _guard259 = _guard257 & _guard258;
wire _guard260 = tdcc_go_out;
wire _guard261 = _guard259 & _guard260;
wire _guard262 = early_reset_static_par_thread_go_out;
wire _guard263 = early_reset_static_par_thread0_go_out;
wire _guard264 = _guard262 | _guard263;
wire _guard265 = fsm_out == 4'd2;
wire _guard266 = early_reset_static_seq1_go_out;
wire _guard267 = _guard265 & _guard266;
wire _guard268 = _guard264 | _guard267;
wire _guard269 = fsm_out == 4'd4;
wire _guard270 = early_reset_static_seq2_go_out;
wire _guard271 = _guard269 & _guard270;
wire _guard272 = _guard268 | _guard271;
wire _guard273 = fsm_out == 4'd5;
wire _guard274 = early_reset_static_seq3_go_out;
wire _guard275 = _guard273 & _guard274;
wire _guard276 = _guard272 | _guard275;
wire _guard277 = fsm_out == 4'd3;
wire _guard278 = early_reset_static_seq4_go_out;
wire _guard279 = _guard277 & _guard278;
wire _guard280 = _guard276 | _guard279;
wire _guard281 = fsm_out == 4'd3;
wire _guard282 = early_reset_static_seq5_go_out;
wire _guard283 = _guard281 & _guard282;
wire _guard284 = _guard280 | _guard283;
wire _guard285 = bb0_35_go_out;
wire _guard286 = early_reset_static_par_thread_go_out;
wire _guard287 = fsm_out == 4'd3;
wire _guard288 = early_reset_static_seq5_go_out;
wire _guard289 = _guard287 & _guard288;
wire _guard290 = fsm_out == 4'd3;
wire _guard291 = early_reset_static_seq4_go_out;
wire _guard292 = _guard290 & _guard291;
wire _guard293 = early_reset_static_par_thread0_go_out;
wire _guard294 = fsm_out == 4'd2;
wire _guard295 = early_reset_static_seq1_go_out;
wire _guard296 = _guard294 & _guard295;
wire _guard297 = fsm_out == 4'd4;
wire _guard298 = early_reset_static_seq2_go_out;
wire _guard299 = _guard297 & _guard298;
wire _guard300 = _guard296 | _guard299;
wire _guard301 = bb0_35_go_out;
wire _guard302 = fsm_out == 4'd5;
wire _guard303 = early_reset_static_seq3_go_out;
wire _guard304 = _guard302 & _guard303;
wire _guard305 = init_repeat1_go_out;
wire _guard306 = incr_repeat1_go_out;
wire _guard307 = _guard305 | _guard306;
wire _guard308 = incr_repeat1_go_out;
wire _guard309 = init_repeat1_go_out;
wire _guard310 = incr_repeat1_go_out;
wire _guard311 = incr_repeat1_go_out;
wire _guard312 = incr_repeat2_go_out;
wire _guard313 = incr_repeat2_go_out;
wire _guard314 = init_repeat3_go_out;
wire _guard315 = incr_repeat3_go_out;
wire _guard316 = _guard314 | _guard315;
wire _guard317 = init_repeat3_go_out;
wire _guard318 = incr_repeat3_go_out;
wire _guard319 = incr_repeat4_go_out;
wire _guard320 = incr_repeat4_go_out;
wire _guard321 = invoke2_done_out;
wire _guard322 = ~_guard321;
wire _guard323 = fsm0_out == 6'd2;
wire _guard324 = _guard322 & _guard323;
wire _guard325 = tdcc_go_out;
wire _guard326 = _guard324 & _guard325;
wire _guard327 = wrapper_early_reset_static_par_thread_done_out;
wire _guard328 = ~_guard327;
wire _guard329 = fsm0_out == 6'd0;
wire _guard330 = _guard328 & _guard329;
wire _guard331 = tdcc_go_out;
wire _guard332 = _guard330 & _guard331;
wire _guard333 = fsm_out == 4'd0;
wire _guard334 = early_reset_static_seq3_go_out;
wire _guard335 = _guard333 & _guard334;
wire _guard336 = fsm_out == 4'd2;
wire _guard337 = early_reset_static_seq5_go_out;
wire _guard338 = _guard336 & _guard337;
wire _guard339 = fsm_out == 4'd0;
wire _guard340 = early_reset_static_seq3_go_out;
wire _guard341 = _guard339 & _guard340;
wire _guard342 = fsm_out == 4'd2;
wire _guard343 = early_reset_static_seq5_go_out;
wire _guard344 = _guard342 & _guard343;
wire _guard345 = _guard341 | _guard344;
wire _guard346 = fsm_out == 4'd0;
wire _guard347 = early_reset_static_seq3_go_out;
wire _guard348 = _guard346 & _guard347;
wire _guard349 = fsm_out == 4'd2;
wire _guard350 = early_reset_static_seq5_go_out;
wire _guard351 = _guard349 & _guard350;
wire _guard352 = _guard348 | _guard351;
wire _guard353 = fsm_out == 4'd0;
wire _guard354 = early_reset_static_seq3_go_out;
wire _guard355 = _guard353 & _guard354;
wire _guard356 = init_repeat0_go_out;
wire _guard357 = incr_repeat0_go_out;
wire _guard358 = _guard356 | _guard357;
wire _guard359 = init_repeat0_go_out;
wire _guard360 = incr_repeat0_go_out;
wire _guard361 = cond_reg3_done;
wire _guard362 = idx3_done;
wire _guard363 = _guard361 & _guard362;
wire _guard364 = cond_reg4_done;
wire _guard365 = idx4_done;
wire _guard366 = _guard364 & _guard365;
wire _guard367 = wrapper_early_reset_static_seq4_go_out;
wire _guard368 = fsm_out == 4'd2;
wire _guard369 = early_reset_static_seq3_go_out;
wire _guard370 = _guard368 & _guard369;
wire _guard371 = fsm_out == 4'd0;
wire _guard372 = early_reset_static_seq4_go_out;
wire _guard373 = _guard371 & _guard372;
wire _guard374 = fsm_out == 4'd2;
wire _guard375 = early_reset_static_seq3_go_out;
wire _guard376 = _guard374 & _guard375;
wire _guard377 = fsm_out == 4'd0;
wire _guard378 = early_reset_static_seq4_go_out;
wire _guard379 = _guard377 & _guard378;
wire _guard380 = _guard376 | _guard379;
wire _guard381 = fsm_out == 4'd2;
wire _guard382 = early_reset_static_seq3_go_out;
wire _guard383 = _guard381 & _guard382;
wire _guard384 = fsm_out == 4'd0;
wire _guard385 = early_reset_static_seq4_go_out;
wire _guard386 = _guard384 & _guard385;
wire _guard387 = _guard383 | _guard386;
wire _guard388 = fsm_out == 4'd2;
wire _guard389 = early_reset_static_seq3_go_out;
wire _guard390 = _guard388 & _guard389;
wire _guard391 = init_repeat3_go_out;
wire _guard392 = incr_repeat3_go_out;
wire _guard393 = _guard391 | _guard392;
wire _guard394 = init_repeat3_go_out;
wire _guard395 = incr_repeat3_go_out;
wire _guard396 = init_repeat1_done_out;
wire _guard397 = ~_guard396;
wire _guard398 = fsm0_out == 6'd1;
wire _guard399 = _guard397 & _guard398;
wire _guard400 = tdcc_go_out;
wire _guard401 = _guard399 & _guard400;
wire _guard402 = incr_repeat3_done_out;
wire _guard403 = ~_guard402;
wire _guard404 = fsm0_out == 6'd39;
wire _guard405 = _guard403 & _guard404;
wire _guard406 = tdcc_go_out;
wire _guard407 = _guard405 & _guard406;
wire _guard408 = wrapper_early_reset_static_seq0_go_out;
wire _guard409 = wrapper_early_reset_static_seq5_go_out;
wire _guard410 = signal_reg_out;
wire _guard411 = invoke17_go_out;
wire _guard412 = invoke54_go_out;
wire _guard413 = _guard411 | _guard412;
wire _guard414 = invoke17_go_out;
wire _guard415 = invoke54_go_out;
wire _guard416 = init_repeat0_go_out;
wire _guard417 = incr_repeat0_go_out;
wire _guard418 = _guard416 | _guard417;
wire _guard419 = init_repeat0_go_out;
wire _guard420 = incr_repeat0_go_out;
wire _guard421 = invoke11_done_out;
wire _guard422 = ~_guard421;
wire _guard423 = fsm0_out == 6'd10;
wire _guard424 = _guard422 & _guard423;
wire _guard425 = tdcc_go_out;
wire _guard426 = _guard424 & _guard425;
wire _guard427 = invoke56_done_out;
wire _guard428 = ~_guard427;
wire _guard429 = fsm0_out == 6'd40;
wire _guard430 = _guard428 & _guard429;
wire _guard431 = tdcc_go_out;
wire _guard432 = _guard430 & _guard431;
wire _guard433 = wrapper_early_reset_static_seq2_go_out;
wire _guard434 = wrapper_early_reset_static_seq3_go_out;
wire _guard435 = wrapper_early_reset_static_seq6_go_out;
wire _guard436 = wrapper_early_reset_static_seq0_done_out;
wire _guard437 = ~_guard436;
wire _guard438 = fsm0_out == 6'd20;
wire _guard439 = _guard437 & _guard438;
wire _guard440 = tdcc_go_out;
wire _guard441 = _guard439 & _guard440;
wire _guard442 = bb0_20_go_out;
wire _guard443 = std_mulFN_1_done;
wire _guard444 = ~_guard443;
wire _guard445 = bb0_20_go_out;
wire _guard446 = _guard444 & _guard445;
wire _guard447 = bb0_20_go_out;
wire _guard448 = bb0_16_go_out;
wire _guard449 = std_mulFN_0_done;
wire _guard450 = ~_guard449;
wire _guard451 = bb0_16_go_out;
wire _guard452 = _guard450 & _guard451;
wire _guard453 = bb0_16_go_out;
wire _guard454 = incr_repeat4_go_out;
wire _guard455 = incr_repeat4_go_out;
wire _guard456 = early_reset_static_seq0_go_out;
wire _guard457 = early_reset_static_seq0_go_out;
wire _guard458 = bb0_16_done_out;
wire _guard459 = ~_guard458;
wire _guard460 = fsm0_out == 6'd23;
wire _guard461 = _guard459 & _guard460;
wire _guard462 = tdcc_go_out;
wire _guard463 = _guard461 & _guard462;
wire _guard464 = invoke12_done_out;
wire _guard465 = ~_guard464;
wire _guard466 = fsm0_out == 6'd12;
wire _guard467 = _guard465 & _guard466;
wire _guard468 = tdcc_go_out;
wire _guard469 = _guard467 & _guard468;
wire _guard470 = incr_repeat_done_out;
wire _guard471 = ~_guard470;
wire _guard472 = fsm0_out == 6'd9;
wire _guard473 = _guard471 & _guard472;
wire _guard474 = tdcc_go_out;
wire _guard475 = _guard473 & _guard474;
wire _guard476 = cond_reg1_done;
wire _guard477 = idx1_done;
wire _guard478 = _guard476 & _guard477;
wire _guard479 = wrapper_early_reset_static_seq1_go_out;
wire _guard480 = fsm_out == 4'd0;
wire _guard481 = early_reset_static_seq2_go_out;
wire _guard482 = _guard480 & _guard481;
wire _guard483 = fsm_out == 4'd1;
wire _guard484 = early_reset_static_seq2_go_out;
wire _guard485 = _guard483 & _guard484;
wire _guard486 = fsm_out == 4'd2;
wire _guard487 = early_reset_static_seq4_go_out;
wire _guard488 = _guard486 & _guard487;
wire _guard489 = _guard485 | _guard488;
wire _guard490 = fsm_out == 4'd0;
wire _guard491 = fsm_out == 4'd1;
wire _guard492 = _guard490 | _guard491;
wire _guard493 = early_reset_static_seq2_go_out;
wire _guard494 = _guard492 & _guard493;
wire _guard495 = fsm_out == 4'd2;
wire _guard496 = early_reset_static_seq4_go_out;
wire _guard497 = _guard495 & _guard496;
wire _guard498 = _guard494 | _guard497;
wire _guard499 = fsm_out == 4'd0;
wire _guard500 = fsm_out == 4'd1;
wire _guard501 = _guard499 | _guard500;
wire _guard502 = early_reset_static_seq2_go_out;
wire _guard503 = _guard501 & _guard502;
wire _guard504 = fsm_out == 4'd2;
wire _guard505 = early_reset_static_seq4_go_out;
wire _guard506 = _guard504 & _guard505;
wire _guard507 = _guard503 | _guard506;
wire _guard508 = fsm_out == 4'd0;
wire _guard509 = early_reset_static_seq2_go_out;
wire _guard510 = _guard508 & _guard509;
wire _guard511 = fsm_out == 4'd0;
wire _guard512 = fsm_out == 4'd1;
wire _guard513 = _guard511 | _guard512;
wire _guard514 = early_reset_static_seq1_go_out;
wire _guard515 = _guard513 & _guard514;
wire _guard516 = fsm_out == 4'd0;
wire _guard517 = fsm_out == 4'd1;
wire _guard518 = _guard516 | _guard517;
wire _guard519 = fsm_out == 4'd3;
wire _guard520 = _guard518 | _guard519;
wire _guard521 = early_reset_static_seq2_go_out;
wire _guard522 = _guard520 & _guard521;
wire _guard523 = _guard515 | _guard522;
wire _guard524 = fsm_out == 4'd0;
wire _guard525 = fsm_out == 4'd1;
wire _guard526 = _guard524 | _guard525;
wire _guard527 = fsm_out == 4'd2;
wire _guard528 = _guard526 | _guard527;
wire _guard529 = fsm_out == 4'd3;
wire _guard530 = _guard528 | _guard529;
wire _guard531 = fsm_out == 4'd4;
wire _guard532 = _guard530 | _guard531;
wire _guard533 = fsm_out == 4'd6;
wire _guard534 = _guard532 | _guard533;
wire _guard535 = early_reset_static_seq3_go_out;
wire _guard536 = _guard534 & _guard535;
wire _guard537 = _guard523 | _guard536;
wire _guard538 = fsm_out == 4'd0;
wire _guard539 = fsm_out == 4'd2;
wire _guard540 = _guard538 | _guard539;
wire _guard541 = early_reset_static_seq4_go_out;
wire _guard542 = _guard540 & _guard541;
wire _guard543 = _guard537 | _guard542;
wire _guard544 = fsm_out == 4'd0;
wire _guard545 = fsm_out == 4'd2;
wire _guard546 = _guard544 | _guard545;
wire _guard547 = early_reset_static_seq5_go_out;
wire _guard548 = _guard546 & _guard547;
wire _guard549 = _guard543 | _guard548;
wire _guard550 = invoke2_go_out;
wire _guard551 = invoke11_go_out;
wire _guard552 = _guard550 | _guard551;
wire _guard553 = bb0_31_go_out;
wire _guard554 = invoke2_go_out;
wire _guard555 = bb0_31_go_out;
wire _guard556 = invoke11_go_out;
wire _guard557 = incr_repeat2_go_out;
wire _guard558 = incr_repeat2_go_out;
wire _guard559 = fsm0_out == 6'd43;
wire _guard560 = fsm0_out == 6'd0;
wire _guard561 = wrapper_early_reset_static_par_thread_done_out;
wire _guard562 = _guard560 & _guard561;
wire _guard563 = tdcc_go_out;
wire _guard564 = _guard562 & _guard563;
wire _guard565 = _guard559 | _guard564;
wire _guard566 = fsm0_out == 6'd1;
wire _guard567 = init_repeat1_done_out;
wire _guard568 = cond_reg1_out;
wire _guard569 = _guard567 & _guard568;
wire _guard570 = _guard566 & _guard569;
wire _guard571 = tdcc_go_out;
wire _guard572 = _guard570 & _guard571;
wire _guard573 = _guard565 | _guard572;
wire _guard574 = fsm0_out == 6'd13;
wire _guard575 = incr_repeat1_done_out;
wire _guard576 = cond_reg1_out;
wire _guard577 = _guard575 & _guard576;
wire _guard578 = _guard574 & _guard577;
wire _guard579 = tdcc_go_out;
wire _guard580 = _guard578 & _guard579;
wire _guard581 = _guard573 | _guard580;
wire _guard582 = fsm0_out == 6'd2;
wire _guard583 = invoke2_done_out;
wire _guard584 = _guard582 & _guard583;
wire _guard585 = tdcc_go_out;
wire _guard586 = _guard584 & _guard585;
wire _guard587 = _guard581 | _guard586;
wire _guard588 = fsm0_out == 6'd3;
wire _guard589 = init_repeat0_done_out;
wire _guard590 = cond_reg0_out;
wire _guard591 = _guard589 & _guard590;
wire _guard592 = _guard588 & _guard591;
wire _guard593 = tdcc_go_out;
wire _guard594 = _guard592 & _guard593;
wire _guard595 = _guard587 | _guard594;
wire _guard596 = fsm0_out == 6'd11;
wire _guard597 = incr_repeat0_done_out;
wire _guard598 = cond_reg0_out;
wire _guard599 = _guard597 & _guard598;
wire _guard600 = _guard596 & _guard599;
wire _guard601 = tdcc_go_out;
wire _guard602 = _guard600 & _guard601;
wire _guard603 = _guard595 | _guard602;
wire _guard604 = fsm0_out == 6'd4;
wire _guard605 = invoke3_done_out;
wire _guard606 = _guard604 & _guard605;
wire _guard607 = tdcc_go_out;
wire _guard608 = _guard606 & _guard607;
wire _guard609 = _guard603 | _guard608;
wire _guard610 = fsm0_out == 6'd5;
wire _guard611 = init_repeat_done_out;
wire _guard612 = cond_reg_out;
wire _guard613 = _guard611 & _guard612;
wire _guard614 = _guard610 & _guard613;
wire _guard615 = tdcc_go_out;
wire _guard616 = _guard614 & _guard615;
wire _guard617 = _guard609 | _guard616;
wire _guard618 = fsm0_out == 6'd9;
wire _guard619 = incr_repeat_done_out;
wire _guard620 = cond_reg_out;
wire _guard621 = _guard619 & _guard620;
wire _guard622 = _guard618 & _guard621;
wire _guard623 = tdcc_go_out;
wire _guard624 = _guard622 & _guard623;
wire _guard625 = _guard617 | _guard624;
wire _guard626 = fsm0_out == 6'd6;
wire _guard627 = wrapper_early_reset_static_seq_done_out;
wire _guard628 = _guard626 & _guard627;
wire _guard629 = tdcc_go_out;
wire _guard630 = _guard628 & _guard629;
wire _guard631 = _guard625 | _guard630;
wire _guard632 = fsm0_out == 6'd7;
wire _guard633 = bb0_6_done_out;
wire _guard634 = _guard632 & _guard633;
wire _guard635 = tdcc_go_out;
wire _guard636 = _guard634 & _guard635;
wire _guard637 = _guard631 | _guard636;
wire _guard638 = fsm0_out == 6'd8;
wire _guard639 = invoke10_done_out;
wire _guard640 = _guard638 & _guard639;
wire _guard641 = tdcc_go_out;
wire _guard642 = _guard640 & _guard641;
wire _guard643 = _guard637 | _guard642;
wire _guard644 = fsm0_out == 6'd5;
wire _guard645 = init_repeat_done_out;
wire _guard646 = cond_reg_out;
wire _guard647 = ~_guard646;
wire _guard648 = _guard645 & _guard647;
wire _guard649 = _guard644 & _guard648;
wire _guard650 = tdcc_go_out;
wire _guard651 = _guard649 & _guard650;
wire _guard652 = _guard643 | _guard651;
wire _guard653 = fsm0_out == 6'd9;
wire _guard654 = incr_repeat_done_out;
wire _guard655 = cond_reg_out;
wire _guard656 = ~_guard655;
wire _guard657 = _guard654 & _guard656;
wire _guard658 = _guard653 & _guard657;
wire _guard659 = tdcc_go_out;
wire _guard660 = _guard658 & _guard659;
wire _guard661 = _guard652 | _guard660;
wire _guard662 = fsm0_out == 6'd10;
wire _guard663 = invoke11_done_out;
wire _guard664 = _guard662 & _guard663;
wire _guard665 = tdcc_go_out;
wire _guard666 = _guard664 & _guard665;
wire _guard667 = _guard661 | _guard666;
wire _guard668 = fsm0_out == 6'd3;
wire _guard669 = init_repeat0_done_out;
wire _guard670 = cond_reg0_out;
wire _guard671 = ~_guard670;
wire _guard672 = _guard669 & _guard671;
wire _guard673 = _guard668 & _guard672;
wire _guard674 = tdcc_go_out;
wire _guard675 = _guard673 & _guard674;
wire _guard676 = _guard667 | _guard675;
wire _guard677 = fsm0_out == 6'd11;
wire _guard678 = incr_repeat0_done_out;
wire _guard679 = cond_reg0_out;
wire _guard680 = ~_guard679;
wire _guard681 = _guard678 & _guard680;
wire _guard682 = _guard677 & _guard681;
wire _guard683 = tdcc_go_out;
wire _guard684 = _guard682 & _guard683;
wire _guard685 = _guard676 | _guard684;
wire _guard686 = fsm0_out == 6'd12;
wire _guard687 = invoke12_done_out;
wire _guard688 = _guard686 & _guard687;
wire _guard689 = tdcc_go_out;
wire _guard690 = _guard688 & _guard689;
wire _guard691 = _guard685 | _guard690;
wire _guard692 = fsm0_out == 6'd1;
wire _guard693 = init_repeat1_done_out;
wire _guard694 = cond_reg1_out;
wire _guard695 = ~_guard694;
wire _guard696 = _guard693 & _guard695;
wire _guard697 = _guard692 & _guard696;
wire _guard698 = tdcc_go_out;
wire _guard699 = _guard697 & _guard698;
wire _guard700 = _guard691 | _guard699;
wire _guard701 = fsm0_out == 6'd13;
wire _guard702 = incr_repeat1_done_out;
wire _guard703 = cond_reg1_out;
wire _guard704 = ~_guard703;
wire _guard705 = _guard702 & _guard704;
wire _guard706 = _guard701 & _guard705;
wire _guard707 = tdcc_go_out;
wire _guard708 = _guard706 & _guard707;
wire _guard709 = _guard700 | _guard708;
wire _guard710 = fsm0_out == 6'd14;
wire _guard711 = wrapper_early_reset_static_par_thread0_done_out;
wire _guard712 = _guard710 & _guard711;
wire _guard713 = tdcc_go_out;
wire _guard714 = _guard712 & _guard713;
wire _guard715 = _guard709 | _guard714;
wire _guard716 = fsm0_out == 6'd15;
wire _guard717 = init_repeat4_done_out;
wire _guard718 = cond_reg4_out;
wire _guard719 = _guard717 & _guard718;
wire _guard720 = _guard716 & _guard719;
wire _guard721 = tdcc_go_out;
wire _guard722 = _guard720 & _guard721;
wire _guard723 = _guard715 | _guard722;
wire _guard724 = fsm0_out == 6'd41;
wire _guard725 = incr_repeat4_done_out;
wire _guard726 = cond_reg4_out;
wire _guard727 = _guard725 & _guard726;
wire _guard728 = _guard724 & _guard727;
wire _guard729 = tdcc_go_out;
wire _guard730 = _guard728 & _guard729;
wire _guard731 = _guard723 | _guard730;
wire _guard732 = fsm0_out == 6'd16;
wire _guard733 = invoke16_done_out;
wire _guard734 = _guard732 & _guard733;
wire _guard735 = tdcc_go_out;
wire _guard736 = _guard734 & _guard735;
wire _guard737 = _guard731 | _guard736;
wire _guard738 = fsm0_out == 6'd17;
wire _guard739 = init_repeat3_done_out;
wire _guard740 = cond_reg3_out;
wire _guard741 = _guard739 & _guard740;
wire _guard742 = _guard738 & _guard741;
wire _guard743 = tdcc_go_out;
wire _guard744 = _guard742 & _guard743;
wire _guard745 = _guard737 | _guard744;
wire _guard746 = fsm0_out == 6'd39;
wire _guard747 = incr_repeat3_done_out;
wire _guard748 = cond_reg3_out;
wire _guard749 = _guard747 & _guard748;
wire _guard750 = _guard746 & _guard749;
wire _guard751 = tdcc_go_out;
wire _guard752 = _guard750 & _guard751;
wire _guard753 = _guard745 | _guard752;
wire _guard754 = fsm0_out == 6'd18;
wire _guard755 = invoke17_done_out;
wire _guard756 = _guard754 & _guard755;
wire _guard757 = tdcc_go_out;
wire _guard758 = _guard756 & _guard757;
wire _guard759 = _guard753 | _guard758;
wire _guard760 = fsm0_out == 6'd19;
wire _guard761 = init_repeat2_done_out;
wire _guard762 = cond_reg2_out;
wire _guard763 = _guard761 & _guard762;
wire _guard764 = _guard760 & _guard763;
wire _guard765 = tdcc_go_out;
wire _guard766 = _guard764 & _guard765;
wire _guard767 = _guard759 | _guard766;
wire _guard768 = fsm0_out == 6'd37;
wire _guard769 = incr_repeat2_done_out;
wire _guard770 = cond_reg2_out;
wire _guard771 = _guard769 & _guard770;
wire _guard772 = _guard768 & _guard771;
wire _guard773 = tdcc_go_out;
wire _guard774 = _guard772 & _guard773;
wire _guard775 = _guard767 | _guard774;
wire _guard776 = fsm0_out == 6'd20;
wire _guard777 = wrapper_early_reset_static_seq0_done_out;
wire _guard778 = _guard776 & _guard777;
wire _guard779 = tdcc_go_out;
wire _guard780 = _guard778 & _guard779;
wire _guard781 = _guard775 | _guard780;
wire _guard782 = fsm0_out == 6'd21;
wire _guard783 = bb0_13_done_out;
wire _guard784 = _guard782 & _guard783;
wire _guard785 = tdcc_go_out;
wire _guard786 = _guard784 & _guard785;
wire _guard787 = _guard781 | _guard786;
wire _guard788 = fsm0_out == 6'd22;
wire _guard789 = wrapper_early_reset_static_seq1_done_out;
wire _guard790 = _guard788 & _guard789;
wire _guard791 = tdcc_go_out;
wire _guard792 = _guard790 & _guard791;
wire _guard793 = _guard787 | _guard792;
wire _guard794 = fsm0_out == 6'd23;
wire _guard795 = bb0_16_done_out;
wire _guard796 = _guard794 & _guard795;
wire _guard797 = tdcc_go_out;
wire _guard798 = _guard796 & _guard797;
wire _guard799 = _guard793 | _guard798;
wire _guard800 = fsm0_out == 6'd24;
wire _guard801 = wrapper_early_reset_static_seq2_done_out;
wire _guard802 = _guard800 & _guard801;
wire _guard803 = tdcc_go_out;
wire _guard804 = _guard802 & _guard803;
wire _guard805 = _guard799 | _guard804;
wire _guard806 = fsm0_out == 6'd25;
wire _guard807 = bb0_20_done_out;
wire _guard808 = _guard806 & _guard807;
wire _guard809 = tdcc_go_out;
wire _guard810 = _guard808 & _guard809;
wire _guard811 = _guard805 | _guard810;
wire _guard812 = fsm0_out == 6'd26;
wire _guard813 = wrapper_early_reset_static_seq3_done_out;
wire _guard814 = _guard812 & _guard813;
wire _guard815 = tdcc_go_out;
wire _guard816 = _guard814 & _guard815;
wire _guard817 = _guard811 | _guard816;
wire _guard818 = fsm0_out == 6'd27;
wire _guard819 = bb0_27_done_out;
wire _guard820 = _guard818 & _guard819;
wire _guard821 = tdcc_go_out;
wire _guard822 = _guard820 & _guard821;
wire _guard823 = _guard817 | _guard822;
wire _guard824 = fsm0_out == 6'd28;
wire _guard825 = wrapper_early_reset_static_seq4_done_out;
wire _guard826 = _guard824 & _guard825;
wire _guard827 = tdcc_go_out;
wire _guard828 = _guard826 & _guard827;
wire _guard829 = _guard823 | _guard828;
wire _guard830 = fsm0_out == 6'd29;
wire _guard831 = bb0_30_done_out;
wire _guard832 = _guard830 & _guard831;
wire _guard833 = tdcc_go_out;
wire _guard834 = _guard832 & _guard833;
wire _guard835 = _guard829 | _guard834;
wire _guard836 = fsm0_out == 6'd30;
wire _guard837 = bb0_31_done_out;
wire _guard838 = _guard836 & _guard837;
wire _guard839 = tdcc_go_out;
wire _guard840 = _guard838 & _guard839;
wire _guard841 = _guard835 | _guard840;
wire _guard842 = fsm0_out == 6'd31;
wire _guard843 = wrapper_early_reset_static_seq5_done_out;
wire _guard844 = _guard842 & _guard843;
wire _guard845 = tdcc_go_out;
wire _guard846 = _guard844 & _guard845;
wire _guard847 = _guard841 | _guard846;
wire _guard848 = fsm0_out == 6'd32;
wire _guard849 = bb0_34_done_out;
wire _guard850 = _guard848 & _guard849;
wire _guard851 = tdcc_go_out;
wire _guard852 = _guard850 & _guard851;
wire _guard853 = _guard847 | _guard852;
wire _guard854 = fsm0_out == 6'd33;
wire _guard855 = bb0_35_done_out;
wire _guard856 = _guard854 & _guard855;
wire _guard857 = tdcc_go_out;
wire _guard858 = _guard856 & _guard857;
wire _guard859 = _guard853 | _guard858;
wire _guard860 = fsm0_out == 6'd34;
wire _guard861 = wrapper_early_reset_static_seq6_done_out;
wire _guard862 = _guard860 & _guard861;
wire _guard863 = tdcc_go_out;
wire _guard864 = _guard862 & _guard863;
wire _guard865 = _guard859 | _guard864;
wire _guard866 = fsm0_out == 6'd35;
wire _guard867 = bb0_42_done_out;
wire _guard868 = _guard866 & _guard867;
wire _guard869 = tdcc_go_out;
wire _guard870 = _guard868 & _guard869;
wire _guard871 = _guard865 | _guard870;
wire _guard872 = fsm0_out == 6'd36;
wire _guard873 = invoke54_done_out;
wire _guard874 = _guard872 & _guard873;
wire _guard875 = tdcc_go_out;
wire _guard876 = _guard874 & _guard875;
wire _guard877 = _guard871 | _guard876;
wire _guard878 = fsm0_out == 6'd19;
wire _guard879 = init_repeat2_done_out;
wire _guard880 = cond_reg2_out;
wire _guard881 = ~_guard880;
wire _guard882 = _guard879 & _guard881;
wire _guard883 = _guard878 & _guard882;
wire _guard884 = tdcc_go_out;
wire _guard885 = _guard883 & _guard884;
wire _guard886 = _guard877 | _guard885;
wire _guard887 = fsm0_out == 6'd37;
wire _guard888 = incr_repeat2_done_out;
wire _guard889 = cond_reg2_out;
wire _guard890 = ~_guard889;
wire _guard891 = _guard888 & _guard890;
wire _guard892 = _guard887 & _guard891;
wire _guard893 = tdcc_go_out;
wire _guard894 = _guard892 & _guard893;
wire _guard895 = _guard886 | _guard894;
wire _guard896 = fsm0_out == 6'd38;
wire _guard897 = invoke55_done_out;
wire _guard898 = _guard896 & _guard897;
wire _guard899 = tdcc_go_out;
wire _guard900 = _guard898 & _guard899;
wire _guard901 = _guard895 | _guard900;
wire _guard902 = fsm0_out == 6'd17;
wire _guard903 = init_repeat3_done_out;
wire _guard904 = cond_reg3_out;
wire _guard905 = ~_guard904;
wire _guard906 = _guard903 & _guard905;
wire _guard907 = _guard902 & _guard906;
wire _guard908 = tdcc_go_out;
wire _guard909 = _guard907 & _guard908;
wire _guard910 = _guard901 | _guard909;
wire _guard911 = fsm0_out == 6'd39;
wire _guard912 = incr_repeat3_done_out;
wire _guard913 = cond_reg3_out;
wire _guard914 = ~_guard913;
wire _guard915 = _guard912 & _guard914;
wire _guard916 = _guard911 & _guard915;
wire _guard917 = tdcc_go_out;
wire _guard918 = _guard916 & _guard917;
wire _guard919 = _guard910 | _guard918;
wire _guard920 = fsm0_out == 6'd40;
wire _guard921 = invoke56_done_out;
wire _guard922 = _guard920 & _guard921;
wire _guard923 = tdcc_go_out;
wire _guard924 = _guard922 & _guard923;
wire _guard925 = _guard919 | _guard924;
wire _guard926 = fsm0_out == 6'd15;
wire _guard927 = init_repeat4_done_out;
wire _guard928 = cond_reg4_out;
wire _guard929 = ~_guard928;
wire _guard930 = _guard927 & _guard929;
wire _guard931 = _guard926 & _guard930;
wire _guard932 = tdcc_go_out;
wire _guard933 = _guard931 & _guard932;
wire _guard934 = _guard925 | _guard933;
wire _guard935 = fsm0_out == 6'd41;
wire _guard936 = incr_repeat4_done_out;
wire _guard937 = cond_reg4_out;
wire _guard938 = ~_guard937;
wire _guard939 = _guard936 & _guard938;
wire _guard940 = _guard935 & _guard939;
wire _guard941 = tdcc_go_out;
wire _guard942 = _guard940 & _guard941;
wire _guard943 = _guard934 | _guard942;
wire _guard944 = fsm0_out == 6'd42;
wire _guard945 = invoke57_done_out;
wire _guard946 = _guard944 & _guard945;
wire _guard947 = tdcc_go_out;
wire _guard948 = _guard946 & _guard947;
wire _guard949 = _guard943 | _guard948;
wire _guard950 = fsm0_out == 6'd8;
wire _guard951 = invoke10_done_out;
wire _guard952 = _guard950 & _guard951;
wire _guard953 = tdcc_go_out;
wire _guard954 = _guard952 & _guard953;
wire _guard955 = fsm0_out == 6'd18;
wire _guard956 = invoke17_done_out;
wire _guard957 = _guard955 & _guard956;
wire _guard958 = tdcc_go_out;
wire _guard959 = _guard957 & _guard958;
wire _guard960 = fsm0_out == 6'd32;
wire _guard961 = bb0_34_done_out;
wire _guard962 = _guard960 & _guard961;
wire _guard963 = tdcc_go_out;
wire _guard964 = _guard962 & _guard963;
wire _guard965 = fsm0_out == 6'd34;
wire _guard966 = wrapper_early_reset_static_seq6_done_out;
wire _guard967 = _guard965 & _guard966;
wire _guard968 = tdcc_go_out;
wire _guard969 = _guard967 & _guard968;
wire _guard970 = fsm0_out == 6'd3;
wire _guard971 = init_repeat0_done_out;
wire _guard972 = cond_reg0_out;
wire _guard973 = _guard971 & _guard972;
wire _guard974 = _guard970 & _guard973;
wire _guard975 = tdcc_go_out;
wire _guard976 = _guard974 & _guard975;
wire _guard977 = fsm0_out == 6'd11;
wire _guard978 = incr_repeat0_done_out;
wire _guard979 = cond_reg0_out;
wire _guard980 = _guard978 & _guard979;
wire _guard981 = _guard977 & _guard980;
wire _guard982 = tdcc_go_out;
wire _guard983 = _guard981 & _guard982;
wire _guard984 = _guard976 | _guard983;
wire _guard985 = fsm0_out == 6'd19;
wire _guard986 = init_repeat2_done_out;
wire _guard987 = cond_reg2_out;
wire _guard988 = _guard986 & _guard987;
wire _guard989 = _guard985 & _guard988;
wire _guard990 = tdcc_go_out;
wire _guard991 = _guard989 & _guard990;
wire _guard992 = fsm0_out == 6'd37;
wire _guard993 = incr_repeat2_done_out;
wire _guard994 = cond_reg2_out;
wire _guard995 = _guard993 & _guard994;
wire _guard996 = _guard992 & _guard995;
wire _guard997 = tdcc_go_out;
wire _guard998 = _guard996 & _guard997;
wire _guard999 = _guard991 | _guard998;
wire _guard1000 = fsm0_out == 6'd1;
wire _guard1001 = init_repeat1_done_out;
wire _guard1002 = cond_reg1_out;
wire _guard1003 = ~_guard1002;
wire _guard1004 = _guard1001 & _guard1003;
wire _guard1005 = _guard1000 & _guard1004;
wire _guard1006 = tdcc_go_out;
wire _guard1007 = _guard1005 & _guard1006;
wire _guard1008 = fsm0_out == 6'd13;
wire _guard1009 = incr_repeat1_done_out;
wire _guard1010 = cond_reg1_out;
wire _guard1011 = ~_guard1010;
wire _guard1012 = _guard1009 & _guard1011;
wire _guard1013 = _guard1008 & _guard1012;
wire _guard1014 = tdcc_go_out;
wire _guard1015 = _guard1013 & _guard1014;
wire _guard1016 = _guard1007 | _guard1015;
wire _guard1017 = fsm0_out == 6'd20;
wire _guard1018 = wrapper_early_reset_static_seq0_done_out;
wire _guard1019 = _guard1017 & _guard1018;
wire _guard1020 = tdcc_go_out;
wire _guard1021 = _guard1019 & _guard1020;
wire _guard1022 = fsm0_out == 6'd25;
wire _guard1023 = bb0_20_done_out;
wire _guard1024 = _guard1022 & _guard1023;
wire _guard1025 = tdcc_go_out;
wire _guard1026 = _guard1024 & _guard1025;
wire _guard1027 = fsm0_out == 6'd31;
wire _guard1028 = wrapper_early_reset_static_seq5_done_out;
wire _guard1029 = _guard1027 & _guard1028;
wire _guard1030 = tdcc_go_out;
wire _guard1031 = _guard1029 & _guard1030;
wire _guard1032 = fsm0_out == 6'd10;
wire _guard1033 = invoke11_done_out;
wire _guard1034 = _guard1032 & _guard1033;
wire _guard1035 = tdcc_go_out;
wire _guard1036 = _guard1034 & _guard1035;
wire _guard1037 = fsm0_out == 6'd28;
wire _guard1038 = wrapper_early_reset_static_seq4_done_out;
wire _guard1039 = _guard1037 & _guard1038;
wire _guard1040 = tdcc_go_out;
wire _guard1041 = _guard1039 & _guard1040;
wire _guard1042 = fsm0_out == 6'd26;
wire _guard1043 = wrapper_early_reset_static_seq3_done_out;
wire _guard1044 = _guard1042 & _guard1043;
wire _guard1045 = tdcc_go_out;
wire _guard1046 = _guard1044 & _guard1045;
wire _guard1047 = fsm0_out == 6'd33;
wire _guard1048 = bb0_35_done_out;
wire _guard1049 = _guard1047 & _guard1048;
wire _guard1050 = tdcc_go_out;
wire _guard1051 = _guard1049 & _guard1050;
wire _guard1052 = fsm0_out == 6'd38;
wire _guard1053 = invoke55_done_out;
wire _guard1054 = _guard1052 & _guard1053;
wire _guard1055 = tdcc_go_out;
wire _guard1056 = _guard1054 & _guard1055;
wire _guard1057 = fsm0_out == 6'd4;
wire _guard1058 = invoke3_done_out;
wire _guard1059 = _guard1057 & _guard1058;
wire _guard1060 = tdcc_go_out;
wire _guard1061 = _guard1059 & _guard1060;
wire _guard1062 = fsm0_out == 6'd3;
wire _guard1063 = init_repeat0_done_out;
wire _guard1064 = cond_reg0_out;
wire _guard1065 = ~_guard1064;
wire _guard1066 = _guard1063 & _guard1065;
wire _guard1067 = _guard1062 & _guard1066;
wire _guard1068 = tdcc_go_out;
wire _guard1069 = _guard1067 & _guard1068;
wire _guard1070 = fsm0_out == 6'd11;
wire _guard1071 = incr_repeat0_done_out;
wire _guard1072 = cond_reg0_out;
wire _guard1073 = ~_guard1072;
wire _guard1074 = _guard1071 & _guard1073;
wire _guard1075 = _guard1070 & _guard1074;
wire _guard1076 = tdcc_go_out;
wire _guard1077 = _guard1075 & _guard1076;
wire _guard1078 = _guard1069 | _guard1077;
wire _guard1079 = fsm0_out == 6'd2;
wire _guard1080 = invoke2_done_out;
wire _guard1081 = _guard1079 & _guard1080;
wire _guard1082 = tdcc_go_out;
wire _guard1083 = _guard1081 & _guard1082;
wire _guard1084 = fsm0_out == 6'd7;
wire _guard1085 = bb0_6_done_out;
wire _guard1086 = _guard1084 & _guard1085;
wire _guard1087 = tdcc_go_out;
wire _guard1088 = _guard1086 & _guard1087;
wire _guard1089 = fsm0_out == 6'd27;
wire _guard1090 = bb0_27_done_out;
wire _guard1091 = _guard1089 & _guard1090;
wire _guard1092 = tdcc_go_out;
wire _guard1093 = _guard1091 & _guard1092;
wire _guard1094 = fsm0_out == 6'd35;
wire _guard1095 = bb0_42_done_out;
wire _guard1096 = _guard1094 & _guard1095;
wire _guard1097 = tdcc_go_out;
wire _guard1098 = _guard1096 & _guard1097;
wire _guard1099 = fsm0_out == 6'd40;
wire _guard1100 = invoke56_done_out;
wire _guard1101 = _guard1099 & _guard1100;
wire _guard1102 = tdcc_go_out;
wire _guard1103 = _guard1101 & _guard1102;
wire _guard1104 = fsm0_out == 6'd15;
wire _guard1105 = init_repeat4_done_out;
wire _guard1106 = cond_reg4_out;
wire _guard1107 = ~_guard1106;
wire _guard1108 = _guard1105 & _guard1107;
wire _guard1109 = _guard1104 & _guard1108;
wire _guard1110 = tdcc_go_out;
wire _guard1111 = _guard1109 & _guard1110;
wire _guard1112 = fsm0_out == 6'd41;
wire _guard1113 = incr_repeat4_done_out;
wire _guard1114 = cond_reg4_out;
wire _guard1115 = ~_guard1114;
wire _guard1116 = _guard1113 & _guard1115;
wire _guard1117 = _guard1112 & _guard1116;
wire _guard1118 = tdcc_go_out;
wire _guard1119 = _guard1117 & _guard1118;
wire _guard1120 = _guard1111 | _guard1119;
wire _guard1121 = fsm0_out == 6'd6;
wire _guard1122 = wrapper_early_reset_static_seq_done_out;
wire _guard1123 = _guard1121 & _guard1122;
wire _guard1124 = tdcc_go_out;
wire _guard1125 = _guard1123 & _guard1124;
wire _guard1126 = fsm0_out == 6'd12;
wire _guard1127 = invoke12_done_out;
wire _guard1128 = _guard1126 & _guard1127;
wire _guard1129 = tdcc_go_out;
wire _guard1130 = _guard1128 & _guard1129;
wire _guard1131 = fsm0_out == 6'd15;
wire _guard1132 = init_repeat4_done_out;
wire _guard1133 = cond_reg4_out;
wire _guard1134 = _guard1132 & _guard1133;
wire _guard1135 = _guard1131 & _guard1134;
wire _guard1136 = tdcc_go_out;
wire _guard1137 = _guard1135 & _guard1136;
wire _guard1138 = fsm0_out == 6'd41;
wire _guard1139 = incr_repeat4_done_out;
wire _guard1140 = cond_reg4_out;
wire _guard1141 = _guard1139 & _guard1140;
wire _guard1142 = _guard1138 & _guard1141;
wire _guard1143 = tdcc_go_out;
wire _guard1144 = _guard1142 & _guard1143;
wire _guard1145 = _guard1137 | _guard1144;
wire _guard1146 = fsm0_out == 6'd30;
wire _guard1147 = bb0_31_done_out;
wire _guard1148 = _guard1146 & _guard1147;
wire _guard1149 = tdcc_go_out;
wire _guard1150 = _guard1148 & _guard1149;
wire _guard1151 = fsm0_out == 6'd21;
wire _guard1152 = bb0_13_done_out;
wire _guard1153 = _guard1151 & _guard1152;
wire _guard1154 = tdcc_go_out;
wire _guard1155 = _guard1153 & _guard1154;
wire _guard1156 = fsm0_out == 6'd29;
wire _guard1157 = bb0_30_done_out;
wire _guard1158 = _guard1156 & _guard1157;
wire _guard1159 = tdcc_go_out;
wire _guard1160 = _guard1158 & _guard1159;
wire _guard1161 = fsm0_out == 6'd43;
wire _guard1162 = fsm0_out == 6'd5;
wire _guard1163 = init_repeat_done_out;
wire _guard1164 = cond_reg_out;
wire _guard1165 = _guard1163 & _guard1164;
wire _guard1166 = _guard1162 & _guard1165;
wire _guard1167 = tdcc_go_out;
wire _guard1168 = _guard1166 & _guard1167;
wire _guard1169 = fsm0_out == 6'd9;
wire _guard1170 = incr_repeat_done_out;
wire _guard1171 = cond_reg_out;
wire _guard1172 = _guard1170 & _guard1171;
wire _guard1173 = _guard1169 & _guard1172;
wire _guard1174 = tdcc_go_out;
wire _guard1175 = _guard1173 & _guard1174;
wire _guard1176 = _guard1168 | _guard1175;
wire _guard1177 = fsm0_out == 6'd5;
wire _guard1178 = init_repeat_done_out;
wire _guard1179 = cond_reg_out;
wire _guard1180 = ~_guard1179;
wire _guard1181 = _guard1178 & _guard1180;
wire _guard1182 = _guard1177 & _guard1181;
wire _guard1183 = tdcc_go_out;
wire _guard1184 = _guard1182 & _guard1183;
wire _guard1185 = fsm0_out == 6'd9;
wire _guard1186 = incr_repeat_done_out;
wire _guard1187 = cond_reg_out;
wire _guard1188 = ~_guard1187;
wire _guard1189 = _guard1186 & _guard1188;
wire _guard1190 = _guard1185 & _guard1189;
wire _guard1191 = tdcc_go_out;
wire _guard1192 = _guard1190 & _guard1191;
wire _guard1193 = _guard1184 | _guard1192;
wire _guard1194 = fsm0_out == 6'd23;
wire _guard1195 = bb0_16_done_out;
wire _guard1196 = _guard1194 & _guard1195;
wire _guard1197 = tdcc_go_out;
wire _guard1198 = _guard1196 & _guard1197;
wire _guard1199 = fsm0_out == 6'd1;
wire _guard1200 = init_repeat1_done_out;
wire _guard1201 = cond_reg1_out;
wire _guard1202 = _guard1200 & _guard1201;
wire _guard1203 = _guard1199 & _guard1202;
wire _guard1204 = tdcc_go_out;
wire _guard1205 = _guard1203 & _guard1204;
wire _guard1206 = fsm0_out == 6'd13;
wire _guard1207 = incr_repeat1_done_out;
wire _guard1208 = cond_reg1_out;
wire _guard1209 = _guard1207 & _guard1208;
wire _guard1210 = _guard1206 & _guard1209;
wire _guard1211 = tdcc_go_out;
wire _guard1212 = _guard1210 & _guard1211;
wire _guard1213 = _guard1205 | _guard1212;
wire _guard1214 = fsm0_out == 6'd14;
wire _guard1215 = wrapper_early_reset_static_par_thread0_done_out;
wire _guard1216 = _guard1214 & _guard1215;
wire _guard1217 = tdcc_go_out;
wire _guard1218 = _guard1216 & _guard1217;
wire _guard1219 = fsm0_out == 6'd16;
wire _guard1220 = invoke16_done_out;
wire _guard1221 = _guard1219 & _guard1220;
wire _guard1222 = tdcc_go_out;
wire _guard1223 = _guard1221 & _guard1222;
wire _guard1224 = fsm0_out == 6'd22;
wire _guard1225 = wrapper_early_reset_static_seq1_done_out;
wire _guard1226 = _guard1224 & _guard1225;
wire _guard1227 = tdcc_go_out;
wire _guard1228 = _guard1226 & _guard1227;
wire _guard1229 = fsm0_out == 6'd17;
wire _guard1230 = init_repeat3_done_out;
wire _guard1231 = cond_reg3_out;
wire _guard1232 = ~_guard1231;
wire _guard1233 = _guard1230 & _guard1232;
wire _guard1234 = _guard1229 & _guard1233;
wire _guard1235 = tdcc_go_out;
wire _guard1236 = _guard1234 & _guard1235;
wire _guard1237 = fsm0_out == 6'd39;
wire _guard1238 = incr_repeat3_done_out;
wire _guard1239 = cond_reg3_out;
wire _guard1240 = ~_guard1239;
wire _guard1241 = _guard1238 & _guard1240;
wire _guard1242 = _guard1237 & _guard1241;
wire _guard1243 = tdcc_go_out;
wire _guard1244 = _guard1242 & _guard1243;
wire _guard1245 = _guard1236 | _guard1244;
wire _guard1246 = fsm0_out == 6'd24;
wire _guard1247 = wrapper_early_reset_static_seq2_done_out;
wire _guard1248 = _guard1246 & _guard1247;
wire _guard1249 = tdcc_go_out;
wire _guard1250 = _guard1248 & _guard1249;
wire _guard1251 = fsm0_out == 6'd19;
wire _guard1252 = init_repeat2_done_out;
wire _guard1253 = cond_reg2_out;
wire _guard1254 = ~_guard1253;
wire _guard1255 = _guard1252 & _guard1254;
wire _guard1256 = _guard1251 & _guard1255;
wire _guard1257 = tdcc_go_out;
wire _guard1258 = _guard1256 & _guard1257;
wire _guard1259 = fsm0_out == 6'd37;
wire _guard1260 = incr_repeat2_done_out;
wire _guard1261 = cond_reg2_out;
wire _guard1262 = ~_guard1261;
wire _guard1263 = _guard1260 & _guard1262;
wire _guard1264 = _guard1259 & _guard1263;
wire _guard1265 = tdcc_go_out;
wire _guard1266 = _guard1264 & _guard1265;
wire _guard1267 = _guard1258 | _guard1266;
wire _guard1268 = fsm0_out == 6'd0;
wire _guard1269 = wrapper_early_reset_static_par_thread_done_out;
wire _guard1270 = _guard1268 & _guard1269;
wire _guard1271 = tdcc_go_out;
wire _guard1272 = _guard1270 & _guard1271;
wire _guard1273 = fsm0_out == 6'd17;
wire _guard1274 = init_repeat3_done_out;
wire _guard1275 = cond_reg3_out;
wire _guard1276 = _guard1274 & _guard1275;
wire _guard1277 = _guard1273 & _guard1276;
wire _guard1278 = tdcc_go_out;
wire _guard1279 = _guard1277 & _guard1278;
wire _guard1280 = fsm0_out == 6'd39;
wire _guard1281 = incr_repeat3_done_out;
wire _guard1282 = cond_reg3_out;
wire _guard1283 = _guard1281 & _guard1282;
wire _guard1284 = _guard1280 & _guard1283;
wire _guard1285 = tdcc_go_out;
wire _guard1286 = _guard1284 & _guard1285;
wire _guard1287 = _guard1279 | _guard1286;
wire _guard1288 = fsm0_out == 6'd36;
wire _guard1289 = invoke54_done_out;
wire _guard1290 = _guard1288 & _guard1289;
wire _guard1291 = tdcc_go_out;
wire _guard1292 = _guard1290 & _guard1291;
wire _guard1293 = fsm0_out == 6'd42;
wire _guard1294 = invoke57_done_out;
wire _guard1295 = _guard1293 & _guard1294;
wire _guard1296 = tdcc_go_out;
wire _guard1297 = _guard1295 & _guard1296;
wire _guard1298 = cond_reg0_done;
wire _guard1299 = idx0_done;
wire _guard1300 = _guard1298 & _guard1299;
wire _guard1301 = incr_repeat2_done_out;
wire _guard1302 = ~_guard1301;
wire _guard1303 = fsm0_out == 6'd37;
wire _guard1304 = _guard1302 & _guard1303;
wire _guard1305 = tdcc_go_out;
wire _guard1306 = _guard1304 & _guard1305;
wire _guard1307 = invoke12_go_out;
wire _guard1308 = early_reset_static_par_thread_go_out;
wire _guard1309 = _guard1307 | _guard1308;
wire _guard1310 = fsm_out == 4'd2;
wire _guard1311 = early_reset_static_seq2_go_out;
wire _guard1312 = _guard1310 & _guard1311;
wire _guard1313 = _guard1309 | _guard1312;
wire _guard1314 = fsm_out == 4'd1;
wire _guard1315 = early_reset_static_seq4_go_out;
wire _guard1316 = _guard1314 & _guard1315;
wire _guard1317 = _guard1313 | _guard1316;
wire _guard1318 = fsm_out == 4'd1;
wire _guard1319 = early_reset_static_seq5_go_out;
wire _guard1320 = _guard1318 & _guard1319;
wire _guard1321 = _guard1317 | _guard1320;
wire _guard1322 = early_reset_static_par_thread_go_out;
wire _guard1323 = fsm_out == 4'd1;
wire _guard1324 = early_reset_static_seq4_go_out;
wire _guard1325 = _guard1323 & _guard1324;
wire _guard1326 = fsm_out == 4'd2;
wire _guard1327 = early_reset_static_seq2_go_out;
wire _guard1328 = _guard1326 & _guard1327;
wire _guard1329 = invoke12_go_out;
wire _guard1330 = fsm_out == 4'd1;
wire _guard1331 = early_reset_static_seq5_go_out;
wire _guard1332 = _guard1330 & _guard1331;
wire _guard1333 = bb0_31_go_out;
wire _guard1334 = bb0_31_go_out;
wire _guard1335 = std_addFN_0_done;
wire _guard1336 = ~_guard1335;
wire _guard1337 = bb0_31_go_out;
wire _guard1338 = _guard1336 & _guard1337;
wire _guard1339 = bb0_31_go_out;
wire _guard1340 = invoke57_go_out;
wire _guard1341 = early_reset_static_par_thread0_go_out;
wire _guard1342 = _guard1340 | _guard1341;
wire _guard1343 = early_reset_static_par_thread0_go_out;
wire _guard1344 = invoke57_go_out;
wire _guard1345 = init_repeat_go_out;
wire _guard1346 = incr_repeat_go_out;
wire _guard1347 = _guard1345 | _guard1346;
wire _guard1348 = incr_repeat_go_out;
wire _guard1349 = init_repeat_go_out;
wire _guard1350 = incr_repeat3_go_out;
wire _guard1351 = incr_repeat3_go_out;
wire _guard1352 = early_reset_static_seq_go_out;
wire _guard1353 = early_reset_static_seq_go_out;
wire _guard1354 = invoke17_done_out;
wire _guard1355 = ~_guard1354;
wire _guard1356 = fsm0_out == 6'd18;
wire _guard1357 = _guard1355 & _guard1356;
wire _guard1358 = tdcc_go_out;
wire _guard1359 = _guard1357 & _guard1358;
wire _guard1360 = cond_reg_done;
wire _guard1361 = idx_done;
wire _guard1362 = _guard1360 & _guard1361;
wire _guard1363 = cond_reg_done;
wire _guard1364 = idx_done;
wire _guard1365 = _guard1363 & _guard1364;
wire _guard1366 = cond_reg0_done;
wire _guard1367 = idx0_done;
wire _guard1368 = _guard1366 & _guard1367;
wire _guard1369 = signal_reg_out;
wire _guard1370 = wrapper_early_reset_static_seq3_done_out;
wire _guard1371 = ~_guard1370;
wire _guard1372 = fsm0_out == 6'd26;
wire _guard1373 = _guard1371 & _guard1372;
wire _guard1374 = tdcc_go_out;
wire _guard1375 = _guard1373 & _guard1374;
wire _guard1376 = invoke55_go_out;
wire _guard1377 = bb0_6_go_out;
wire _guard1378 = bb0_13_go_out;
wire _guard1379 = _guard1377 | _guard1378;
wire _guard1380 = bb0_42_go_out;
wire _guard1381 = _guard1379 | _guard1380;
wire _guard1382 = fsm_out >= 4'd4;
wire _guard1383 = fsm_out < 4'd7;
wire _guard1384 = _guard1382 & _guard1383;
wire _guard1385 = fsm_out >= 4'd8;
wire _guard1386 = fsm_out < 4'd11;
wire _guard1387 = _guard1385 & _guard1386;
wire _guard1388 = _guard1384 | _guard1387;
wire _guard1389 = early_reset_static_seq_go_out;
wire _guard1390 = _guard1388 & _guard1389;
wire _guard1391 = _guard1381 | _guard1390;
wire _guard1392 = fsm_out >= 4'd4;
wire _guard1393 = fsm_out < 4'd7;
wire _guard1394 = _guard1392 & _guard1393;
wire _guard1395 = fsm_out >= 4'd8;
wire _guard1396 = fsm_out < 4'd11;
wire _guard1397 = _guard1395 & _guard1396;
wire _guard1398 = _guard1394 | _guard1397;
wire _guard1399 = early_reset_static_seq0_go_out;
wire _guard1400 = _guard1398 & _guard1399;
wire _guard1401 = _guard1391 | _guard1400;
wire _guard1402 = fsm_out >= 4'd4;
wire _guard1403 = fsm_out < 4'd7;
wire _guard1404 = _guard1402 & _guard1403;
wire _guard1405 = fsm_out >= 4'd8;
wire _guard1406 = fsm_out < 4'd11;
wire _guard1407 = _guard1405 & _guard1406;
wire _guard1408 = _guard1404 | _guard1407;
wire _guard1409 = early_reset_static_seq6_go_out;
wire _guard1410 = _guard1408 & _guard1409;
wire _guard1411 = _guard1401 | _guard1410;
wire _guard1412 = early_reset_static_par_thread0_go_out;
wire _guard1413 = invoke54_go_out;
wire _guard1414 = invoke11_go_out;
wire _guard1415 = invoke12_go_out;
wire _guard1416 = invoke57_go_out;
wire _guard1417 = invoke10_go_out;
wire _guard1418 = invoke56_go_out;
wire _guard1419 = fsm_out >= 4'd8;
wire _guard1420 = fsm_out < 4'd11;
wire _guard1421 = _guard1419 & _guard1420;
wire _guard1422 = early_reset_static_seq0_go_out;
wire _guard1423 = _guard1421 & _guard1422;
wire _guard1424 = fsm_out >= 4'd8;
wire _guard1425 = fsm_out < 4'd11;
wire _guard1426 = _guard1424 & _guard1425;
wire _guard1427 = early_reset_static_seq6_go_out;
wire _guard1428 = _guard1426 & _guard1427;
wire _guard1429 = _guard1423 | _guard1428;
wire _guard1430 = bb0_13_go_out;
wire _guard1431 = bb0_42_go_out;
wire _guard1432 = _guard1430 | _guard1431;
wire _guard1433 = fsm_out >= 4'd8;
wire _guard1434 = fsm_out < 4'd11;
wire _guard1435 = _guard1433 & _guard1434;
wire _guard1436 = early_reset_static_seq_go_out;
wire _guard1437 = _guard1435 & _guard1436;
wire _guard1438 = fsm_out >= 4'd4;
wire _guard1439 = fsm_out < 4'd7;
wire _guard1440 = _guard1438 & _guard1439;
wire _guard1441 = early_reset_static_seq_go_out;
wire _guard1442 = _guard1440 & _guard1441;
wire _guard1443 = bb0_6_go_out;
wire _guard1444 = fsm_out >= 4'd4;
wire _guard1445 = fsm_out < 4'd7;
wire _guard1446 = _guard1444 & _guard1445;
wire _guard1447 = early_reset_static_seq0_go_out;
wire _guard1448 = _guard1446 & _guard1447;
wire _guard1449 = fsm_out >= 4'd4;
wire _guard1450 = fsm_out < 4'd7;
wire _guard1451 = _guard1449 & _guard1450;
wire _guard1452 = early_reset_static_seq6_go_out;
wire _guard1453 = _guard1451 & _guard1452;
wire _guard1454 = _guard1448 | _guard1453;
wire _guard1455 = invoke10_go_out;
wire _guard1456 = invoke11_go_out;
wire _guard1457 = _guard1455 | _guard1456;
wire _guard1458 = invoke12_go_out;
wire _guard1459 = _guard1457 | _guard1458;
wire _guard1460 = invoke54_go_out;
wire _guard1461 = _guard1459 | _guard1460;
wire _guard1462 = invoke55_go_out;
wire _guard1463 = _guard1461 | _guard1462;
wire _guard1464 = invoke56_go_out;
wire _guard1465 = _guard1463 | _guard1464;
wire _guard1466 = invoke57_go_out;
wire _guard1467 = _guard1465 | _guard1466;
wire _guard1468 = early_reset_static_par_thread0_go_out;
wire _guard1469 = _guard1467 | _guard1468;
wire _guard1470 = invoke3_go_out;
wire _guard1471 = invoke10_go_out;
wire _guard1472 = _guard1470 | _guard1471;
wire _guard1473 = bb0_27_go_out;
wire _guard1474 = invoke3_go_out;
wire _guard1475 = invoke10_go_out;
wire _guard1476 = bb0_27_go_out;
wire _guard1477 = incr_repeat0_go_out;
wire _guard1478 = incr_repeat0_go_out;
wire _guard1479 = init_repeat4_go_out;
wire _guard1480 = incr_repeat4_go_out;
wire _guard1481 = _guard1479 | _guard1480;
wire _guard1482 = incr_repeat4_go_out;
wire _guard1483 = init_repeat4_go_out;
wire _guard1484 = early_reset_static_seq5_go_out;
wire _guard1485 = early_reset_static_seq5_go_out;
wire _guard1486 = invoke16_done_out;
wire _guard1487 = ~_guard1486;
wire _guard1488 = fsm0_out == 6'd16;
wire _guard1489 = _guard1487 & _guard1488;
wire _guard1490 = tdcc_go_out;
wire _guard1491 = _guard1489 & _guard1490;
wire _guard1492 = init_repeat0_done_out;
wire _guard1493 = ~_guard1492;
wire _guard1494 = fsm0_out == 6'd3;
wire _guard1495 = _guard1493 & _guard1494;
wire _guard1496 = tdcc_go_out;
wire _guard1497 = _guard1495 & _guard1496;
wire _guard1498 = incr_repeat0_done_out;
wire _guard1499 = ~_guard1498;
wire _guard1500 = fsm0_out == 6'd11;
wire _guard1501 = _guard1499 & _guard1500;
wire _guard1502 = tdcc_go_out;
wire _guard1503 = _guard1501 & _guard1502;
wire _guard1504 = init_repeat2_done_out;
wire _guard1505 = ~_guard1504;
wire _guard1506 = fsm0_out == 6'd19;
wire _guard1507 = _guard1505 & _guard1506;
wire _guard1508 = tdcc_go_out;
wire _guard1509 = _guard1507 & _guard1508;
wire _guard1510 = wrapper_early_reset_static_seq_go_out;
wire _guard1511 = wrapper_early_reset_static_par_thread0_done_out;
wire _guard1512 = ~_guard1511;
wire _guard1513 = fsm0_out == 6'd14;
wire _guard1514 = _guard1512 & _guard1513;
wire _guard1515 = tdcc_go_out;
wire _guard1516 = _guard1514 & _guard1515;
wire _guard1517 = fsm_out == 4'd0;
wire _guard1518 = early_reset_static_seq1_go_out;
wire _guard1519 = _guard1517 & _guard1518;
wire _guard1520 = fsm_out == 4'd1;
wire _guard1521 = early_reset_static_seq1_go_out;
wire _guard1522 = _guard1520 & _guard1521;
wire _guard1523 = fsm_out == 4'd3;
wire _guard1524 = early_reset_static_seq2_go_out;
wire _guard1525 = _guard1523 & _guard1524;
wire _guard1526 = _guard1522 | _guard1525;
wire _guard1527 = fsm_out == 4'd6;
wire _guard1528 = early_reset_static_seq3_go_out;
wire _guard1529 = _guard1527 & _guard1528;
wire _guard1530 = _guard1526 | _guard1529;
wire _guard1531 = fsm_out == 4'd0;
wire _guard1532 = fsm_out == 4'd1;
wire _guard1533 = _guard1531 | _guard1532;
wire _guard1534 = early_reset_static_seq1_go_out;
wire _guard1535 = _guard1533 & _guard1534;
wire _guard1536 = fsm_out == 4'd3;
wire _guard1537 = early_reset_static_seq2_go_out;
wire _guard1538 = _guard1536 & _guard1537;
wire _guard1539 = _guard1535 | _guard1538;
wire _guard1540 = fsm_out == 4'd6;
wire _guard1541 = early_reset_static_seq3_go_out;
wire _guard1542 = _guard1540 & _guard1541;
wire _guard1543 = _guard1539 | _guard1542;
wire _guard1544 = fsm_out == 4'd0;
wire _guard1545 = fsm_out == 4'd1;
wire _guard1546 = _guard1544 | _guard1545;
wire _guard1547 = early_reset_static_seq1_go_out;
wire _guard1548 = _guard1546 & _guard1547;
wire _guard1549 = fsm_out == 4'd3;
wire _guard1550 = early_reset_static_seq2_go_out;
wire _guard1551 = _guard1549 & _guard1550;
wire _guard1552 = _guard1548 | _guard1551;
wire _guard1553 = fsm_out == 4'd6;
wire _guard1554 = early_reset_static_seq3_go_out;
wire _guard1555 = _guard1553 & _guard1554;
wire _guard1556 = _guard1552 | _guard1555;
wire _guard1557 = fsm_out == 4'd0;
wire _guard1558 = early_reset_static_seq1_go_out;
wire _guard1559 = _guard1557 & _guard1558;
wire _guard1560 = bb0_35_go_out;
wire _guard1561 = bb0_35_go_out;
wire _guard1562 = std_addFN_1_done;
wire _guard1563 = ~_guard1562;
wire _guard1564 = bb0_35_go_out;
wire _guard1565 = _guard1563 & _guard1564;
wire _guard1566 = bb0_35_go_out;
wire _guard1567 = invoke56_go_out;
wire _guard1568 = early_reset_static_par_thread0_go_out;
wire _guard1569 = _guard1567 | _guard1568;
wire _guard1570 = early_reset_static_par_thread0_go_out;
wire _guard1571 = invoke56_go_out;
wire _guard1572 = early_reset_static_seq2_go_out;
wire _guard1573 = early_reset_static_seq2_go_out;
wire _guard1574 = signal_reg_out;
wire _guard1575 = _guard0 & _guard0;
wire _guard1576 = signal_reg_out;
wire _guard1577 = ~_guard1576;
wire _guard1578 = _guard1575 & _guard1577;
wire _guard1579 = wrapper_early_reset_static_par_thread_go_out;
wire _guard1580 = _guard1578 & _guard1579;
wire _guard1581 = _guard1574 | _guard1580;
wire _guard1582 = fsm_out == 4'd11;
wire _guard1583 = _guard1582 & _guard0;
wire _guard1584 = signal_reg_out;
wire _guard1585 = ~_guard1584;
wire _guard1586 = _guard1583 & _guard1585;
wire _guard1587 = wrapper_early_reset_static_seq_go_out;
wire _guard1588 = _guard1586 & _guard1587;
wire _guard1589 = _guard1581 | _guard1588;
wire _guard1590 = _guard0 & _guard0;
wire _guard1591 = signal_reg_out;
wire _guard1592 = ~_guard1591;
wire _guard1593 = _guard1590 & _guard1592;
wire _guard1594 = wrapper_early_reset_static_par_thread0_go_out;
wire _guard1595 = _guard1593 & _guard1594;
wire _guard1596 = _guard1589 | _guard1595;
wire _guard1597 = fsm_out == 4'd11;
wire _guard1598 = _guard1597 & _guard0;
wire _guard1599 = signal_reg_out;
wire _guard1600 = ~_guard1599;
wire _guard1601 = _guard1598 & _guard1600;
wire _guard1602 = wrapper_early_reset_static_seq0_go_out;
wire _guard1603 = _guard1601 & _guard1602;
wire _guard1604 = _guard1596 | _guard1603;
wire _guard1605 = fsm_out == 4'd2;
wire _guard1606 = _guard1605 & _guard0;
wire _guard1607 = signal_reg_out;
wire _guard1608 = ~_guard1607;
wire _guard1609 = _guard1606 & _guard1608;
wire _guard1610 = wrapper_early_reset_static_seq1_go_out;
wire _guard1611 = _guard1609 & _guard1610;
wire _guard1612 = _guard1604 | _guard1611;
wire _guard1613 = fsm_out == 4'd4;
wire _guard1614 = _guard1613 & _guard0;
wire _guard1615 = signal_reg_out;
wire _guard1616 = ~_guard1615;
wire _guard1617 = _guard1614 & _guard1616;
wire _guard1618 = wrapper_early_reset_static_seq2_go_out;
wire _guard1619 = _guard1617 & _guard1618;
wire _guard1620 = _guard1612 | _guard1619;
wire _guard1621 = fsm_out == 4'd7;
wire _guard1622 = _guard1621 & _guard0;
wire _guard1623 = signal_reg_out;
wire _guard1624 = ~_guard1623;
wire _guard1625 = _guard1622 & _guard1624;
wire _guard1626 = wrapper_early_reset_static_seq3_go_out;
wire _guard1627 = _guard1625 & _guard1626;
wire _guard1628 = _guard1620 | _guard1627;
wire _guard1629 = fsm_out == 4'd3;
wire _guard1630 = _guard1629 & _guard0;
wire _guard1631 = signal_reg_out;
wire _guard1632 = ~_guard1631;
wire _guard1633 = _guard1630 & _guard1632;
wire _guard1634 = wrapper_early_reset_static_seq4_go_out;
wire _guard1635 = _guard1633 & _guard1634;
wire _guard1636 = _guard1628 | _guard1635;
wire _guard1637 = fsm_out == 4'd3;
wire _guard1638 = _guard1637 & _guard0;
wire _guard1639 = signal_reg_out;
wire _guard1640 = ~_guard1639;
wire _guard1641 = _guard1638 & _guard1640;
wire _guard1642 = wrapper_early_reset_static_seq5_go_out;
wire _guard1643 = _guard1641 & _guard1642;
wire _guard1644 = _guard1636 | _guard1643;
wire _guard1645 = fsm_out == 4'd11;
wire _guard1646 = _guard1645 & _guard0;
wire _guard1647 = signal_reg_out;
wire _guard1648 = ~_guard1647;
wire _guard1649 = _guard1646 & _guard1648;
wire _guard1650 = wrapper_early_reset_static_seq6_go_out;
wire _guard1651 = _guard1649 & _guard1650;
wire _guard1652 = _guard1644 | _guard1651;
wire _guard1653 = _guard0 & _guard0;
wire _guard1654 = signal_reg_out;
wire _guard1655 = ~_guard1654;
wire _guard1656 = _guard1653 & _guard1655;
wire _guard1657 = wrapper_early_reset_static_par_thread_go_out;
wire _guard1658 = _guard1656 & _guard1657;
wire _guard1659 = fsm_out == 4'd11;
wire _guard1660 = _guard1659 & _guard0;
wire _guard1661 = signal_reg_out;
wire _guard1662 = ~_guard1661;
wire _guard1663 = _guard1660 & _guard1662;
wire _guard1664 = wrapper_early_reset_static_seq_go_out;
wire _guard1665 = _guard1663 & _guard1664;
wire _guard1666 = _guard1658 | _guard1665;
wire _guard1667 = _guard0 & _guard0;
wire _guard1668 = signal_reg_out;
wire _guard1669 = ~_guard1668;
wire _guard1670 = _guard1667 & _guard1669;
wire _guard1671 = wrapper_early_reset_static_par_thread0_go_out;
wire _guard1672 = _guard1670 & _guard1671;
wire _guard1673 = _guard1666 | _guard1672;
wire _guard1674 = fsm_out == 4'd11;
wire _guard1675 = _guard1674 & _guard0;
wire _guard1676 = signal_reg_out;
wire _guard1677 = ~_guard1676;
wire _guard1678 = _guard1675 & _guard1677;
wire _guard1679 = wrapper_early_reset_static_seq0_go_out;
wire _guard1680 = _guard1678 & _guard1679;
wire _guard1681 = _guard1673 | _guard1680;
wire _guard1682 = fsm_out == 4'd2;
wire _guard1683 = _guard1682 & _guard0;
wire _guard1684 = signal_reg_out;
wire _guard1685 = ~_guard1684;
wire _guard1686 = _guard1683 & _guard1685;
wire _guard1687 = wrapper_early_reset_static_seq1_go_out;
wire _guard1688 = _guard1686 & _guard1687;
wire _guard1689 = _guard1681 | _guard1688;
wire _guard1690 = fsm_out == 4'd4;
wire _guard1691 = _guard1690 & _guard0;
wire _guard1692 = signal_reg_out;
wire _guard1693 = ~_guard1692;
wire _guard1694 = _guard1691 & _guard1693;
wire _guard1695 = wrapper_early_reset_static_seq2_go_out;
wire _guard1696 = _guard1694 & _guard1695;
wire _guard1697 = _guard1689 | _guard1696;
wire _guard1698 = fsm_out == 4'd7;
wire _guard1699 = _guard1698 & _guard0;
wire _guard1700 = signal_reg_out;
wire _guard1701 = ~_guard1700;
wire _guard1702 = _guard1699 & _guard1701;
wire _guard1703 = wrapper_early_reset_static_seq3_go_out;
wire _guard1704 = _guard1702 & _guard1703;
wire _guard1705 = _guard1697 | _guard1704;
wire _guard1706 = fsm_out == 4'd3;
wire _guard1707 = _guard1706 & _guard0;
wire _guard1708 = signal_reg_out;
wire _guard1709 = ~_guard1708;
wire _guard1710 = _guard1707 & _guard1709;
wire _guard1711 = wrapper_early_reset_static_seq4_go_out;
wire _guard1712 = _guard1710 & _guard1711;
wire _guard1713 = _guard1705 | _guard1712;
wire _guard1714 = fsm_out == 4'd3;
wire _guard1715 = _guard1714 & _guard0;
wire _guard1716 = signal_reg_out;
wire _guard1717 = ~_guard1716;
wire _guard1718 = _guard1715 & _guard1717;
wire _guard1719 = wrapper_early_reset_static_seq5_go_out;
wire _guard1720 = _guard1718 & _guard1719;
wire _guard1721 = _guard1713 | _guard1720;
wire _guard1722 = fsm_out == 4'd11;
wire _guard1723 = _guard1722 & _guard0;
wire _guard1724 = signal_reg_out;
wire _guard1725 = ~_guard1724;
wire _guard1726 = _guard1723 & _guard1725;
wire _guard1727 = wrapper_early_reset_static_seq6_go_out;
wire _guard1728 = _guard1726 & _guard1727;
wire _guard1729 = _guard1721 | _guard1728;
wire _guard1730 = signal_reg_out;
wire _guard1731 = invoke55_done_out;
wire _guard1732 = ~_guard1731;
wire _guard1733 = fsm0_out == 6'd38;
wire _guard1734 = _guard1732 & _guard1733;
wire _guard1735 = tdcc_go_out;
wire _guard1736 = _guard1734 & _guard1735;
wire _guard1737 = invoke57_done_out;
wire _guard1738 = ~_guard1737;
wire _guard1739 = fsm0_out == 6'd42;
wire _guard1740 = _guard1738 & _guard1739;
wire _guard1741 = tdcc_go_out;
wire _guard1742 = _guard1740 & _guard1741;
wire _guard1743 = cond_reg1_done;
wire _guard1744 = idx1_done;
wire _guard1745 = _guard1743 & _guard1744;
wire _guard1746 = cond_reg2_done;
wire _guard1747 = idx2_done;
wire _guard1748 = _guard1746 & _guard1747;
wire _guard1749 = wrapper_early_reset_static_par_thread_go_out;
wire _guard1750 = signal_reg_out;
wire _guard1751 = bb0_35_done_out;
wire _guard1752 = ~_guard1751;
wire _guard1753 = fsm0_out == 6'd33;
wire _guard1754 = _guard1752 & _guard1753;
wire _guard1755 = tdcc_go_out;
wire _guard1756 = _guard1754 & _guard1755;
wire _guard1757 = wrapper_early_reset_static_par_thread0_go_out;
wire _guard1758 = signal_reg_out;
wire _guard1759 = signal_reg_out;
wire _guard1760 = signal_reg_out;
wire _guard1761 = fsm_out < 4'd3;
wire _guard1762 = early_reset_static_seq_go_out;
wire _guard1763 = _guard1761 & _guard1762;
wire _guard1764 = fsm_out < 4'd3;
wire _guard1765 = early_reset_static_seq0_go_out;
wire _guard1766 = _guard1764 & _guard1765;
wire _guard1767 = fsm_out < 4'd3;
wire _guard1768 = early_reset_static_seq6_go_out;
wire _guard1769 = _guard1767 & _guard1768;
wire _guard1770 = _guard1766 | _guard1769;
wire _guard1771 = fsm_out >= 4'd4;
wire _guard1772 = fsm_out < 4'd7;
wire _guard1773 = _guard1771 & _guard1772;
wire _guard1774 = fsm_out >= 4'd8;
wire _guard1775 = fsm_out < 4'd11;
wire _guard1776 = _guard1774 & _guard1775;
wire _guard1777 = _guard1773 | _guard1776;
wire _guard1778 = early_reset_static_seq_go_out;
wire _guard1779 = _guard1777 & _guard1778;
wire _guard1780 = fsm_out >= 4'd4;
wire _guard1781 = fsm_out < 4'd7;
wire _guard1782 = _guard1780 & _guard1781;
wire _guard1783 = fsm_out >= 4'd8;
wire _guard1784 = fsm_out < 4'd11;
wire _guard1785 = _guard1783 & _guard1784;
wire _guard1786 = _guard1782 | _guard1785;
wire _guard1787 = early_reset_static_seq0_go_out;
wire _guard1788 = _guard1786 & _guard1787;
wire _guard1789 = _guard1779 | _guard1788;
wire _guard1790 = fsm_out >= 4'd4;
wire _guard1791 = fsm_out < 4'd7;
wire _guard1792 = _guard1790 & _guard1791;
wire _guard1793 = fsm_out >= 4'd8;
wire _guard1794 = fsm_out < 4'd11;
wire _guard1795 = _guard1793 & _guard1794;
wire _guard1796 = _guard1792 | _guard1795;
wire _guard1797 = early_reset_static_seq6_go_out;
wire _guard1798 = _guard1796 & _guard1797;
wire _guard1799 = _guard1789 | _guard1798;
wire _guard1800 = fsm_out < 4'd3;
wire _guard1801 = fsm_out >= 4'd4;
wire _guard1802 = fsm_out < 4'd7;
wire _guard1803 = _guard1801 & _guard1802;
wire _guard1804 = _guard1800 | _guard1803;
wire _guard1805 = fsm_out >= 4'd8;
wire _guard1806 = fsm_out < 4'd11;
wire _guard1807 = _guard1805 & _guard1806;
wire _guard1808 = _guard1804 | _guard1807;
wire _guard1809 = early_reset_static_seq_go_out;
wire _guard1810 = _guard1808 & _guard1809;
wire _guard1811 = fsm_out < 4'd3;
wire _guard1812 = fsm_out >= 4'd4;
wire _guard1813 = fsm_out < 4'd7;
wire _guard1814 = _guard1812 & _guard1813;
wire _guard1815 = _guard1811 | _guard1814;
wire _guard1816 = fsm_out >= 4'd8;
wire _guard1817 = fsm_out < 4'd11;
wire _guard1818 = _guard1816 & _guard1817;
wire _guard1819 = _guard1815 | _guard1818;
wire _guard1820 = early_reset_static_seq0_go_out;
wire _guard1821 = _guard1819 & _guard1820;
wire _guard1822 = _guard1810 | _guard1821;
wire _guard1823 = fsm_out < 4'd3;
wire _guard1824 = fsm_out >= 4'd4;
wire _guard1825 = fsm_out < 4'd7;
wire _guard1826 = _guard1824 & _guard1825;
wire _guard1827 = _guard1823 | _guard1826;
wire _guard1828 = fsm_out >= 4'd8;
wire _guard1829 = fsm_out < 4'd11;
wire _guard1830 = _guard1828 & _guard1829;
wire _guard1831 = _guard1827 | _guard1830;
wire _guard1832 = early_reset_static_seq6_go_out;
wire _guard1833 = _guard1831 & _guard1832;
wire _guard1834 = _guard1822 | _guard1833;
wire _guard1835 = fsm_out < 4'd3;
wire _guard1836 = early_reset_static_seq_go_out;
wire _guard1837 = _guard1835 & _guard1836;
wire _guard1838 = fsm_out < 4'd3;
wire _guard1839 = early_reset_static_seq0_go_out;
wire _guard1840 = _guard1838 & _guard1839;
wire _guard1841 = _guard1837 | _guard1840;
wire _guard1842 = fsm_out < 4'd3;
wire _guard1843 = early_reset_static_seq6_go_out;
wire _guard1844 = _guard1842 & _guard1843;
wire _guard1845 = _guard1841 | _guard1844;
wire _guard1846 = fsm_out >= 4'd8;
wire _guard1847 = fsm_out < 4'd11;
wire _guard1848 = _guard1846 & _guard1847;
wire _guard1849 = early_reset_static_seq_go_out;
wire _guard1850 = _guard1848 & _guard1849;
wire _guard1851 = fsm_out >= 4'd8;
wire _guard1852 = fsm_out < 4'd11;
wire _guard1853 = _guard1851 & _guard1852;
wire _guard1854 = early_reset_static_seq0_go_out;
wire _guard1855 = _guard1853 & _guard1854;
wire _guard1856 = _guard1850 | _guard1855;
wire _guard1857 = fsm_out >= 4'd8;
wire _guard1858 = fsm_out < 4'd11;
wire _guard1859 = _guard1857 & _guard1858;
wire _guard1860 = early_reset_static_seq6_go_out;
wire _guard1861 = _guard1859 & _guard1860;
wire _guard1862 = _guard1856 | _guard1861;
wire _guard1863 = fsm_out >= 4'd4;
wire _guard1864 = fsm_out < 4'd7;
wire _guard1865 = _guard1863 & _guard1864;
wire _guard1866 = early_reset_static_seq_go_out;
wire _guard1867 = _guard1865 & _guard1866;
wire _guard1868 = fsm_out >= 4'd4;
wire _guard1869 = fsm_out < 4'd7;
wire _guard1870 = _guard1868 & _guard1869;
wire _guard1871 = early_reset_static_seq0_go_out;
wire _guard1872 = _guard1870 & _guard1871;
wire _guard1873 = _guard1867 | _guard1872;
wire _guard1874 = fsm_out >= 4'd4;
wire _guard1875 = fsm_out < 4'd7;
wire _guard1876 = _guard1874 & _guard1875;
wire _guard1877 = early_reset_static_seq6_go_out;
wire _guard1878 = _guard1876 & _guard1877;
wire _guard1879 = _guard1873 | _guard1878;
wire _guard1880 = bb0_34_go_out;
wire _guard1881 = std_mulFN_4_done;
wire _guard1882 = ~_guard1881;
wire _guard1883 = bb0_34_go_out;
wire _guard1884 = _guard1882 & _guard1883;
wire _guard1885 = bb0_34_go_out;
wire _guard1886 = bb0_30_go_out;
wire _guard1887 = std_mulFN_3_done;
wire _guard1888 = ~_guard1887;
wire _guard1889 = bb0_30_go_out;
wire _guard1890 = _guard1888 & _guard1889;
wire _guard1891 = bb0_30_go_out;
wire _guard1892 = bb0_30_done_out;
wire _guard1893 = ~_guard1892;
wire _guard1894 = fsm0_out == 6'd29;
wire _guard1895 = _guard1893 & _guard1894;
wire _guard1896 = tdcc_go_out;
wire _guard1897 = _guard1895 & _guard1896;
wire _guard1898 = bb0_34_done_out;
wire _guard1899 = ~_guard1898;
wire _guard1900 = fsm0_out == 6'd32;
wire _guard1901 = _guard1899 & _guard1900;
wire _guard1902 = tdcc_go_out;
wire _guard1903 = _guard1901 & _guard1902;
wire _guard1904 = init_repeat4_done_out;
wire _guard1905 = ~_guard1904;
wire _guard1906 = fsm0_out == 6'd15;
wire _guard1907 = _guard1905 & _guard1906;
wire _guard1908 = tdcc_go_out;
wire _guard1909 = _guard1907 & _guard1908;
wire _guard1910 = wrapper_early_reset_static_seq1_done_out;
wire _guard1911 = ~_guard1910;
wire _guard1912 = fsm0_out == 6'd22;
wire _guard1913 = _guard1911 & _guard1912;
wire _guard1914 = tdcc_go_out;
wire _guard1915 = _guard1913 & _guard1914;
wire _guard1916 = fsm0_out == 6'd43;
wire _guard1917 = bb0_6_go_out;
wire _guard1918 = bb0_13_go_out;
wire _guard1919 = _guard1917 | _guard1918;
wire _guard1920 = bb0_42_go_out;
wire _guard1921 = _guard1919 | _guard1920;
wire _guard1922 = fsm_out == 4'd1;
wire _guard1923 = early_reset_static_seq3_go_out;
wire _guard1924 = _guard1922 & _guard1923;
wire _guard1925 = fsm_out == 4'd4;
wire _guard1926 = early_reset_static_seq3_go_out;
wire _guard1927 = _guard1925 & _guard1926;
wire _guard1928 = fsm_out == 4'd1;
wire _guard1929 = fsm_out == 4'd4;
wire _guard1930 = _guard1928 | _guard1929;
wire _guard1931 = early_reset_static_seq3_go_out;
wire _guard1932 = _guard1930 & _guard1931;
wire _guard1933 = fsm_out == 4'd1;
wire _guard1934 = fsm_out == 4'd4;
wire _guard1935 = _guard1933 | _guard1934;
wire _guard1936 = early_reset_static_seq3_go_out;
wire _guard1937 = _guard1935 & _guard1936;
wire _guard1938 = fsm_out == 4'd1;
wire _guard1939 = early_reset_static_seq3_go_out;
wire _guard1940 = _guard1938 & _guard1939;
wire _guard1941 = incr_repeat_go_out;
wire _guard1942 = incr_repeat_go_out;
wire _guard1943 = init_repeat2_go_out;
wire _guard1944 = incr_repeat2_go_out;
wire _guard1945 = _guard1943 | _guard1944;
wire _guard1946 = init_repeat2_go_out;
wire _guard1947 = incr_repeat2_go_out;
wire _guard1948 = bb0_31_done_out;
wire _guard1949 = ~_guard1948;
wire _guard1950 = fsm0_out == 6'd30;
wire _guard1951 = _guard1949 & _guard1950;
wire _guard1952 = tdcc_go_out;
wire _guard1953 = _guard1951 & _guard1952;
wire _guard1954 = invoke3_done_out;
wire _guard1955 = ~_guard1954;
wire _guard1956 = fsm0_out == 6'd4;
wire _guard1957 = _guard1955 & _guard1956;
wire _guard1958 = tdcc_go_out;
wire _guard1959 = _guard1957 & _guard1958;
wire _guard1960 = init_repeat3_done_out;
wire _guard1961 = ~_guard1960;
wire _guard1962 = fsm0_out == 6'd17;
wire _guard1963 = _guard1961 & _guard1962;
wire _guard1964 = tdcc_go_out;
wire _guard1965 = _guard1963 & _guard1964;
wire _guard1966 = cond_reg3_done;
wire _guard1967 = idx3_done;
wire _guard1968 = _guard1966 & _guard1967;
wire _guard1969 = incr_repeat4_done_out;
wire _guard1970 = ~_guard1969;
wire _guard1971 = fsm0_out == 6'd41;
wire _guard1972 = _guard1970 & _guard1971;
wire _guard1973 = tdcc_go_out;
wire _guard1974 = _guard1972 & _guard1973;
wire _guard1975 = wrapper_early_reset_static_seq2_done_out;
wire _guard1976 = ~_guard1975;
wire _guard1977 = fsm0_out == 6'd24;
wire _guard1978 = _guard1976 & _guard1977;
wire _guard1979 = tdcc_go_out;
wire _guard1980 = _guard1978 & _guard1979;
wire _guard1981 = signal_reg_out;
wire _guard1982 = wrapper_early_reset_static_seq6_done_out;
wire _guard1983 = ~_guard1982;
wire _guard1984 = fsm0_out == 6'd34;
wire _guard1985 = _guard1983 & _guard1984;
wire _guard1986 = tdcc_go_out;
wire _guard1987 = _guard1985 & _guard1986;
wire _guard1988 = init_repeat4_go_out;
wire _guard1989 = incr_repeat4_go_out;
wire _guard1990 = _guard1988 | _guard1989;
wire _guard1991 = init_repeat4_go_out;
wire _guard1992 = incr_repeat4_go_out;
wire _guard1993 = wrapper_early_reset_static_seq_done_out;
wire _guard1994 = ~_guard1993;
wire _guard1995 = fsm0_out == 6'd6;
wire _guard1996 = _guard1994 & _guard1995;
wire _guard1997 = tdcc_go_out;
wire _guard1998 = _guard1996 & _guard1997;
wire _guard1999 = signal_reg_out;
wire _guard2000 = wrapper_early_reset_static_seq4_done_out;
wire _guard2001 = ~_guard2000;
wire _guard2002 = fsm0_out == 6'd28;
wire _guard2003 = _guard2001 & _guard2002;
wire _guard2004 = tdcc_go_out;
wire _guard2005 = _guard2003 & _guard2004;
wire _guard2006 = bb0_27_go_out;
wire _guard2007 = std_mulFN_2_done;
wire _guard2008 = ~_guard2007;
wire _guard2009 = bb0_27_go_out;
wire _guard2010 = _guard2008 & _guard2009;
wire _guard2011 = bb0_27_go_out;
wire _guard2012 = fsm_out == 4'd3;
wire _guard2013 = early_reset_static_seq3_go_out;
wire _guard2014 = _guard2012 & _guard2013;
wire _guard2015 = fsm_out == 4'd0;
wire _guard2016 = early_reset_static_seq5_go_out;
wire _guard2017 = _guard2015 & _guard2016;
wire _guard2018 = fsm_out == 4'd3;
wire _guard2019 = early_reset_static_seq3_go_out;
wire _guard2020 = _guard2018 & _guard2019;
wire _guard2021 = fsm_out == 4'd0;
wire _guard2022 = early_reset_static_seq5_go_out;
wire _guard2023 = _guard2021 & _guard2022;
wire _guard2024 = _guard2020 | _guard2023;
wire _guard2025 = fsm_out == 4'd3;
wire _guard2026 = early_reset_static_seq3_go_out;
wire _guard2027 = _guard2025 & _guard2026;
wire _guard2028 = fsm_out == 4'd0;
wire _guard2029 = early_reset_static_seq5_go_out;
wire _guard2030 = _guard2028 & _guard2029;
wire _guard2031 = _guard2027 | _guard2030;
wire _guard2032 = fsm_out == 4'd3;
wire _guard2033 = early_reset_static_seq3_go_out;
wire _guard2034 = _guard2032 & _guard2033;
wire _guard2035 = init_repeat_go_out;
wire _guard2036 = incr_repeat_go_out;
wire _guard2037 = _guard2035 | _guard2036;
wire _guard2038 = init_repeat_go_out;
wire _guard2039 = incr_repeat_go_out;
wire _guard2040 = incr_repeat0_go_out;
wire _guard2041 = incr_repeat0_go_out;
wire _guard2042 = init_repeat2_go_out;
wire _guard2043 = incr_repeat2_go_out;
wire _guard2044 = _guard2042 | _guard2043;
wire _guard2045 = init_repeat2_go_out;
wire _guard2046 = incr_repeat2_go_out;
wire _guard2047 = incr_repeat3_go_out;
wire _guard2048 = incr_repeat3_go_out;
wire _guard2049 = early_reset_static_seq1_go_out;
wire _guard2050 = early_reset_static_seq1_go_out;
wire _guard2051 = early_reset_static_seq3_go_out;
wire _guard2052 = early_reset_static_seq3_go_out;
wire _guard2053 = bb0_13_done_out;
wire _guard2054 = ~_guard2053;
wire _guard2055 = fsm0_out == 6'd21;
wire _guard2056 = _guard2054 & _guard2055;
wire _guard2057 = tdcc_go_out;
wire _guard2058 = _guard2056 & _guard2057;
wire _guard2059 = invoke10_done_out;
wire _guard2060 = ~_guard2059;
wire _guard2061 = fsm0_out == 6'd8;
wire _guard2062 = _guard2060 & _guard2061;
wire _guard2063 = tdcc_go_out;
wire _guard2064 = _guard2062 & _guard2063;
wire _guard2065 = cond_reg2_done;
wire _guard2066 = idx2_done;
wire _guard2067 = _guard2065 & _guard2066;
wire _guard2068 = cond_reg4_done;
wire _guard2069 = idx4_done;
wire _guard2070 = _guard2068 & _guard2069;
wire _guard2071 = signal_reg_out;
assign for_5_induction_var_reg_write_en = _guard3;
assign for_5_induction_var_reg_clk = clk;
assign for_5_induction_var_reg_reset = reset;
assign for_5_induction_var_reg_in =
  _guard4 ? 32'd0 :
  _guard5 ? std_add_16_out :
  'x;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard5, _guard4})) begin
    $fatal(2, "Multiple assignment to port `for_5_induction_var_reg.in'.");
end
end
assign cond_reg1_write_en = _guard8;
assign cond_reg1_clk = clk;
assign cond_reg1_reset = reset;
assign cond_reg1_in =
  _guard9 ? 1'd1 :
  _guard10 ? lt1_out :
  1'd0;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard10, _guard9})) begin
    $fatal(2, "Multiple assignment to port `cond_reg1.in'.");
end
end
assign adder1_left =
  _guard11 ? idx1_out :
  2'd0;
assign adder1_right =
  _guard12 ? 2'd1 :
  2'd0;
assign bb0_6_go_in = _guard18;
assign bb0_20_go_in = _guard24;
assign bb0_27_go_in = _guard30;
assign init_repeat_go_in = _guard36;
assign muli_8_reg_write_en =
  _guard63 ? 1'd1 :
  _guard64 ? std_mulFN_1_done :
  _guard65 ? std_mulFN_0_done :
  _guard66 ? std_mulFN_4_done :
  _guard67 ? std_mulFN_3_done :
  1'd0;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard67, _guard66, _guard65, _guard64, _guard63})) begin
    $fatal(2, "Multiple assignment to port `muli_8_reg.write_en'.");
end
end
assign muli_8_reg_clk = clk;
assign muli_8_reg_reset = reset;
assign muli_8_reg_in =
  _guard68 ? std_mulFN_1_out :
  _guard69 ? std_mulFN_0_out :
  _guard72 ? mem_0_read_data :
  _guard95 ? std_mult_pipe_8_out :
  _guard96 ? std_mulFN_4_out :
  _guard97 ? std_mulFN_3_out :
  'x;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard97, _guard96, _guard95, _guard72, _guard69, _guard68})) begin
    $fatal(2, "Multiple assignment to port `muli_8_reg.in'.");
end
end
assign done = _guard98;
assign arg_mem_1_write_data =
  _guard99 ? cst_3_out :
  _guard100 ? addf_1_reg_out :
  'x;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard100, _guard99})) begin
    $fatal(2, "Multiple assignment to port `_this.arg_mem_1_write_data'.");
end
end
assign arg_mem_0_content_en = _guard101;
assign arg_mem_0_addr0 = std_slice_17_out;
assign arg_mem_0_write_en =
  _guard103 ? 1'd0 :
  1'd0;
assign arg_mem_1_write_en = _guard106;
assign arg_mem_1_addr0 = std_slice_17_out;
assign arg_mem_1_content_en = _guard112;
assign adder_left =
  _guard113 ? idx_out :
  4'd0;
assign adder_right =
  _guard114 ? 4'd1 :
  4'd0;
assign fsm_write_en = _guard177;
assign fsm_clk = clk;
assign fsm_reset = reset;
assign fsm_in =
  _guard180 ? adder10_out :
  _guard183 ? adder12_out :
  _guard214 ? 4'd0 :
  _guard217 ? adder6_out :
  _guard220 ? adder5_out :
  _guard223 ? adder11_out :
  _guard226 ? adder8_out :
  _guard229 ? adder7_out :
  _guard232 ? adder9_out :
  4'd0;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard232, _guard229, _guard226, _guard223, _guard220, _guard217, _guard214, _guard183, _guard180})) begin
    $fatal(2, "Multiple assignment to port `fsm.in'.");
end
end
assign adder10_left =
  _guard233 ? fsm_out :
  4'd0;
assign adder10_right =
  _guard234 ? 4'd1 :
  4'd0;
assign adder12_left =
  _guard235 ? fsm_out :
  4'd0;
assign adder12_right =
  _guard236 ? 4'd1 :
  4'd0;
assign bb0_30_done_in = muli_8_reg_done;
assign bb0_42_go_in = _guard242;
assign invoke11_done_in = addf_0_reg_done;
assign invoke54_go_in = _guard248;
assign incr_repeat1_go_in = _guard254;
assign wrapper_early_reset_static_seq4_done_in = _guard255;
assign wrapper_early_reset_static_seq5_go_in = _guard261;
assign addf_1_reg_write_en =
  _guard284 ? 1'd1 :
  _guard285 ? std_addFN_1_done :
  1'd0;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard285, _guard284})) begin
    $fatal(2, "Multiple assignment to port `addf_1_reg.write_en'.");
end
end
assign addf_1_reg_clk = clk;
assign addf_1_reg_reset = reset;
assign addf_1_reg_in =
  _guard286 ? 32'd0 :
  _guard289 ? mem_2_read_data :
  _guard292 ? mem_1_read_data :
  _guard293 ? std_add_16_out :
  _guard300 ? mem_0_read_data :
  _guard301 ? std_addFN_1_out :
  _guard304 ? mem_3_read_data :
  'x;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard304, _guard301, _guard300, _guard293, _guard292, _guard289, _guard286})) begin
    $fatal(2, "Multiple assignment to port `addf_1_reg.in'.");
end
end
assign idx1_write_en = _guard307;
assign idx1_clk = clk;
assign idx1_reset = reset;
assign idx1_in =
  _guard308 ? adder1_out :
  _guard309 ? 2'd0 :
  2'd0;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard309, _guard308})) begin
    $fatal(2, "Multiple assignment to port `idx1.in'.");
end
end
assign lt1_left =
  _guard310 ? adder1_out :
  2'd0;
assign lt1_right =
  _guard311 ? 2'd3 :
  2'd0;
assign lt2_left =
  _guard312 ? adder2_out :
  4'd0;
assign lt2_right =
  _guard313 ? 4'd10 :
  4'd0;
assign cond_reg3_write_en = _guard316;
assign cond_reg3_clk = clk;
assign cond_reg3_reset = reset;
assign cond_reg3_in =
  _guard317 ? 1'd1 :
  _guard318 ? lt3_out :
  1'd0;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard318, _guard317})) begin
    $fatal(2, "Multiple assignment to port `cond_reg3.in'.");
end
end
assign adder4_left =
  _guard319 ? idx4_out :
  2'd0;
assign adder4_right =
  _guard320 ? 2'd1 :
  2'd0;
assign invoke2_go_in = _guard326;
assign wrapper_early_reset_static_par_thread_go_in = _guard332;
assign mem_2_write_en =
  _guard335 ? 1'd1 :
  _guard338 ? 1'd0 :
  1'd0;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard338, _guard335})) begin
    $fatal(2, "Multiple assignment to port `mem_2.write_en'.");
end
end
assign mem_2_clk = clk;
assign mem_2_addr0 = std_slice_15_out;
assign mem_2_content_en = _guard352;
assign mem_2_reset = reset;
assign mem_2_write_data = muli_8_reg_out;
assign cond_reg0_write_en = _guard358;
assign cond_reg0_clk = clk;
assign cond_reg0_reset = reset;
assign cond_reg0_in =
  _guard359 ? 1'd1 :
  _guard360 ? lt0_out :
  1'd0;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard360, _guard359})) begin
    $fatal(2, "Multiple assignment to port `cond_reg0.in'.");
end
end
assign invoke55_done_in = for_5_induction_var_reg_done;
assign incr_repeat3_done_in = _guard363;
assign incr_repeat4_done_in = _guard366;
assign early_reset_static_par_thread0_done_in = ud1_out;
assign early_reset_static_seq2_done_in = ud4_out;
assign early_reset_static_seq3_done_in = ud5_out;
assign early_reset_static_seq4_go_in = _guard367;
assign mem_4_write_en =
  _guard370 ? 1'd1 :
  _guard373 ? 1'd0 :
  1'd0;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard373, _guard370})) begin
    $fatal(2, "Multiple assignment to port `mem_4.write_en'.");
end
end
assign mem_4_clk = clk;
assign mem_4_addr0 = std_slice_15_out;
assign mem_4_content_en = _guard387;
assign mem_4_reset = reset;
assign mem_4_write_data = cst_1_out;
assign idx3_write_en = _guard393;
assign idx3_clk = clk;
assign idx3_reset = reset;
assign idx3_in =
  _guard394 ? 4'd0 :
  _guard395 ? adder3_out :
  4'd0;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard395, _guard394})) begin
    $fatal(2, "Multiple assignment to port `idx3.in'.");
end
end
assign bb0_42_done_in = arg_mem_1_done;
assign init_repeat1_go_in = _guard401;
assign incr_repeat3_go_in = _guard407;
assign early_reset_static_seq0_go_in = _guard408;
assign early_reset_static_seq5_go_in = _guard409;
assign wrapper_early_reset_static_seq1_done_in = _guard410;
assign for_4_induction_var_reg_write_en = _guard413;
assign for_4_induction_var_reg_clk = clk;
assign for_4_induction_var_reg_reset = reset;
assign for_4_induction_var_reg_in =
  _guard414 ? 32'd0 :
  _guard415 ? std_add_16_out :
  'x;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard415, _guard414})) begin
    $fatal(2, "Multiple assignment to port `for_4_induction_var_reg.in'.");
end
end
assign idx0_write_en = _guard418;
assign idx0_clk = clk;
assign idx0_reset = reset;
assign idx0_in =
  _guard419 ? 4'd0 :
  _guard420 ? adder0_out :
  4'd0;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard420, _guard419})) begin
    $fatal(2, "Multiple assignment to port `idx0.in'.");
end
end
assign bb0_13_done_in = arg_mem_0_done;
assign invoke11_go_in = _guard426;
assign invoke56_go_in = _guard432;
assign early_reset_static_seq1_done_in = ud3_out;
assign early_reset_static_seq2_go_in = _guard433;
assign early_reset_static_seq3_go_in = _guard434;
assign early_reset_static_seq6_go_in = _guard435;
assign early_reset_static_seq6_done_in = ud8_out;
assign wrapper_early_reset_static_seq0_go_in = _guard441;
assign std_mulFN_1_roundingMode = 3'd0;
assign std_mulFN_1_control = 1'd0;
assign std_mulFN_1_clk = clk;
assign std_mulFN_1_left =
  _guard442 ? load_7_reg_out :
  32'd0;
assign std_mulFN_1_reset = reset;
assign std_mulFN_1_go = _guard446;
assign std_mulFN_1_right =
  _guard447 ? addf_1_reg_out :
  32'd0;
assign std_mulFN_0_roundingMode = 3'd0;
assign std_mulFN_0_control = 1'd0;
assign std_mulFN_0_clk = clk;
assign std_mulFN_0_left =
  _guard448 ? addf_1_reg_out :
  32'd0;
assign std_mulFN_0_reset = reset;
assign std_mulFN_0_go = _guard452;
assign std_mulFN_0_right =
  _guard453 ? addf_1_reg_out :
  32'd0;
assign lt4_left =
  _guard454 ? adder4_out :
  2'd0;
assign lt4_right =
  _guard455 ? 2'd3 :
  2'd0;
assign adder6_left =
  _guard456 ? fsm_out :
  4'd0;
assign adder6_right =
  _guard457 ? 4'd1 :
  4'd0;
assign bb0_16_go_in = _guard463;
assign invoke12_go_in = _guard469;
assign invoke16_done_in = for_5_induction_var_reg_done;
assign incr_repeat_go_in = _guard475;
assign init_repeat1_done_in = _guard478;
assign early_reset_static_seq1_go_in = _guard479;
assign tdcc_go_in = go;
assign mem_1_write_en =
  _guard482 ? 1'd1 :
  _guard489 ? 1'd0 :
  1'd0;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard489, _guard482})) begin
    $fatal(2, "Multiple assignment to port `mem_1.write_en'.");
end
end
assign mem_1_clk = clk;
assign mem_1_addr0 = std_slice_15_out;
assign mem_1_content_en = _guard507;
assign mem_1_reset = reset;
assign mem_1_write_data = muli_8_reg_out;
assign std_slice_15_in = 32'd0;
assign addf_0_reg_write_en =
  _guard552 ? 1'd1 :
  _guard553 ? std_addFN_0_done :
  1'd0;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard553, _guard552})) begin
    $fatal(2, "Multiple assignment to port `addf_0_reg.write_en'.");
end
end
assign addf_0_reg_clk = clk;
assign addf_0_reg_reset = reset;
assign addf_0_reg_in =
  _guard554 ? 32'd0 :
  _guard555 ? std_addFN_0_out :
  _guard556 ? std_add_16_out :
  'x;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard556, _guard555, _guard554})) begin
    $fatal(2, "Multiple assignment to port `addf_0_reg.in'.");
end
end
assign adder2_left =
  _guard557 ? idx2_out :
  4'd0;
assign adder2_right =
  _guard558 ? 4'd1 :
  4'd0;
assign fsm0_write_en = _guard949;
assign fsm0_clk = clk;
assign fsm0_reset = reset;
assign fsm0_in =
  _guard954 ? 6'd9 :
  _guard959 ? 6'd19 :
  _guard964 ? 6'd33 :
  _guard969 ? 6'd35 :
  _guard984 ? 6'd4 :
  _guard999 ? 6'd20 :
  _guard1016 ? 6'd14 :
  _guard1021 ? 6'd21 :
  _guard1026 ? 6'd26 :
  _guard1031 ? 6'd32 :
  _guard1036 ? 6'd11 :
  _guard1041 ? 6'd29 :
  _guard1046 ? 6'd27 :
  _guard1051 ? 6'd34 :
  _guard1056 ? 6'd39 :
  _guard1061 ? 6'd5 :
  _guard1078 ? 6'd12 :
  _guard1083 ? 6'd3 :
  _guard1088 ? 6'd8 :
  _guard1093 ? 6'd28 :
  _guard1098 ? 6'd36 :
  _guard1103 ? 6'd41 :
  _guard1120 ? 6'd42 :
  _guard1125 ? 6'd7 :
  _guard1130 ? 6'd13 :
  _guard1145 ? 6'd16 :
  _guard1150 ? 6'd31 :
  _guard1155 ? 6'd22 :
  _guard1160 ? 6'd30 :
  _guard1161 ? 6'd0 :
  _guard1176 ? 6'd6 :
  _guard1193 ? 6'd10 :
  _guard1198 ? 6'd24 :
  _guard1213 ? 6'd2 :
  _guard1218 ? 6'd15 :
  _guard1223 ? 6'd17 :
  _guard1228 ? 6'd23 :
  _guard1245 ? 6'd40 :
  _guard1250 ? 6'd25 :
  _guard1267 ? 6'd38 :
  _guard1272 ? 6'd1 :
  _guard1287 ? 6'd18 :
  _guard1292 ? 6'd37 :
  _guard1297 ? 6'd43 :
  6'd0;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard1297, _guard1292, _guard1287, _guard1272, _guard1267, _guard1250, _guard1245, _guard1228, _guard1223, _guard1218, _guard1213, _guard1198, _guard1193, _guard1176, _guard1161, _guard1160, _guard1155, _guard1150, _guard1145, _guard1130, _guard1125, _guard1120, _guard1103, _guard1098, _guard1093, _guard1088, _guard1083, _guard1078, _guard1061, _guard1056, _guard1051, _guard1046, _guard1041, _guard1036, _guard1031, _guard1026, _guard1021, _guard1016, _guard999, _guard984, _guard969, _guard964, _guard959, _guard954})) begin
    $fatal(2, "Multiple assignment to port `fsm0.in'.");
end
end
assign bb0_35_done_in = addf_1_reg_done;
assign invoke3_done_in = mulf_2_reg_done;
assign invoke10_done_in = mulf_2_reg_done;
assign invoke57_done_in = for_7_induction_var_reg_done;
assign incr_repeat0_done_in = _guard1300;
assign incr_repeat2_go_in = _guard1306;
assign load_7_reg_write_en = _guard1321;
assign load_7_reg_clk = clk;
assign load_7_reg_reset = reset;
assign load_7_reg_in =
  _guard1322 ? 32'd0 :
  _guard1325 ? mem_4_read_data :
  _guard1328 ? mem_1_read_data :
  _guard1329 ? std_add_16_out :
  _guard1332 ? mem_5_read_data :
  'x;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard1332, _guard1329, _guard1328, _guard1325, _guard1322})) begin
    $fatal(2, "Multiple assignment to port `load_7_reg.in'.");
end
end
assign std_addFN_0_roundingMode = 3'd0;
assign std_addFN_0_control = 1'd0;
assign std_addFN_0_clk = clk;
assign std_addFN_0_left =
  _guard1333 ? mulf_2_reg_out :
  32'd0;
assign std_addFN_0_subOp =
  _guard1334 ? 1'd0 :
  1'd0;
assign std_addFN_0_reset = reset;
assign std_addFN_0_go = _guard1338;
assign std_addFN_0_right =
  _guard1339 ? muli_8_reg_out :
  32'd0;
assign for_7_induction_var_reg_write_en = _guard1342;
assign for_7_induction_var_reg_clk = clk;
assign for_7_induction_var_reg_reset = reset;
assign for_7_induction_var_reg_in =
  _guard1343 ? 32'd0 :
  _guard1344 ? std_add_16_out :
  'x;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard1344, _guard1343})) begin
    $fatal(2, "Multiple assignment to port `for_7_induction_var_reg.in'.");
end
end
assign idx_write_en = _guard1347;
assign idx_clk = clk;
assign idx_reset = reset;
assign idx_in =
  _guard1348 ? adder_out :
  _guard1349 ? 4'd0 :
  4'd0;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard1349, _guard1348})) begin
    $fatal(2, "Multiple assignment to port `idx.in'.");
end
end
assign adder3_left =
  _guard1350 ? idx3_out :
  4'd0;
assign adder3_right =
  _guard1351 ? 4'd1 :
  4'd0;
assign adder5_left =
  _guard1352 ? fsm_out :
  4'd0;
assign adder5_right =
  _guard1353 ? 4'd1 :
  4'd0;
assign invoke12_done_in = load_7_reg_done;
assign invoke17_go_in = _guard1359;
assign invoke56_done_in = for_6_induction_var_reg_done;
assign init_repeat_done_in = _guard1362;
assign incr_repeat_done_in = _guard1365;
assign init_repeat0_done_in = _guard1368;
assign wrapper_early_reset_static_seq_done_in = _guard1369;
assign wrapper_early_reset_static_seq3_go_in = _guard1375;
assign std_add_16_left =
  _guard1376 ? for_5_induction_var_reg_out :
  _guard1411 ? muli_8_reg_out :
  _guard1412 ? addf_1_reg_out :
  _guard1413 ? for_4_induction_var_reg_out :
  _guard1414 ? addf_0_reg_out :
  _guard1415 ? load_7_reg_out :
  _guard1416 ? for_7_induction_var_reg_out :
  _guard1417 ? mulf_2_reg_out :
  _guard1418 ? for_6_induction_var_reg_out :
  'x;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard1418, _guard1417, _guard1416, _guard1415, _guard1414, _guard1413, _guard1412, _guard1411, _guard1376})) begin
    $fatal(2, "Multiple assignment to port `std_add_16.left'.");
end
end
assign std_add_16_right =
  _guard1429 ? for_5_induction_var_reg_out :
  _guard1432 ? for_4_induction_var_reg_out :
  _guard1437 ? addf_0_reg_out :
  _guard1442 ? load_7_reg_out :
  _guard1443 ? mulf_2_reg_out :
  _guard1454 ? for_6_induction_var_reg_out :
  _guard1469 ? 32'd1 :
  'x;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard1469, _guard1454, _guard1443, _guard1442, _guard1437, _guard1432, _guard1429})) begin
    $fatal(2, "Multiple assignment to port `std_add_16.right'.");
end
end
assign mulf_2_reg_write_en =
  _guard1472 ? 1'd1 :
  _guard1473 ? std_mulFN_2_done :
  1'd0;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard1473, _guard1472})) begin
    $fatal(2, "Multiple assignment to port `mulf_2_reg.write_en'.");
end
end
assign mulf_2_reg_clk = clk;
assign mulf_2_reg_reset = reset;
assign mulf_2_reg_in =
  _guard1474 ? 32'd0 :
  _guard1475 ? std_add_16_out :
  _guard1476 ? std_mulFN_2_out :
  'x;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard1476, _guard1475, _guard1474})) begin
    $fatal(2, "Multiple assignment to port `mulf_2_reg.in'.");
end
end
assign adder0_left =
  _guard1477 ? idx0_out :
  4'd0;
assign adder0_right =
  _guard1478 ? 4'd1 :
  4'd0;
assign idx4_write_en = _guard1481;
assign idx4_clk = clk;
assign idx4_reset = reset;
assign idx4_in =
  _guard1482 ? adder4_out :
  _guard1483 ? 2'd0 :
  2'd0;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard1483, _guard1482})) begin
    $fatal(2, "Multiple assignment to port `idx4.in'.");
end
end
assign adder11_left =
  _guard1484 ? fsm_out :
  4'd0;
assign adder11_right =
  _guard1485 ? 4'd1 :
  4'd0;
assign bb0_16_done_in = muli_8_reg_done;
assign bb0_27_done_in = mulf_2_reg_done;
assign bb0_31_done_in = addf_0_reg_done;
assign invoke16_go_in = _guard1491;
assign init_repeat0_go_in = _guard1497;
assign incr_repeat0_go_in = _guard1503;
assign init_repeat2_go_in = _guard1509;
assign early_reset_static_seq_go_in = _guard1510;
assign wrapper_early_reset_static_par_thread0_go_in = _guard1516;
assign mem_0_write_en =
  _guard1519 ? 1'd1 :
  _guard1530 ? 1'd0 :
  1'd0;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard1530, _guard1519})) begin
    $fatal(2, "Multiple assignment to port `mem_0.write_en'.");
end
end
assign mem_0_clk = clk;
assign mem_0_addr0 = std_slice_15_out;
assign mem_0_content_en = _guard1556;
assign mem_0_reset = reset;
assign mem_0_write_data = arg_mem_0_read_data;
assign std_addFN_1_roundingMode = 3'd0;
assign std_addFN_1_control = 1'd0;
assign std_addFN_1_clk = clk;
assign std_addFN_1_left =
  _guard1560 ? addf_0_reg_out :
  32'd0;
assign std_addFN_1_subOp =
  _guard1561 ? 1'd0 :
  1'd0;
assign std_addFN_1_reset = reset;
assign std_addFN_1_go = _guard1565;
assign std_addFN_1_right =
  _guard1566 ? muli_8_reg_out :
  32'd0;
assign for_6_induction_var_reg_write_en = _guard1569;
assign for_6_induction_var_reg_clk = clk;
assign for_6_induction_var_reg_reset = reset;
assign for_6_induction_var_reg_in =
  _guard1570 ? 32'd0 :
  _guard1571 ? std_add_16_out :
  'x;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard1571, _guard1570})) begin
    $fatal(2, "Multiple assignment to port `for_6_induction_var_reg.in'.");
end
end
assign adder8_left =
  _guard1572 ? fsm_out :
  4'd0;
assign adder8_right =
  _guard1573 ? 4'd1 :
  4'd0;
assign signal_reg_write_en = _guard1652;
assign signal_reg_clk = clk;
assign signal_reg_reset = reset;
assign signal_reg_in =
  _guard1729 ? 1'd1 :
  _guard1730 ? 1'd0 :
  1'd0;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard1730, _guard1729})) begin
    $fatal(2, "Multiple assignment to port `signal_reg.in'.");
end
end
assign bb0_6_done_in = arg_mem_1_done;
assign bb0_20_done_in = muli_8_reg_done;
assign invoke2_done_in = addf_0_reg_done;
assign invoke55_go_in = _guard1736;
assign invoke57_go_in = _guard1742;
assign incr_repeat1_done_in = _guard1745;
assign init_repeat2_done_in = _guard1748;
assign early_reset_static_par_thread_go_in = _guard1749;
assign early_reset_static_seq5_done_in = ud7_out;
assign wrapper_early_reset_static_par_thread0_done_in = _guard1750;
assign bb0_35_go_in = _guard1756;
assign invoke54_done_in = for_4_induction_var_reg_done;
assign early_reset_static_par_thread0_go_in = _guard1757;
assign early_reset_static_seq4_done_in = ud6_out;
assign wrapper_early_reset_static_par_thread_done_in = _guard1758;
assign wrapper_early_reset_static_seq2_done_in = _guard1759;
assign wrapper_early_reset_static_seq6_done_in = _guard1760;
assign std_mult_pipe_8_clk = clk;
assign std_mult_pipe_8_left =
  _guard1763 ? addf_1_reg_out :
  _guard1770 ? for_7_induction_var_reg_out :
  _guard1799 ? std_add_16_out :
  'x;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard1799, _guard1770, _guard1763})) begin
    $fatal(2, "Multiple assignment to port `std_mult_pipe_8.left'.");
end
end
assign std_mult_pipe_8_reset = reset;
assign std_mult_pipe_8_go = _guard1834;
assign std_mult_pipe_8_right =
  _guard1845 ? 32'd300 :
  _guard1862 ? 32'd10 :
  _guard1879 ? 32'd100 :
  'x;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard1879, _guard1862, _guard1845})) begin
    $fatal(2, "Multiple assignment to port `std_mult_pipe_8.right'.");
end
end
assign std_mulFN_4_roundingMode = 3'd0;
assign std_mulFN_4_control = 1'd0;
assign std_mulFN_4_clk = clk;
assign std_mulFN_4_left =
  _guard1880 ? load_7_reg_out :
  32'd0;
assign std_mulFN_4_reset = reset;
assign std_mulFN_4_go = _guard1884;
assign std_mulFN_4_right =
  _guard1885 ? addf_1_reg_out :
  32'd0;
assign std_mulFN_3_roundingMode = 3'd0;
assign std_mulFN_3_control = 1'd0;
assign std_mulFN_3_clk = clk;
assign std_mulFN_3_left =
  _guard1886 ? load_7_reg_out :
  32'd0;
assign std_mulFN_3_reset = reset;
assign std_mulFN_3_go = _guard1890;
assign std_mulFN_3_right =
  _guard1891 ? addf_1_reg_out :
  32'd0;
assign bb0_30_go_in = _guard1897;
assign bb0_34_go_in = _guard1903;
assign bb0_34_done_in = muli_8_reg_done;
assign invoke17_done_in = for_4_induction_var_reg_done;
assign init_repeat4_go_in = _guard1909;
assign early_reset_static_seq_done_in = ud0_out;
assign wrapper_early_reset_static_seq1_go_in = _guard1915;
assign tdcc_done_in = _guard1916;
assign std_slice_17_in = std_add_16_out;
assign mem_3_write_en =
  _guard1924 ? 1'd1 :
  _guard1927 ? 1'd0 :
  1'd0;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard1927, _guard1924})) begin
    $fatal(2, "Multiple assignment to port `mem_3.write_en'.");
end
end
assign mem_3_clk = clk;
assign mem_3_addr0 = std_slice_15_out;
assign mem_3_content_en = _guard1937;
assign mem_3_reset = reset;
assign mem_3_write_data = cst_2_out;
assign lt_left =
  _guard1941 ? adder_out :
  4'd0;
assign lt_right =
  _guard1942 ? 4'd10 :
  4'd0;
assign cond_reg2_write_en = _guard1945;
assign cond_reg2_clk = clk;
assign cond_reg2_reset = reset;
assign cond_reg2_in =
  _guard1946 ? 1'd1 :
  _guard1947 ? lt2_out :
  1'd0;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard1947, _guard1946})) begin
    $fatal(2, "Multiple assignment to port `cond_reg2.in'.");
end
end
assign bb0_31_go_in = _guard1953;
assign invoke3_go_in = _guard1959;
assign init_repeat3_go_in = _guard1965;
assign init_repeat3_done_in = _guard1968;
assign incr_repeat4_go_in = _guard1974;
assign wrapper_early_reset_static_seq2_go_in = _guard1980;
assign wrapper_early_reset_static_seq3_done_in = _guard1981;
assign wrapper_early_reset_static_seq6_go_in = _guard1987;
assign cond_reg4_write_en = _guard1990;
assign cond_reg4_clk = clk;
assign cond_reg4_reset = reset;
assign cond_reg4_in =
  _guard1991 ? 1'd1 :
  _guard1992 ? lt4_out :
  1'd0;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard1992, _guard1991})) begin
    $fatal(2, "Multiple assignment to port `cond_reg4.in'.");
end
end
assign early_reset_static_par_thread_done_in = ud_out;
assign early_reset_static_seq0_done_in = ud2_out;
assign wrapper_early_reset_static_seq_go_in = _guard1998;
assign wrapper_early_reset_static_seq0_done_in = _guard1999;
assign wrapper_early_reset_static_seq4_go_in = _guard2005;
assign std_mulFN_2_roundingMode = 3'd0;
assign std_mulFN_2_control = 1'd0;
assign std_mulFN_2_clk = clk;
assign std_mulFN_2_left =
  _guard2006 ? addf_1_reg_out :
  32'd0;
assign std_mulFN_2_reset = reset;
assign std_mulFN_2_go = _guard2010;
assign std_mulFN_2_right =
  _guard2011 ? muli_8_reg_out :
  32'd0;
assign mem_5_write_en =
  _guard2014 ? 1'd1 :
  _guard2017 ? 1'd0 :
  1'd0;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard2017, _guard2014})) begin
    $fatal(2, "Multiple assignment to port `mem_5.write_en'.");
end
end
assign mem_5_clk = clk;
assign mem_5_addr0 = std_slice_15_out;
assign mem_5_content_en = _guard2031;
assign mem_5_reset = reset;
assign mem_5_write_data = cst_0_out;
assign cond_reg_write_en = _guard2037;
assign cond_reg_clk = clk;
assign cond_reg_reset = reset;
assign cond_reg_in =
  _guard2038 ? 1'd1 :
  _guard2039 ? lt_out :
  1'd0;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard2039, _guard2038})) begin
    $fatal(2, "Multiple assignment to port `cond_reg.in'.");
end
end
assign lt0_left =
  _guard2040 ? adder0_out :
  4'd0;
assign lt0_right =
  _guard2041 ? 4'd10 :
  4'd0;
assign idx2_write_en = _guard2044;
assign idx2_clk = clk;
assign idx2_reset = reset;
assign idx2_in =
  _guard2045 ? 4'd0 :
  _guard2046 ? adder2_out :
  4'd0;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard2046, _guard2045})) begin
    $fatal(2, "Multiple assignment to port `idx2.in'.");
end
end
assign lt3_left =
  _guard2047 ? adder3_out :
  4'd0;
assign lt3_right =
  _guard2048 ? 4'd10 :
  4'd0;
assign adder7_left =
  _guard2049 ? fsm_out :
  4'd0;
assign adder7_right =
  _guard2050 ? 4'd1 :
  4'd0;
assign adder9_left =
  _guard2051 ? fsm_out :
  4'd0;
assign adder9_right =
  _guard2052 ? 4'd1 :
  4'd0;
assign bb0_13_go_in = _guard2058;
assign invoke10_go_in = _guard2064;
assign incr_repeat2_done_in = _guard2067;
assign init_repeat4_done_in = _guard2070;
assign wrapper_early_reset_static_seq5_done_in = _guard2071;
// COMPONENT END: gelu
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
    mulRecFNToFullRaw#(parameter expWidth = 3, parameter sigWidth = 3) (
        input [(1 - 1):0] control,
        input [(expWidth + sigWidth):0] a,
        input [(expWidth + sigWidth):0] b,
        output invalidExc,
        output out_isNaN,
        output out_isInf,
        output out_isZero,
        output out_sign,
        output signed [(expWidth + 1):0] out_sExp,
        output [(sigWidth*2 - 1):0] out_sig
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
    wire notSigNaN_invalidExc = (isInfA && isZeroB) || (isZeroA && isInfB);
    wire notNaN_isInfOut = isInfA || isInfB;
    wire notNaN_isZeroOut = isZeroA || isZeroB;
    wire notNaN_signOut = signA ^ signB;
    wire signed [(expWidth + 1):0] common_sExpOut =
        sExpA + sExpB - (1<<expWidth);
    wire [(sigWidth*2 - 1):0] common_sigOut = sigA * sigB;
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
    mulRecFNToRaw#(parameter expWidth = 3, parameter sigWidth = 3) (
        input [(1 - 1):0] control,
        input [(expWidth + sigWidth):0] a,
        input [(expWidth + sigWidth):0] b,
        output invalidExc,
        output out_isNaN,
        output out_isInf,
        output out_isZero,
        output out_sign,
        output signed [(expWidth + 1):0] out_sExp,
        output [(sigWidth + 2):0] out_sig
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
    wire notSigNaN_invalidExc = (isInfA && isZeroB) || (isZeroA && isInfB);
    wire notNaN_isInfOut = isInfA || isInfB;
    wire notNaN_isZeroOut = isZeroA || isZeroB;
    wire notNaN_signOut = signA ^ signB;
    wire signed [(expWidth + 1):0] common_sExpOut =
        sExpA + sExpB - (1<<expWidth);
    wire [(sigWidth*2 - 1):0] sigProd = sigA * sigB;
    wire [(sigWidth + 2):0] common_sigOut =
        {sigProd[(sigWidth*2 - 1):(sigWidth - 2)], |sigProd[(sigWidth - 3):0]};
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
    mulRecFN#(parameter expWidth = 3, parameter sigWidth = 3) (
        input [(1 - 1):0] control,
        input [(expWidth + sigWidth):0] a,
        input [(expWidth + sigWidth):0] b,
        input [2:0] roundingMode,
        output [(expWidth + sigWidth):0] out,
        output [4:0] exceptionFlags
    );

    wire invalidExc, out_isNaN, out_isInf, out_isZero, out_sign;
    wire signed [(expWidth + 1):0] out_sExp;
    wire [(sigWidth + 2):0] out_sig;
    mulRecFNToRaw#(expWidth, sigWidth)
        mulRecFNToRaw(
            control,
            a,
            b,
            invalidExc,
            out_isNaN,
            out_isInf,
            out_isZero,
            out_sign,
            out_sExp,
            out_sig
        );
    roundRawFNToRecFN#(expWidth, sigWidth, 0)
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

