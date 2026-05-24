module {
  func.func @gelu(%arg0: memref<300xf32>, %arg1: memref<300xf32>) attributes {itypes = "_", otypes = "_"} {
    %cst = arith.constant 3.570000e-02 : f32
    %cst_0 = arith.constant 3.989000e-01 : f32
    %cst_1 = arith.constant 5.000000e-01 : f32
    %cst_2 = arith.constant 0.000000e+00 : f32
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %c3 = arith.constant 3 : index
    %c10 = arith.constant 10 : index
    scf.for %arg2 = %c0 to %c1 step %c1 {
      scf.for %arg3 = %c0 to %c3 step %c1 {
        scf.for %arg4 = %c0 to %c10 step %c1 {
          scf.for %arg5 = %c0 to %c10 step %c1 {
            %c300 = arith.constant 300 : index
            %0 = arith.muli %arg2, %c300 : index
            %1 = arith.addi %0, %arg3 : index
            %c100 = arith.constant 100 : index
            %2 = arith.muli %1, %c100 : index
            %3 = arith.addi %2, %arg4 : index
            %c10_6 = arith.constant 10 : index
            %4 = arith.muli %3, %c10_6 : index
            %5 = arith.addi %4, %arg5 : index
            memref.store %cst_2, %arg1[%5] : memref<300xf32>
          }
        }
      }
    }
    %c0_3 = arith.constant 0 : index
    %c1_4 = arith.constant 1 : index
    %c1_5 = arith.constant 1 : index
    scf.for %arg2 = %c0_3 to %c1_4 step %c1_5 {
      %c0_6 = arith.constant 0 : index
      %c3_7 = arith.constant 3 : index
      %c1_8 = arith.constant 1 : index
      scf.for %arg3 = %c0_6 to %c3_7 step %c1_8 {
        %c0_9 = arith.constant 0 : index
        %c10_10 = arith.constant 10 : index
        %c1_11 = arith.constant 1 : index
        scf.for %arg4 = %c0_9 to %c10_10 step %c1_11 {
          %c0_12 = arith.constant 0 : index
          %c10_13 = arith.constant 10 : index
          %c1_14 = arith.constant 1 : index
          scf.for %arg5 = %c0_12 to %c10_13 step %c1_14 {
            %c300 = arith.constant 300 : index
            %0 = arith.muli %arg2, %c300 : index
            %1 = arith.addi %0, %arg3 : index
            %c100 = arith.constant 100 : index
            %2 = arith.muli %1, %c100 : index
            %3 = arith.addi %2, %arg4 : index
            %c10_15 = arith.constant 10 : index
            %4 = arith.muli %3, %c10_15 : index
            %5 = arith.addi %4, %arg5 : index
            %6 = memref.load %arg0[%5] : memref<300xf32>
            %alloc = memref.alloc() : memref<1xf32>
            %c0_16 = arith.constant 0 : index
            memref.store %6, %alloc[%c0_16] : memref<1xf32>
            %c0_17 = arith.constant 0 : index
            %7 = memref.load %alloc[%c0_17] : memref<1xf32>
            %8 = arith.mulf %7, %7 : f32
            %alloc_18 = memref.alloc() : memref<1xf32>
            %c0_19 = arith.constant 0 : index
            memref.store %8, %alloc_18[%c0_19] : memref<1xf32>
            %c0_20 = arith.constant 0 : index
            %9 = memref.load %alloc_18[%c0_20] : memref<1xf32>
            %c0_21 = arith.constant 0 : index
            %10 = memref.load %alloc[%c0_21] : memref<1xf32>
            %11 = arith.mulf %9, %10 : f32
            %alloc_22 = memref.alloc() : memref<1xf32>
            %c0_23 = arith.constant 0 : index
            memref.store %11, %alloc_22[%c0_23] : memref<1xf32>
            %alloc_24 = memref.alloc() : memref<1xf32>
            %c0_25 = arith.constant 0 : index
            memref.store %cst_1, %alloc_24[%c0_25] : memref<1xf32>
            %alloc_26 = memref.alloc() : memref<1xf32>
            %c0_27 = arith.constant 0 : index
            memref.store %cst_0, %alloc_26[%c0_27] : memref<1xf32>
            %alloc_28 = memref.alloc() : memref<1xf32>
            %c0_29 = arith.constant 0 : index
            memref.store %cst, %alloc_28[%c0_29] : memref<1xf32>
            %c0_30 = arith.constant 0 : index
            %12 = memref.load %alloc_24[%c0_30] : memref<1xf32>
            %c0_31 = arith.constant 0 : index
            %13 = memref.load %alloc[%c0_31] : memref<1xf32>
            %14 = arith.mulf %12, %13 : f32
            %c0_32 = arith.constant 0 : index
            %15 = memref.load %alloc_26[%c0_32] : memref<1xf32>
            %c0_33 = arith.constant 0 : index
            %16 = memref.load %alloc_18[%c0_33] : memref<1xf32>
            %17 = arith.mulf %15, %16 : f32
            %18 = arith.addf %14, %17 : f32
            %c0_34 = arith.constant 0 : index
            %19 = memref.load %alloc_28[%c0_34] : memref<1xf32>
            %c0_35 = arith.constant 0 : index
            %20 = memref.load %alloc_22[%c0_35] : memref<1xf32>
            %21 = arith.mulf %19, %20 : f32
            %22 = arith.addf %18, %21 : f32
            %c300_36 = arith.constant 300 : index
            %23 = arith.muli %arg2, %c300_36 : index
            %24 = arith.addi %23, %arg3 : index
            %c100_37 = arith.constant 100 : index
            %25 = arith.muli %24, %c100_37 : index
            %26 = arith.addi %25, %arg4 : index
            %c10_38 = arith.constant 10 : index
            %27 = arith.muli %26, %c10_38 : index
            %28 = arith.addi %27, %arg5 : index
            memref.store %22, %arg1[%28] : memref<300xf32>
          }
        }
      }
    }
    return
  }
}

