`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Module: main
// Description: Synthesizable FFNN (64 -> 48 -> 4) with ReLU activation.
//              Uses Q16.16 Fixed Point Arithmetic.
//              No Vendor IP used.
//////////////////////////////////////////////////////////////////////////////////

module main #(
    parameter integer IN_SIZE = 64,
    parameter integer HID_SIZE = 48,
    parameter integer OUT_SIZE = 4,
    parameter integer DATA_WIDTH = 32,
    parameter integer FRAC_BITS = 16
)(
    input  logic                    clk,
    input  logic                    reset,
    
    // Interface to load input vector (Q16.16 format)
    input  logic                    in_we,
    input  logic [$clog2(IN_SIZE)-1:0] in_addr,
    input  logic [DATA_WIDTH-1:0]   in_data,
    
    // Control
    input  logic                    start,
    output logic                    done,
    
    // Outputs (Directly exposed for observation/synthesis preservation)
    output logic [DATA_WIDTH-1:0]   out_0,
    output logic [DATA_WIDTH-1:0]   out_1,
    output logic [DATA_WIDTH-1:0]   out_2,
    output logic [DATA_WIDTH-1:0]   out_3
);

    // -------------------------------------------------------------------------
    // Signal Definitions
    // -------------------------------------------------------------------------

    // State Machine
    typedef enum logic [2:0] {
        IDLE,
        COMPUTE_L1,
        COMPUTE_L2,
        FINISHED
    } state_t;

    state_t state, next_state;

    // Data Storage
    logic [DATA_WIDTH-1:0] ram_input  [0:IN_SIZE-1];
    logic [DATA_WIDTH-1:0] ram_hidden [0:HID_SIZE-1];
    logic [DATA_WIDTH-1:0] reg_output [0:OUT_SIZE-1];

    // Weights and Biases (Implemented as ROMs via logic)
    // In a real flow, these would be loaded from .mem files or an AXI interface.
    // Here we use arrays initialized with synthetic values to ensure synthesis logic generation.
    logic [DATA_WIDTH-1:0] rom_w1 [0:IN_SIZE-1][0:HID_SIZE-1]; // [64][48]
    logic [DATA_WIDTH-1:0] rom_b1 [0:HID_SIZE-1];               // [48]
    logic [DATA_WIDTH-1:0] rom_w2 [0:HID_SIZE-1][0:OUT_SIZE-1]; // [48][4]
    logic [DATA_WIDTH-1:0] rom_b2 [0:OUT_SIZE-1];               // [4]

    // Computation Signals
    logic [$clog2(IN_SIZE)-1:0]  idx_i; // Input iterator
    logic [$clog2(HID_SIZE)-1:0] idx_h; // Hidden iterator
    logic [$clog2(OUT_SIZE)-1:0] idx_o; // Output iterator

    logic signed [DATA_WIDTH-1:0]   op_a, op_b;
    logic signed [2*DATA_WIDTH-1:0] mult_res;
    logic signed [DATA_WIDTH-1:0]   mult_res_scaled;
    logic signed [DATA_WIDTH-1:0]   accumulator;

    // -------------------------------------------------------------------------
    // Memory Initialization (Synthetic Weights for Synthesis)
    // -------------------------------------------------------------------------
    // Initialize weights to deterministic non-zero values so Vivado infers DSPs.
    // Values roughly simulate normalized weights in Fixed Point Q16.16
    // 1.0 in Q16.16 = 65536. We use smaller values to avoid massive overflows in this demo.
    initial begin
        integer i, h, o;
        // Layer 1 Weights
        for (i = 0; i < IN_SIZE; i++) begin
            for (h = 0; h < HID_SIZE; h++) begin
                // Synthetic pattern: (i - h) * small_factor
                rom_w1[i][h] = (i - h) * 32'd100; 
            end
        end
        // Layer 1 Biases
        for (h = 0; h < HID_SIZE; h++) begin
            rom_b1[h] = 32'd1000; 
        end

        // Layer 2 Weights
        for (h = 0; h < HID_SIZE; h++) begin
            for (o = 0; o < OUT_SIZE; o++) begin
                rom_w2[h][o] = (h + o) * 32'd200;
            end
        end
        // Layer 2 Biases
        for (o = 0; o < OUT_SIZE; o++) begin
            rom_b2[o] = -32'd500;
        end
    end

    // -------------------------------------------------------------------------
    // Input Loading
    // -------------------------------------------------------------------------
    always_ff @(posedge clk) begin
        if (in_we) begin
            ram_input[in_addr] <= in_data;
        end
    end

    // -------------------------------------------------------------------------
    // Arithmetic Helper (Combinational)
    // -------------------------------------------------------------------------
    // Fixed point multiplication: (A * B) >> FRAC_BITS
    assign mult_res = op_a * op_b;
    assign mult_res_scaled = mult_res >>> FRAC_BITS;

    // -------------------------------------------------------------------------
    // FSM & Datapath
    // -------------------------------------------------------------------------
    
    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            idx_i <= 0;
            idx_h <= 0;
            idx_o <= 0;
            accumulator <= 0;
            done <= 0;
            // Clear outputs
            reg_output[0] <= 0; reg_output[1] <= 0; reg_output[2] <= 0; reg_output[3] <= 0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 0;
                    if (start) begin
                        state <= COMPUTE_L1;
                        idx_h <= 0;
                        idx_i <= 0;
                        accumulator <= 0;
                    end
                end

                // -------------------------------------------------------------
                // Layer 1: Linear(64, 48) + ReLU
                // -------------------------------------------------------------
                COMPUTE_L1: begin
                    // 1. MAC Operation
                    // We perform one MAC per cycle for simplicity (Serial implementation)
                    // Accumulator += Input[i] * W1[i][h]
                    // Note: op_a and op_b are driven combinationally below based on state/indices
                    
                    // Update accumulator with the result of the multiplication from this cycle
                    if (idx_i == 0) 
                        accumulator <= mult_res_scaled + rom_b1[idx_h]; // Add bias on first step
                    else 
                        accumulator <= accumulator + mult_res_scaled;

                    // Counter Logic
                    if (idx_i == IN_SIZE - 1) begin
                        // Neuron Calculation Complete
                        idx_i <= 0;
                        
                        // Apply ReLU: max(0, accumulator)
                        if (accumulator + mult_res_scaled < 0) // Check final accumulated value
                            ram_hidden[idx_h] <= 0;
                        else
                            ram_hidden[idx_h] <= accumulator + mult_res_scaled;

                        // Move to next neuron
                        if (idx_h == HID_SIZE - 1) begin
                            state <= COMPUTE_L2;
                            idx_h <= 0; // Will use as inner loop for L2
                            idx_o <= 0; // Outer loop for L2
                            accumulator <= 0;
                        end else begin
                            idx_h <= idx_h + 1;
                        end
                    end else begin
                        idx_i <= idx_i + 1;
                    end
                end

                // -------------------------------------------------------------
                // Layer 2: Linear(48, 4) (No Activation per Allo code, or implicit Linear)
                // Allo code: output = self.l2(output) -> Returns raw logits usually.
                // -------------------------------------------------------------
                COMPUTE_L2: begin
                    // Accumulator += Hidden[h] * W2[h][o]
                    
                    if (idx_h == 0)
                        accumulator <= mult_res_scaled + rom_b2[idx_o];
                    else
                        accumulator <= accumulator + mult_res_scaled;

                    if (idx_h == HID_SIZE - 1) begin
                        // Neuron Complete
                        idx_h <= 0;
                        reg_output[idx_o] <= accumulator + mult_res_scaled;

                        if (idx_o == OUT_SIZE - 1) begin
                            state <= FINISHED;
                        end else begin
                            idx_o <= idx_o + 1;
                        end
                    end else begin
                        idx_h <= idx_h + 1;
                    end
                end

                FINISHED: begin
                    done <= 1;
                    // Wait for reset or restart
                    if (start == 0) state <= IDLE; 
                end

            endcase
        end
    end

    // -------------------------------------------------------------------------
    // Combinational Operand Selection
    // -------------------------------------------------------------------------
    always_comb begin
        op_a = 0;
        op_b = 0;

        case (state)
            COMPUTE_L1: begin
                op_a = ram_input[idx_i];
                op_b = rom_w1[idx_i][idx_h];
            end
            COMPUTE_L2: begin
                op_a = ram_hidden[idx_h];
                op_b = rom_w2[idx_h][idx_o];
            end
            default: begin
                op_a = 0;
                op_b = 0;
            end
        endcase
    end

    // -------------------------------------------------------------------------
    // Output Wiring
    // -------------------------------------------------------------------------
    assign out_0 = reg_output[0];
    assign out_1 = reg_output[1];
    assign out_2 = reg_output[2];
    assign out_3 = reg_output[3];

endmodule
