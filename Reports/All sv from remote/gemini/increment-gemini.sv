`timescale 1ns / 1ps

module main (
    // PORTS MUST MATCH YOUR TCL SCRIPT EXACTLY
    input  logic        clk,      // Matches: create_clock ... [get_ports clk]
    input  logic        reset,    // Matches: set_false_path -from [get_ports reset]
    
    // HLS Control Interface
    input  logic        ap_start,
    output logic        ap_done,
    output logic        ap_idle,
    output logic        ap_ready,
    
    // Scalar Input A
    input  logic [31:0] A,
    
    // Array Output B (Standard HLS Memory Interface)
    output logic [0:0]  B_address0,
    output logic        B_ce0,
    output logic        B_we0,
    output logic [31:0] B_d0
);

    // --------------------------------------------------------
    // FSM States
    // --------------------------------------------------------
    typedef enum logic [1:0] {
        ST_IDLE    = 2'b00,
        ST_COMPUTE = 2'b01,
        ST_WRITE   = 2'b10
    } state_t;

    state_t current_state, next_state;

    // --------------------------------------------------------
    // Internal Registers
    // --------------------------------------------------------
    logic [31:0] result_reg;

    // --------------------------------------------------------
    // FSM Logic
    // --------------------------------------------------------
    always_ff @(posedge clk) begin
        if (reset) begin
            current_state <= ST_IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    always_comb begin
        next_state = current_state;
        case (current_state)
            ST_IDLE: begin
                if (ap_start)
                    next_state = ST_COMPUTE;
                else
                    next_state = ST_IDLE;
            end
            ST_COMPUTE: begin
                // Move to write stage
                next_state = ST_WRITE;
            end
            ST_WRITE: begin
                // Handshake complete, return to IDLE
                next_state = ST_IDLE;
            end
            default: next_state = ST_IDLE;
        endcase
    end

    // --------------------------------------------------------
    // Datapath (The Calculation)
    // --------------------------------------------------------
    always_ff @(posedge clk) begin
        // We capture inputs at the start of the transaction
        if (current_state == ST_IDLE && ap_start) begin
            result_reg <= A + 1;
        end
    end

    // --------------------------------------------------------
    // Output Logic
    // --------------------------------------------------------
    assign ap_done  = (current_state == ST_WRITE);
    assign ap_ready = (current_state == ST_WRITE);
    assign ap_idle  = (current_state == ST_IDLE);

    // Memory Interface for B
    assign B_address0 = 1'b0; 
    assign B_ce0      = (current_state == ST_WRITE);
    assign B_we0      = (current_state == ST_WRITE);
    assign B_d0       = result_reg;

endmodule
