module attributes {calyx.entrypoint = "main"} {
  calyx.component @main(%clk: i1 {clk}, %reset: i1 {reset}, %go: i1 {go}) -> (%done: i1 {done}) {
    %mem_3.addr0, %mem_3.clk, %mem_3.reset, %mem_3.content_en, %mem_3.write_en, %mem_3.write_data, %mem_3.read_data, %mem_3.done = calyx.seq_mem @mem_3 <[300] x 32> [9] {external = true} : i9, i1, i1, i1, i1, i32, i32, i1
    %mem_2.addr0, %mem_2.clk, %mem_2.reset, %mem_2.content_en, %mem_2.write_en, %mem_2.write_data, %mem_2.read_data, %mem_2.done = calyx.seq_mem @mem_2 <[300] x 32> [9] {external = true} : i9, i1, i1, i1, i1, i32, i32, i1
    %mem_1.addr0, %mem_1.clk, %mem_1.reset, %mem_1.content_en, %mem_1.write_en, %mem_1.write_data, %mem_1.read_data, %mem_1.done = calyx.seq_mem @mem_1 <[300] x 32> [9] {external = true} : i9, i1, i1, i1, i1, i32, i32, i1
    %mem_0.addr0, %mem_0.clk, %mem_0.reset, %mem_0.content_en, %mem_0.write_en, %mem_0.write_data, %mem_0.read_data, %mem_0.done = calyx.seq_mem @mem_0 <[300] x 32> [9] {external = true} : i9, i1, i1, i1, i1, i32, i32, i1
    %forward_instance.clk, %forward_instance.reset, %forward_instance.go, %forward_instance.done = calyx.instance @forward_instance of @forward : i1, i1, i1, i1
    calyx.wires {
    }
    calyx.control {
      calyx.seq {
        calyx.seq {
          calyx.invoke @forward_instance[arg_mem_0 = mem_0, arg_mem_1 = mem_1, arg_mem_2 = mem_2, arg_mem_3 = mem_3]() -> ()
        }
      }
    }
  } {toplevel}
  calyx.component @relu4d_0(%clk: i1 {clk}, %reset: i1 {reset}, %go: i1 {go}) -> (%done: i1 {done}) {
    %c1_i32 = hw.constant 1 : i32
    %true = hw.constant true
    %false = hw.constant false
    %c0_i32 = hw.constant 0 : i32
    %cst = calyx.constant @cst_0 <0.000000e+00 : f32> : i32
    %c10_i32 = hw.constant 10 : i32
    %c300_i32 = hw.constant 300 : i32
    %c100_i32 = hw.constant 100 : i32
    %std_slice_1.in, %std_slice_1.out = calyx.std_slice @std_slice_1 : i32, i9
    %std_slice_0.in, %std_slice_0.out = calyx.std_slice @std_slice_0 : i32, i9
    %std_add_9.left, %std_add_9.right, %std_add_9.out = calyx.std_add @std_add_9 : i32, i32, i32
    %std_add_8.left, %std_add_8.right, %std_add_8.out = calyx.std_add @std_add_8 : i32, i32, i32
    %std_add_7.left, %std_add_7.right, %std_add_7.out = calyx.std_add @std_add_7 : i32, i32, i32
    %std_add_6.left, %std_add_6.right, %std_add_6.out = calyx.std_add @std_add_6 : i32, i32, i32
    %std_add_5.left, %std_add_5.right, %std_add_5.out = calyx.std_add @std_add_5 : i32, i32, i32
    %muli_5_reg.in, %muli_5_reg.write_en, %muli_5_reg.clk, %muli_5_reg.reset, %muli_5_reg.out, %muli_5_reg.done = calyx.register @muli_5_reg : i32, i1, i1, i1, i32, i1
    %std_mult_pipe_5.clk, %std_mult_pipe_5.reset, %std_mult_pipe_5.go, %std_mult_pipe_5.left, %std_mult_pipe_5.right, %std_mult_pipe_5.out, %std_mult_pipe_5.done = calyx.std_mult_pipe @std_mult_pipe_5 : i1, i1, i1, i32, i32, i32, i1
    %std_add_4.left, %std_add_4.right, %std_add_4.out = calyx.std_add @std_add_4 : i32, i32, i32
    %muli_4_reg.in, %muli_4_reg.write_en, %muli_4_reg.clk, %muli_4_reg.reset, %muli_4_reg.out, %muli_4_reg.done = calyx.register @muli_4_reg : i32, i1, i1, i1, i32, i1
    %std_mult_pipe_4.clk, %std_mult_pipe_4.reset, %std_mult_pipe_4.go, %std_mult_pipe_4.left, %std_mult_pipe_4.right, %std_mult_pipe_4.out, %std_mult_pipe_4.done = calyx.std_mult_pipe @std_mult_pipe_4 : i1, i1, i1, i32, i32, i32, i1
    %std_add_3.left, %std_add_3.right, %std_add_3.out = calyx.std_add @std_add_3 : i32, i32, i32
    %muli_3_reg.in, %muli_3_reg.write_en, %muli_3_reg.clk, %muli_3_reg.reset, %muli_3_reg.out, %muli_3_reg.done = calyx.register @muli_3_reg : i32, i1, i1, i1, i32, i1
    %std_mult_pipe_3.clk, %std_mult_pipe_3.reset, %std_mult_pipe_3.go, %std_mult_pipe_3.left, %std_mult_pipe_3.right, %std_mult_pipe_3.out, %std_mult_pipe_3.done = calyx.std_mult_pipe @std_mult_pipe_3 : i1, i1, i1, i32, i32, i32, i1
    %std_mux_0.cond, %std_mux_0.tru, %std_mux_0.fal, %std_mux_0.out = calyx.std_mux @std_mux_0 : i1, i32, i32, i32
    %std_and_0.left, %std_and_0.right, %std_and_0.out = calyx.std_and @std_and_0 : i1, i1, i1
    %std_or_0.left, %std_or_0.right, %std_or_0.out = calyx.std_or @std_or_0 : i1, i1, i1
    %unordered_port_0_reg.in, %unordered_port_0_reg.write_en, %unordered_port_0_reg.clk, %unordered_port_0_reg.reset, %unordered_port_0_reg.out, %unordered_port_0_reg.done = calyx.register @unordered_port_0_reg : i1, i1, i1, i1, i1, i1
    %compare_port_0_reg.in, %compare_port_0_reg.write_en, %compare_port_0_reg.clk, %compare_port_0_reg.reset, %compare_port_0_reg.out, %compare_port_0_reg.done = calyx.register @compare_port_0_reg : i1, i1, i1, i1, i1, i1
    %cmpf_0_reg.in, %cmpf_0_reg.write_en, %cmpf_0_reg.clk, %cmpf_0_reg.reset, %cmpf_0_reg.out, %cmpf_0_reg.done = calyx.register @cmpf_0_reg : i1, i1, i1, i1, i1, i1
    %std_compareFN_0.clk, %std_compareFN_0.reset, %std_compareFN_0.go, %std_compareFN_0.left, %std_compareFN_0.right, %std_compareFN_0.signaling, %std_compareFN_0.lt, %std_compareFN_0.eq, %std_compareFN_0.gt, %std_compareFN_0.unordered, %std_compareFN_0.exceptionalFlags, %std_compareFN_0.done = calyx.ieee754.compare @std_compareFN_0 : i1, i1, i1, i32, i32, i1, i1, i1, i1, i1, i5, i1
    %std_add_2.left, %std_add_2.right, %std_add_2.out = calyx.std_add @std_add_2 : i32, i32, i32
    %muli_2_reg.in, %muli_2_reg.write_en, %muli_2_reg.clk, %muli_2_reg.reset, %muli_2_reg.out, %muli_2_reg.done = calyx.register @muli_2_reg : i32, i1, i1, i1, i32, i1
    %std_mult_pipe_2.clk, %std_mult_pipe_2.reset, %std_mult_pipe_2.go, %std_mult_pipe_2.left, %std_mult_pipe_2.right, %std_mult_pipe_2.out, %std_mult_pipe_2.done = calyx.std_mult_pipe @std_mult_pipe_2 : i1, i1, i1, i32, i32, i32, i1
    %std_add_1.left, %std_add_1.right, %std_add_1.out = calyx.std_add @std_add_1 : i32, i32, i32
    %muli_1_reg.in, %muli_1_reg.write_en, %muli_1_reg.clk, %muli_1_reg.reset, %muli_1_reg.out, %muli_1_reg.done = calyx.register @muli_1_reg : i32, i1, i1, i1, i32, i1
    %std_mult_pipe_1.clk, %std_mult_pipe_1.reset, %std_mult_pipe_1.go, %std_mult_pipe_1.left, %std_mult_pipe_1.right, %std_mult_pipe_1.out, %std_mult_pipe_1.done = calyx.std_mult_pipe @std_mult_pipe_1 : i1, i1, i1, i32, i32, i32, i1
    %std_add_0.left, %std_add_0.right, %std_add_0.out = calyx.std_add @std_add_0 : i32, i32, i32
    %muli_0_reg.in, %muli_0_reg.write_en, %muli_0_reg.clk, %muli_0_reg.reset, %muli_0_reg.out, %muli_0_reg.done = calyx.register @muli_0_reg : i32, i1, i1, i1, i32, i1
    %std_mult_pipe_0.clk, %std_mult_pipe_0.reset, %std_mult_pipe_0.go, %std_mult_pipe_0.left, %std_mult_pipe_0.right, %std_mult_pipe_0.out, %std_mult_pipe_0.done = calyx.std_mult_pipe @std_mult_pipe_0 : i1, i1, i1, i32, i32, i32, i1
    %for_3_induction_var_reg.in, %for_3_induction_var_reg.write_en, %for_3_induction_var_reg.clk, %for_3_induction_var_reg.reset, %for_3_induction_var_reg.out, %for_3_induction_var_reg.done = calyx.register @for_3_induction_var_reg : i32, i1, i1, i1, i32, i1
    %for_2_induction_var_reg.in, %for_2_induction_var_reg.write_en, %for_2_induction_var_reg.clk, %for_2_induction_var_reg.reset, %for_2_induction_var_reg.out, %for_2_induction_var_reg.done = calyx.register @for_2_induction_var_reg : i32, i1, i1, i1, i32, i1
    %for_1_induction_var_reg.in, %for_1_induction_var_reg.write_en, %for_1_induction_var_reg.clk, %for_1_induction_var_reg.reset, %for_1_induction_var_reg.out, %for_1_induction_var_reg.done = calyx.register @for_1_induction_var_reg : i32, i1, i1, i1, i32, i1
    %for_0_induction_var_reg.in, %for_0_induction_var_reg.write_en, %for_0_induction_var_reg.clk, %for_0_induction_var_reg.reset, %for_0_induction_var_reg.out, %for_0_induction_var_reg.done = calyx.register @for_0_induction_var_reg : i32, i1, i1, i1, i32, i1
    %arg_mem_1.addr0, %arg_mem_1.clk, %arg_mem_1.reset, %arg_mem_1.content_en, %arg_mem_1.write_en, %arg_mem_1.write_data, %arg_mem_1.read_data, %arg_mem_1.done = calyx.seq_mem @arg_mem_1 <[300] x 32> [9] : i9, i1, i1, i1, i1, i32, i32, i1
    %arg_mem_0.addr0, %arg_mem_0.clk, %arg_mem_0.reset, %arg_mem_0.content_en, %arg_mem_0.write_en, %arg_mem_0.write_data, %arg_mem_0.read_data, %arg_mem_0.done = calyx.seq_mem @arg_mem_0 <[300] x 32> [9] : i9, i1, i1, i1, i1, i32, i32, i1
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
      calyx.group @bb0_0 {
        calyx.assign %std_mult_pipe_0.left = %for_3_induction_var_reg.out : i32
        calyx.assign %std_mult_pipe_0.right = %c300_i32 : i32
        calyx.assign %muli_0_reg.in = %std_mult_pipe_0.out : i32
        calyx.assign %muli_0_reg.write_en = %std_mult_pipe_0.done : i1
        %0 = comb.xor %std_mult_pipe_0.done, %true : i1
        calyx.assign %std_mult_pipe_0.go = %0 ? %true : i1
        calyx.group_done %muli_0_reg.done : i1
      }
      calyx.group @bb0_2 {
        calyx.assign %std_mult_pipe_1.left = %std_add_0.out : i32
        calyx.assign %std_mult_pipe_1.right = %c100_i32 : i32
        calyx.assign %muli_1_reg.in = %std_mult_pipe_1.out : i32
        calyx.assign %muli_1_reg.write_en = %std_mult_pipe_1.done : i1
        %0 = comb.xor %std_mult_pipe_1.done, %true : i1
        calyx.assign %std_mult_pipe_1.go = %0 ? %true : i1
        calyx.assign %std_add_0.left = %muli_0_reg.out : i32
        calyx.assign %std_add_0.right = %for_2_induction_var_reg.out : i32
        calyx.group_done %muli_1_reg.done : i1
      }
      calyx.group @bb0_4 {
        calyx.assign %std_mult_pipe_2.left = %std_add_1.out : i32
        calyx.assign %std_mult_pipe_2.right = %c10_i32 : i32
        calyx.assign %muli_2_reg.in = %std_mult_pipe_2.out : i32
        calyx.assign %muli_2_reg.write_en = %std_mult_pipe_2.done : i1
        %0 = comb.xor %std_mult_pipe_2.done, %true : i1
        calyx.assign %std_mult_pipe_2.go = %0 ? %true : i1
        calyx.assign %std_add_1.left = %muli_1_reg.out : i32
        calyx.assign %std_add_1.right = %for_1_induction_var_reg.out : i32
        calyx.group_done %muli_2_reg.done : i1
      }
      calyx.group @bb0_6 {
        calyx.assign %std_slice_1.in = %std_add_2.out : i32
        calyx.assign %arg_mem_0.addr0 = %std_slice_1.out : i9
        calyx.assign %arg_mem_0.content_en = %true : i1
        calyx.assign %arg_mem_0.write_en = %false : i1
        calyx.assign %std_add_2.left = %muli_2_reg.out : i32
        calyx.assign %std_add_2.right = %for_0_induction_var_reg.out : i32
        calyx.group_done %arg_mem_0.done : i1
      }
      calyx.group @bb0_7 {
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
      calyx.group @bb0_9 {
        calyx.assign %std_mult_pipe_3.left = %for_3_induction_var_reg.out : i32
        calyx.assign %std_mult_pipe_3.right = %c300_i32 : i32
        calyx.assign %muli_3_reg.in = %std_mult_pipe_3.out : i32
        calyx.assign %muli_3_reg.write_en = %std_mult_pipe_3.done : i1
        %0 = comb.xor %std_mult_pipe_3.done, %true : i1
        calyx.assign %std_mult_pipe_3.go = %0 ? %true : i1
        calyx.group_done %muli_3_reg.done : i1
      }
      calyx.group @bb0_11 {
        calyx.assign %std_mult_pipe_4.left = %std_add_3.out : i32
        calyx.assign %std_mult_pipe_4.right = %c100_i32 : i32
        calyx.assign %muli_4_reg.in = %std_mult_pipe_4.out : i32
        calyx.assign %muli_4_reg.write_en = %std_mult_pipe_4.done : i1
        %0 = comb.xor %std_mult_pipe_4.done, %true : i1
        calyx.assign %std_mult_pipe_4.go = %0 ? %true : i1
        calyx.assign %std_add_3.left = %muli_3_reg.out : i32
        calyx.assign %std_add_3.right = %for_2_induction_var_reg.out : i32
        calyx.group_done %muli_4_reg.done : i1
      }
      calyx.group @bb0_13 {
        calyx.assign %std_mult_pipe_5.left = %std_add_4.out : i32
        calyx.assign %std_mult_pipe_5.right = %c10_i32 : i32
        calyx.assign %muli_5_reg.in = %std_mult_pipe_5.out : i32
        calyx.assign %muli_5_reg.write_en = %std_mult_pipe_5.done : i1
        %0 = comb.xor %std_mult_pipe_5.done, %true : i1
        calyx.assign %std_mult_pipe_5.go = %0 ? %true : i1
        calyx.assign %std_add_4.left = %muli_4_reg.out : i32
        calyx.assign %std_add_4.right = %for_1_induction_var_reg.out : i32
        calyx.group_done %muli_5_reg.done : i1
      }
      calyx.group @bb0_15 {
        calyx.assign %std_slice_0.in = %std_add_5.out : i32
        calyx.assign %arg_mem_1.addr0 = %std_slice_0.out : i9
        calyx.assign %arg_mem_1.write_data = %std_mux_0.out : i32
        calyx.assign %arg_mem_1.write_en = %true : i1
        calyx.assign %arg_mem_1.content_en = %true : i1
        calyx.assign %std_add_5.left = %muli_5_reg.out : i32
        calyx.assign %std_add_5.right = %for_0_induction_var_reg.out : i32
        calyx.assign %std_mux_0.cond = %cmpf_0_reg.out : i1
        calyx.assign %std_mux_0.tru = %arg_mem_0.read_data : i32
        calyx.assign %std_mux_0.fal = %cst : i32
        calyx.group_done %arg_mem_1.done : i1
      }
      calyx.group @incr_for_0_induction_var {
        calyx.assign %std_add_6.left = %for_0_induction_var_reg.out : i32
        calyx.assign %std_add_6.right = %c1_i32 : i32
        calyx.assign %for_0_induction_var_reg.in = %std_add_6.out : i32
        calyx.assign %for_0_induction_var_reg.write_en = %true : i1
        calyx.group_done %for_0_induction_var_reg.done : i1
      }
      calyx.group @incr_for_1_induction_var {
        calyx.assign %std_add_7.left = %for_1_induction_var_reg.out : i32
        calyx.assign %std_add_7.right = %c1_i32 : i32
        calyx.assign %for_1_induction_var_reg.in = %std_add_7.out : i32
        calyx.assign %for_1_induction_var_reg.write_en = %true : i1
        calyx.group_done %for_1_induction_var_reg.done : i1
      }
      calyx.group @incr_for_2_induction_var {
        calyx.assign %std_add_8.left = %for_2_induction_var_reg.out : i32
        calyx.assign %std_add_8.right = %c1_i32 : i32
        calyx.assign %for_2_induction_var_reg.in = %std_add_8.out : i32
        calyx.assign %for_2_induction_var_reg.write_en = %true : i1
        calyx.group_done %for_2_induction_var_reg.done : i1
      }
      calyx.group @incr_for_3_induction_var {
        calyx.assign %std_add_9.left = %for_3_induction_var_reg.out : i32
        calyx.assign %std_add_9.right = %c1_i32 : i32
        calyx.assign %for_3_induction_var_reg.in = %std_add_9.out : i32
        calyx.assign %for_3_induction_var_reg.write_en = %true : i1
        calyx.group_done %for_3_induction_var_reg.done : i1
      }
    }
    calyx.control {
      calyx.seq {
        calyx.par {
          calyx.enable @init_for_3_induction_var
        }
        calyx.repeat 1 {
          calyx.seq {
            calyx.par {
              calyx.enable @init_for_2_induction_var
            }
            calyx.repeat 3 {
              calyx.seq {
                calyx.par {
                  calyx.enable @init_for_1_induction_var
                }
                calyx.repeat 10 {
                  calyx.seq {
                    calyx.par {
                      calyx.enable @init_for_0_induction_var
                    }
                    calyx.repeat 10 {
                      calyx.seq {
                        calyx.seq {
                          calyx.enable @bb0_0
                          calyx.enable @bb0_2
                          calyx.enable @bb0_4
                          calyx.enable @bb0_6
                          calyx.enable @bb0_7
                          calyx.enable @bb0_9
                          calyx.enable @bb0_11
                          calyx.enable @bb0_13
                          calyx.enable @bb0_15
                        }
                        calyx.enable @incr_for_0_induction_var
                      }
                    }
                    calyx.enable @incr_for_1_induction_var
                  }
                }
                calyx.enable @incr_for_2_induction_var
              }
            }
            calyx.enable @incr_for_3_induction_var
          }
        }
      }
    }
  }
  calyx.component @forward(%clk: i1 {clk}, %reset: i1 {reset}, %go: i1 {go}) -> (%done: i1 {done}) {
    %c1_i32 = hw.constant 1 : i32
    %true = hw.constant true
    %false = hw.constant false
    %c0_i32 = hw.constant 0 : i32
    %c10_i32 = hw.constant 10 : i32
    %c300_i32 = hw.constant 300 : i32
    %c100_i32 = hw.constant 100 : i32
    %std_slice_2.in, %std_slice_2.out = calyx.std_slice @std_slice_2 : i32, i9
    %std_slice_1.in, %std_slice_1.out = calyx.std_slice @std_slice_1 : i32, i9
    %std_slice_0.in, %std_slice_0.out = calyx.std_slice @std_slice_0 : i32, i9
    %std_add_12.left, %std_add_12.right, %std_add_12.out = calyx.std_add @std_add_12 : i32, i32, i32
    %std_add_11.left, %std_add_11.right, %std_add_11.out = calyx.std_add @std_add_11 : i32, i32, i32
    %std_add_10.left, %std_add_10.right, %std_add_10.out = calyx.std_add @std_add_10 : i32, i32, i32
    %std_add_9.left, %std_add_9.right, %std_add_9.out = calyx.std_add @std_add_9 : i32, i32, i32
    %std_add_8.left, %std_add_8.right, %std_add_8.out = calyx.std_add @std_add_8 : i32, i32, i32
    %muli_8_reg.in, %muli_8_reg.write_en, %muli_8_reg.clk, %muli_8_reg.reset, %muli_8_reg.out, %muli_8_reg.done = calyx.register @muli_8_reg : i32, i1, i1, i1, i32, i1
    %std_mult_pipe_8.clk, %std_mult_pipe_8.reset, %std_mult_pipe_8.go, %std_mult_pipe_8.left, %std_mult_pipe_8.right, %std_mult_pipe_8.out, %std_mult_pipe_8.done = calyx.std_mult_pipe @std_mult_pipe_8 : i1, i1, i1, i32, i32, i32, i1
    %std_add_7.left, %std_add_7.right, %std_add_7.out = calyx.std_add @std_add_7 : i32, i32, i32
    %muli_7_reg.in, %muli_7_reg.write_en, %muli_7_reg.clk, %muli_7_reg.reset, %muli_7_reg.out, %muli_7_reg.done = calyx.register @muli_7_reg : i32, i1, i1, i1, i32, i1
    %std_mult_pipe_7.clk, %std_mult_pipe_7.reset, %std_mult_pipe_7.go, %std_mult_pipe_7.left, %std_mult_pipe_7.right, %std_mult_pipe_7.out, %std_mult_pipe_7.done = calyx.std_mult_pipe @std_mult_pipe_7 : i1, i1, i1, i32, i32, i32, i1
    %std_add_6.left, %std_add_6.right, %std_add_6.out = calyx.std_add @std_add_6 : i32, i32, i32
    %muli_6_reg.in, %muli_6_reg.write_en, %muli_6_reg.clk, %muli_6_reg.reset, %muli_6_reg.out, %muli_6_reg.done = calyx.register @muli_6_reg : i32, i1, i1, i1, i32, i1
    %std_mult_pipe_6.clk, %std_mult_pipe_6.reset, %std_mult_pipe_6.go, %std_mult_pipe_6.left, %std_mult_pipe_6.right, %std_mult_pipe_6.out, %std_mult_pipe_6.done = calyx.std_mult_pipe @std_mult_pipe_6 : i1, i1, i1, i32, i32, i32, i1
    %addf_0_reg.in, %addf_0_reg.write_en, %addf_0_reg.clk, %addf_0_reg.reset, %addf_0_reg.out, %addf_0_reg.done = calyx.register @addf_0_reg : i32, i1, i1, i1, i32, i1
    %std_addFN_0.clk, %std_addFN_0.reset, %std_addFN_0.go, %std_addFN_0.control, %std_addFN_0.subOp, %std_addFN_0.left, %std_addFN_0.right, %std_addFN_0.roundingMode, %std_addFN_0.out, %std_addFN_0.exceptionalFlags, %std_addFN_0.done = calyx.ieee754.add @std_addFN_0 : i1, i1, i1, i1, i1, i32, i32, i3, i32, i5, i1
    %std_add_5.left, %std_add_5.right, %std_add_5.out = calyx.std_add @std_add_5 : i32, i32, i32
    %muli_5_reg.in, %muli_5_reg.write_en, %muli_5_reg.clk, %muli_5_reg.reset, %muli_5_reg.out, %muli_5_reg.done = calyx.register @muli_5_reg : i32, i1, i1, i1, i32, i1
    %std_mult_pipe_5.clk, %std_mult_pipe_5.reset, %std_mult_pipe_5.go, %std_mult_pipe_5.left, %std_mult_pipe_5.right, %std_mult_pipe_5.out, %std_mult_pipe_5.done = calyx.std_mult_pipe @std_mult_pipe_5 : i1, i1, i1, i32, i32, i32, i1
    %std_add_4.left, %std_add_4.right, %std_add_4.out = calyx.std_add @std_add_4 : i32, i32, i32
    %muli_4_reg.in, %muli_4_reg.write_en, %muli_4_reg.clk, %muli_4_reg.reset, %muli_4_reg.out, %muli_4_reg.done = calyx.register @muli_4_reg : i32, i1, i1, i1, i32, i1
    %std_mult_pipe_4.clk, %std_mult_pipe_4.reset, %std_mult_pipe_4.go, %std_mult_pipe_4.left, %std_mult_pipe_4.right, %std_mult_pipe_4.out, %std_mult_pipe_4.done = calyx.std_mult_pipe @std_mult_pipe_4 : i1, i1, i1, i32, i32, i32, i1
    %std_add_3.left, %std_add_3.right, %std_add_3.out = calyx.std_add @std_add_3 : i32, i32, i32
    %muli_3_reg.in, %muli_3_reg.write_en, %muli_3_reg.clk, %muli_3_reg.reset, %muli_3_reg.out, %muli_3_reg.done = calyx.register @muli_3_reg : i32, i1, i1, i1, i32, i1
    %std_mult_pipe_3.clk, %std_mult_pipe_3.reset, %std_mult_pipe_3.go, %std_mult_pipe_3.left, %std_mult_pipe_3.right, %std_mult_pipe_3.out, %std_mult_pipe_3.done = calyx.std_mult_pipe @std_mult_pipe_3 : i1, i1, i1, i32, i32, i32, i1
    %std_add_2.left, %std_add_2.right, %std_add_2.out = calyx.std_add @std_add_2 : i32, i32, i32
    %muli_2_reg.in, %muli_2_reg.write_en, %muli_2_reg.clk, %muli_2_reg.reset, %muli_2_reg.out, %muli_2_reg.done = calyx.register @muli_2_reg : i32, i1, i1, i1, i32, i1
    %std_mult_pipe_2.clk, %std_mult_pipe_2.reset, %std_mult_pipe_2.go, %std_mult_pipe_2.left, %std_mult_pipe_2.right, %std_mult_pipe_2.out, %std_mult_pipe_2.done = calyx.std_mult_pipe @std_mult_pipe_2 : i1, i1, i1, i32, i32, i32, i1
    %std_add_1.left, %std_add_1.right, %std_add_1.out = calyx.std_add @std_add_1 : i32, i32, i32
    %muli_1_reg.in, %muli_1_reg.write_en, %muli_1_reg.clk, %muli_1_reg.reset, %muli_1_reg.out, %muli_1_reg.done = calyx.register @muli_1_reg : i32, i1, i1, i1, i32, i1
    %std_mult_pipe_1.clk, %std_mult_pipe_1.reset, %std_mult_pipe_1.go, %std_mult_pipe_1.left, %std_mult_pipe_1.right, %std_mult_pipe_1.out, %std_mult_pipe_1.done = calyx.std_mult_pipe @std_mult_pipe_1 : i1, i1, i1, i32, i32, i32, i1
    %std_add_0.left, %std_add_0.right, %std_add_0.out = calyx.std_add @std_add_0 : i32, i32, i32
    %muli_0_reg.in, %muli_0_reg.write_en, %muli_0_reg.clk, %muli_0_reg.reset, %muli_0_reg.out, %muli_0_reg.done = calyx.register @muli_0_reg : i32, i1, i1, i1, i32, i1
    %std_mult_pipe_0.clk, %std_mult_pipe_0.reset, %std_mult_pipe_0.go, %std_mult_pipe_0.left, %std_mult_pipe_0.right, %std_mult_pipe_0.out, %std_mult_pipe_0.done = calyx.std_mult_pipe @std_mult_pipe_0 : i1, i1, i1, i32, i32, i32, i1
    %for_3_induction_var_reg.in, %for_3_induction_var_reg.write_en, %for_3_induction_var_reg.clk, %for_3_induction_var_reg.reset, %for_3_induction_var_reg.out, %for_3_induction_var_reg.done = calyx.register @for_3_induction_var_reg : i32, i1, i1, i1, i32, i1
    %for_2_induction_var_reg.in, %for_2_induction_var_reg.write_en, %for_2_induction_var_reg.clk, %for_2_induction_var_reg.reset, %for_2_induction_var_reg.out, %for_2_induction_var_reg.done = calyx.register @for_2_induction_var_reg : i32, i1, i1, i1, i32, i1
    %for_1_induction_var_reg.in, %for_1_induction_var_reg.write_en, %for_1_induction_var_reg.clk, %for_1_induction_var_reg.reset, %for_1_induction_var_reg.out, %for_1_induction_var_reg.done = calyx.register @for_1_induction_var_reg : i32, i1, i1, i1, i32, i1
    %for_0_induction_var_reg.in, %for_0_induction_var_reg.write_en, %for_0_induction_var_reg.clk, %for_0_induction_var_reg.reset, %for_0_induction_var_reg.out, %for_0_induction_var_reg.done = calyx.register @for_0_induction_var_reg : i32, i1, i1, i1, i32, i1
    %relu4d_0_instance.clk, %relu4d_0_instance.reset, %relu4d_0_instance.go, %relu4d_0_instance.done = calyx.instance @relu4d_0_instance of @relu4d_0 : i1, i1, i1, i1
    %arg_mem_3.addr0, %arg_mem_3.clk, %arg_mem_3.reset, %arg_mem_3.content_en, %arg_mem_3.write_en, %arg_mem_3.write_data, %arg_mem_3.read_data, %arg_mem_3.done = calyx.seq_mem @arg_mem_3 <[300] x 32> [9] : i9, i1, i1, i1, i1, i32, i32, i1
    %arg_mem_2.addr0, %arg_mem_2.clk, %arg_mem_2.reset, %arg_mem_2.content_en, %arg_mem_2.write_en, %arg_mem_2.write_data, %arg_mem_2.read_data, %arg_mem_2.done = calyx.seq_mem @arg_mem_2 <[300] x 32> [9] : i9, i1, i1, i1, i1, i32, i32, i1
    %arg_mem_1.addr0, %arg_mem_1.clk, %arg_mem_1.reset, %arg_mem_1.content_en, %arg_mem_1.write_en, %arg_mem_1.write_data, %arg_mem_1.read_data, %arg_mem_1.done = calyx.seq_mem @arg_mem_1 <[300] x 32> [9] : i9, i1, i1, i1, i1, i32, i32, i1
    %arg_mem_0.addr0, %arg_mem_0.clk, %arg_mem_0.reset, %arg_mem_0.content_en, %arg_mem_0.write_en, %arg_mem_0.write_data, %arg_mem_0.read_data, %arg_mem_0.done = calyx.seq_mem @arg_mem_0 <[300] x 32> [9] : i9, i1, i1, i1, i1, i32, i32, i1
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
      calyx.group @bb0_0 {
        calyx.assign %std_mult_pipe_0.left = %for_3_induction_var_reg.out : i32
        calyx.assign %std_mult_pipe_0.right = %c300_i32 : i32
        calyx.assign %muli_0_reg.in = %std_mult_pipe_0.out : i32
        calyx.assign %muli_0_reg.write_en = %std_mult_pipe_0.done : i1
        %0 = comb.xor %std_mult_pipe_0.done, %true : i1
        calyx.assign %std_mult_pipe_0.go = %0 ? %true : i1
        calyx.group_done %muli_0_reg.done : i1
      }
      calyx.group @bb0_2 {
        calyx.assign %std_mult_pipe_1.left = %std_add_0.out : i32
        calyx.assign %std_mult_pipe_1.right = %c100_i32 : i32
        calyx.assign %muli_1_reg.in = %std_mult_pipe_1.out : i32
        calyx.assign %muli_1_reg.write_en = %std_mult_pipe_1.done : i1
        %0 = comb.xor %std_mult_pipe_1.done, %true : i1
        calyx.assign %std_mult_pipe_1.go = %0 ? %true : i1
        calyx.assign %std_add_0.left = %muli_0_reg.out : i32
        calyx.assign %std_add_0.right = %for_2_induction_var_reg.out : i32
        calyx.group_done %muli_1_reg.done : i1
      }
      calyx.group @bb0_4 {
        calyx.assign %std_mult_pipe_2.left = %std_add_1.out : i32
        calyx.assign %std_mult_pipe_2.right = %c10_i32 : i32
        calyx.assign %muli_2_reg.in = %std_mult_pipe_2.out : i32
        calyx.assign %muli_2_reg.write_en = %std_mult_pipe_2.done : i1
        %0 = comb.xor %std_mult_pipe_2.done, %true : i1
        calyx.assign %std_mult_pipe_2.go = %0 ? %true : i1
        calyx.assign %std_add_1.left = %muli_1_reg.out : i32
        calyx.assign %std_add_1.right = %for_1_induction_var_reg.out : i32
        calyx.group_done %muli_2_reg.done : i1
      }
      calyx.group @bb0_6 {
        calyx.assign %std_slice_2.in = %std_add_2.out : i32
        calyx.assign %arg_mem_0.addr0 = %std_slice_2.out : i9
        calyx.assign %arg_mem_0.content_en = %true : i1
        calyx.assign %arg_mem_0.write_en = %false : i1
        calyx.assign %std_add_2.left = %muli_2_reg.out : i32
        calyx.assign %std_add_2.right = %for_0_induction_var_reg.out : i32
        calyx.group_done %arg_mem_0.done : i1
      }
      calyx.group @bb0_7 {
        calyx.assign %std_mult_pipe_3.left = %for_3_induction_var_reg.out : i32
        calyx.assign %std_mult_pipe_3.right = %c300_i32 : i32
        calyx.assign %muli_3_reg.in = %std_mult_pipe_3.out : i32
        calyx.assign %muli_3_reg.write_en = %std_mult_pipe_3.done : i1
        %0 = comb.xor %std_mult_pipe_3.done, %true : i1
        calyx.assign %std_mult_pipe_3.go = %0 ? %true : i1
        calyx.group_done %muli_3_reg.done : i1
      }
      calyx.group @bb0_9 {
        calyx.assign %std_mult_pipe_4.left = %std_add_3.out : i32
        calyx.assign %std_mult_pipe_4.right = %c100_i32 : i32
        calyx.assign %muli_4_reg.in = %std_mult_pipe_4.out : i32
        calyx.assign %muli_4_reg.write_en = %std_mult_pipe_4.done : i1
        %0 = comb.xor %std_mult_pipe_4.done, %true : i1
        calyx.assign %std_mult_pipe_4.go = %0 ? %true : i1
        calyx.assign %std_add_3.left = %muli_3_reg.out : i32
        calyx.assign %std_add_3.right = %for_2_induction_var_reg.out : i32
        calyx.group_done %muli_4_reg.done : i1
      }
      calyx.group @bb0_11 {
        calyx.assign %std_mult_pipe_5.left = %std_add_4.out : i32
        calyx.assign %std_mult_pipe_5.right = %c10_i32 : i32
        calyx.assign %muli_5_reg.in = %std_mult_pipe_5.out : i32
        calyx.assign %muli_5_reg.write_en = %std_mult_pipe_5.done : i1
        %0 = comb.xor %std_mult_pipe_5.done, %true : i1
        calyx.assign %std_mult_pipe_5.go = %0 ? %true : i1
        calyx.assign %std_add_4.left = %muli_4_reg.out : i32
        calyx.assign %std_add_4.right = %for_1_induction_var_reg.out : i32
        calyx.group_done %muli_5_reg.done : i1
      }
      calyx.group @bb0_13 {
        calyx.assign %std_slice_1.in = %std_add_5.out : i32
        calyx.assign %arg_mem_1.addr0 = %std_slice_1.out : i9
        calyx.assign %arg_mem_1.content_en = %true : i1
        calyx.assign %arg_mem_1.write_en = %false : i1
        calyx.assign %std_add_5.left = %muli_5_reg.out : i32
        calyx.assign %std_add_5.right = %for_0_induction_var_reg.out : i32
        calyx.group_done %arg_mem_1.done : i1
      }
      calyx.group @bb0_14 {
        calyx.assign %std_addFN_0.left = %arg_mem_0.read_data : i32
        calyx.assign %std_addFN_0.right = %arg_mem_1.read_data : i32
        calyx.assign %addf_0_reg.in = %std_addFN_0.out : i32
        calyx.assign %addf_0_reg.write_en = %std_addFN_0.done : i1
        %0 = comb.xor %std_addFN_0.done, %true : i1
        calyx.assign %std_addFN_0.go = %0 ? %true : i1
        calyx.assign %std_addFN_0.subOp = %false : i1
        calyx.group_done %addf_0_reg.done : i1
      }
      calyx.group @bb0_15 {
        calyx.assign %std_mult_pipe_6.left = %for_3_induction_var_reg.out : i32
        calyx.assign %std_mult_pipe_6.right = %c300_i32 : i32
        calyx.assign %muli_6_reg.in = %std_mult_pipe_6.out : i32
        calyx.assign %muli_6_reg.write_en = %std_mult_pipe_6.done : i1
        %0 = comb.xor %std_mult_pipe_6.done, %true : i1
        calyx.assign %std_mult_pipe_6.go = %0 ? %true : i1
        calyx.group_done %muli_6_reg.done : i1
      }
      calyx.group @bb0_17 {
        calyx.assign %std_mult_pipe_7.left = %std_add_6.out : i32
        calyx.assign %std_mult_pipe_7.right = %c100_i32 : i32
        calyx.assign %muli_7_reg.in = %std_mult_pipe_7.out : i32
        calyx.assign %muli_7_reg.write_en = %std_mult_pipe_7.done : i1
        %0 = comb.xor %std_mult_pipe_7.done, %true : i1
        calyx.assign %std_mult_pipe_7.go = %0 ? %true : i1
        calyx.assign %std_add_6.left = %muli_6_reg.out : i32
        calyx.assign %std_add_6.right = %for_2_induction_var_reg.out : i32
        calyx.group_done %muli_7_reg.done : i1
      }
      calyx.group @bb0_19 {
        calyx.assign %std_mult_pipe_8.left = %std_add_7.out : i32
        calyx.assign %std_mult_pipe_8.right = %c10_i32 : i32
        calyx.assign %muli_8_reg.in = %std_mult_pipe_8.out : i32
        calyx.assign %muli_8_reg.write_en = %std_mult_pipe_8.done : i1
        %0 = comb.xor %std_mult_pipe_8.done, %true : i1
        calyx.assign %std_mult_pipe_8.go = %0 ? %true : i1
        calyx.assign %std_add_7.left = %muli_7_reg.out : i32
        calyx.assign %std_add_7.right = %for_1_induction_var_reg.out : i32
        calyx.group_done %muli_8_reg.done : i1
      }
      calyx.group @bb0_21 {
        calyx.assign %std_slice_0.in = %std_add_8.out : i32
        calyx.assign %arg_mem_3.addr0 = %std_slice_0.out : i9
        calyx.assign %arg_mem_3.write_data = %addf_0_reg.out : i32
        calyx.assign %arg_mem_3.write_en = %true : i1
        calyx.assign %arg_mem_3.content_en = %true : i1
        calyx.assign %std_add_8.left = %muli_8_reg.out : i32
        calyx.assign %std_add_8.right = %for_0_induction_var_reg.out : i32
        calyx.group_done %arg_mem_3.done : i1
      }
      calyx.group @incr_for_0_induction_var {
        calyx.assign %std_add_9.left = %for_0_induction_var_reg.out : i32
        calyx.assign %std_add_9.right = %c1_i32 : i32
        calyx.assign %for_0_induction_var_reg.in = %std_add_9.out : i32
        calyx.assign %for_0_induction_var_reg.write_en = %true : i1
        calyx.group_done %for_0_induction_var_reg.done : i1
      }
      calyx.group @incr_for_1_induction_var {
        calyx.assign %std_add_10.left = %for_1_induction_var_reg.out : i32
        calyx.assign %std_add_10.right = %c1_i32 : i32
        calyx.assign %for_1_induction_var_reg.in = %std_add_10.out : i32
        calyx.assign %for_1_induction_var_reg.write_en = %true : i1
        calyx.group_done %for_1_induction_var_reg.done : i1
      }
      calyx.group @incr_for_2_induction_var {
        calyx.assign %std_add_11.left = %for_2_induction_var_reg.out : i32
        calyx.assign %std_add_11.right = %c1_i32 : i32
        calyx.assign %for_2_induction_var_reg.in = %std_add_11.out : i32
        calyx.assign %for_2_induction_var_reg.write_en = %true : i1
        calyx.group_done %for_2_induction_var_reg.done : i1
      }
      calyx.group @incr_for_3_induction_var {
        calyx.assign %std_add_12.left = %for_3_induction_var_reg.out : i32
        calyx.assign %std_add_12.right = %c1_i32 : i32
        calyx.assign %for_3_induction_var_reg.in = %std_add_12.out : i32
        calyx.assign %for_3_induction_var_reg.write_en = %true : i1
        calyx.group_done %for_3_induction_var_reg.done : i1
      }
    }
    calyx.control {
      calyx.seq {
        calyx.seq {
          calyx.par {
            calyx.enable @init_for_3_induction_var
          }
          calyx.repeat 1 {
            calyx.seq {
              calyx.par {
                calyx.enable @init_for_2_induction_var
              }
              calyx.repeat 3 {
                calyx.seq {
                  calyx.par {
                    calyx.enable @init_for_1_induction_var
                  }
                  calyx.repeat 10 {
                    calyx.seq {
                      calyx.par {
                        calyx.enable @init_for_0_induction_var
                      }
                      calyx.repeat 10 {
                        calyx.seq {
                          calyx.seq {
                            calyx.enable @bb0_0
                            calyx.enable @bb0_2
                            calyx.enable @bb0_4
                            calyx.enable @bb0_6
                            calyx.enable @bb0_7
                            calyx.enable @bb0_9
                            calyx.enable @bb0_11
                            calyx.enable @bb0_13
                            calyx.enable @bb0_14
                            calyx.enable @bb0_15
                            calyx.enable @bb0_17
                            calyx.enable @bb0_19
                            calyx.enable @bb0_21
                          }
                          calyx.enable @incr_for_0_induction_var
                        }
                      }
                      calyx.enable @incr_for_1_induction_var
                    }
                  }
                  calyx.enable @incr_for_2_induction_var
                }
              }
              calyx.enable @incr_for_3_induction_var
            }
          }
          calyx.seq {
            calyx.invoke @relu4d_0_instance[arg_mem_0 = arg_mem_3, arg_mem_1 = arg_mem_2]() -> ()
          }
        }
      }
    }
  }
}
