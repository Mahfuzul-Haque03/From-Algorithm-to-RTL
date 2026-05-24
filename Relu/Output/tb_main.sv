`timescale 1ns/1ps

module tb_main;
  // 250 MHz example: 4 ns period
  localparam time T_HALF = 2ns;

  reg clk = 0;
  always #(T_HALF) clk = ~clk;

  reg reset;
  reg go;
  wire done;

  // counters
  integer cycle;
  integer start_cycle;
  reg measuring;

  // DUT
  main dut (
    .clk(clk),
    .reset(reset),
    .go(go),
    .done(done)
  );

  // cycle counter
  always @(posedge clk) begin
    if (reset) cycle <= 0;
    else       cycle <= cycle + 1;
  end

  // latency measurement
  always @(posedge clk) begin
    if (reset) begin
      measuring   <= 0;
      start_cycle <= 0;
    end else begin
      if (go && !measuring) begin
        measuring   <= 1;
        start_cycle <= cycle;
      end
      if (done && measuring) begin
        $display("LATENCY_CYCLES=%0d", (cycle - start_cycle));
        measuring <= 0;
      end
    end
  end

  initial begin
    reset = 1;
    go    = 0;
    cycle = 0;
    measuring = 0;

    repeat (10) @(posedge clk);
    reset = 0;

    repeat (2) @(posedge clk);

    // pulse go
    @(posedge clk); go = 1;
    @(posedge clk); go = 0;

    // wait done and finish
    wait (done === 1'b1);
    repeat (5) @(posedge clk);
    $finish;
  end
endmodule
