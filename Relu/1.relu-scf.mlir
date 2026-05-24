module {
  func.func @relu4d_0(%arg0: memref<1x3x10x10xf32>, %arg1: memref<1x3x10x10xf32>) attributes {itypes = "_", otypes = "_"} {
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
            %0 = memref.load %arg0[%arg2, %arg3, %arg4, %arg5] : memref<1x3x10x10xf32>
            %1 = arith.cmpf ugt, %0, %cst : f32
            %2 = arith.select %1, %0, %cst : f32
            memref.store %2, %arg1[%arg2, %arg3, %arg4, %arg5] : memref<1x3x10x10xf32>
          }
        }
      }
    }
    return
  }
  func.func @forward(%arg0: memref<1x3x10x10xf32>, %arg1: memref<1x3x10x10xf32>, %arg2: memref<1x3x10x10xf32>) attributes {itypes = "__", otypes = "_"} {
    %c10 = arith.constant 10 : index
    %c3 = arith.constant 3 : index
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %alloc = memref.alloc() {name = "add"} : memref<1x3x10x10xf32>
    scf.for %arg3 = %c0 to %c1 step %c1 {
      scf.for %arg4 = %c0 to %c3 step %c1 {
        scf.for %arg5 = %c0 to %c10 step %c1 {
          scf.for %arg6 = %c0 to %c10 step %c1 {
            %0 = memref.load %arg0[%arg3, %arg4, %arg5, %arg6] : memref<1x3x10x10xf32>
            %1 = memref.load %arg1[%arg3, %arg4, %arg5, %arg6] : memref<1x3x10x10xf32>
            %2 = arith.addf %0, %1 : f32
            memref.store %2, %alloc[%arg3, %arg4, %arg5, %arg6] : memref<1x3x10x10xf32>
          }
        }
      }
    }
    call @relu4d_0(%alloc, %arg2) : (memref<1x3x10x10xf32>, memref<1x3x10x10xf32>) -> ()
    return
  }
}

