`timescale 1ns / 1ps

module main (
    // Clock and Reset (Matches your Tcl script)
    input  logic        clk,
    input  logic        reset,

    // Control Interface (HLS Standard)
    input  logic        ap_start,
    output logic        ap_done,
    output logic        ap_idle,
    output logic        ap_ready,

    // Memory Interface for Matrix A (Input)
    // 32x32 = 1024 elements -> 10-bit address
    output logic [9:0]  A_address0,
    output logic        A_ce0,
    input  logic [31:0] A_q0,       // Data coming FROM memory A

    // Memory Interface for Matrix B (Input)
    output logic [9:0]  B_address0,
    output logic        B_ce0,
    input  logic [31:0] B_q0,       // Data coming FROM memory B

    // Memory Interface for Matrix C (Output)
    output logic [9:0]  C_address0,
    output logic        C_ce0,
    output logic        C_we0,      // Write Enable
    output logic [31:0] C_d0        // Data writing TO memory C
);

    // --------------------------------------------------------
    // Parameters
    // --------------------------------------------------------
    localparam integer DIM = 32;

    // --------------------------------------------------------
    // FSM States
    // --------------------------------------------------------
    typedef enum logic [2:0] {
        ST_IDLE      = 3'b000,
        ST_INIT_ACC  = 3'b001,
        ST_READ_RAM  = 3'b010,
        ST_WAIT_RAM  = 3'b011,
        ST_ACCUM     = 3'b100,
        ST_WRITE_C   = 3'b101,
        ST_DONE      = 3'b110
    } state_t;

    state_t current_state, next_state;

    // --------------------------------------------------------
    // Internal Registers
    // --------------------------------------------------------
    logic [5:0]  i;   // Loop counter for rows (0-31)
    logic [5:0]  j;   // Loop counter for cols (0-31)
    logic [5:0]  k;   // Loop counter for inner dot prod (0-31)
    
    logic [31:0] accumulator; // Stores sum of A*B
    
    // --------------------------------------------------------
    // FSM Sequential Logic
    // --------------------------------------------------------
    always_ff @(posedge clk) begin
        if (reset) begin
            current_state <= ST_IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    // --------------------------------------------------------
    // FSM Combinational Logic
    // --------------------------------------------------------
    always_comb begin
        next_state = current_state;
        case (current_state)
            ST_IDLE: begin
                if (ap_start)
                    next_state = ST_INIT_ACC;
                else
                    next_state = ST_IDLE;
            end
            
            ST_INIT_ACC: begin
                // Ready to start calculating a new C[i,j] cell
                next_state = ST_READ_RAM;
            end

            ST_READ_RAM: begin
                // Address is set, move to wait state
                next_state = ST_WAIT_RAM;
            end

            ST_WAIT_RAM: begin
                // Latency cycle for Block RAM read
                next_state = ST_ACCUM;
            end

            ST_ACCUM: begin
                // Check if we finished the Dot Product for this cell (k loop)
                if (k == DIM - 1)
                    next_state = ST_WRITE_C;
                else
                    next_state = ST_READ_RAM; // Fetch next k
            end

            ST_WRITE_C: begin
                // Check if we finished the whole matrix
                if (j == DIM - 1 && i == DIM - 1)
                    next_state = ST_DONE;
                else
                    next_state = ST_INIT_ACC; // Move to next cell
            end

            ST_DONE: begin
                // Handshake
                next_state = ST_IDLE;
            end
            
            default: next_state = ST_IDLE;
        endcase
    end

    // --------------------------------------------------------
    // Datapath & Loop Counters
    // --------------------------------------------------------
    always_ff @(posedge clk) begin
        if (reset) begin
            i <= 0;
            j <= 0;
            k <= 0;
            accumulator <= 0;
        end else begin
            case (current_state)
                ST_IDLE: begin
                    i <= 0;
                    j <= 0;
                    k <= 0;
                    accumulator <= 0;
                end

                ST_INIT_ACC: begin
                    // Reset accumulator for the new cell C[i,j]
                    accumulator <= 0;
                    k <= 0; 
                end

                ST_ACCUM: begin
                    // The MAC operation: Sum += A * B
                    accumulator <= accumulator + (A_q0 * B_q0);
                    
                    if (k < DIM - 1) begin
                        k <= k + 1;
                    end
                end

                ST_WRITE_C: begin
                    // Update i, j loops
                    if (j == DIM - 1) begin
                        j <= 0;
                        if (i < DIM - 1) begin
                            i <= i + 1;
                        end
                    end else begin
                        j <= j + 1;
                    end
                end
            endcase
        end
    end

    // --------------------------------------------------------
    // Output Logic / Memory Mapping
    // --------------------------------------------------------
    
    // Control Signals
    assign ap_done  = (current_state == ST_DONE);
    assign ap_ready = (current_state == ST_DONE);
    assign ap_idle  = (current_state == ST_IDLE);

    // Flatten 2D indices to 1D address: Addr = (Row * 32) + Col
    // (Row << 5) is equivalent to Row * 32
    
    // A Address: A[i][k]
    assign A_address0 = {i[4:0], k[4:0]}; 
    assign A_ce0      = (current_state == ST_READ_RAM);

    // B Address: B[k][j]
    assign B_address0 = {k[4:0], j[4:0]};
    assign B_ce0      = (current_state == ST_READ_RAM);

    // C Address: C[i][j]
    // We write only in the ST_WRITE_C state
    assign C_address0 = {i[4:0], j[4:0]};
    assign C_ce0      = (current_state == ST_WRITE_C);
    assign C_we0      = (current_state == ST_WRITE_C);
    assign C_d0       = accumulator;

endmodule
