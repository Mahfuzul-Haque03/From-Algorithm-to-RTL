/**
Implements a memory with sequential reads and writes.
- Both reads and writes take one cycle to perform.
- Attempting to read and write at the same time is an error.
- The out signal is registered to the last value requested by the read_en signal.
- The out signal is undefined once write_en is asserted.
*/
module increase_stream (
  input  logic              clk,
  input  logic              rst_n,

  // input channel
  input  logic              in_valid,
  output logic              in_ready,
  input  logic signed [31:0] in_A,

  // output channel
  output logic              out_valid,
  input  logic              out_ready,
  output logic signed [31:0] out_B0
);

  // 1-stage pipeline register
  logic full;

  assign in_ready  = !full || (out_ready);     // can accept if buffer empty or being consumed
  assign out_valid = full;
  
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      full   <= 1'b0;
      out_B0 <= 32'sd0;
    end else begin
      // consume output
      if (out_ready && out_valid) begin
        full <= 1'b0;
      end

      // accept input
      if (in_valid && in_ready) begin
        out_B0 <= in_A + 32'sd1;
        full   <= 1'b1;
      end
    end
  end

endmodule
