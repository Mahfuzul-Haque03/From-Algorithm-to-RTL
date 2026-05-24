module gemm_32x32_int32 (
  input  logic        clk,
  input  logic        rst_n,

  input  logic        start,
  output logic        done,

  // A memory read port (1024 entries)
  output logic [9:0]  A_addr,
  input  logic signed [31:0] A_rdata,

  // B memory read port (1024 entries)
  output logic [9:0]  B_addr,
  input  logic signed [31:0] B_rdata,

  // C memory write port (1024 entries)
  output logic        C_we,
  output logic [9:0]  C_addr,
  output logic signed [31:0] C_wdata
);

  // Indices: 0..31 fit in 5 bits
  logic [4:0] i, j, k;

  // Internal accumulator:
  // 32 products of (32-bit * 32-bit) -> 64-bit product, sum can exceed 32-bit.
  // Allo int32 semantics are typically wrap-around; we output lower 32 bits.
  logic signed [63:0] acc;

  // Pipeline registers for the read data (because memory is 1-cycle latency)
  logic signed [31:0] A_q, B_q;

  // FSM
  typedef enum logic [2:0] {
    S_IDLE,
    S_INIT_IJ,
    S_ISSUE_READ,   // drive A_addr/B_addr for current (i,j,k)
    S_CAPTURE,      // capture A_rdata/B_rdata (arrive this cycle)
    S_MAC,          // multiply-accumulate using captured A_q/B_q
    S_WRITE_C,
    S_DONE
  } state_t;

  state_t st;

  // Address mapping: row-major [r,c] -> r*32 + c
  function automatic logic [9:0] idx_2d(input logic [4:0] r, input logic [4:0] c);
    idx_2d = {r, 5'b0} + c;  // r*32 + c
  endfunction

  // Default outputs
  always_comb begin
    done   = 1'b0;
    C_we   = 1'b0;

    // keep last unless overwritten in sequential always_ff
    // (assigned in always_ff for clarity)
  end

  // Main sequential logic
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      st      <= S_IDLE;

      i       <= '0;
      j       <= '0;
      k       <= '0;
      acc     <= '0;

      A_addr  <= '0;
      B_addr  <= '0;
      A_q     <= '0;
      B_q     <= '0;

      C_addr  <= '0;
      C_wdata <= '0;
    end else begin
      case (st)

        S_IDLE: begin
          if (start) begin
            i   <= 5'd0;
            j   <= 5'd0;
            k   <= 5'd0;
            acc <= 64'sd0;
            st  <= S_INIT_IJ;
          end
        end

        // Prepare to compute a new (i,j)
        S_INIT_IJ: begin
          k   <= 5'd0;
          acc <= 64'sd0;
          st  <= S_ISSUE_READ;
        end

        // Issue reads for A[i,k] and B[k,j]
        // Data will be valid on A_rdata/B_rdata next cycle.
        S_ISSUE_READ: begin
          A_addr <= idx_2d(i, k);
          B_addr <= idx_2d(k, j);
          st     <= S_CAPTURE;
        end

        // Capture read data (1-cycle latency assumption)
        S_CAPTURE: begin
          A_q <= A_rdata;
          B_q <= B_rdata;
          st  <= S_MAC;
        end

        // Multiply-accumulate
        S_MAC: begin
          acc <= acc + ( $signed(A_q) * $signed(B_q) );

          if (k == 5'd31) begin
            st <= S_WRITE_C;
          end else begin
            k  <= k + 5'd1;
            st <= S_ISSUE_READ;
          end
        end

        // Write out C[i,j] once the sum is complete
        S_WRITE_C: begin
          C_addr  <= idx_2d(i, j);
          C_wdata <= acc[31:0];   // wrap/truncate to int32
          // pulse write enable (one cycle)
          // (combinational default sets C_we=0; we set it here by sequencing)
          st      <= S_DONE;
        end

        // Use S_DONE as a 1-cycle "commit/pulse" stage:
        // - assert C_we
        // - update i/j for next element or finish
        S_DONE: begin
          // write enable pulse
          // (drive via registered behavior)
          // We'll repurpose this state for both write pulse and loop advancement.
          // Assert C_we by holding it high with a registered signal:
          // easiest: drive it as a reg here with a separate reg.
          st <= S_DONE; // overwritten below
        end

        default: st <= S_IDLE;

      endcase

      // Handle write-enable pulse + loop advancement in a clean way
      if (st == S_DONE) begin
        // C_we pulse this cycle
        // (implemented by inferring it from st==S_DONE in a separate assign below)
        // Advance (i,j) after write
        if (i == 5'd31 && j == 5'd31) begin
          // finished all outputs
          // next cycle we go idle with done pulse
          st <= S_IDLE;
        end else begin
          if (j == 5'd31) begin
            j <= 5'd0;
            i <= i + 5'd1;
          end else begin
            j <= j + 5'd1;
          end
          st <= S_INIT_IJ;
        end
      end
    end
  end

  // Derived control pulses
  // - C_we: pulse when st==S_DONE (the cycle we "commit" C_wdata to memory)
  // - done: pulse when we just finished last write (detect end condition)
  assign C_we = (st == S_DONE);

  // done pulses when we are in S_DONE *and* we just wrote the last element
  assign done = (st == S_DONE) && (i == 5'd31) && (j == 5'd31);

endmodule
