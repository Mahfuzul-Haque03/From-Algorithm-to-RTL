`timescale 1ns / 1ps

// =====================================================================
// TOP MODULE: GELU (Polynomial Approximation)
// =====================================================================
module main (
    input  logic        clk,
    input  logic        reset,
    input  logic        ap_start,
    output logic        ap_done,
    output logic        ap_idle,
    output logic        ap_ready,

    // Memory Interface
    output logic [8:0]  X_address0,
    output logic        X_ce0,
    input  logic [31:0] X_q0,

    output logic [8:0]  Z_address0,
    output logic        Z_ce0,
    output logic        Z_we0,
    output logic [31:0] Z_d0
);

    // IEEE-754 Constants
    localparam [31:0] C0 = 32'h3D123A26; // 0.0357
    localparam [31:0] CB = 32'h3ECC37F1; // 0.3989
    localparam [31:0] CA = 32'h3F000000; // 0.5
    localparam int NUM_ELEMENTS = 300;

    // Latency Definitions (Must match the modules below)
    localparam int LAT_MUL = 5;
    localparam int LAT_ADD = 7; 
    
    // Total Pipeline Depth Calculation (Horner's Method):
    // 1. Mul(x, C0)     -> T = 5
    // 2. Add(., CB)     -> T = 5+7 = 12
    // 3. Mul(., x)      -> T = 12+5 = 17
    // 4. Add(., CA)     -> T = 17+7 = 24
    // 5. Mul(., x)      -> T = 24+5 = 29
    localparam int PIPE_DEPTH = 29;

    // FSM
    typedef enum logic [1:0] {ST_IDLE, ST_PROCESS, ST_DONE} state_t;
    state_t state;

    logic [8:0] read_idx, write_idx;
    logic       input_valid, output_valid;
    logic [PIPE_DEPTH-1:0] valid_pipe;

    // Data Signals
    logic [31:0] x_in;
    logic [31:0] t1_mul, t2_add, t3_mul, t4_add, t5_mul;
    logic [31:0] x_d12, x_d24; // Delayed versions of X

    // -----------------------------------------------------------------
    // DATAPATH: Horner's Scheme
    // Z = x * (CA + x * (CB + x * C0))
    // -----------------------------------------------------------------
    
    assign x_in = X_q0;

    // Step 1: x * C0
    fp32_mul #(.LATENCY(LAT_MUL)) u_m1 (
        .clk(clk), .a(x_in), .b(C0), .res(t1_mul)
    );

    // Step 2: Result1 + CB
    fp32_add #(.LATENCY(LAT_ADD)) u_a1 (
        .clk(clk), .a(t1_mul), .b(CB), .res(t2_add)
    );

    // Delay X to match Step 2 timing (12 cycles)
    delay_reg #(.WIDTH(32), .DEPTH(LAT_MUL + LAT_ADD)) d_x_12 (
        .clk(clk), .in(x_in), .out(x_d12)
    );

    // Step 3: Result2 * x (delayed)
    fp32_mul #(.LATENCY(LAT_MUL)) u_m2 (
        .clk(clk), .a(t2_add), .b(x_d12), .res(t3_mul)
    );

    // Step 4: Result3 + CA
    fp32_add #(.LATENCY(LAT_ADD)) u_a2 (
        .clk(clk), .a(t3_mul), .b(CA), .res(t4_add)
    );

    // Delay X to match Step 4 timing (24 cycles)
    delay_reg #(.WIDTH(32), .DEPTH(LAT_MUL + LAT_ADD + LAT_MUL + LAT_ADD)) d_x_24 (
        .clk(clk), .in(x_in), .out(x_d24)
    );

    // Step 5: Result4 * x (delayed)
    fp32_mul #(.LATENCY(LAT_MUL)) u_m3 (
        .clk(clk), .a(t4_add), .b(x_d24), .res(t5_mul)
    );

    // -----------------------------------------------------------------
    // CONTROL LOGIC
    // -----------------------------------------------------------------
    
    // Main FSM
    always_ff @(posedge clk) begin
        if (reset) state <= ST_IDLE;
        else begin
            case (state)
                ST_IDLE: if (ap_start) state <= ST_PROCESS;
                ST_PROCESS: if (write_idx == NUM_ELEMENTS - 1 && output_valid) state <= ST_DONE;
                ST_DONE: state <= ST_IDLE;
            endcase
        end
    end

    assign input_valid = (state == ST_PROCESS && read_idx < NUM_ELEMENTS);

    // Read Index
    always_ff @(posedge clk) begin
        if (reset || state == ST_IDLE) read_idx <= 0;
        else if (input_valid) read_idx <= read_idx + 1;
    end

    // Pipeline Valid Shift Register
    always_ff @(posedge clk) begin
        if (reset) valid_pipe <= 0;
        else valid_pipe <= {valid_pipe[PIPE_DEPTH-2:0], input_valid};
    end
    assign output_valid = valid_pipe[PIPE_DEPTH-1];

    // Write Index
    always_ff @(posedge clk) begin
        if (reset || state == ST_IDLE) write_idx <= 0;
        else if (output_valid) write_idx <= write_idx + 1;
    end

    // Outputs
    assign X_ce0      = input_valid;
    assign X_address0 = read_idx;
    
    assign Z_ce0      = output_valid;
    assign Z_we0      = output_valid;
    assign Z_address0 = write_idx;
    assign Z_d0       = t5_mul;

    assign ap_done    = (state == ST_DONE);
    assign ap_ready   = (state == ST_DONE);
    assign ap_idle    = (state == ST_IDLE);

endmodule


// =====================================================================
// MODULE: Robust FP32 Adder (7 Stages)
// Features: Full Barrel Shifter, LZC, Round-to-Nearest-Even
// =====================================================================
module fp32_add #(parameter LATENCY=7) (
    input  logic        clk,
    input  logic [31:0] a,
    input  logic [31:0] b,
    output logic [31:0] res
);
    // Unpacking
    logic        sa, sb;
    logic [7:0]  ea, eb;
    logic [23:0] ma, mb; // 1.mantissa

    // Stage 1: Alignment (Compare & Swap)
    logic [7:0]  s1_e;
    logic [23:0] s1_ma, s1_mb; // ma is always larger
    logic        s1_sa, s1_sb;
    logic [7:0]  s1_diff;
    
    // Stage 2: Alignment (Shift)
    logic [26:0] s2_ma; // Expanded for guard bits
    logic [26:0] s2_mb;
    logic [7:0]  s2_e;
    logic        s2_sa, s2_sb;

    // Stage 3: Math (Add/Sub)
    logic [27:0] s3_sum; // 1 extra bit for carry/overflow
    logic [7:0]  s3_e;
    logic        s3_sign;
    
    // Stage 4: Leading Zero Count (LZC)
    logic [4:0]  s4_lz;
    logic [27:0] s4_sum;
    logic [7:0]  s4_e;
    logic        s4_sign;

    // Stage 5: Normalization (Shift)
    logic [27:0] s5_norm_m;
    logic [7:0]  s5_e;
    logic        s5_sign;

    // Stage 6: Rounding
    logic [31:0] s6_res;

    // --- S1: Compare & Swap ---
    always_ff @(posedge clk) begin
        logic [7:0] e_a, e_b;
        e_a = a[30:23]; e_b = b[30:23];
        
        // Flush denormals to zero (simplification for timing)
        if (e_a == 0) ma <= 0; else ma <= {1'b1, a[22:0]};
        if (e_b == 0) mb <= 0; else mb <= {1'b1, b[22:0]};

        if ({e_a, a[22:0]} >= {e_b, b[22:0]}) begin
            s1_e <= e_a; s1_diff <= e_a - e_b;
            s1_ma <= (e_a==0)? 0 : {1'b1, a[22:0]}; 
            s1_mb <= (e_b==0)? 0 : {1'b1, b[22:0]};
            s1_sa <= a[31]; s1_sb <= b[31];
        end else begin
            s1_e <= e_b; s1_diff <= e_b - e_a;
            s1_ma <= (e_b==0)? 0 : {1'b1, b[22:0]}; 
            s1_mb <= (e_a==0)? 0 : {1'b1, a[22:0]};
            s1_sa <= b[31]; s1_sb <= a[31];
        end
    end

    // --- S2: Shift Smaller ---
    always_ff @(posedge clk) begin
        s2_ma <= {s1_ma, 3'b0}; // Add Guard/Round/Sticky space
        // Sticky bit logic: if we shift out any 1s, set the LSB
        if (s1_diff > 26) begin
            s2_mb <= (s1_mb != 0); // Just sticky
        end else begin
            logic [49:0] shift_temp;
            shift_temp = {s1_mb, 26'b0} >> s1_diff;
            s2_mb <= {shift_temp[49:24], |shift_temp[23:0]}; // sticky collection
        end
        s2_e <= s1_e; s2_sa <= s1_sa; s2_sb <= s1_sb;
    end

    // --- S3: Add/Sub ---
    always_ff @(posedge clk) begin
        if (s2_sa == s2_sb) begin
            s3_sum <= s2_ma + s2_mb;
        end else begin
            s3_sum <= s2_ma - s2_mb; // s2_ma is always >= s2_mb
        end
        s3_e <= s2_e; s3_sign <= s2_sa;
    end

    // --- S4: LZC ---
    // Perform LZC on s3_sum.
    function [4:0] get_lz(input [27:0] val);
        if (val[27]) return 0;
        if (val[26]) return 1;
        if (val[25]) return 2;
        if (val[24]) return 3;
        if (val[23]) return 4;
        if (val[22]) return 5;
        if (val[21]) return 6;
        if (val[20]) return 7;
        if (val[19]) return 8;
        if (val[18]) return 9;
        if (val[17]) return 10;
        if (val[16]) return 11;
        if (val[15]) return 12;
        if (val[14]) return 13;
        if (val[13]) return 14;
        if (val[12]) return 15;
        if (val[11]) return 16;
        if (val[10]) return 17;
        if (val[9])  return 18;
        if (val[8])  return 19;
        if (val[7])  return 20;
        if (val[6])  return 21;
        if (val[5])  return 22;
        if (val[4])  return 23;
        if (val[3])  return 24;
        if (val[2])  return 25;
        if (val[1])  return 26;
        if (val[0])  return 27;
        return 28;
    endfunction

    always_ff @(posedge clk) begin
        s4_lz <= get_lz(s3_sum);
        s4_sum <= s3_sum;
        s4_e <= s3_e;
        s4_sign <= s3_sign;
    end

    // --- S5: Normalize ---
    always_ff @(posedge clk) begin
        logic [27:0] norm_temp;
        logic [8:0]  e_temp; // Needs extra bit for underflow check
        
        // Case 1: Overflow (Sum resulted in carry, bit 27 set)
        // 1.xxxx + 1.xxxx = 1x.xxxx
        if (s4_sum[27]) begin
            s5_norm_m <= s4_sum >> 1;
            s5_e <= s4_e + 1;
        end 
        // Case 2: Zero result
        else if (s4_sum == 0) begin
            s5_norm_m <= 0;
            s5_e <= 0;
        end
        // Case 3: Normalization needed (Subtraction)
        else begin
            // Shift left by LZC
            s5_norm_m <= s4_sum << s4_lz;
            
            // Check for exponent underflow
            if (s4_lz > s4_e) begin
                s5_e <= 0; // Underflow to zero
                s5_norm_m <= 0;
            end else begin
                s5_e <= s4_e - s4_lz;
            end
        end
        s5_sign <= s4_sign;
    end

    // --- S6: Rounding ---
    always_ff @(posedge clk) begin
        logic [23:0] mant_rounded;
        logic        guard, round_bit, sticky, rnd_up;
        
        // After normalization, implicit 1 is at bit 26
        // Mantissa is 26 down to 3.
        // Guard=2, Round=1, Sticky=0
        
        guard     = s5_norm_m[2];
        round_bit = s5_norm_m[1];
        sticky    = s5_norm_m[0];
        
        // Round to nearest even
        rnd_up = guard && (round_bit || sticky || s5_norm_m[3]);
        
        if (s5_e == 0) begin
            s6_res <= 0; // Clean zero
        end else begin
            if (rnd_up) begin
                // Check if rounding causes overflow (all 1s)
                if (&s5_norm_m[26:3]) 
                    s6_res <= {s5_sign, s5_e + 8'd1, 23'd0};
                else
                    s6_res <= {s5_sign, s5_e, s5_norm_m[25:3] + 1'b1};
            end else begin
                s6_res <= {s5_sign, s5_e, s5_norm_m[25:3]};
            end
        end
    end
    
    // Output
    assign res = s6_res;

endmodule

// =====================================================================
// MODULE: Robust FP32 Multiplier (5 Stages)
// =====================================================================
module fp32_mul #(parameter LATENCY=5) (
    input  logic        clk,
    input  logic [31:0] a,
    input  logic [31:0] b,
    output logic [31:0] res
);
    // S1: Unpack
    logic        s1_sign;
    logic [9:0]  s1_e_sum;
    logic [23:0] s1_ma, s1_mb;

    // S2-S3: DSP Multiply (2 cycles)
    logic [47:0] s3_prod;
    logic        s3_sign;
    logic [9:0]  s3_e_sum;

    // S4: Normalize
    logic [22:0] s4_mant;
    logic [7:0]  s4_e;
    logic        s4_sign;

    // S5: Pack
    logic [31:0] s5_res;

    // --- S1 ---
    always_ff @(posedge clk) begin
        s1_sign <= a[31] ^ b[31];
        // Add exponents, subtract bias (127) later
        // Use 10 bits to prevent overflow during intermediate calc
        if (a[30:23] == 0 || b[30:23] == 0) begin
            s1_e_sum <= 0; // Zero
            s1_ma <= 0; s1_mb <= 0;
        end else begin
            s1_e_sum <= {2'b0, a[30:23]} + {2'b0, b[30:23]};
            s1_ma <= {1'b1, a[22:0]};
            s1_mb <= {1'b1, b[22:0]};
        end
    end

    // --- S2 & S3 (Multiply) ---
    // Split into 2 stages to help DSP mapping
    logic [47:0] s2_prod_pipe;
    logic [9:0]  s2_e_pipe;
    logic        s2_sign_pipe;

    always_ff @(posedge clk) begin
        s2_prod_pipe <= s1_ma * s1_mb; 
        s2_e_pipe    <= s1_e_sum;
        s2_sign_pipe <= s1_sign;
    end
    
    always_ff @(posedge clk) begin
        s3_prod <= s2_prod_pipe;
        s3_e_sum <= s2_e_pipe;
        s3_sign <= s2_sign_pipe;
    end

    // --- S4: Normalize ---
    always_ff @(posedge clk) begin
        logic [9:0] e_temp;
        logic [47:0] p_norm;
        
        if (s3_e_sum == 0) begin
            s4_e <= 0; s4_mant <= 0; s4_sign <= 0;
        end else begin
            // Product of 1.x * 1.x is either [1.x, 2.0) or [2.x, 4.0)
            // Bit 47 is the carry.
            if (s3_prod[47]) begin
                // Result is 1x.xxxxx. Shift right 1 to get 1.xxxx
                p_norm = s3_prod >> 1;
                e_temp = s3_e_sum - 127 + 1;
            end else begin
                p_norm = s3_prod;
                e_temp = s3_e_sum - 127;
            end

            // Check Overflow/Underflow
            if (e_temp[9] || e_temp > 254) begin 
                // Simple saturation/zeroing
                if (e_temp[9]) s4_e <= 0; // Underflow
                else s4_e <= 255; // Overflow
                s4_mant <= 0;
            end else begin
                s4_e <= e_temp[7:0];
                s4_mant <= p_norm[45:23]; // Truncate round for simplicity here, or add round logic
            end
            s4_sign <= s3_sign;
        end
    end

    // --- S5: Output ---
    always_ff @(posedge clk) begin
        res <= {s4_sign, s4_e, s4_mant};
    end

endmodule

// =====================================================================
// HELPER: Delay Register
// =====================================================================
module delay_reg #(parameter WIDTH=32, DEPTH=1) (
    input  logic             clk,
    input  logic [WIDTH-1:0] in,
    output logic [WIDTH-1:0] out
);
    logic [WIDTH-1:0] pipe [0:DEPTH-1];
    integer i;
    always_ff @(posedge clk) begin
        pipe[0] <= in;
        for (i=1; i<DEPTH; i=i+1) pipe[i] <= pipe[i-1];
    end
    assign out = pipe[DEPTH-1];
endmodule
