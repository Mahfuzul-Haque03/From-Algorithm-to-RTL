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
string DATA;
int CODE;
initial begin
    CODE = $value$plusargs("DATA=%s", DATA);
    $display("DATA (path to meminit files): %s", DATA);
    $readmemh({DATA, "/mem_1.dat"}, mem_1.mem);
    $readmemh({DATA, "/mem_0.dat"}, mem_0.mem);
end
final begin
    $writememh({DATA, "/mem_1.out"}, mem_1.mem);
    $writememh({DATA, "/mem_0.out"}, mem_0.mem);
end
logic [31:0] std_slice_5_in;
logic [1:0] std_slice_5_out;
logic mem_1_clk;
logic mem_1_reset;
logic [1:0] mem_1_addr0;
logic mem_1_content_en;
logic mem_1_write_en;
logic [63:0] mem_1_write_data;
logic [63:0] mem_1_read_data;
logic mem_1_done;
logic mem_0_clk;
logic mem_0_reset;
logic [1:0] mem_0_addr0;
logic mem_0_content_en;
logic mem_0_write_en;
logic [63:0] mem_0_write_data;
logic [63:0] mem_0_read_data;
logic mem_0_done;
logic [2:0] fsm_in;
logic fsm_write_en;
logic fsm_clk;
logic fsm_reset;
logic [2:0] fsm_out;
logic fsm_done;
logic [2:0] adder_left;
logic [2:0] adder_right;
logic [2:0] adder_out;
logic ud_out;
logic signal_reg_in;
logic signal_reg_write_en;
logic signal_reg_clk;
logic signal_reg_reset;
logic signal_reg_out;
logic signal_reg_done;
logic early_reset_static_seq_go_in;
logic early_reset_static_seq_go_out;
logic early_reset_static_seq_done_in;
logic early_reset_static_seq_done_out;
logic wrapper_early_reset_static_seq_go_in;
logic wrapper_early_reset_static_seq_go_out;
logic wrapper_early_reset_static_seq_done_in;
logic wrapper_early_reset_static_seq_done_out;
std_slice # (
    .IN_WIDTH(32),
    .OUT_WIDTH(2)
) std_slice_5 (
    .in(std_slice_5_in),
    .out(std_slice_5_out)
);
seq_mem_d1 # (
    .IDX_SIZE(2),
    .SIZE(3),
    .WIDTH(64)
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
    .IDX_SIZE(2),
    .SIZE(3),
    .WIDTH(64)
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
) adder (
    .left(adder_left),
    .out(adder_out),
    .right(adder_right)
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
wire _guard0 = 1;
wire _guard1 = wrapper_early_reset_static_seq_done_out;
wire _guard2 = fsm_out != 3'd5;
wire _guard3 = early_reset_static_seq_go_out;
wire _guard4 = _guard2 & _guard3;
wire _guard5 = fsm_out == 3'd5;
wire _guard6 = early_reset_static_seq_go_out;
wire _guard7 = _guard5 & _guard6;
wire _guard8 = _guard4 | _guard7;
wire _guard9 = fsm_out != 3'd5;
wire _guard10 = early_reset_static_seq_go_out;
wire _guard11 = _guard9 & _guard10;
wire _guard12 = fsm_out == 3'd5;
wire _guard13 = early_reset_static_seq_go_out;
wire _guard14 = _guard12 & _guard13;
wire _guard15 = early_reset_static_seq_go_out;
wire _guard16 = early_reset_static_seq_go_out;
wire _guard17 = fsm_out == 3'd0;
wire _guard18 = fsm_out == 3'd3;
wire _guard19 = _guard17 | _guard18;
wire _guard20 = early_reset_static_seq_go_out;
wire _guard21 = _guard19 & _guard20;
wire _guard22 = fsm_out == 3'd2;
wire _guard23 = fsm_out == 3'd5;
wire _guard24 = _guard22 | _guard23;
wire _guard25 = early_reset_static_seq_go_out;
wire _guard26 = _guard24 & _guard25;
wire _guard27 = fsm_out == 3'd1;
wire _guard28 = fsm_out == 3'd4;
wire _guard29 = _guard27 | _guard28;
wire _guard30 = early_reset_static_seq_go_out;
wire _guard31 = _guard29 & _guard30;
wire _guard32 = fsm_out == 3'd3;
wire _guard33 = fsm_out == 3'd4;
wire _guard34 = _guard32 | _guard33;
wire _guard35 = fsm_out == 3'd5;
wire _guard36 = _guard34 | _guard35;
wire _guard37 = early_reset_static_seq_go_out;
wire _guard38 = _guard36 & _guard37;
wire _guard39 = fsm_out == 3'd3;
wire _guard40 = fsm_out == 3'd4;
wire _guard41 = _guard39 | _guard40;
wire _guard42 = fsm_out == 3'd5;
wire _guard43 = _guard41 | _guard42;
wire _guard44 = early_reset_static_seq_go_out;
wire _guard45 = _guard43 & _guard44;
wire _guard46 = fsm_out == 3'd3;
wire _guard47 = fsm_out == 3'd4;
wire _guard48 = _guard46 | _guard47;
wire _guard49 = fsm_out == 3'd5;
wire _guard50 = _guard48 | _guard49;
wire _guard51 = early_reset_static_seq_go_out;
wire _guard52 = _guard50 & _guard51;
wire _guard53 = fsm_out == 3'd4;
wire _guard54 = early_reset_static_seq_go_out;
wire _guard55 = _guard53 & _guard54;
wire _guard56 = fsm_out == 3'd5;
wire _guard57 = early_reset_static_seq_go_out;
wire _guard58 = _guard56 & _guard57;
wire _guard59 = fsm_out == 3'd3;
wire _guard60 = early_reset_static_seq_go_out;
wire _guard61 = _guard59 & _guard60;
wire _guard62 = signal_reg_out;
wire _guard63 = wrapper_early_reset_static_seq_go_out;
wire _guard64 = fsm_out == 3'd0;
wire _guard65 = fsm_out == 3'd1;
wire _guard66 = _guard64 | _guard65;
wire _guard67 = fsm_out == 3'd2;
wire _guard68 = _guard66 | _guard67;
wire _guard69 = early_reset_static_seq_go_out;
wire _guard70 = _guard68 & _guard69;
wire _guard71 = fsm_out == 3'd0;
wire _guard72 = fsm_out == 3'd1;
wire _guard73 = _guard71 | _guard72;
wire _guard74 = fsm_out == 3'd2;
wire _guard75 = _guard73 | _guard74;
wire _guard76 = early_reset_static_seq_go_out;
wire _guard77 = _guard75 & _guard76;
wire _guard78 = fsm_out == 3'd0;
wire _guard79 = fsm_out == 3'd1;
wire _guard80 = _guard78 | _guard79;
wire _guard81 = fsm_out == 3'd2;
wire _guard82 = _guard80 | _guard81;
wire _guard83 = early_reset_static_seq_go_out;
wire _guard84 = _guard82 & _guard83;
wire _guard85 = fsm_out == 3'd1;
wire _guard86 = early_reset_static_seq_go_out;
wire _guard87 = _guard85 & _guard86;
wire _guard88 = fsm_out == 3'd2;
wire _guard89 = early_reset_static_seq_go_out;
wire _guard90 = _guard88 & _guard89;
wire _guard91 = fsm_out == 3'd0;
wire _guard92 = early_reset_static_seq_go_out;
wire _guard93 = _guard91 & _guard92;
wire _guard94 = signal_reg_out;
wire _guard95 = fsm_out == 3'd5;
wire _guard96 = _guard95 & _guard0;
wire _guard97 = signal_reg_out;
wire _guard98 = ~_guard97;
wire _guard99 = _guard96 & _guard98;
wire _guard100 = wrapper_early_reset_static_seq_go_out;
wire _guard101 = _guard99 & _guard100;
wire _guard102 = _guard94 | _guard101;
wire _guard103 = fsm_out == 3'd5;
wire _guard104 = _guard103 & _guard0;
wire _guard105 = signal_reg_out;
wire _guard106 = ~_guard105;
wire _guard107 = _guard104 & _guard106;
wire _guard108 = wrapper_early_reset_static_seq_go_out;
wire _guard109 = _guard107 & _guard108;
wire _guard110 = signal_reg_out;
assign done = _guard1;
assign fsm_write_en = _guard8;
assign fsm_clk = clk;
assign fsm_reset = reset;
assign fsm_in =
  _guard11 ? adder_out :
  _guard14 ? 3'd0 :
  3'd0;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard14, _guard11})) begin
    $fatal(2, "Multiple assignment to port `fsm.in'.");
end
end
assign adder_left =
  _guard15 ? fsm_out :
  3'd0;
assign adder_right =
  _guard16 ? 3'd1 :
  3'd0;
assign std_slice_5_in =
  _guard21 ? 32'd0 :
  _guard26 ? 32'd2 :
  _guard31 ? 32'd1 :
  'x;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard31, _guard26, _guard21})) begin
    $fatal(2, "Multiple assignment to port `std_slice_5.in'.");
end
end
assign mem_1_write_en = _guard38;
assign mem_1_clk = clk;
assign mem_1_addr0 = std_slice_5_out;
assign mem_1_content_en = _guard52;
assign mem_1_reset = reset;
assign mem_1_write_data =
  _guard55 ? 64'd2 :
  _guard58 ? 64'd3 :
  _guard61 ? 64'd1 :
  'x;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard61, _guard58, _guard55})) begin
    $fatal(2, "Multiple assignment to port `mem_1.write_data'.");
end
end
assign wrapper_early_reset_static_seq_done_in = _guard62;
assign early_reset_static_seq_go_in = _guard63;
assign mem_0_write_en = _guard70;
assign mem_0_clk = clk;
assign mem_0_addr0 = std_slice_5_out;
assign mem_0_content_en = _guard84;
assign mem_0_reset = reset;
assign mem_0_write_data =
  _guard87 ? 64'd2 :
  _guard90 ? 64'd3 :
  _guard93 ? 64'd1 :
  'x;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard93, _guard90, _guard87})) begin
    $fatal(2, "Multiple assignment to port `mem_0.write_data'.");
end
end
assign signal_reg_write_en = _guard102;
assign signal_reg_clk = clk;
assign signal_reg_reset = reset;
assign signal_reg_in =
  _guard109 ? 1'd1 :
  _guard110 ? 1'd0 :
  1'd0;
always_ff @(posedge clk) begin
  if(~$onehot0({_guard110, _guard109})) begin
    $fatal(2, "Multiple assignment to port `signal_reg.in'.");
end
end
assign early_reset_static_seq_done_in = ud_out;
assign wrapper_early_reset_static_seq_go_in = go;
// COMPONENT END: main
endmodule
