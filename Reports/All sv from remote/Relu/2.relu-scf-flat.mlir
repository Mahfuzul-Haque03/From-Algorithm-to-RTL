module {
  func.func @relu4d_0(%arg0: memref<300xf32>, %arg1: memref<300xf32>) attributes {itypes = "_", otypes = "_"} {
    %cst = arith.constant 0.000000e+00 : f32
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %c1_0 = arith.constant 1 : index
    scf.for %arg2 = %c0 to %c1 step %c1_0 {
      %c0_1 = arith.constant 0 : index
      %c3 = arith.constant 3 : index
      %c1_2 = arith.constant 1 : index
      scf.for %arg3 = %c0_1 to %c3 step %c1_2 {
        %c0_3 = arith.constant 0 : index
        %c10 = arith.constant 10 : index
        %c1_4 = arith.constant 1 : index
        scf.for %arg4 = %c0_3 to %c10 step %c1_4 {
          %c0_5 = arith.constant 0 : index
          %c10_6 = arith.constant 10 : index
          %c1_7 = arith.constant 1 : index
          scf.for %arg5 = %c0_5 to %c10_6 step %c1_7 {
            %c300 = arith.constant 300 : index
            %0 = arith.muli %arg2, %c300 : index
            %1 = arith.addi %0, %arg3 : index
            %c100 = arith.constant 100 : index
            %2 = arith.muli %1, %c100 : index
            %3 = arith.addi %2, %arg4 : index
            %c10_8 = arith.constant 10 : index
            %4 = arith.muli %3, %c10_8 : index
            %5 = arith.addi %4, %arg5 : index
            %6 = memref.load %arg0[%5] : memref<300xf32>
            %7 = arith.cmpf ugt, %6, %cst : f32
            %8 = arith.select %7, %6, %cst : f32
            %c300_9 = arith.constant 300 : index
            %9 = arith.muli %arg2, %c300_9 : index
            %10 = arith.addi %9, %arg3 : index
            %c100_10 = arith.constant 100 : index
            %11 = arith.muli %10, %c100_10 : index
            %12 = arith.addi %11, %arg4 : index
            %c10_11 = arith.constant 10 : index
            %13 = arith.muli %12, %c10_11 : index
            %14 = arith.addi %13, %arg5 : index
            memref.store %8, %arg1[%14] : memref<300xf32>
          }
        }
      }
    }
    return
  }
  func.func @forward(%arg0: memref<300xf32>, %arg1: memref<300xf32>, %arg2: memref<300xf32>) attributes {itypes = "__", otypes = "_"} {
    %c10 = arith.constant 10 : index
    %c3 = arith.constant 3 : index
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %alloc = memref.alloc() : memref<300xf32>
    scf.for %arg3 = %c0 to %c1 step %c1 {
      scf.for %arg4 = %c0 to %c3 step %c1 {
        scf.for %arg5 = %c0 to %c10 step %c1 {
          scf.for %arg6 = %c0 to %c10 step %c1 {
            %c300 = arith.constant 300 : index
            %0 = arith.muli %arg3, %c300 : index
            %1 = arith.addi %0, %arg4 : index
            %c100 = arith.constant 100 : index
            %2 = arith.muli %1, %c100 : index
            %3 = arith.addi %2, %arg5 : index
            %c10_0 = arith.constant 10 : index
            %4 = arith.muli %3, %c10_0 : index
            %5 = arith.addi %4, %arg6 : index
            %6 = memref.load %arg0[%5] : memref<300xf32>
            %c300_1 = arith.constant 300 : index
            %7 = arith.muli %arg3, %c300_1 : index
            %8 = arith.addi %7, %arg4 : index
            %c100_2 = arith.constant 100 : index
            %9 = arith.muli %8, %c100_2 : index
            %10 = arith.addi %9, %arg5 : index
            %c10_3 = arith.constant 10 : index
            %11 = arith.muli %10, %c10_3 : index
            %12 = arith.addi %11, %arg6 : index
            %13 = memref.load %arg1[%12] : memref<300xf32>
            %14 = arith.addf %6, %13 : f32
            %c300_4 = arith.constant 300 : index
            %15 = arith.muli %arg3, %c300_4 : index
            %16 = arith.addi %15, %arg4 : index
            %c100_5 = arith.constant 100 : index
            %17 = arith.muli %16, %c100_5 : index
            %18 = arith.addi %17, %arg5 : index
            %c10_6 = arith.constant 10 : index
            %19 = arith.muli %18, %c10_6 : index
            %20 = arith.addi %19, %arg6 : index
            memref.store %14, %alloc[%20] : memref<300xf32>
          }
        }
      }
    }
    call @relu4d_0(%alloc, %arg2) : (memref<300xf32>, memref<300xf32>) -> ()
    return
  }
}

