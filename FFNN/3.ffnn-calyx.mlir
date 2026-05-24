module attributes {calyx.entrypoint = "main"} {
  calyx.component @main(%clk: i1 {clk}, %reset: i1 {reset}, %go: i1 {go}) -> (%done: i1 {done}) {
    %mem_9.addr0, %mem_9.clk, %mem_9.reset, %mem_9.content_en, %mem_9.write_en, %mem_9.write_data, %mem_9.read_data, %mem_9.done = calyx.seq_mem @mem_9 <[4] x 32> [2] {external = true} : i2, i1, i1, i1, i1, i32, i32, i1
    %mem_8.addr0, %mem_8.clk, %mem_8.reset, %mem_8.content_en, %mem_8.write_en, %mem_8.write_data, %mem_8.read_data, %mem_8.done = calyx.seq_mem @mem_8 <[2304] x 32> [12] {external = true} : i12, i1, i1, i1, i1, i32, i32, i1
    %mem_7.addr0, %mem_7.clk, %mem_7.reset, %mem_7.content_en, %mem_7.write_en, %mem_7.write_data, %mem_7.read_data, %mem_7.done = calyx.seq_mem @mem_7 <[48] x 32> [6] {external = true} : i6, i1, i1, i1, i1, i32, i32, i1
    %mem_6.addr0, %mem_6.clk, %mem_6.reset, %mem_6.content_en, %mem_6.write_en, %mem_6.write_data, %mem_6.read_data, %mem_6.done = calyx.seq_mem @mem_6 <[2304] x 32> [12] {external = true} : i12, i1, i1, i1, i1, i32, i32, i1
    %mem_5.addr0, %mem_5.clk, %mem_5.reset, %mem_5.content_en, %mem_5.write_en, %mem_5.write_data, %mem_5.read_data, %mem_5.done = calyx.seq_mem @mem_5 <[192] x 32> [8] {external = true} : i8, i1, i1, i1, i1, i32, i32, i1
    %mem_4.addr0, %mem_4.clk, %mem_4.reset, %mem_4.content_en, %mem_4.write_en, %mem_4.write_data, %mem_4.read_data, %mem_4.done = calyx.seq_mem @mem_4 <[4] x 32> [2] {external = true} : i2, i1, i1, i1, i1, i32, i32, i1
    %mem_3.addr0, %mem_3.clk, %mem_3.reset, %mem_3.content_en, %mem_3.write_en, %mem_3.write_data, %mem_3.read_data, %mem_3.done = calyx.seq_mem @mem_3 <[192] x 32> [8] {external = true} : i8, i1, i1, i1, i1, i32, i32, i1
    %mem_2.addr0, %mem_2.clk, %mem_2.reset, %mem_2.content_en, %mem_2.write_en, %mem_2.write_data, %mem_2.read_data, %mem_2.done = calyx.seq_mem @mem_2 <[48] x 32> [6] {external = true} : i6, i1, i1, i1, i1, i32, i32, i1
    %mem_1.addr0, %mem_1.clk, %mem_1.reset, %mem_1.content_en, %mem_1.write_en, %mem_1.write_data, %mem_1.read_data, %mem_1.done = calyx.seq_mem @mem_1 <[3072] x 32> [12] {external = true} : i12, i1, i1, i1, i1, i32, i32, i1
    %mem_0.addr0, %mem_0.clk, %mem_0.reset, %mem_0.content_en, %mem_0.write_en, %mem_0.write_data, %mem_0.read_data, %mem_0.done = calyx.seq_mem @mem_0 <[3072] x 32> [12] {external = true} : i12, i1, i1, i1, i1, i32, i32, i1
    %forward_instance.clk, %forward_instance.reset, %forward_instance.go, %forward_instance.done = calyx.instance @forward_instance of @forward : i1, i1, i1, i1
    calyx.wires {
    }
    calyx.control {
      calyx.seq {
        calyx.seq {
          calyx.invoke @forward_instance[arg_mem_0 = mem_0, arg_mem_1 = mem_1, arg_mem_2 = mem_2, arg_mem_3 = mem_3, arg_mem_4 = mem_4, arg_mem_5 = mem_5, arg_mem_6 = mem_6, arg_mem_7 = mem_7, arg_mem_8 = mem_8, arg_mem_9 = mem_9]() -> ()
        }
      }
    }
  } {toplevel}
  calyx.component @linear2d_0(%clk: i1 {clk}, %reset: i1 {reset}, %go: i1 {go}) -> (%done: i1 {done}) {
    %c1_i32 = hw.constant 1 : i32
    %true = hw.constant true
    %false = hw.constant false
    %cst = calyx.constant @cst_0 <0.000000e+00 : f32> : i32
    %c0_i32 = hw.constant 0 : i32
    %c48_i32 = hw.constant 48 : i32
    %c6_i32 = hw.constant 6 : i32
    %std_slice_9.in, %std_slice_9.out = calyx.std_slice @std_slice_9 : i32, i6
    %std_slice_8.in, %std_slice_8.out = calyx.std_slice @std_slice_8 : i32, i12
    %std_slice_7.in, %std_slice_7.out = calyx.std_slice @std_slice_7 : i32, i1
    %std_slice_6.in, %std_slice_6.out = calyx.std_slice @std_slice_6 : i32, i1
    %std_slice_5.in, %std_slice_5.out = calyx.std_slice @std_slice_5 : i32, i12
    %std_slice_4.in, %std_slice_4.out = calyx.std_slice @std_slice_4 : i32, i6
    %std_slice_3.in, %std_slice_3.out = calyx.std_slice @std_slice_3 : i32, i6
    %std_slice_2.in, %std_slice_2.out = calyx.std_slice @std_slice_2 : i32, i6
    %std_slice_1.in, %std_slice_1.out = calyx.std_slice @std_slice_1 : i32, i6
    %std_slice_0.in, %std_slice_0.out = calyx.std_slice @std_slice_0 : i32, i12
    %std_add_7.left, %std_add_7.right, %std_add_7.out = calyx.std_add @std_add_7 : i32, i32, i32
    %std_add_6.left, %std_add_6.right, %std_add_6.out = calyx.std_add @std_add_6 : i32, i32, i32
    %std_add_5.left, %std_add_5.right, %std_add_5.out = calyx.std_add @std_add_5 : i32, i32, i32
    %muli_0_reg.in, %muli_0_reg.write_en, %muli_0_reg.clk, %muli_0_reg.reset, %muli_0_reg.out, %muli_0_reg.done = calyx.register @muli_0_reg : i32, i1, i1, i1, i32, i1
    %std_mult_pipe_0.clk, %std_mult_pipe_0.reset, %std_mult_pipe_0.go, %std_mult_pipe_0.left, %std_mult_pipe_0.right, %std_mult_pipe_0.out, %std_mult_pipe_0.done = calyx.std_mult_pipe @std_mult_pipe_0 : i1, i1, i1, i32, i32, i32, i1
    %addf_1_reg.in, %addf_1_reg.write_en, %addf_1_reg.clk, %addf_1_reg.reset, %addf_1_reg.out, %addf_1_reg.done = calyx.register @addf_1_reg : i32, i1, i1, i1, i32, i1
    %std_addFN_1.clk, %std_addFN_1.reset, %std_addFN_1.go, %std_addFN_1.control, %std_addFN_1.subOp, %std_addFN_1.left, %std_addFN_1.right, %std_addFN_1.roundingMode, %std_addFN_1.out, %std_addFN_1.exceptionalFlags, %std_addFN_1.done = calyx.ieee754.add @std_addFN_1 : i1, i1, i1, i1, i1, i32, i32, i3, i32, i5, i1
    %load_2_reg.in, %load_2_reg.write_en, %load_2_reg.clk, %load_2_reg.reset, %load_2_reg.out, %load_2_reg.done = calyx.register @load_2_reg : i32, i1, i1, i1, i32, i1
    %std_add_4.left, %std_add_4.right, %std_add_4.out = calyx.std_add @std_add_4 : i32, i32, i32
    %std_add_3.left, %std_add_3.right, %std_add_3.out = calyx.std_add @std_add_3 : i32, i32, i32
    %addf_0_reg.in, %addf_0_reg.write_en, %addf_0_reg.clk, %addf_0_reg.reset, %addf_0_reg.out, %addf_0_reg.done = calyx.register @addf_0_reg : i32, i1, i1, i1, i32, i1
    %std_addFN_0.clk, %std_addFN_0.reset, %std_addFN_0.go, %std_addFN_0.control, %std_addFN_0.subOp, %std_addFN_0.left, %std_addFN_0.right, %std_addFN_0.roundingMode, %std_addFN_0.out, %std_addFN_0.exceptionalFlags, %std_addFN_0.done = calyx.ieee754.add @std_addFN_0 : i1, i1, i1, i1, i1, i32, i32, i3, i32, i5, i1
    %load_1_reg.in, %load_1_reg.write_en, %load_1_reg.clk, %load_1_reg.reset, %load_1_reg.out, %load_1_reg.done = calyx.register @load_1_reg : i32, i1, i1, i1, i32, i1
    %mulf_0_reg.in, %mulf_0_reg.write_en, %mulf_0_reg.clk, %mulf_0_reg.reset, %mulf_0_reg.out, %mulf_0_reg.done = calyx.register @mulf_0_reg : i32, i1, i1, i1, i32, i1
    %std_mulFN_0.clk, %std_mulFN_0.reset, %std_mulFN_0.go, %std_mulFN_0.control, %std_mulFN_0.left, %std_mulFN_0.right, %std_mulFN_0.roundingMode, %std_mulFN_0.out, %std_mulFN_0.exceptionalFlags, %std_mulFN_0.done = calyx.ieee754.mul @std_mulFN_0 : i1, i1, i1, i1, i32, i32, i3, i32, i5, i1
    %std_add_2.left, %std_add_2.right, %std_add_2.out = calyx.std_add @std_add_2 : i32, i32, i32
    %std_lsh_1.left, %std_lsh_1.right, %std_lsh_1.out = calyx.std_lsh @std_lsh_1 : i32, i32, i32
    %load_0_reg.in, %load_0_reg.write_en, %load_0_reg.clk, %load_0_reg.reset, %load_0_reg.out, %load_0_reg.done = calyx.register @load_0_reg : i32, i1, i1, i1, i32, i1
    %mem_1.addr0, %mem_1.clk, %mem_1.reset, %mem_1.content_en, %mem_1.write_en, %mem_1.write_data, %mem_1.read_data, %mem_1.done = calyx.seq_mem @mem_1 <[1] x 32> [1] {external = true} : i1, i1, i1, i1, i1, i32, i32, i1
    %std_add_1.left, %std_add_1.right, %std_add_1.out = calyx.std_add @std_add_1 : i32, i32, i32
    %std_lsh_0.left, %std_lsh_0.right, %std_lsh_0.out = calyx.std_lsh @std_lsh_0 : i32, i32, i32
    %std_add_0.left, %std_add_0.right, %std_add_0.out = calyx.std_add @std_add_0 : i32, i32, i32
    %mem_0.addr0, %mem_0.clk, %mem_0.reset, %mem_0.content_en, %mem_0.write_en, %mem_0.write_data, %mem_0.read_data, %mem_0.done = calyx.seq_mem @mem_0 <[48] x 32> [6] {external = true} : i6, i1, i1, i1, i1, i32, i32, i1
    %for_4_induction_var_reg.in, %for_4_induction_var_reg.write_en, %for_4_induction_var_reg.clk, %for_4_induction_var_reg.reset, %for_4_induction_var_reg.out, %for_4_induction_var_reg.done = calyx.register @for_4_induction_var_reg : i32, i1, i1, i1, i32, i1
    %for_3_induction_var_reg.in, %for_3_induction_var_reg.write_en, %for_3_induction_var_reg.clk, %for_3_induction_var_reg.reset, %for_3_induction_var_reg.out, %for_3_induction_var_reg.done = calyx.register @for_3_induction_var_reg : i32, i1, i1, i1, i32, i1
    %for_2_induction_var_reg.in, %for_2_induction_var_reg.write_en, %for_2_induction_var_reg.clk, %for_2_induction_var_reg.reset, %for_2_induction_var_reg.out, %for_2_induction_var_reg.done = calyx.register @for_2_induction_var_reg : i32, i1, i1, i1, i32, i1
    %for_1_induction_var_reg.in, %for_1_induction_var_reg.write_en, %for_1_induction_var_reg.clk, %for_1_induction_var_reg.reset, %for_1_induction_var_reg.out, %for_1_induction_var_reg.done = calyx.register @for_1_induction_var_reg : i32, i1, i1, i1, i32, i1
    %for_0_induction_var_reg.in, %for_0_induction_var_reg.write_en, %for_0_induction_var_reg.clk, %for_0_induction_var_reg.reset, %for_0_induction_var_reg.out, %for_0_induction_var_reg.done = calyx.register @for_0_induction_var_reg : i32, i1, i1, i1, i32, i1
    %arg_mem_3.addr0, %arg_mem_3.clk, %arg_mem_3.reset, %arg_mem_3.content_en, %arg_mem_3.write_en, %arg_mem_3.write_data, %arg_mem_3.read_data, %arg_mem_3.done = calyx.seq_mem @arg_mem_3 <[2304] x 32> [12] : i12, i1, i1, i1, i1, i32, i32, i1
    %arg_mem_2.addr0, %arg_mem_2.clk, %arg_mem_2.reset, %arg_mem_2.content_en, %arg_mem_2.write_en, %arg_mem_2.write_data, %arg_mem_2.read_data, %arg_mem_2.done = calyx.seq_mem @arg_mem_2 <[48] x 32> [6] : i6, i1, i1, i1, i1, i32, i32, i1
    %arg_mem_1.addr0, %arg_mem_1.clk, %arg_mem_1.reset, %arg_mem_1.content_en, %arg_mem_1.write_en, %arg_mem_1.write_data, %arg_mem_1.read_data, %arg_mem_1.done = calyx.seq_mem @arg_mem_1 <[3072] x 32> [12] : i12, i1, i1, i1, i1, i32, i32, i1
    %arg_mem_0.addr0, %arg_mem_0.clk, %arg_mem_0.reset, %arg_mem_0.content_en, %arg_mem_0.write_en, %arg_mem_0.write_data, %arg_mem_0.read_data, %arg_mem_0.done = calyx.seq_mem @arg_mem_0 <[3072] x 32> [12] : i12, i1, i1, i1, i1, i32, i32, i1
    calyx.wires {
      calyx.group @init_for_0_induction_var {
        calyx.assign %for_0_induction_var_reg.in = %c0_i32 : i32
        calyx.assign %for_0_induction_var_reg.write_en = %true : i1
        calyx.group_done %for_0_induction_var_reg.done : i1
      }
      calyx.group @init_for_1_induction_var {
        calyx.assign %for_1_induction_var_reg.in = %c0_i32 : i32
        calyx.assign %for_1_induction_var_reg.write_en = %true : i1
        calyx.group_done %for_1_induction_var_reg.done : i1
      }
      calyx.group @init_for_2_induction_var {
        calyx.assign %for_2_induction_var_reg.in = %c0_i32 : i32
        calyx.assign %for_2_induction_var_reg.write_en = %true : i1
        calyx.group_done %for_2_induction_var_reg.done : i1
      }
      calyx.group @init_for_3_induction_var {
        calyx.assign %for_3_induction_var_reg.in = %c0_i32 : i32
        calyx.assign %for_3_induction_var_reg.write_en = %true : i1
        calyx.group_done %for_3_induction_var_reg.done : i1
      }
      calyx.group @init_for_4_induction_var {
        calyx.assign %for_4_induction_var_reg.in = %c0_i32 : i32
        calyx.assign %for_4_induction_var_reg.write_en = %true : i1
        calyx.group_done %for_4_induction_var_reg.done : i1
      }
      calyx.group @bb0_0 {
        calyx.assign %std_slice_9.in = %for_0_induction_var_reg.out : i32
        calyx.assign %mem_0.addr0 = %std_slice_9.out : i6
        calyx.assign %mem_0.write_data = %cst : i32
        calyx.assign %mem_0.write_en = %true : i1
        calyx.assign %mem_0.content_en = %true : i1
        calyx.group_done %mem_0.done : i1
      }
      calyx.group @incr_for_0_induction_var {
        calyx.assign %std_add_0.left = %for_0_induction_var_reg.out : i32
        calyx.assign %std_add_0.right = %c1_i32 : i32
        calyx.assign %for_0_induction_var_reg.in = %std_add_0.out : i32
        calyx.assign %for_0_induction_var_reg.write_en = %true : i1
        calyx.group_done %for_0_induction_var_reg.done : i1
      }
      calyx.group @bb0_3 {
        calyx.assign %std_slice_8.in = %std_add_1.out : i32
        calyx.assign %arg_mem_0.addr0 = %std_slice_8.out : i12
        calyx.assign %arg_mem_0.content_en = %true : i1
        calyx.assign %arg_mem_0.write_en = %false : i1
        calyx.assign %std_add_1.left = %std_lsh_0.out : i32
        calyx.assign %std_lsh_0.left = %for_4_induction_var_reg.out : i32
        calyx.assign %std_lsh_0.right = %c6_i32 : i32
        calyx.assign %std_add_1.right = %for_2_induction_var_reg.out : i32
        calyx.group_done %arg_mem_0.done : i1
      }
      calyx.group @bb0_4 {
        calyx.assign %std_slice_7.in = %c0_i32 : i32
        calyx.assign %mem_1.addr0 = %std_slice_7.out : i1
        calyx.assign %mem_1.write_data = %arg_mem_0.read_data : i32
        calyx.assign %mem_1.write_en = %true : i1
        calyx.assign %mem_1.content_en = %true : i1
        calyx.group_done %mem_1.done : i1
      }
      calyx.group @bb0_5 {
        calyx.assign %std_slice_6.in = %c0_i32 : i32
        calyx.assign %mem_1.addr0 = %std_slice_6.out : i1
        calyx.assign %mem_1.content_en = %true : i1
        calyx.assign %mem_1.write_en = %false : i1
        calyx.assign %load_0_reg.in = %mem_1.read_data : i32
        calyx.assign %load_0_reg.write_en = %mem_1.done : i1
        calyx.group_done %load_0_reg.done : i1
      }
      calyx.group @bb0_8 {
        calyx.assign %std_slice_5.in = %std_add_2.out : i32
        calyx.assign %arg_mem_1.addr0 = %std_slice_5.out : i12
        calyx.assign %arg_mem_1.content_en = %true : i1
        calyx.assign %arg_mem_1.write_en = %false : i1
        calyx.assign %std_add_2.left = %std_lsh_1.out : i32
        calyx.assign %std_lsh_1.left = %for_1_induction_var_reg.out : i32
        calyx.assign %std_lsh_1.right = %c6_i32 : i32
        calyx.assign %std_add_2.right = %for_2_induction_var_reg.out : i32
        calyx.group_done %arg_mem_1.done : i1
      }
      calyx.group @bb0_9 {
        calyx.assign %std_mulFN_0.left = %load_0_reg.out : i32
        calyx.assign %std_mulFN_0.right = %arg_mem_1.read_data : i32
        calyx.assign %mulf_0_reg.in = %std_mulFN_0.out : i32
        calyx.assign %mulf_0_reg.write_en = %std_mulFN_0.done : i1
        %0 = comb.xor %std_mulFN_0.done, %true : i1
        calyx.assign %std_mulFN_0.go = %0 ? %true : i1
        calyx.group_done %mulf_0_reg.done : i1
      }
      calyx.group @bb0_10 {
        calyx.assign %std_slice_4.in = %for_1_induction_var_reg.out : i32
        calyx.assign %mem_0.addr0 = %std_slice_4.out : i6
        calyx.assign %mem_0.content_en = %true : i1
        calyx.assign %mem_0.write_en = %false : i1
        calyx.assign %load_1_reg.in = %mem_0.read_data : i32
        calyx.assign %load_1_reg.write_en = %mem_0.done : i1
        calyx.group_done %load_1_reg.done : i1
      }
      calyx.group @bb0_11 {
        calyx.assign %std_addFN_0.left = %load_1_reg.out : i32
        calyx.assign %std_addFN_0.right = %mulf_0_reg.out : i32
        calyx.assign %addf_0_reg.in = %std_addFN_0.out : i32
        calyx.assign %addf_0_reg.write_en = %std_addFN_0.done : i1
        %0 = comb.xor %std_addFN_0.done, %true : i1
        calyx.assign %std_addFN_0.go = %0 ? %true : i1
        calyx.assign %std_addFN_0.subOp = %false : i1
        calyx.group_done %addf_0_reg.done : i1
      }
      calyx.group @bb0_12 {
        calyx.assign %std_slice_3.in = %for_1_induction_var_reg.out : i32
        calyx.assign %mem_0.addr0 = %std_slice_3.out : i6
        calyx.assign %mem_0.write_data = %addf_0_reg.out : i32
        calyx.assign %mem_0.write_en = %true : i1
        calyx.assign %mem_0.content_en = %true : i1
        calyx.group_done %mem_0.done : i1
      }
      calyx.group @incr_for_1_induction_var {
        calyx.assign %std_add_3.left = %for_1_induction_var_reg.out : i32
        calyx.assign %std_add_3.right = %c1_i32 : i32
        calyx.assign %for_1_induction_var_reg.in = %std_add_3.out : i32
        calyx.assign %for_1_induction_var_reg.write_en = %true : i1
        calyx.group_done %for_1_induction_var_reg.done : i1
      }
      calyx.group @incr_for_2_induction_var {
        calyx.assign %std_add_4.left = %for_2_induction_var_reg.out : i32
        calyx.assign %std_add_4.right = %c1_i32 : i32
        calyx.assign %for_2_induction_var_reg.in = %std_add_4.out : i32
        calyx.assign %for_2_induction_var_reg.write_en = %true : i1
        calyx.group_done %for_2_induction_var_reg.done : i1
      }
      calyx.group @bb0_13 {
        calyx.assign %std_slice_2.in = %for_3_induction_var_reg.out : i32
        calyx.assign %mem_0.addr0 = %std_slice_2.out : i6
        calyx.assign %mem_0.content_en = %true : i1
        calyx.assign %mem_0.write_en = %false : i1
        calyx.assign %load_2_reg.in = %mem_0.read_data : i32
        calyx.assign %load_2_reg.write_en = %mem_0.done : i1
        calyx.group_done %load_2_reg.done : i1
      }
      calyx.group @bb0_14 {
        calyx.assign %std_slice_1.in = %for_3_induction_var_reg.out : i32
        calyx.assign %arg_mem_2.addr0 = %std_slice_1.out : i6
        calyx.assign %arg_mem_2.content_en = %true : i1
        calyx.assign %arg_mem_2.write_en = %false : i1
        calyx.group_done %arg_mem_2.done : i1
      }
      calyx.group @bb0_15 {
        calyx.assign %std_addFN_1.left = %load_2_reg.out : i32
        calyx.assign %std_addFN_1.right = %arg_mem_2.read_data : i32
        calyx.assign %addf_1_reg.in = %std_addFN_1.out : i32
        calyx.assign %addf_1_reg.write_en = %std_addFN_1.done : i1
        %0 = comb.xor %std_addFN_1.done, %true : i1
        calyx.assign %std_addFN_1.go = %0 ? %true : i1
        calyx.assign %std_addFN_1.subOp = %false : i1
        calyx.group_done %addf_1_reg.done : i1
      }
      calyx.group @bb0_16 {
        calyx.assign %std_mult_pipe_0.left = %for_4_induction_var_reg.out : i32
        calyx.assign %std_mult_pipe_0.right = %c48_i32 : i32
        calyx.assign %muli_0_reg.in = %std_mult_pipe_0.out : i32
        calyx.assign %muli_0_reg.write_en = %std_mult_pipe_0.done : i1
        %0 = comb.xor %std_mult_pipe_0.done, %true : i1
        calyx.assign %std_mult_pipe_0.go = %0 ? %true : i1
        calyx.group_done %muli_0_reg.done : i1
      }
      calyx.group @bb0_18 {
        calyx.assign %std_slice_0.in = %std_add_5.out : i32
        calyx.assign %arg_mem_3.addr0 = %std_slice_0.out : i12
        calyx.assign %arg_mem_3.write_data = %addf_1_reg.out : i32
        calyx.assign %arg_mem_3.write_en = %true : i1
        calyx.assign %arg_mem_3.content_en = %true : i1
        calyx.assign %std_add_5.left = %muli_0_reg.out : i32
        calyx.assign %std_add_5.right = %for_3_induction_var_reg.out : i32
        calyx.group_done %arg_mem_3.done : i1
      }
      calyx.group @incr_for_3_induction_var {
        calyx.assign %std_add_6.left = %for_3_induction_var_reg.out : i32
        calyx.assign %std_add_6.right = %c1_i32 : i32
        calyx.assign %for_3_induction_var_reg.in = %std_add_6.out : i32
        calyx.assign %for_3_induction_var_reg.write_en = %true : i1
        calyx.group_done %for_3_induction_var_reg.done : i1
      }
      calyx.group @incr_for_4_induction_var {
        calyx.assign %std_add_7.left = %for_4_induction_var_reg.out : i32
        calyx.assign %std_add_7.right = %c1_i32 : i32
        calyx.assign %for_4_induction_var_reg.in = %std_add_7.out : i32
        calyx.assign %for_4_induction_var_reg.write_en = %true : i1
        calyx.group_done %for_4_induction_var_reg.done : i1
      }
    }
    calyx.control {
      calyx.seq {
        calyx.par {
          calyx.enable @init_for_4_induction_var
        }
        calyx.repeat 48 {
          calyx.seq {
            calyx.seq {
              calyx.par {
                calyx.enable @init_for_0_induction_var
              }
              calyx.repeat 48 {
                calyx.seq {
                  calyx.enable @bb0_0
                  calyx.enable @incr_for_0_induction_var
                }
              }
              calyx.par {
                calyx.enable @init_for_2_induction_var
              }
              calyx.repeat 64 {
                calyx.seq {
                  calyx.seq {
                    calyx.enable @bb0_3
                    calyx.enable @bb0_4
                    calyx.par {
                      calyx.enable @init_for_1_induction_var
                    }
                    calyx.repeat 48 {
                      calyx.seq {
                        calyx.seq {
                          calyx.enable @bb0_5
                          calyx.enable @bb0_8
                          calyx.enable @bb0_9
                          calyx.enable @bb0_10
                          calyx.enable @bb0_11
                          calyx.enable @bb0_12
                        }
                        calyx.enable @incr_for_1_induction_var
                      }
                    }
                  }
                  calyx.enable @incr_for_2_induction_var
                }
              }
              calyx.par {
                calyx.enable @init_for_3_induction_var
              }
              calyx.repeat 48 {
                calyx.seq {
                  calyx.seq {
                    calyx.enable @bb0_13
                    calyx.enable @bb0_14
                    calyx.enable @bb0_15
                    calyx.enable @bb0_16
                    calyx.enable @bb0_18
                  }
                  calyx.enable @incr_for_3_induction_var
                }
              }
            }
            calyx.enable @incr_for_4_induction_var
          }
        }
      }
    }
  }
  calyx.component @relu2d_0(%clk: i1 {clk}, %reset: i1 {reset}, %go: i1 {go}) -> (%done: i1 {done}) {
    %c1_i32 = hw.constant 1 : i32
    %true = hw.constant true
    %false = hw.constant false
    %c48_i32 = hw.constant 48 : i32
    %c0_i32 = hw.constant 0 : i32
    %cst = calyx.constant @cst_0 <0.000000e+00 : f32> : i32
    %std_slice_1.in, %std_slice_1.out = calyx.std_slice @std_slice_1 : i32, i12
    %std_slice_0.in, %std_slice_0.out = calyx.std_slice @std_slice_0 : i32, i12
    %std_add_3.left, %std_add_3.right, %std_add_3.out = calyx.std_add @std_add_3 : i32, i32, i32
    %std_add_2.left, %std_add_2.right, %std_add_2.out = calyx.std_add @std_add_2 : i32, i32, i32
    %std_add_1.left, %std_add_1.right, %std_add_1.out = calyx.std_add @std_add_1 : i32, i32, i32
    %muli_1_reg.in, %muli_1_reg.write_en, %muli_1_reg.clk, %muli_1_reg.reset, %muli_1_reg.out, %muli_1_reg.done = calyx.register @muli_1_reg : i32, i1, i1, i1, i32, i1
    %std_mult_pipe_1.clk, %std_mult_pipe_1.reset, %std_mult_pipe_1.go, %std_mult_pipe_1.left, %std_mult_pipe_1.right, %std_mult_pipe_1.out, %std_mult_pipe_1.done = calyx.std_mult_pipe @std_mult_pipe_1 : i1, i1, i1, i32, i32, i32, i1
    %std_mux_0.cond, %std_mux_0.tru, %std_mux_0.fal, %std_mux_0.out = calyx.std_mux @std_mux_0 : i1, i32, i32, i32
    %std_and_0.left, %std_and_0.right, %std_and_0.out = calyx.std_and @std_and_0 : i1, i1, i1
    %std_or_0.left, %std_or_0.right, %std_or_0.out = calyx.std_or @std_or_0 : i1, i1, i1
    %unordered_port_0_reg.in, %unordered_port_0_reg.write_en, %unordered_port_0_reg.clk, %unordered_port_0_reg.reset, %unordered_port_0_reg.out, %unordered_port_0_reg.done = calyx.register @unordered_port_0_reg : i1, i1, i1, i1, i1, i1
    %compare_port_0_reg.in, %compare_port_0_reg.write_en, %compare_port_0_reg.clk, %compare_port_0_reg.reset, %compare_port_0_reg.out, %compare_port_0_reg.done = calyx.register @compare_port_0_reg : i1, i1, i1, i1, i1, i1
    %cmpf_0_reg.in, %cmpf_0_reg.write_en, %cmpf_0_reg.clk, %cmpf_0_reg.reset, %cmpf_0_reg.out, %cmpf_0_reg.done = calyx.register @cmpf_0_reg : i1, i1, i1, i1, i1, i1
    %std_compareFN_0.clk, %std_compareFN_0.reset, %std_compareFN_0.go, %std_compareFN_0.left, %std_compareFN_0.right, %std_compareFN_0.signaling, %std_compareFN_0.lt, %std_compareFN_0.eq, %std_compareFN_0.gt, %std_compareFN_0.unordered, %std_compareFN_0.exceptionalFlags, %std_compareFN_0.done = calyx.ieee754.compare @std_compareFN_0 : i1, i1, i1, i32, i32, i1, i1, i1, i1, i1, i5, i1
    %std_add_0.left, %std_add_0.right, %std_add_0.out = calyx.std_add @std_add_0 : i32, i32, i32
    %muli_0_reg.in, %muli_0_reg.write_en, %muli_0_reg.clk, %muli_0_reg.reset, %muli_0_reg.out, %muli_0_reg.done = calyx.register @muli_0_reg : i32, i1, i1, i1, i32, i1
    %std_mult_pipe_0.clk, %std_mult_pipe_0.reset, %std_mult_pipe_0.go, %std_mult_pipe_0.left, %std_mult_pipe_0.right, %std_mult_pipe_0.out, %std_mult_pipe_0.done = calyx.std_mult_pipe @std_mult_pipe_0 : i1, i1, i1, i32, i32, i32, i1
    %for_1_induction_var_reg.in, %for_1_induction_var_reg.write_en, %for_1_induction_var_reg.clk, %for_1_induction_var_reg.reset, %for_1_induction_var_reg.out, %for_1_induction_var_reg.done = calyx.register @for_1_induction_var_reg : i32, i1, i1, i1, i32, i1
    %for_0_induction_var_reg.in, %for_0_induction_var_reg.write_en, %for_0_induction_var_reg.clk, %for_0_induction_var_reg.reset, %for_0_induction_var_reg.out, %for_0_induction_var_reg.done = calyx.register @for_0_induction_var_reg : i32, i1, i1, i1, i32, i1
    %arg_mem_1.addr0, %arg_mem_1.clk, %arg_mem_1.reset, %arg_mem_1.content_en, %arg_mem_1.write_en, %arg_mem_1.write_data, %arg_mem_1.read_data, %arg_mem_1.done = calyx.seq_mem @arg_mem_1 <[2304] x 32> [12] : i12, i1, i1, i1, i1, i32, i32, i1
    %arg_mem_0.addr0, %arg_mem_0.clk, %arg_mem_0.reset, %arg_mem_0.content_en, %arg_mem_0.write_en, %arg_mem_0.write_data, %arg_mem_0.read_data, %arg_mem_0.done = calyx.seq_mem @arg_mem_0 <[2304] x 32> [12] : i12, i1, i1, i1, i1, i32, i32, i1
    calyx.wires {
      calyx.group @init_for_0_induction_var {
        calyx.assign %for_0_induction_var_reg.in = %c0_i32 : i32
        calyx.assign %for_0_induction_var_reg.write_en = %true : i1
        calyx.group_done %for_0_induction_var_reg.done : i1
      }
      calyx.group @init_for_1_induction_var {
        calyx.assign %for_1_induction_var_reg.in = %c0_i32 : i32
        calyx.assign %for_1_induction_var_reg.write_en = %true : i1
        calyx.group_done %for_1_induction_var_reg.done : i1
      }
      calyx.group @bb0_0 {
        calyx.assign %std_mult_pipe_0.left = %for_1_induction_var_reg.out : i32
        calyx.assign %std_mult_pipe_0.right = %c48_i32 : i32
        calyx.assign %muli_0_reg.in = %std_mult_pipe_0.out : i32
        calyx.assign %muli_0_reg.write_en = %std_mult_pipe_0.done : i1
        %0 = comb.xor %std_mult_pipe_0.done, %true : i1
        calyx.assign %std_mult_pipe_0.go = %0 ? %true : i1
        calyx.group_done %muli_0_reg.done : i1
      }
      calyx.group @bb0_2 {
        calyx.assign %std_slice_1.in = %std_add_0.out : i32
        calyx.assign %arg_mem_0.addr0 = %std_slice_1.out : i12
        calyx.assign %arg_mem_0.content_en = %true : i1
        calyx.assign %arg_mem_0.write_en = %false : i1
        calyx.assign %std_add_0.left = %muli_0_reg.out : i32
        calyx.assign %std_add_0.right = %for_0_induction_var_reg.out : i32
        calyx.group_done %arg_mem_0.done : i1
      }
      calyx.group @bb0_3 {
        calyx.assign %std_compareFN_0.left = %arg_mem_0.read_data : i32
        calyx.assign %std_compareFN_0.right = %cst : i32
        calyx.assign %std_compareFN_0.signaling = %true : i1
        calyx.assign %compare_port_0_reg.write_en = %std_compareFN_0.done : i1
        calyx.assign %compare_port_0_reg.in = %std_compareFN_0.gt : i1
        calyx.assign %unordered_port_0_reg.write_en = %std_compareFN_0.done : i1
        calyx.assign %unordered_port_0_reg.in = %std_compareFN_0.unordered : i1
        calyx.assign %std_or_0.left = %compare_port_0_reg.out : i1
        calyx.assign %std_or_0.right = %unordered_port_0_reg.out : i1
        calyx.assign %std_and_0.left = %compare_port_0_reg.done : i1
        calyx.assign %std_and_0.right = %unordered_port_0_reg.done : i1
        calyx.assign %cmpf_0_reg.in = %std_or_0.out : i1
        calyx.assign %cmpf_0_reg.write_en = %std_and_0.out : i1
        %0 = comb.xor %std_compareFN_0.done, %true : i1
        calyx.assign %std_compareFN_0.go = %0 ? %true : i1
        calyx.group_done %cmpf_0_reg.done : i1
      }
      calyx.group @bb0_5 {
        calyx.assign %std_mult_pipe_1.left = %for_1_induction_var_reg.out : i32
        calyx.assign %std_mult_pipe_1.right = %c48_i32 : i32
        calyx.assign %muli_1_reg.in = %std_mult_pipe_1.out : i32
        calyx.assign %muli_1_reg.write_en = %std_mult_pipe_1.done : i1
        %0 = comb.xor %std_mult_pipe_1.done, %true : i1
        calyx.assign %std_mult_pipe_1.go = %0 ? %true : i1
        calyx.group_done %muli_1_reg.done : i1
      }
      calyx.group @bb0_7 {
        calyx.assign %std_slice_0.in = %std_add_1.out : i32
        calyx.assign %arg_mem_1.addr0 = %std_slice_0.out : i12
        calyx.assign %arg_mem_1.write_data = %std_mux_0.out : i32
        calyx.assign %arg_mem_1.write_en = %true : i1
        calyx.assign %arg_mem_1.content_en = %true : i1
        calyx.assign %std_add_1.left = %muli_1_reg.out : i32
        calyx.assign %std_add_1.right = %for_0_induction_var_reg.out : i32
        calyx.assign %std_mux_0.cond = %cmpf_0_reg.out : i1
        calyx.assign %std_mux_0.tru = %arg_mem_0.read_data : i32
        calyx.assign %std_mux_0.fal = %cst : i32
        calyx.group_done %arg_mem_1.done : i1
      }
      calyx.group @incr_for_0_induction_var {
        calyx.assign %std_add_2.left = %for_0_induction_var_reg.out : i32
        calyx.assign %std_add_2.right = %c1_i32 : i32
        calyx.assign %for_0_induction_var_reg.in = %std_add_2.out : i32
        calyx.assign %for_0_induction_var_reg.write_en = %true : i1
        calyx.group_done %for_0_induction_var_reg.done : i1
      }
      calyx.group @incr_for_1_induction_var {
        calyx.assign %std_add_3.left = %for_1_induction_var_reg.out : i32
        calyx.assign %std_add_3.right = %c1_i32 : i32
        calyx.assign %for_1_induction_var_reg.in = %std_add_3.out : i32
        calyx.assign %for_1_induction_var_reg.write_en = %true : i1
        calyx.group_done %for_1_induction_var_reg.done : i1
      }
    }
    calyx.control {
      calyx.seq {
        calyx.par {
          calyx.enable @init_for_1_induction_var
        }
        calyx.repeat 48 {
          calyx.seq {
            calyx.par {
              calyx.enable @init_for_0_induction_var
            }
            calyx.repeat 48 {
              calyx.seq {
                calyx.seq {
                  calyx.enable @bb0_0
                  calyx.enable @bb0_2
                  calyx.enable @bb0_3
                  calyx.enable @bb0_5
                  calyx.enable @bb0_7
                }
                calyx.enable @incr_for_0_induction_var
              }
            }
            calyx.enable @incr_for_1_induction_var
          }
        }
      }
    }
  }
  calyx.component @linear2d_1(%clk: i1 {clk}, %reset: i1 {reset}, %go: i1 {go}) -> (%done: i1 {done}) {
    %c1_i32 = hw.constant 1 : i32
    %true = hw.constant true
    %false = hw.constant false
    %cst = calyx.constant @cst_0 <0.000000e+00 : f32> : i32
    %c0_i32 = hw.constant 0 : i32
    %c48_i32 = hw.constant 48 : i32
    %c2_i32 = hw.constant 2 : i32
    %std_slice_9.in, %std_slice_9.out = calyx.std_slice @std_slice_9 : i32, i2
    %std_slice_8.in, %std_slice_8.out = calyx.std_slice @std_slice_8 : i32, i12
    %std_slice_7.in, %std_slice_7.out = calyx.std_slice @std_slice_7 : i32, i1
    %std_slice_6.in, %std_slice_6.out = calyx.std_slice @std_slice_6 : i32, i1
    %std_slice_5.in, %std_slice_5.out = calyx.std_slice @std_slice_5 : i32, i8
    %std_slice_4.in, %std_slice_4.out = calyx.std_slice @std_slice_4 : i32, i2
    %std_slice_3.in, %std_slice_3.out = calyx.std_slice @std_slice_3 : i32, i2
    %std_slice_2.in, %std_slice_2.out = calyx.std_slice @std_slice_2 : i32, i2
    %std_slice_1.in, %std_slice_1.out = calyx.std_slice @std_slice_1 : i32, i2
    %std_slice_0.in, %std_slice_0.out = calyx.std_slice @std_slice_0 : i32, i8
    %std_add_7.left, %std_add_7.right, %std_add_7.out = calyx.std_add @std_add_7 : i32, i32, i32
    %std_add_6.left, %std_add_6.right, %std_add_6.out = calyx.std_add @std_add_6 : i32, i32, i32
    %std_add_5.left, %std_add_5.right, %std_add_5.out = calyx.std_add @std_add_5 : i32, i32, i32
    %std_lsh_0.left, %std_lsh_0.right, %std_lsh_0.out = calyx.std_lsh @std_lsh_0 : i32, i32, i32
    %addf_1_reg.in, %addf_1_reg.write_en, %addf_1_reg.clk, %addf_1_reg.reset, %addf_1_reg.out, %addf_1_reg.done = calyx.register @addf_1_reg : i32, i1, i1, i1, i32, i1
    %std_addFN_1.clk, %std_addFN_1.reset, %std_addFN_1.go, %std_addFN_1.control, %std_addFN_1.subOp, %std_addFN_1.left, %std_addFN_1.right, %std_addFN_1.roundingMode, %std_addFN_1.out, %std_addFN_1.exceptionalFlags, %std_addFN_1.done = calyx.ieee754.add @std_addFN_1 : i1, i1, i1, i1, i1, i32, i32, i3, i32, i5, i1
    %load_2_reg.in, %load_2_reg.write_en, %load_2_reg.clk, %load_2_reg.reset, %load_2_reg.out, %load_2_reg.done = calyx.register @load_2_reg : i32, i1, i1, i1, i32, i1
    %std_add_4.left, %std_add_4.right, %std_add_4.out = calyx.std_add @std_add_4 : i32, i32, i32
    %std_add_3.left, %std_add_3.right, %std_add_3.out = calyx.std_add @std_add_3 : i32, i32, i32
    %addf_0_reg.in, %addf_0_reg.write_en, %addf_0_reg.clk, %addf_0_reg.reset, %addf_0_reg.out, %addf_0_reg.done = calyx.register @addf_0_reg : i32, i1, i1, i1, i32, i1
    %std_addFN_0.clk, %std_addFN_0.reset, %std_addFN_0.go, %std_addFN_0.control, %std_addFN_0.subOp, %std_addFN_0.left, %std_addFN_0.right, %std_addFN_0.roundingMode, %std_addFN_0.out, %std_addFN_0.exceptionalFlags, %std_addFN_0.done = calyx.ieee754.add @std_addFN_0 : i1, i1, i1, i1, i1, i32, i32, i3, i32, i5, i1
    %load_1_reg.in, %load_1_reg.write_en, %load_1_reg.clk, %load_1_reg.reset, %load_1_reg.out, %load_1_reg.done = calyx.register @load_1_reg : i32, i1, i1, i1, i32, i1
    %mulf_0_reg.in, %mulf_0_reg.write_en, %mulf_0_reg.clk, %mulf_0_reg.reset, %mulf_0_reg.out, %mulf_0_reg.done = calyx.register @mulf_0_reg : i32, i1, i1, i1, i32, i1
    %std_mulFN_0.clk, %std_mulFN_0.reset, %std_mulFN_0.go, %std_mulFN_0.control, %std_mulFN_0.left, %std_mulFN_0.right, %std_mulFN_0.roundingMode, %std_mulFN_0.out, %std_mulFN_0.exceptionalFlags, %std_mulFN_0.done = calyx.ieee754.mul @std_mulFN_0 : i1, i1, i1, i1, i32, i32, i3, i32, i5, i1
    %std_add_2.left, %std_add_2.right, %std_add_2.out = calyx.std_add @std_add_2 : i32, i32, i32
    %muli_1_reg.in, %muli_1_reg.write_en, %muli_1_reg.clk, %muli_1_reg.reset, %muli_1_reg.out, %muli_1_reg.done = calyx.register @muli_1_reg : i32, i1, i1, i1, i32, i1
    %std_mult_pipe_1.clk, %std_mult_pipe_1.reset, %std_mult_pipe_1.go, %std_mult_pipe_1.left, %std_mult_pipe_1.right, %std_mult_pipe_1.out, %std_mult_pipe_1.done = calyx.std_mult_pipe @std_mult_pipe_1 : i1, i1, i1, i32, i32, i32, i1
    %load_0_reg.in, %load_0_reg.write_en, %load_0_reg.clk, %load_0_reg.reset, %load_0_reg.out, %load_0_reg.done = calyx.register @load_0_reg : i32, i1, i1, i1, i32, i1
    %mem_1.addr0, %mem_1.clk, %mem_1.reset, %mem_1.content_en, %mem_1.write_en, %mem_1.write_data, %mem_1.read_data, %mem_1.done = calyx.seq_mem @mem_1 <[1] x 32> [1] {external = true} : i1, i1, i1, i1, i1, i32, i32, i1
    %std_add_1.left, %std_add_1.right, %std_add_1.out = calyx.std_add @std_add_1 : i32, i32, i32
    %muli_0_reg.in, %muli_0_reg.write_en, %muli_0_reg.clk, %muli_0_reg.reset, %muli_0_reg.out, %muli_0_reg.done = calyx.register @muli_0_reg : i32, i1, i1, i1, i32, i1
    %std_mult_pipe_0.clk, %std_mult_pipe_0.reset, %std_mult_pipe_0.go, %std_mult_pipe_0.left, %std_mult_pipe_0.right, %std_mult_pipe_0.out, %std_mult_pipe_0.done = calyx.std_mult_pipe @std_mult_pipe_0 : i1, i1, i1, i32, i32, i32, i1
    %std_add_0.left, %std_add_0.right, %std_add_0.out = calyx.std_add @std_add_0 : i32, i32, i32
    %mem_0.addr0, %mem_0.clk, %mem_0.reset, %mem_0.content_en, %mem_0.write_en, %mem_0.write_data, %mem_0.read_data, %mem_0.done = calyx.seq_mem @mem_0 <[4] x 32> [2] {external = true} : i2, i1, i1, i1, i1, i32, i32, i1
    %for_4_induction_var_reg.in, %for_4_induction_var_reg.write_en, %for_4_induction_var_reg.clk, %for_4_induction_var_reg.reset, %for_4_induction_var_reg.out, %for_4_induction_var_reg.done = calyx.register @for_4_induction_var_reg : i32, i1, i1, i1, i32, i1
    %for_3_induction_var_reg.in, %for_3_induction_var_reg.write_en, %for_3_induction_var_reg.clk, %for_3_induction_var_reg.reset, %for_3_induction_var_reg.out, %for_3_induction_var_reg.done = calyx.register @for_3_induction_var_reg : i32, i1, i1, i1, i32, i1
    %for_2_induction_var_reg.in, %for_2_induction_var_reg.write_en, %for_2_induction_var_reg.clk, %for_2_induction_var_reg.reset, %for_2_induction_var_reg.out, %for_2_induction_var_reg.done = calyx.register @for_2_induction_var_reg : i32, i1, i1, i1, i32, i1
    %for_1_induction_var_reg.in, %for_1_induction_var_reg.write_en, %for_1_induction_var_reg.clk, %for_1_induction_var_reg.reset, %for_1_induction_var_reg.out, %for_1_induction_var_reg.done = calyx.register @for_1_induction_var_reg : i32, i1, i1, i1, i32, i1
    %for_0_induction_var_reg.in, %for_0_induction_var_reg.write_en, %for_0_induction_var_reg.clk, %for_0_induction_var_reg.reset, %for_0_induction_var_reg.out, %for_0_induction_var_reg.done = calyx.register @for_0_induction_var_reg : i32, i1, i1, i1, i32, i1
    %arg_mem_3.addr0, %arg_mem_3.clk, %arg_mem_3.reset, %arg_mem_3.content_en, %arg_mem_3.write_en, %arg_mem_3.write_data, %arg_mem_3.read_data, %arg_mem_3.done = calyx.seq_mem @arg_mem_3 <[192] x 32> [8] : i8, i1, i1, i1, i1, i32, i32, i1
    %arg_mem_2.addr0, %arg_mem_2.clk, %arg_mem_2.reset, %arg_mem_2.content_en, %arg_mem_2.write_en, %arg_mem_2.write_data, %arg_mem_2.read_data, %arg_mem_2.done = calyx.seq_mem @arg_mem_2 <[4] x 32> [2] : i2, i1, i1, i1, i1, i32, i32, i1
    %arg_mem_1.addr0, %arg_mem_1.clk, %arg_mem_1.reset, %arg_mem_1.content_en, %arg_mem_1.write_en, %arg_mem_1.write_data, %arg_mem_1.read_data, %arg_mem_1.done = calyx.seq_mem @arg_mem_1 <[192] x 32> [8] : i8, i1, i1, i1, i1, i32, i32, i1
    %arg_mem_0.addr0, %arg_mem_0.clk, %arg_mem_0.reset, %arg_mem_0.content_en, %arg_mem_0.write_en, %arg_mem_0.write_data, %arg_mem_0.read_data, %arg_mem_0.done = calyx.seq_mem @arg_mem_0 <[2304] x 32> [12] : i12, i1, i1, i1, i1, i32, i32, i1
    calyx.wires {
      calyx.group @init_for_0_induction_var {
        calyx.assign %for_0_induction_var_reg.in = %c0_i32 : i32
        calyx.assign %for_0_induction_var_reg.write_en = %true : i1
        calyx.group_done %for_0_induction_var_reg.done : i1
      }
      calyx.group @init_for_1_induction_var {
        calyx.assign %for_1_induction_var_reg.in = %c0_i32 : i32
        calyx.assign %for_1_induction_var_reg.write_en = %true : i1
        calyx.group_done %for_1_induction_var_reg.done : i1
      }
      calyx.group @init_for_2_induction_var {
        calyx.assign %for_2_induction_var_reg.in = %c0_i32 : i32
        calyx.assign %for_2_induction_var_reg.write_en = %true : i1
        calyx.group_done %for_2_induction_var_reg.done : i1
      }
      calyx.group @init_for_3_induction_var {
        calyx.assign %for_3_induction_var_reg.in = %c0_i32 : i32
        calyx.assign %for_3_induction_var_reg.write_en = %true : i1
        calyx.group_done %for_3_induction_var_reg.done : i1
      }
      calyx.group @init_for_4_induction_var {
        calyx.assign %for_4_induction_var_reg.in = %c0_i32 : i32
        calyx.assign %for_4_induction_var_reg.write_en = %true : i1
        calyx.group_done %for_4_induction_var_reg.done : i1
      }
      calyx.group @bb0_0 {
        calyx.assign %std_slice_9.in = %for_0_induction_var_reg.out : i32
        calyx.assign %mem_0.addr0 = %std_slice_9.out : i2
        calyx.assign %mem_0.write_data = %cst : i32
        calyx.assign %mem_0.write_en = %true : i1
        calyx.assign %mem_0.content_en = %true : i1
        calyx.group_done %mem_0.done : i1
      }
      calyx.group @incr_for_0_induction_var {
        calyx.assign %std_add_0.left = %for_0_induction_var_reg.out : i32
        calyx.assign %std_add_0.right = %c1_i32 : i32
        calyx.assign %for_0_induction_var_reg.in = %std_add_0.out : i32
        calyx.assign %for_0_induction_var_reg.write_en = %true : i1
        calyx.group_done %for_0_induction_var_reg.done : i1
      }
      calyx.group @bb0_1 {
        calyx.assign %std_mult_pipe_0.left = %for_4_induction_var_reg.out : i32
        calyx.assign %std_mult_pipe_0.right = %c48_i32 : i32
        calyx.assign %muli_0_reg.in = %std_mult_pipe_0.out : i32
        calyx.assign %muli_0_reg.write_en = %std_mult_pipe_0.done : i1
        %0 = comb.xor %std_mult_pipe_0.done, %true : i1
        calyx.assign %std_mult_pipe_0.go = %0 ? %true : i1
        calyx.group_done %muli_0_reg.done : i1
      }
      calyx.group @bb0_3 {
        calyx.assign %std_slice_8.in = %std_add_1.out : i32
        calyx.assign %arg_mem_0.addr0 = %std_slice_8.out : i12
        calyx.assign %arg_mem_0.content_en = %true : i1
        calyx.assign %arg_mem_0.write_en = %false : i1
        calyx.assign %std_add_1.left = %muli_0_reg.out : i32
        calyx.assign %std_add_1.right = %for_2_induction_var_reg.out : i32
        calyx.group_done %arg_mem_0.done : i1
      }
      calyx.group @bb0_4 {
        calyx.assign %std_slice_7.in = %c0_i32 : i32
        calyx.assign %mem_1.addr0 = %std_slice_7.out : i1
        calyx.assign %mem_1.write_data = %arg_mem_0.read_data : i32
        calyx.assign %mem_1.write_en = %true : i1
        calyx.assign %mem_1.content_en = %true : i1
        calyx.group_done %mem_1.done : i1
      }
      calyx.group @bb0_5 {
        calyx.assign %std_slice_6.in = %c0_i32 : i32
        calyx.assign %mem_1.addr0 = %std_slice_6.out : i1
        calyx.assign %mem_1.content_en = %true : i1
        calyx.assign %mem_1.write_en = %false : i1
        calyx.assign %load_0_reg.in = %mem_1.read_data : i32
        calyx.assign %load_0_reg.write_en = %mem_1.done : i1
        calyx.group_done %load_0_reg.done : i1
      }
      calyx.group @bb0_6 {
        calyx.assign %std_mult_pipe_1.left = %for_1_induction_var_reg.out : i32
        calyx.assign %std_mult_pipe_1.right = %c48_i32 : i32
        calyx.assign %muli_1_reg.in = %std_mult_pipe_1.out : i32
        calyx.assign %muli_1_reg.write_en = %std_mult_pipe_1.done : i1
        %0 = comb.xor %std_mult_pipe_1.done, %true : i1
        calyx.assign %std_mult_pipe_1.go = %0 ? %true : i1
        calyx.group_done %muli_1_reg.done : i1
      }
      calyx.group @bb0_8 {
        calyx.assign %std_slice_5.in = %std_add_2.out : i32
        calyx.assign %arg_mem_1.addr0 = %std_slice_5.out : i8
        calyx.assign %arg_mem_1.content_en = %true : i1
        calyx.assign %arg_mem_1.write_en = %false : i1
        calyx.assign %std_add_2.left = %muli_1_reg.out : i32
        calyx.assign %std_add_2.right = %for_2_induction_var_reg.out : i32
        calyx.group_done %arg_mem_1.done : i1
      }
      calyx.group @bb0_9 {
        calyx.assign %std_mulFN_0.left = %load_0_reg.out : i32
        calyx.assign %std_mulFN_0.right = %arg_mem_1.read_data : i32
        calyx.assign %mulf_0_reg.in = %std_mulFN_0.out : i32
        calyx.assign %mulf_0_reg.write_en = %std_mulFN_0.done : i1
        %0 = comb.xor %std_mulFN_0.done, %true : i1
        calyx.assign %std_mulFN_0.go = %0 ? %true : i1
        calyx.group_done %mulf_0_reg.done : i1
      }
      calyx.group @bb0_10 {
        calyx.assign %std_slice_4.in = %for_1_induction_var_reg.out : i32
        calyx.assign %mem_0.addr0 = %std_slice_4.out : i2
        calyx.assign %mem_0.content_en = %true : i1
        calyx.assign %mem_0.write_en = %false : i1
        calyx.assign %load_1_reg.in = %mem_0.read_data : i32
        calyx.assign %load_1_reg.write_en = %mem_0.done : i1
        calyx.group_done %load_1_reg.done : i1
      }
      calyx.group @bb0_11 {
        calyx.assign %std_addFN_0.left = %load_1_reg.out : i32
        calyx.assign %std_addFN_0.right = %mulf_0_reg.out : i32
        calyx.assign %addf_0_reg.in = %std_addFN_0.out : i32
        calyx.assign %addf_0_reg.write_en = %std_addFN_0.done : i1
        %0 = comb.xor %std_addFN_0.done, %true : i1
        calyx.assign %std_addFN_0.go = %0 ? %true : i1
        calyx.assign %std_addFN_0.subOp = %false : i1
        calyx.group_done %addf_0_reg.done : i1
      }
      calyx.group @bb0_12 {
        calyx.assign %std_slice_3.in = %for_1_induction_var_reg.out : i32
        calyx.assign %mem_0.addr0 = %std_slice_3.out : i2
        calyx.assign %mem_0.write_data = %addf_0_reg.out : i32
        calyx.assign %mem_0.write_en = %true : i1
        calyx.assign %mem_0.content_en = %true : i1
        calyx.group_done %mem_0.done : i1
      }
      calyx.group @incr_for_1_induction_var {
        calyx.assign %std_add_3.left = %for_1_induction_var_reg.out : i32
        calyx.assign %std_add_3.right = %c1_i32 : i32
        calyx.assign %for_1_induction_var_reg.in = %std_add_3.out : i32
        calyx.assign %for_1_induction_var_reg.write_en = %true : i1
        calyx.group_done %for_1_induction_var_reg.done : i1
      }
      calyx.group @incr_for_2_induction_var {
        calyx.assign %std_add_4.left = %for_2_induction_var_reg.out : i32
        calyx.assign %std_add_4.right = %c1_i32 : i32
        calyx.assign %for_2_induction_var_reg.in = %std_add_4.out : i32
        calyx.assign %for_2_induction_var_reg.write_en = %true : i1
        calyx.group_done %for_2_induction_var_reg.done : i1
      }
      calyx.group @bb0_13 {
        calyx.assign %std_slice_2.in = %for_3_induction_var_reg.out : i32
        calyx.assign %mem_0.addr0 = %std_slice_2.out : i2
        calyx.assign %mem_0.content_en = %true : i1
        calyx.assign %mem_0.write_en = %false : i1
        calyx.assign %load_2_reg.in = %mem_0.read_data : i32
        calyx.assign %load_2_reg.write_en = %mem_0.done : i1
        calyx.group_done %load_2_reg.done : i1
      }
      calyx.group @bb0_14 {
        calyx.assign %std_slice_1.in = %for_3_induction_var_reg.out : i32
        calyx.assign %arg_mem_2.addr0 = %std_slice_1.out : i2
        calyx.assign %arg_mem_2.content_en = %true : i1
        calyx.assign %arg_mem_2.write_en = %false : i1
        calyx.group_done %arg_mem_2.done : i1
      }
      calyx.group @bb0_15 {
        calyx.assign %std_addFN_1.left = %load_2_reg.out : i32
        calyx.assign %std_addFN_1.right = %arg_mem_2.read_data : i32
        calyx.assign %addf_1_reg.in = %std_addFN_1.out : i32
        calyx.assign %addf_1_reg.write_en = %std_addFN_1.done : i1
        %0 = comb.xor %std_addFN_1.done, %true : i1
        calyx.assign %std_addFN_1.go = %0 ? %true : i1
        calyx.assign %std_addFN_1.subOp = %false : i1
        calyx.group_done %addf_1_reg.done : i1
      }
      calyx.group @bb0_18 {
        calyx.assign %std_slice_0.in = %std_add_5.out : i32
        calyx.assign %arg_mem_3.addr0 = %std_slice_0.out : i8
        calyx.assign %arg_mem_3.write_data = %addf_1_reg.out : i32
        calyx.assign %arg_mem_3.write_en = %true : i1
        calyx.assign %arg_mem_3.content_en = %true : i1
        calyx.assign %std_add_5.left = %std_lsh_0.out : i32
        calyx.assign %std_lsh_0.left = %for_4_induction_var_reg.out : i32
        calyx.assign %std_lsh_0.right = %c2_i32 : i32
        calyx.assign %std_add_5.right = %for_3_induction_var_reg.out : i32
        calyx.group_done %arg_mem_3.done : i1
      }
      calyx.group @incr_for_3_induction_var {
        calyx.assign %std_add_6.left = %for_3_induction_var_reg.out : i32
        calyx.assign %std_add_6.right = %c1_i32 : i32
        calyx.assign %for_3_induction_var_reg.in = %std_add_6.out : i32
        calyx.assign %for_3_induction_var_reg.write_en = %true : i1
        calyx.group_done %for_3_induction_var_reg.done : i1
      }
      calyx.group @incr_for_4_induction_var {
        calyx.assign %std_add_7.left = %for_4_induction_var_reg.out : i32
        calyx.assign %std_add_7.right = %c1_i32 : i32
        calyx.assign %for_4_induction_var_reg.in = %std_add_7.out : i32
        calyx.assign %for_4_induction_var_reg.write_en = %true : i1
        calyx.group_done %for_4_induction_var_reg.done : i1
      }
    }
    calyx.control {
      calyx.seq {
        calyx.par {
          calyx.enable @init_for_4_induction_var
        }
        calyx.repeat 48 {
          calyx.seq {
            calyx.seq {
              calyx.par {
                calyx.enable @init_for_0_induction_var
              }
              calyx.repeat 4 {
                calyx.seq {
                  calyx.enable @bb0_0
                  calyx.enable @incr_for_0_induction_var
                }
              }
              calyx.par {
                calyx.enable @init_for_2_induction_var
              }
              calyx.repeat 48 {
                calyx.seq {
                  calyx.seq {
                    calyx.enable @bb0_1
                    calyx.enable @bb0_3
                    calyx.enable @bb0_4
                    calyx.par {
                      calyx.enable @init_for_1_induction_var
                    }
                    calyx.repeat 4 {
                      calyx.seq {
                        calyx.seq {
                          calyx.enable @bb0_5
                          calyx.enable @bb0_6
                          calyx.enable @bb0_8
                          calyx.enable @bb0_9
                          calyx.enable @bb0_10
                          calyx.enable @bb0_11
                          calyx.enable @bb0_12
                        }
                        calyx.enable @incr_for_1_induction_var
                      }
                    }
                  }
                  calyx.enable @incr_for_2_induction_var
                }
              }
              calyx.par {
                calyx.enable @init_for_3_induction_var
              }
              calyx.repeat 4 {
                calyx.seq {
                  calyx.seq {
                    calyx.enable @bb0_13
                    calyx.enable @bb0_14
                    calyx.enable @bb0_15
                    calyx.enable @bb0_18
                  }
                  calyx.enable @incr_for_3_induction_var
                }
              }
            }
            calyx.enable @incr_for_4_induction_var
          }
        }
      }
    }
  }
  calyx.component @forward(%clk: i1 {clk}, %reset: i1 {reset}, %go: i1 {go}) -> (%done: i1 {done}) {
    %c1_i32 = hw.constant 1 : i32
    %true = hw.constant true
    %false = hw.constant false
    %cst = calyx.constant @cst_0 <0.000000e+00 : f32> : i32
    %c0_i32 = hw.constant 0 : i32
    %c48_i32 = hw.constant 48 : i32
    %c6_i32 = hw.constant 6 : i32
    %c2_i32 = hw.constant 2 : i32
    %std_slice_21.in, %std_slice_21.out = calyx.std_slice @std_slice_21 : i32, i6
    %std_slice_20.in, %std_slice_20.out = calyx.std_slice @std_slice_20 : i32, i12
    %std_slice_19.in, %std_slice_19.out = calyx.std_slice @std_slice_19 : i32, i1
    %std_slice_18.in, %std_slice_18.out = calyx.std_slice @std_slice_18 : i32, i1
    %std_slice_17.in, %std_slice_17.out = calyx.std_slice @std_slice_17 : i32, i12
    %std_slice_16.in, %std_slice_16.out = calyx.std_slice @std_slice_16 : i32, i6
    %std_slice_15.in, %std_slice_15.out = calyx.std_slice @std_slice_15 : i32, i6
    %std_slice_14.in, %std_slice_14.out = calyx.std_slice @std_slice_14 : i32, i6
    %std_slice_13.in, %std_slice_13.out = calyx.std_slice @std_slice_13 : i32, i6
    %std_slice_12.in, %std_slice_12.out = calyx.std_slice @std_slice_12 : i32, i12
    %std_slice_11.in, %std_slice_11.out = calyx.std_slice @std_slice_11 : i32, i12
    %std_slice_10.in, %std_slice_10.out = calyx.std_slice @std_slice_10 : i32, i12
    %std_slice_9.in, %std_slice_9.out = calyx.std_slice @std_slice_9 : i32, i2
    %std_slice_8.in, %std_slice_8.out = calyx.std_slice @std_slice_8 : i32, i12
    %std_slice_7.in, %std_slice_7.out = calyx.std_slice @std_slice_7 : i32, i1
    %std_slice_6.in, %std_slice_6.out = calyx.std_slice @std_slice_6 : i32, i1
    %std_slice_5.in, %std_slice_5.out = calyx.std_slice @std_slice_5 : i32, i8
    %std_slice_4.in, %std_slice_4.out = calyx.std_slice @std_slice_4 : i32, i2
    %std_slice_3.in, %std_slice_3.out = calyx.std_slice @std_slice_3 : i32, i2
    %std_slice_2.in, %std_slice_2.out = calyx.std_slice @std_slice_2 : i32, i2
    %std_slice_1.in, %std_slice_1.out = calyx.std_slice @std_slice_1 : i32, i2
    %std_slice_0.in, %std_slice_0.out = calyx.std_slice @std_slice_0 : i32, i8
    %std_add_19.left, %std_add_19.right, %std_add_19.out = calyx.std_add @std_add_19 : i32, i32, i32
    %std_add_18.left, %std_add_18.right, %std_add_18.out = calyx.std_add @std_add_18 : i32, i32, i32
    %std_add_17.left, %std_add_17.right, %std_add_17.out = calyx.std_add @std_add_17 : i32, i32, i32
    %std_lsh_2.left, %std_lsh_2.right, %std_lsh_2.out = calyx.std_lsh @std_lsh_2 : i32, i32, i32
    %addf_3_reg.in, %addf_3_reg.write_en, %addf_3_reg.clk, %addf_3_reg.reset, %addf_3_reg.out, %addf_3_reg.done = calyx.register @addf_3_reg : i32, i1, i1, i1, i32, i1
    %std_addFN_3.clk, %std_addFN_3.reset, %std_addFN_3.go, %std_addFN_3.control, %std_addFN_3.subOp, %std_addFN_3.left, %std_addFN_3.right, %std_addFN_3.roundingMode, %std_addFN_3.out, %std_addFN_3.exceptionalFlags, %std_addFN_3.done = calyx.ieee754.add @std_addFN_3 : i1, i1, i1, i1, i1, i32, i32, i3, i32, i5, i1
    %load_7_reg.in, %load_7_reg.write_en, %load_7_reg.clk, %load_7_reg.reset, %load_7_reg.out, %load_7_reg.done = calyx.register @load_7_reg : i32, i1, i1, i1, i32, i1
    %std_add_16.left, %std_add_16.right, %std_add_16.out = calyx.std_add @std_add_16 : i32, i32, i32
    %std_add_15.left, %std_add_15.right, %std_add_15.out = calyx.std_add @std_add_15 : i32, i32, i32
    %addf_2_reg.in, %addf_2_reg.write_en, %addf_2_reg.clk, %addf_2_reg.reset, %addf_2_reg.out, %addf_2_reg.done = calyx.register @addf_2_reg : i32, i1, i1, i1, i32, i1
    %std_addFN_2.clk, %std_addFN_2.reset, %std_addFN_2.go, %std_addFN_2.control, %std_addFN_2.subOp, %std_addFN_2.left, %std_addFN_2.right, %std_addFN_2.roundingMode, %std_addFN_2.out, %std_addFN_2.exceptionalFlags, %std_addFN_2.done = calyx.ieee754.add @std_addFN_2 : i1, i1, i1, i1, i1, i32, i32, i3, i32, i5, i1
    %load_6_reg.in, %load_6_reg.write_en, %load_6_reg.clk, %load_6_reg.reset, %load_6_reg.out, %load_6_reg.done = calyx.register @load_6_reg : i32, i1, i1, i1, i32, i1
    %mulf_1_reg.in, %mulf_1_reg.write_en, %mulf_1_reg.clk, %mulf_1_reg.reset, %mulf_1_reg.out, %mulf_1_reg.done = calyx.register @mulf_1_reg : i32, i1, i1, i1, i32, i1
    %std_mulFN_1.clk, %std_mulFN_1.reset, %std_mulFN_1.go, %std_mulFN_1.control, %std_mulFN_1.left, %std_mulFN_1.right, %std_mulFN_1.roundingMode, %std_mulFN_1.out, %std_mulFN_1.exceptionalFlags, %std_mulFN_1.done = calyx.ieee754.mul @std_mulFN_1 : i1, i1, i1, i1, i32, i32, i3, i32, i5, i1
    %std_add_14.left, %std_add_14.right, %std_add_14.out = calyx.std_add @std_add_14 : i32, i32, i32
    %muli_4_reg.in, %muli_4_reg.write_en, %muli_4_reg.clk, %muli_4_reg.reset, %muli_4_reg.out, %muli_4_reg.done = calyx.register @muli_4_reg : i32, i1, i1, i1, i32, i1
    %std_mult_pipe_4.clk, %std_mult_pipe_4.reset, %std_mult_pipe_4.go, %std_mult_pipe_4.left, %std_mult_pipe_4.right, %std_mult_pipe_4.out, %std_mult_pipe_4.done = calyx.std_mult_pipe @std_mult_pipe_4 : i1, i1, i1, i32, i32, i32, i1
    %load_5_reg.in, %load_5_reg.write_en, %load_5_reg.clk, %load_5_reg.reset, %load_5_reg.out, %load_5_reg.done = calyx.register @load_5_reg : i32, i1, i1, i1, i32, i1
    %mem_1.addr0, %mem_1.clk, %mem_1.reset, %mem_1.content_en, %mem_1.write_en, %mem_1.write_data, %mem_1.read_data, %mem_1.done = calyx.seq_mem @mem_1 <[1] x 32> [1] {external = true} : i1, i1, i1, i1, i1, i32, i32, i1
    %load_4_reg.in, %load_4_reg.write_en, %load_4_reg.clk, %load_4_reg.reset, %load_4_reg.out, %load_4_reg.done = calyx.register @load_4_reg : i32, i1, i1, i1, i32, i1
    %std_add_13.left, %std_add_13.right, %std_add_13.out = calyx.std_add @std_add_13 : i32, i32, i32
    %muli_3_reg.in, %muli_3_reg.write_en, %muli_3_reg.clk, %muli_3_reg.reset, %muli_3_reg.out, %muli_3_reg.done = calyx.register @muli_3_reg : i32, i1, i1, i1, i32, i1
    %std_mult_pipe_3.clk, %std_mult_pipe_3.reset, %std_mult_pipe_3.go, %std_mult_pipe_3.left, %std_mult_pipe_3.right, %std_mult_pipe_3.out, %std_mult_pipe_3.done = calyx.std_mult_pipe @std_mult_pipe_3 : i1, i1, i1, i32, i32, i32, i1
    %std_add_12.left, %std_add_12.right, %std_add_12.out = calyx.std_add @std_add_12 : i32, i32, i32
    %std_add_11.left, %std_add_11.right, %std_add_11.out = calyx.std_add @std_add_11 : i32, i32, i32
    %std_add_10.left, %std_add_10.right, %std_add_10.out = calyx.std_add @std_add_10 : i32, i32, i32
    %std_add_9.left, %std_add_9.right, %std_add_9.out = calyx.std_add @std_add_9 : i32, i32, i32
    %muli_2_reg.in, %muli_2_reg.write_en, %muli_2_reg.clk, %muli_2_reg.reset, %muli_2_reg.out, %muli_2_reg.done = calyx.register @muli_2_reg : i32, i1, i1, i1, i32, i1
    %std_mult_pipe_2.clk, %std_mult_pipe_2.reset, %std_mult_pipe_2.go, %std_mult_pipe_2.left, %std_mult_pipe_2.right, %std_mult_pipe_2.out, %std_mult_pipe_2.done = calyx.std_mult_pipe @std_mult_pipe_2 : i1, i1, i1, i32, i32, i32, i1
    %std_mux_0.cond, %std_mux_0.tru, %std_mux_0.fal, %std_mux_0.out = calyx.std_mux @std_mux_0 : i1, i32, i32, i32
    %std_and_0.left, %std_and_0.right, %std_and_0.out = calyx.std_and @std_and_0 : i1, i1, i1
    %std_or_0.left, %std_or_0.right, %std_or_0.out = calyx.std_or @std_or_0 : i1, i1, i1
    %unordered_port_0_reg.in, %unordered_port_0_reg.write_en, %unordered_port_0_reg.clk, %unordered_port_0_reg.reset, %unordered_port_0_reg.out, %unordered_port_0_reg.done = calyx.register @unordered_port_0_reg : i1, i1, i1, i1, i1, i1
    %compare_port_0_reg.in, %compare_port_0_reg.write_en, %compare_port_0_reg.clk, %compare_port_0_reg.reset, %compare_port_0_reg.out, %compare_port_0_reg.done = calyx.register @compare_port_0_reg : i1, i1, i1, i1, i1, i1
    %cmpf_0_reg.in, %cmpf_0_reg.write_en, %cmpf_0_reg.clk, %cmpf_0_reg.reset, %cmpf_0_reg.out, %cmpf_0_reg.done = calyx.register @cmpf_0_reg : i1, i1, i1, i1, i1, i1
    %std_compareFN_0.clk, %std_compareFN_0.reset, %std_compareFN_0.go, %std_compareFN_0.left, %std_compareFN_0.right, %std_compareFN_0.signaling, %std_compareFN_0.lt, %std_compareFN_0.eq, %std_compareFN_0.gt, %std_compareFN_0.unordered, %std_compareFN_0.exceptionalFlags, %std_compareFN_0.done = calyx.ieee754.compare @std_compareFN_0 : i1, i1, i1, i32, i32, i1, i1, i1, i1, i1, i5, i1
    %load_3_reg.in, %load_3_reg.write_en, %load_3_reg.clk, %load_3_reg.reset, %load_3_reg.out, %load_3_reg.done = calyx.register @load_3_reg : i32, i1, i1, i1, i32, i1
    %std_add_8.left, %std_add_8.right, %std_add_8.out = calyx.std_add @std_add_8 : i32, i32, i32
    %muli_1_reg.in, %muli_1_reg.write_en, %muli_1_reg.clk, %muli_1_reg.reset, %muli_1_reg.out, %muli_1_reg.done = calyx.register @muli_1_reg : i32, i1, i1, i1, i32, i1
    %std_mult_pipe_1.clk, %std_mult_pipe_1.reset, %std_mult_pipe_1.go, %std_mult_pipe_1.left, %std_mult_pipe_1.right, %std_mult_pipe_1.out, %std_mult_pipe_1.done = calyx.std_mult_pipe @std_mult_pipe_1 : i1, i1, i1, i32, i32, i32, i1
    %std_add_7.left, %std_add_7.right, %std_add_7.out = calyx.std_add @std_add_7 : i32, i32, i32
    %std_add_6.left, %std_add_6.right, %std_add_6.out = calyx.std_add @std_add_6 : i32, i32, i32
    %std_add_5.left, %std_add_5.right, %std_add_5.out = calyx.std_add @std_add_5 : i32, i32, i32
    %muli_0_reg.in, %muli_0_reg.write_en, %muli_0_reg.clk, %muli_0_reg.reset, %muli_0_reg.out, %muli_0_reg.done = calyx.register @muli_0_reg : i32, i1, i1, i1, i32, i1
    %std_mult_pipe_0.clk, %std_mult_pipe_0.reset, %std_mult_pipe_0.go, %std_mult_pipe_0.left, %std_mult_pipe_0.right, %std_mult_pipe_0.out, %std_mult_pipe_0.done = calyx.std_mult_pipe @std_mult_pipe_0 : i1, i1, i1, i32, i32, i32, i1
    %addf_1_reg.in, %addf_1_reg.write_en, %addf_1_reg.clk, %addf_1_reg.reset, %addf_1_reg.out, %addf_1_reg.done = calyx.register @addf_1_reg : i32, i1, i1, i1, i32, i1
    %std_addFN_1.clk, %std_addFN_1.reset, %std_addFN_1.go, %std_addFN_1.control, %std_addFN_1.subOp, %std_addFN_1.left, %std_addFN_1.right, %std_addFN_1.roundingMode, %std_addFN_1.out, %std_addFN_1.exceptionalFlags, %std_addFN_1.done = calyx.ieee754.add @std_addFN_1 : i1, i1, i1, i1, i1, i32, i32, i3, i32, i5, i1
    %load_2_reg.in, %load_2_reg.write_en, %load_2_reg.clk, %load_2_reg.reset, %load_2_reg.out, %load_2_reg.done = calyx.register @load_2_reg : i32, i1, i1, i1, i32, i1
    %std_add_4.left, %std_add_4.right, %std_add_4.out = calyx.std_add @std_add_4 : i32, i32, i32
    %std_add_3.left, %std_add_3.right, %std_add_3.out = calyx.std_add @std_add_3 : i32, i32, i32
    %addf_0_reg.in, %addf_0_reg.write_en, %addf_0_reg.clk, %addf_0_reg.reset, %addf_0_reg.out, %addf_0_reg.done = calyx.register @addf_0_reg : i32, i1, i1, i1, i32, i1
    %std_addFN_0.clk, %std_addFN_0.reset, %std_addFN_0.go, %std_addFN_0.control, %std_addFN_0.subOp, %std_addFN_0.left, %std_addFN_0.right, %std_addFN_0.roundingMode, %std_addFN_0.out, %std_addFN_0.exceptionalFlags, %std_addFN_0.done = calyx.ieee754.add @std_addFN_0 : i1, i1, i1, i1, i1, i32, i32, i3, i32, i5, i1
    %load_1_reg.in, %load_1_reg.write_en, %load_1_reg.clk, %load_1_reg.reset, %load_1_reg.out, %load_1_reg.done = calyx.register @load_1_reg : i32, i1, i1, i1, i32, i1
    %mulf_0_reg.in, %mulf_0_reg.write_en, %mulf_0_reg.clk, %mulf_0_reg.reset, %mulf_0_reg.out, %mulf_0_reg.done = calyx.register @mulf_0_reg : i32, i1, i1, i1, i32, i1
    %std_mulFN_0.clk, %std_mulFN_0.reset, %std_mulFN_0.go, %std_mulFN_0.control, %std_mulFN_0.left, %std_mulFN_0.right, %std_mulFN_0.roundingMode, %std_mulFN_0.out, %std_mulFN_0.exceptionalFlags, %std_mulFN_0.done = calyx.ieee754.mul @std_mulFN_0 : i1, i1, i1, i1, i32, i32, i3, i32, i5, i1
    %std_add_2.left, %std_add_2.right, %std_add_2.out = calyx.std_add @std_add_2 : i32, i32, i32
    %std_lsh_1.left, %std_lsh_1.right, %std_lsh_1.out = calyx.std_lsh @std_lsh_1 : i32, i32, i32
    %load_0_reg.in, %load_0_reg.write_en, %load_0_reg.clk, %load_0_reg.reset, %load_0_reg.out, %load_0_reg.done = calyx.register @load_0_reg : i32, i1, i1, i1, i32, i1
    %mem_0.addr0, %mem_0.clk, %mem_0.reset, %mem_0.content_en, %mem_0.write_en, %mem_0.write_data, %mem_0.read_data, %mem_0.done = calyx.seq_mem @mem_0 <[1] x 32> [1] {external = true} : i1, i1, i1, i1, i1, i32, i32, i1
    %std_add_1.left, %std_add_1.right, %std_add_1.out = calyx.std_add @std_add_1 : i32, i32, i32
    %std_lsh_0.left, %std_lsh_0.right, %std_lsh_0.out = calyx.std_lsh @std_lsh_0 : i32, i32, i32
    %std_add_0.left, %std_add_0.right, %std_add_0.out = calyx.std_add @std_add_0 : i32, i32, i32
    %for_11_induction_var_reg.in, %for_11_induction_var_reg.write_en, %for_11_induction_var_reg.clk, %for_11_induction_var_reg.reset, %for_11_induction_var_reg.out, %for_11_induction_var_reg.done = calyx.register @for_11_induction_var_reg : i32, i1, i1, i1, i32, i1
    %for_10_induction_var_reg.in, %for_10_induction_var_reg.write_en, %for_10_induction_var_reg.clk, %for_10_induction_var_reg.reset, %for_10_induction_var_reg.out, %for_10_induction_var_reg.done = calyx.register @for_10_induction_var_reg : i32, i1, i1, i1, i32, i1
    %for_9_induction_var_reg.in, %for_9_induction_var_reg.write_en, %for_9_induction_var_reg.clk, %for_9_induction_var_reg.reset, %for_9_induction_var_reg.out, %for_9_induction_var_reg.done = calyx.register @for_9_induction_var_reg : i32, i1, i1, i1, i32, i1
    %for_8_induction_var_reg.in, %for_8_induction_var_reg.write_en, %for_8_induction_var_reg.clk, %for_8_induction_var_reg.reset, %for_8_induction_var_reg.out, %for_8_induction_var_reg.done = calyx.register @for_8_induction_var_reg : i32, i1, i1, i1, i32, i1
    %for_7_induction_var_reg.in, %for_7_induction_var_reg.write_en, %for_7_induction_var_reg.clk, %for_7_induction_var_reg.reset, %for_7_induction_var_reg.out, %for_7_induction_var_reg.done = calyx.register @for_7_induction_var_reg : i32, i1, i1, i1, i32, i1
    %for_6_induction_var_reg.in, %for_6_induction_var_reg.write_en, %for_6_induction_var_reg.clk, %for_6_induction_var_reg.reset, %for_6_induction_var_reg.out, %for_6_induction_var_reg.done = calyx.register @for_6_induction_var_reg : i32, i1, i1, i1, i32, i1
    %for_5_induction_var_reg.in, %for_5_induction_var_reg.write_en, %for_5_induction_var_reg.clk, %for_5_induction_var_reg.reset, %for_5_induction_var_reg.out, %for_5_induction_var_reg.done = calyx.register @for_5_induction_var_reg : i32, i1, i1, i1, i32, i1
    %for_4_induction_var_reg.in, %for_4_induction_var_reg.write_en, %for_4_induction_var_reg.clk, %for_4_induction_var_reg.reset, %for_4_induction_var_reg.out, %for_4_induction_var_reg.done = calyx.register @for_4_induction_var_reg : i32, i1, i1, i1, i32, i1
    %for_3_induction_var_reg.in, %for_3_induction_var_reg.write_en, %for_3_induction_var_reg.clk, %for_3_induction_var_reg.reset, %for_3_induction_var_reg.out, %for_3_induction_var_reg.done = calyx.register @for_3_induction_var_reg : i32, i1, i1, i1, i32, i1
    %for_2_induction_var_reg.in, %for_2_induction_var_reg.write_en, %for_2_induction_var_reg.clk, %for_2_induction_var_reg.reset, %for_2_induction_var_reg.out, %for_2_induction_var_reg.done = calyx.register @for_2_induction_var_reg : i32, i1, i1, i1, i32, i1
    %for_1_induction_var_reg.in, %for_1_induction_var_reg.write_en, %for_1_induction_var_reg.clk, %for_1_induction_var_reg.reset, %for_1_induction_var_reg.out, %for_1_induction_var_reg.done = calyx.register @for_1_induction_var_reg : i32, i1, i1, i1, i32, i1
    %for_0_induction_var_reg.in, %for_0_induction_var_reg.write_en, %for_0_induction_var_reg.clk, %for_0_induction_var_reg.reset, %for_0_induction_var_reg.out, %for_0_induction_var_reg.done = calyx.register @for_0_induction_var_reg : i32, i1, i1, i1, i32, i1
    %arg_mem_9.addr0, %arg_mem_9.clk, %arg_mem_9.reset, %arg_mem_9.content_en, %arg_mem_9.write_en, %arg_mem_9.write_data, %arg_mem_9.read_data, %arg_mem_9.done = calyx.seq_mem @arg_mem_9 <[4] x 32> [2] : i2, i1, i1, i1, i1, i32, i32, i1
    %arg_mem_8.addr0, %arg_mem_8.clk, %arg_mem_8.reset, %arg_mem_8.content_en, %arg_mem_8.write_en, %arg_mem_8.write_data, %arg_mem_8.read_data, %arg_mem_8.done = calyx.seq_mem @arg_mem_8 <[2304] x 32> [12] : i12, i1, i1, i1, i1, i32, i32, i1
    %arg_mem_7.addr0, %arg_mem_7.clk, %arg_mem_7.reset, %arg_mem_7.content_en, %arg_mem_7.write_en, %arg_mem_7.write_data, %arg_mem_7.read_data, %arg_mem_7.done = calyx.seq_mem @arg_mem_7 <[48] x 32> [6] : i6, i1, i1, i1, i1, i32, i32, i1
    %arg_mem_6.addr0, %arg_mem_6.clk, %arg_mem_6.reset, %arg_mem_6.content_en, %arg_mem_6.write_en, %arg_mem_6.write_data, %arg_mem_6.read_data, %arg_mem_6.done = calyx.seq_mem @arg_mem_6 <[2304] x 32> [12] : i12, i1, i1, i1, i1, i32, i32, i1
    %arg_mem_5.addr0, %arg_mem_5.clk, %arg_mem_5.reset, %arg_mem_5.content_en, %arg_mem_5.write_en, %arg_mem_5.write_data, %arg_mem_5.read_data, %arg_mem_5.done = calyx.seq_mem @arg_mem_5 <[192] x 32> [8] : i8, i1, i1, i1, i1, i32, i32, i1
    %arg_mem_4.addr0, %arg_mem_4.clk, %arg_mem_4.reset, %arg_mem_4.content_en, %arg_mem_4.write_en, %arg_mem_4.write_data, %arg_mem_4.read_data, %arg_mem_4.done = calyx.seq_mem @arg_mem_4 <[4] x 32> [2] : i2, i1, i1, i1, i1, i32, i32, i1
    %arg_mem_3.addr0, %arg_mem_3.clk, %arg_mem_3.reset, %arg_mem_3.content_en, %arg_mem_3.write_en, %arg_mem_3.write_data, %arg_mem_3.read_data, %arg_mem_3.done = calyx.seq_mem @arg_mem_3 <[192] x 32> [8] : i8, i1, i1, i1, i1, i32, i32, i1
    %arg_mem_2.addr0, %arg_mem_2.clk, %arg_mem_2.reset, %arg_mem_2.content_en, %arg_mem_2.write_en, %arg_mem_2.write_data, %arg_mem_2.read_data, %arg_mem_2.done = calyx.seq_mem @arg_mem_2 <[48] x 32> [6] : i6, i1, i1, i1, i1, i32, i32, i1
    %arg_mem_1.addr0, %arg_mem_1.clk, %arg_mem_1.reset, %arg_mem_1.content_en, %arg_mem_1.write_en, %arg_mem_1.write_data, %arg_mem_1.read_data, %arg_mem_1.done = calyx.seq_mem @arg_mem_1 <[3072] x 32> [12] : i12, i1, i1, i1, i1, i32, i32, i1
    %arg_mem_0.addr0, %arg_mem_0.clk, %arg_mem_0.reset, %arg_mem_0.content_en, %arg_mem_0.write_en, %arg_mem_0.write_data, %arg_mem_0.read_data, %arg_mem_0.done = calyx.seq_mem @arg_mem_0 <[3072] x 32> [12] : i12, i1, i1, i1, i1, i32, i32, i1
    calyx.wires {
      calyx.group @init_for_0_induction_var {
        calyx.assign %for_0_induction_var_reg.in = %c0_i32 : i32
        calyx.assign %for_0_induction_var_reg.write_en = %true : i1
        calyx.group_done %for_0_induction_var_reg.done : i1
      }
      calyx.group @init_for_1_induction_var {
        calyx.assign %for_1_induction_var_reg.in = %c0_i32 : i32
        calyx.assign %for_1_induction_var_reg.write_en = %true : i1
        calyx.group_done %for_1_induction_var_reg.done : i1
      }
      calyx.group @init_for_2_induction_var {
        calyx.assign %for_2_induction_var_reg.in = %c0_i32 : i32
        calyx.assign %for_2_induction_var_reg.write_en = %true : i1
        calyx.group_done %for_2_induction_var_reg.done : i1
      }
      calyx.group @init_for_3_induction_var {
        calyx.assign %for_3_induction_var_reg.in = %c0_i32 : i32
        calyx.assign %for_3_induction_var_reg.write_en = %true : i1
        calyx.group_done %for_3_induction_var_reg.done : i1
      }
      calyx.group @init_for_4_induction_var {
        calyx.assign %for_4_induction_var_reg.in = %c0_i32 : i32
        calyx.assign %for_4_induction_var_reg.write_en = %true : i1
        calyx.group_done %for_4_induction_var_reg.done : i1
      }
      calyx.group @init_for_5_induction_var {
        calyx.assign %for_5_induction_var_reg.in = %c0_i32 : i32
        calyx.assign %for_5_induction_var_reg.write_en = %true : i1
        calyx.group_done %for_5_induction_var_reg.done : i1
      }
      calyx.group @init_for_6_induction_var {
        calyx.assign %for_6_induction_var_reg.in = %c0_i32 : i32
        calyx.assign %for_6_induction_var_reg.write_en = %true : i1
        calyx.group_done %for_6_induction_var_reg.done : i1
      }
      calyx.group @init_for_7_induction_var {
        calyx.assign %for_7_induction_var_reg.in = %c0_i32 : i32
        calyx.assign %for_7_induction_var_reg.write_en = %true : i1
        calyx.group_done %for_7_induction_var_reg.done : i1
      }
      calyx.group @init_for_8_induction_var {
        calyx.assign %for_8_induction_var_reg.in = %c0_i32 : i32
        calyx.assign %for_8_induction_var_reg.write_en = %true : i1
        calyx.group_done %for_8_induction_var_reg.done : i1
      }
      calyx.group @init_for_9_induction_var {
        calyx.assign %for_9_induction_var_reg.in = %c0_i32 : i32
        calyx.assign %for_9_induction_var_reg.write_en = %true : i1
        calyx.group_done %for_9_induction_var_reg.done : i1
      }
      calyx.group @init_for_10_induction_var {
        calyx.assign %for_10_induction_var_reg.in = %c0_i32 : i32
        calyx.assign %for_10_induction_var_reg.write_en = %true : i1
        calyx.group_done %for_10_induction_var_reg.done : i1
      }
      calyx.group @init_for_11_induction_var {
        calyx.assign %for_11_induction_var_reg.in = %c0_i32 : i32
        calyx.assign %for_11_induction_var_reg.write_en = %true : i1
        calyx.group_done %for_11_induction_var_reg.done : i1
      }
      calyx.group @bb0_0 {
        calyx.assign %std_slice_21.in = %for_0_induction_var_reg.out : i32
        calyx.assign %arg_mem_7.addr0 = %std_slice_21.out : i6
        calyx.assign %arg_mem_7.write_data = %cst : i32
        calyx.assign %arg_mem_7.write_en = %true : i1
        calyx.assign %arg_mem_7.content_en = %true : i1
        calyx.group_done %arg_mem_7.done : i1
      }
      calyx.group @incr_for_0_induction_var {
        calyx.assign %std_add_0.left = %for_0_induction_var_reg.out : i32
        calyx.assign %std_add_0.right = %c1_i32 : i32
        calyx.assign %for_0_induction_var_reg.in = %std_add_0.out : i32
        calyx.assign %for_0_induction_var_reg.write_en = %true : i1
        calyx.group_done %for_0_induction_var_reg.done : i1
      }
      calyx.group @bb0_3 {
        calyx.assign %std_slice_20.in = %std_add_1.out : i32
        calyx.assign %arg_mem_0.addr0 = %std_slice_20.out : i12
        calyx.assign %arg_mem_0.content_en = %true : i1
        calyx.assign %arg_mem_0.write_en = %false : i1
        calyx.assign %std_add_1.left = %std_lsh_0.out : i32
        calyx.assign %std_lsh_0.left = %for_4_induction_var_reg.out : i32
        calyx.assign %std_lsh_0.right = %c6_i32 : i32
        calyx.assign %std_add_1.right = %for_2_induction_var_reg.out : i32
        calyx.group_done %arg_mem_0.done : i1
      }
      calyx.group @bb0_4 {
        calyx.assign %std_slice_19.in = %c0_i32 : i32
        calyx.assign %mem_0.addr0 = %std_slice_19.out : i1
        calyx.assign %mem_0.write_data = %arg_mem_0.read_data : i32
        calyx.assign %mem_0.write_en = %true : i1
        calyx.assign %mem_0.content_en = %true : i1
        calyx.group_done %mem_0.done : i1
      }
      calyx.group @bb0_5 {
        calyx.assign %std_slice_18.in = %c0_i32 : i32
        calyx.assign %mem_0.addr0 = %std_slice_18.out : i1
        calyx.assign %mem_0.content_en = %true : i1
        calyx.assign %mem_0.write_en = %false : i1
        calyx.assign %load_0_reg.in = %mem_0.read_data : i32
        calyx.assign %load_0_reg.write_en = %mem_0.done : i1
        calyx.group_done %load_0_reg.done : i1
      }
      calyx.group @bb0_8 {
        calyx.assign %std_slice_17.in = %std_add_2.out : i32
        calyx.assign %arg_mem_1.addr0 = %std_slice_17.out : i12
        calyx.assign %arg_mem_1.content_en = %true : i1
        calyx.assign %arg_mem_1.write_en = %false : i1
        calyx.assign %std_add_2.left = %std_lsh_1.out : i32
        calyx.assign %std_lsh_1.left = %for_1_induction_var_reg.out : i32
        calyx.assign %std_lsh_1.right = %c6_i32 : i32
        calyx.assign %std_add_2.right = %for_2_induction_var_reg.out : i32
        calyx.group_done %arg_mem_1.done : i1
      }
      calyx.group @bb0_9 {
        calyx.assign %std_mulFN_0.left = %load_0_reg.out : i32
        calyx.assign %std_mulFN_0.right = %arg_mem_1.read_data : i32
        calyx.assign %mulf_0_reg.in = %std_mulFN_0.out : i32
        calyx.assign %mulf_0_reg.write_en = %std_mulFN_0.done : i1
        %0 = comb.xor %std_mulFN_0.done, %true : i1
        calyx.assign %std_mulFN_0.go = %0 ? %true : i1
        calyx.group_done %mulf_0_reg.done : i1
      }
      calyx.group @bb0_10 {
        calyx.assign %std_slice_16.in = %for_1_induction_var_reg.out : i32
        calyx.assign %arg_mem_7.addr0 = %std_slice_16.out : i6
        calyx.assign %arg_mem_7.content_en = %true : i1
        calyx.assign %arg_mem_7.write_en = %false : i1
        calyx.assign %load_1_reg.in = %arg_mem_7.read_data : i32
        calyx.assign %load_1_reg.write_en = %arg_mem_7.done : i1
        calyx.group_done %load_1_reg.done : i1
      }
      calyx.group @bb0_11 {
        calyx.assign %std_addFN_0.left = %load_1_reg.out : i32
        calyx.assign %std_addFN_0.right = %mulf_0_reg.out : i32
        calyx.assign %addf_0_reg.in = %std_addFN_0.out : i32
        calyx.assign %addf_0_reg.write_en = %std_addFN_0.done : i1
        %0 = comb.xor %std_addFN_0.done, %true : i1
        calyx.assign %std_addFN_0.go = %0 ? %true : i1
        calyx.assign %std_addFN_0.subOp = %false : i1
        calyx.group_done %addf_0_reg.done : i1
      }
      calyx.group @bb0_12 {
        calyx.assign %std_slice_15.in = %for_1_induction_var_reg.out : i32
        calyx.assign %arg_mem_7.addr0 = %std_slice_15.out : i6
        calyx.assign %arg_mem_7.write_data = %addf_0_reg.out : i32
        calyx.assign %arg_mem_7.write_en = %true : i1
        calyx.assign %arg_mem_7.content_en = %true : i1
        calyx.group_done %arg_mem_7.done : i1
      }
      calyx.group @incr_for_1_induction_var {
        calyx.assign %std_add_3.left = %for_1_induction_var_reg.out : i32
        calyx.assign %std_add_3.right = %c1_i32 : i32
        calyx.assign %for_1_induction_var_reg.in = %std_add_3.out : i32
        calyx.assign %for_1_induction_var_reg.write_en = %true : i1
        calyx.group_done %for_1_induction_var_reg.done : i1
      }
      calyx.group @incr_for_2_induction_var {
        calyx.assign %std_add_4.left = %for_2_induction_var_reg.out : i32
        calyx.assign %std_add_4.right = %c1_i32 : i32
        calyx.assign %for_2_induction_var_reg.in = %std_add_4.out : i32
        calyx.assign %for_2_induction_var_reg.write_en = %true : i1
        calyx.group_done %for_2_induction_var_reg.done : i1
      }
      calyx.group @bb0_13 {
        calyx.assign %std_slice_14.in = %for_3_induction_var_reg.out : i32
        calyx.assign %arg_mem_7.addr0 = %std_slice_14.out : i6
        calyx.assign %arg_mem_7.content_en = %true : i1
        calyx.assign %arg_mem_7.write_en = %false : i1
        calyx.assign %load_2_reg.in = %arg_mem_7.read_data : i32
        calyx.assign %load_2_reg.write_en = %arg_mem_7.done : i1
        calyx.group_done %load_2_reg.done : i1
      }
      calyx.group @bb0_14 {
        calyx.assign %std_slice_13.in = %for_3_induction_var_reg.out : i32
        calyx.assign %arg_mem_2.addr0 = %std_slice_13.out : i6
        calyx.assign %arg_mem_2.content_en = %true : i1
        calyx.assign %arg_mem_2.write_en = %false : i1
        calyx.group_done %arg_mem_2.done : i1
      }
      calyx.group @bb0_15 {
        calyx.assign %std_addFN_1.left = %load_2_reg.out : i32
        calyx.assign %std_addFN_1.right = %arg_mem_2.read_data : i32
        calyx.assign %addf_1_reg.in = %std_addFN_1.out : i32
        calyx.assign %addf_1_reg.write_en = %std_addFN_1.done : i1
        %0 = comb.xor %std_addFN_1.done, %true : i1
        calyx.assign %std_addFN_1.go = %0 ? %true : i1
        calyx.assign %std_addFN_1.subOp = %false : i1
        calyx.group_done %addf_1_reg.done : i1
      }
      calyx.group @bb0_16 {
        calyx.assign %std_mult_pipe_0.left = %for_4_induction_var_reg.out : i32
        calyx.assign %std_mult_pipe_0.right = %c48_i32 : i32
        calyx.assign %muli_0_reg.in = %std_mult_pipe_0.out : i32
        calyx.assign %muli_0_reg.write_en = %std_mult_pipe_0.done : i1
        %0 = comb.xor %std_mult_pipe_0.done, %true : i1
        calyx.assign %std_mult_pipe_0.go = %0 ? %true : i1
        calyx.group_done %muli_0_reg.done : i1
      }
      calyx.group @bb0_18 {
        calyx.assign %std_slice_12.in = %std_add_5.out : i32
        calyx.assign %arg_mem_6.addr0 = %std_slice_12.out : i12
        calyx.assign %arg_mem_6.write_data = %addf_1_reg.out : i32
        calyx.assign %arg_mem_6.write_en = %true : i1
        calyx.assign %arg_mem_6.content_en = %true : i1
        calyx.assign %std_add_5.left = %muli_0_reg.out : i32
        calyx.assign %std_add_5.right = %for_3_induction_var_reg.out : i32
        calyx.group_done %arg_mem_6.done : i1
      }
      calyx.group @incr_for_3_induction_var {
        calyx.assign %std_add_6.left = %for_3_induction_var_reg.out : i32
        calyx.assign %std_add_6.right = %c1_i32 : i32
        calyx.assign %for_3_induction_var_reg.in = %std_add_6.out : i32
        calyx.assign %for_3_induction_var_reg.write_en = %true : i1
        calyx.group_done %for_3_induction_var_reg.done : i1
      }
      calyx.group @incr_for_4_induction_var {
        calyx.assign %std_add_7.left = %for_4_induction_var_reg.out : i32
        calyx.assign %std_add_7.right = %c1_i32 : i32
        calyx.assign %for_4_induction_var_reg.in = %std_add_7.out : i32
        calyx.assign %for_4_induction_var_reg.write_en = %true : i1
        calyx.group_done %for_4_induction_var_reg.done : i1
      }
      calyx.group @bb0_19 {
        calyx.assign %std_mult_pipe_1.left = %for_6_induction_var_reg.out : i32
        calyx.assign %std_mult_pipe_1.right = %c48_i32 : i32
        calyx.assign %muli_1_reg.in = %std_mult_pipe_1.out : i32
        calyx.assign %muli_1_reg.write_en = %std_mult_pipe_1.done : i1
        %0 = comb.xor %std_mult_pipe_1.done, %true : i1
        calyx.assign %std_mult_pipe_1.go = %0 ? %true : i1
        calyx.group_done %muli_1_reg.done : i1
      }
      calyx.group @bb0_21 {
        calyx.assign %std_slice_11.in = %std_add_8.out : i32
        calyx.assign %arg_mem_6.addr0 = %std_slice_11.out : i12
        calyx.assign %arg_mem_6.content_en = %true : i1
        calyx.assign %arg_mem_6.write_en = %false : i1
        calyx.assign %load_3_reg.in = %arg_mem_6.read_data : i32
        calyx.assign %load_3_reg.write_en = %arg_mem_6.done : i1
        calyx.assign %std_add_8.left = %muli_1_reg.out : i32
        calyx.assign %std_add_8.right = %for_5_induction_var_reg.out : i32
        calyx.group_done %load_3_reg.done : i1
      }
      calyx.group @bb0_22 {
        calyx.assign %std_compareFN_0.left = %load_3_reg.out : i32
        calyx.assign %std_compareFN_0.right = %cst : i32
        calyx.assign %std_compareFN_0.signaling = %true : i1
        calyx.assign %compare_port_0_reg.write_en = %std_compareFN_0.done : i1
        calyx.assign %compare_port_0_reg.in = %std_compareFN_0.gt : i1
        calyx.assign %unordered_port_0_reg.write_en = %std_compareFN_0.done : i1
        calyx.assign %unordered_port_0_reg.in = %std_compareFN_0.unordered : i1
        calyx.assign %std_or_0.left = %compare_port_0_reg.out : i1
        calyx.assign %std_or_0.right = %unordered_port_0_reg.out : i1
        calyx.assign %std_and_0.left = %compare_port_0_reg.done : i1
        calyx.assign %std_and_0.right = %unordered_port_0_reg.done : i1
        calyx.assign %cmpf_0_reg.in = %std_or_0.out : i1
        calyx.assign %cmpf_0_reg.write_en = %std_and_0.out : i1
        %0 = comb.xor %std_compareFN_0.done, %true : i1
        calyx.assign %std_compareFN_0.go = %0 ? %true : i1
        calyx.group_done %cmpf_0_reg.done : i1
      }
      calyx.group @bb0_24 {
        calyx.assign %std_mult_pipe_2.left = %for_6_induction_var_reg.out : i32
        calyx.assign %std_mult_pipe_2.right = %c48_i32 : i32
        calyx.assign %muli_2_reg.in = %std_mult_pipe_2.out : i32
        calyx.assign %muli_2_reg.write_en = %std_mult_pipe_2.done : i1
        %0 = comb.xor %std_mult_pipe_2.done, %true : i1
        calyx.assign %std_mult_pipe_2.go = %0 ? %true : i1
        calyx.group_done %muli_2_reg.done : i1
      }
      calyx.group @bb0_26 {
        calyx.assign %std_slice_10.in = %std_add_9.out : i32
        calyx.assign %arg_mem_8.addr0 = %std_slice_10.out : i12
        calyx.assign %arg_mem_8.write_data = %std_mux_0.out : i32
        calyx.assign %arg_mem_8.write_en = %true : i1
        calyx.assign %arg_mem_8.content_en = %true : i1
        calyx.assign %std_add_9.left = %muli_2_reg.out : i32
        calyx.assign %std_add_9.right = %for_5_induction_var_reg.out : i32
        calyx.assign %std_mux_0.cond = %cmpf_0_reg.out : i1
        calyx.assign %std_mux_0.tru = %load_3_reg.out : i32
        calyx.assign %std_mux_0.fal = %cst : i32
        calyx.group_done %arg_mem_8.done : i1
      }
      calyx.group @incr_for_5_induction_var {
        calyx.assign %std_add_10.left = %for_5_induction_var_reg.out : i32
        calyx.assign %std_add_10.right = %c1_i32 : i32
        calyx.assign %for_5_induction_var_reg.in = %std_add_10.out : i32
        calyx.assign %for_5_induction_var_reg.write_en = %true : i1
        calyx.group_done %for_5_induction_var_reg.done : i1
      }
      calyx.group @incr_for_6_induction_var {
        calyx.assign %std_add_11.left = %for_6_induction_var_reg.out : i32
        calyx.assign %std_add_11.right = %c1_i32 : i32
        calyx.assign %for_6_induction_var_reg.in = %std_add_11.out : i32
        calyx.assign %for_6_induction_var_reg.write_en = %true : i1
        calyx.group_done %for_6_induction_var_reg.done : i1
      }
      calyx.group @bb0_27 {
        calyx.assign %std_slice_9.in = %for_7_induction_var_reg.out : i32
        calyx.assign %arg_mem_9.addr0 = %std_slice_9.out : i2
        calyx.assign %arg_mem_9.write_data = %cst : i32
        calyx.assign %arg_mem_9.write_en = %true : i1
        calyx.assign %arg_mem_9.content_en = %true : i1
        calyx.group_done %arg_mem_9.done : i1
      }
      calyx.group @incr_for_7_induction_var {
        calyx.assign %std_add_12.left = %for_7_induction_var_reg.out : i32
        calyx.assign %std_add_12.right = %c1_i32 : i32
        calyx.assign %for_7_induction_var_reg.in = %std_add_12.out : i32
        calyx.assign %for_7_induction_var_reg.write_en = %true : i1
        calyx.group_done %for_7_induction_var_reg.done : i1
      }
      calyx.group @bb0_28 {
        calyx.assign %std_mult_pipe_3.left = %for_11_induction_var_reg.out : i32
        calyx.assign %std_mult_pipe_3.right = %c48_i32 : i32
        calyx.assign %muli_3_reg.in = %std_mult_pipe_3.out : i32
        calyx.assign %muli_3_reg.write_en = %std_mult_pipe_3.done : i1
        %0 = comb.xor %std_mult_pipe_3.done, %true : i1
        calyx.assign %std_mult_pipe_3.go = %0 ? %true : i1
        calyx.group_done %muli_3_reg.done : i1
      }
      calyx.group @bb0_30 {
        calyx.assign %std_slice_8.in = %std_add_13.out : i32
        calyx.assign %arg_mem_8.addr0 = %std_slice_8.out : i12
        calyx.assign %arg_mem_8.content_en = %true : i1
        calyx.assign %arg_mem_8.write_en = %false : i1
        calyx.assign %load_4_reg.in = %arg_mem_8.read_data : i32
        calyx.assign %load_4_reg.write_en = %arg_mem_8.done : i1
        calyx.assign %std_add_13.left = %muli_3_reg.out : i32
        calyx.assign %std_add_13.right = %for_9_induction_var_reg.out : i32
        calyx.group_done %load_4_reg.done : i1
      }
      calyx.group @bb0_31 {
        calyx.assign %std_slice_7.in = %c0_i32 : i32
        calyx.assign %mem_1.addr0 = %std_slice_7.out : i1
        calyx.assign %mem_1.write_data = %load_4_reg.out : i32
        calyx.assign %mem_1.write_en = %true : i1
        calyx.assign %mem_1.content_en = %true : i1
        calyx.group_done %mem_1.done : i1
      }
      calyx.group @bb0_32 {
        calyx.assign %std_slice_6.in = %c0_i32 : i32
        calyx.assign %mem_1.addr0 = %std_slice_6.out : i1
        calyx.assign %mem_1.content_en = %true : i1
        calyx.assign %mem_1.write_en = %false : i1
        calyx.assign %load_5_reg.in = %mem_1.read_data : i32
        calyx.assign %load_5_reg.write_en = %mem_1.done : i1
        calyx.group_done %load_5_reg.done : i1
      }
      calyx.group @bb0_33 {
        calyx.assign %std_mult_pipe_4.left = %for_8_induction_var_reg.out : i32
        calyx.assign %std_mult_pipe_4.right = %c48_i32 : i32
        calyx.assign %muli_4_reg.in = %std_mult_pipe_4.out : i32
        calyx.assign %muli_4_reg.write_en = %std_mult_pipe_4.done : i1
        %0 = comb.xor %std_mult_pipe_4.done, %true : i1
        calyx.assign %std_mult_pipe_4.go = %0 ? %true : i1
        calyx.group_done %muli_4_reg.done : i1
      }
      calyx.group @bb0_35 {
        calyx.assign %std_slice_5.in = %std_add_14.out : i32
        calyx.assign %arg_mem_3.addr0 = %std_slice_5.out : i8
        calyx.assign %arg_mem_3.content_en = %true : i1
        calyx.assign %arg_mem_3.write_en = %false : i1
        calyx.assign %std_add_14.left = %muli_4_reg.out : i32
        calyx.assign %std_add_14.right = %for_9_induction_var_reg.out : i32
        calyx.group_done %arg_mem_3.done : i1
      }
      calyx.group @bb0_36 {
        calyx.assign %std_mulFN_1.left = %load_5_reg.out : i32
        calyx.assign %std_mulFN_1.right = %arg_mem_3.read_data : i32
        calyx.assign %mulf_1_reg.in = %std_mulFN_1.out : i32
        calyx.assign %mulf_1_reg.write_en = %std_mulFN_1.done : i1
        %0 = comb.xor %std_mulFN_1.done, %true : i1
        calyx.assign %std_mulFN_1.go = %0 ? %true : i1
        calyx.group_done %mulf_1_reg.done : i1
      }
      calyx.group @bb0_37 {
        calyx.assign %std_slice_4.in = %for_8_induction_var_reg.out : i32
        calyx.assign %arg_mem_9.addr0 = %std_slice_4.out : i2
        calyx.assign %arg_mem_9.content_en = %true : i1
        calyx.assign %arg_mem_9.write_en = %false : i1
        calyx.assign %load_6_reg.in = %arg_mem_9.read_data : i32
        calyx.assign %load_6_reg.write_en = %arg_mem_9.done : i1
        calyx.group_done %load_6_reg.done : i1
      }
      calyx.group @bb0_38 {
        calyx.assign %std_addFN_2.left = %load_6_reg.out : i32
        calyx.assign %std_addFN_2.right = %mulf_1_reg.out : i32
        calyx.assign %addf_2_reg.in = %std_addFN_2.out : i32
        calyx.assign %addf_2_reg.write_en = %std_addFN_2.done : i1
        %0 = comb.xor %std_addFN_2.done, %true : i1
        calyx.assign %std_addFN_2.go = %0 ? %true : i1
        calyx.assign %std_addFN_2.subOp = %false : i1
        calyx.group_done %addf_2_reg.done : i1
      }
      calyx.group @bb0_39 {
        calyx.assign %std_slice_3.in = %for_8_induction_var_reg.out : i32
        calyx.assign %arg_mem_9.addr0 = %std_slice_3.out : i2
        calyx.assign %arg_mem_9.write_data = %addf_2_reg.out : i32
        calyx.assign %arg_mem_9.write_en = %true : i1
        calyx.assign %arg_mem_9.content_en = %true : i1
        calyx.group_done %arg_mem_9.done : i1
      }
      calyx.group @incr_for_8_induction_var {
        calyx.assign %std_add_15.left = %for_8_induction_var_reg.out : i32
        calyx.assign %std_add_15.right = %c1_i32 : i32
        calyx.assign %for_8_induction_var_reg.in = %std_add_15.out : i32
        calyx.assign %for_8_induction_var_reg.write_en = %true : i1
        calyx.group_done %for_8_induction_var_reg.done : i1
      }
      calyx.group @incr_for_9_induction_var {
        calyx.assign %std_add_16.left = %for_9_induction_var_reg.out : i32
        calyx.assign %std_add_16.right = %c1_i32 : i32
        calyx.assign %for_9_induction_var_reg.in = %std_add_16.out : i32
        calyx.assign %for_9_induction_var_reg.write_en = %true : i1
        calyx.group_done %for_9_induction_var_reg.done : i1
      }
      calyx.group @bb0_40 {
        calyx.assign %std_slice_2.in = %for_10_induction_var_reg.out : i32
        calyx.assign %arg_mem_9.addr0 = %std_slice_2.out : i2
        calyx.assign %arg_mem_9.content_en = %true : i1
        calyx.assign %arg_mem_9.write_en = %false : i1
        calyx.assign %load_7_reg.in = %arg_mem_9.read_data : i32
        calyx.assign %load_7_reg.write_en = %arg_mem_9.done : i1
        calyx.group_done %load_7_reg.done : i1
      }
      calyx.group @bb0_41 {
        calyx.assign %std_slice_1.in = %for_10_induction_var_reg.out : i32
        calyx.assign %arg_mem_4.addr0 = %std_slice_1.out : i2
        calyx.assign %arg_mem_4.content_en = %true : i1
        calyx.assign %arg_mem_4.write_en = %false : i1
        calyx.group_done %arg_mem_4.done : i1
      }
      calyx.group @bb0_42 {
        calyx.assign %std_addFN_3.left = %load_7_reg.out : i32
        calyx.assign %std_addFN_3.right = %arg_mem_4.read_data : i32
        calyx.assign %addf_3_reg.in = %std_addFN_3.out : i32
        calyx.assign %addf_3_reg.write_en = %std_addFN_3.done : i1
        %0 = comb.xor %std_addFN_3.done, %true : i1
        calyx.assign %std_addFN_3.go = %0 ? %true : i1
        calyx.assign %std_addFN_3.subOp = %false : i1
        calyx.group_done %addf_3_reg.done : i1
      }
      calyx.group @bb0_45 {
        calyx.assign %std_slice_0.in = %std_add_17.out : i32
        calyx.assign %arg_mem_5.addr0 = %std_slice_0.out : i8
        calyx.assign %arg_mem_5.write_data = %addf_3_reg.out : i32
        calyx.assign %arg_mem_5.write_en = %true : i1
        calyx.assign %arg_mem_5.content_en = %true : i1
        calyx.assign %std_add_17.left = %std_lsh_2.out : i32
        calyx.assign %std_lsh_2.left = %for_11_induction_var_reg.out : i32
        calyx.assign %std_lsh_2.right = %c2_i32 : i32
        calyx.assign %std_add_17.right = %for_10_induction_var_reg.out : i32
        calyx.group_done %arg_mem_5.done : i1
      }
      calyx.group @incr_for_10_induction_var {
        calyx.assign %std_add_18.left = %for_10_induction_var_reg.out : i32
        calyx.assign %std_add_18.right = %c1_i32 : i32
        calyx.assign %for_10_induction_var_reg.in = %std_add_18.out : i32
        calyx.assign %for_10_induction_var_reg.write_en = %true : i1
        calyx.group_done %for_10_induction_var_reg.done : i1
      }
      calyx.group @incr_for_11_induction_var {
        calyx.assign %std_add_19.left = %for_11_induction_var_reg.out : i32
        calyx.assign %std_add_19.right = %c1_i32 : i32
        calyx.assign %for_11_induction_var_reg.in = %std_add_19.out : i32
        calyx.assign %for_11_induction_var_reg.write_en = %true : i1
        calyx.group_done %for_11_induction_var_reg.done : i1
      }
    }
    calyx.control {
      calyx.seq {
        calyx.seq {
          calyx.par {
            calyx.enable @init_for_4_induction_var
          }
          calyx.repeat 48 {
            calyx.seq {
              calyx.seq {
                calyx.par {
                  calyx.enable @init_for_0_induction_var
                }
                calyx.repeat 48 {
                  calyx.seq {
                    calyx.enable @bb0_0
                    calyx.enable @incr_for_0_induction_var
                  }
                }
                calyx.par {
                  calyx.enable @init_for_2_induction_var
                }
                calyx.repeat 64 {
                  calyx.seq {
                    calyx.seq {
                      calyx.enable @bb0_3
                      calyx.enable @bb0_4
                      calyx.par {
                        calyx.enable @init_for_1_induction_var
                      }
                      calyx.repeat 48 {
                        calyx.seq {
                          calyx.seq {
                            calyx.enable @bb0_5
                            calyx.enable @bb0_8
                            calyx.enable @bb0_9
                            calyx.enable @bb0_10
                            calyx.enable @bb0_11
                            calyx.enable @bb0_12
                          }
                          calyx.enable @incr_for_1_induction_var
                        }
                      }
                    }
                    calyx.enable @incr_for_2_induction_var
                  }
                }
                calyx.par {
                  calyx.enable @init_for_3_induction_var
                }
                calyx.repeat 48 {
                  calyx.seq {
                    calyx.seq {
                      calyx.enable @bb0_13
                      calyx.enable @bb0_14
                      calyx.enable @bb0_15
                      calyx.enable @bb0_16
                      calyx.enable @bb0_18
                    }
                    calyx.enable @incr_for_3_induction_var
                  }
                }
              }
              calyx.enable @incr_for_4_induction_var
            }
          }
          calyx.par {
            calyx.enable @init_for_6_induction_var
          }
          calyx.repeat 48 {
            calyx.seq {
              calyx.par {
                calyx.enable @init_for_5_induction_var
              }
              calyx.repeat 48 {
                calyx.seq {
                  calyx.seq {
                    calyx.enable @bb0_19
                    calyx.enable @bb0_21
                    calyx.enable @bb0_22
                    calyx.enable @bb0_24
                    calyx.enable @bb0_26
                  }
                  calyx.enable @incr_for_5_induction_var
                }
              }
              calyx.enable @incr_for_6_induction_var
            }
          }
          calyx.par {
            calyx.enable @init_for_11_induction_var
          }
          calyx.repeat 48 {
            calyx.seq {
              calyx.seq {
                calyx.par {
                  calyx.enable @init_for_7_induction_var
                }
                calyx.repeat 4 {
                  calyx.seq {
                    calyx.enable @bb0_27
                    calyx.enable @incr_for_7_induction_var
                  }
                }
                calyx.par {
                  calyx.enable @init_for_9_induction_var
                }
                calyx.repeat 48 {
                  calyx.seq {
                    calyx.seq {
                      calyx.enable @bb0_28
                      calyx.enable @bb0_30
                      calyx.enable @bb0_31
                      calyx.par {
                        calyx.enable @init_for_8_induction_var
                      }
                      calyx.repeat 4 {
                        calyx.seq {
                          calyx.seq {
                            calyx.enable @bb0_32
                            calyx.enable @bb0_33
                            calyx.enable @bb0_35
                            calyx.enable @bb0_36
                            calyx.enable @bb0_37
                            calyx.enable @bb0_38
                            calyx.enable @bb0_39
                          }
                          calyx.enable @incr_for_8_induction_var
                        }
                      }
                    }
                    calyx.enable @incr_for_9_induction_var
                  }
                }
                calyx.par {
                  calyx.enable @init_for_10_induction_var
                }
                calyx.repeat 4 {
                  calyx.seq {
                    calyx.seq {
                      calyx.enable @bb0_40
                      calyx.enable @bb0_41
                      calyx.enable @bb0_42
                      calyx.enable @bb0_45
                    }
                    calyx.enable @incr_for_10_induction_var
                  }
                }
              }
              calyx.enable @incr_for_11_induction_var
            }
          }
        }
      }
    }
  }
}
