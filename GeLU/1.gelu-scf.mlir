module {
  func.func @gelu(%arg0: memref<1x3x10x10xf32>, %arg1: memref<1x3x10x10xf32>) attributes {itypes = "_", otypes = "_"} {
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
            memref.store %cst_2, %arg1[%arg2, %arg3, %arg4, %arg5] : memref<1x3x10x10xf32>
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
            %0 = memref.load %arg0[%arg2, %arg3, %arg4, %arg5] : memref<1x3x10x10xf32>
            %alloc = memref.alloc() {name = "x"} : memref<f32>
            memref.store %0, %alloc[] : memref<f32>
            %1 = memref.load %alloc[] : memref<f32>
            %2 = arith.mulf %1, %1 : f32
            %alloc_15 = memref.alloc() {name = "x2"} : memref<f32>
            memref.store %2, %alloc_15[] : memref<f32>
            %3 = memref.load %alloc_15[] : memref<f32>
            %4 = memref.load %alloc[] : memref<f32>
            %5 = arith.mulf %3, %4 : f32
            %alloc_16 = memref.alloc() {name = "x3"} : memref<f32>
            memref.store %5, %alloc_16[] : memref<f32>
            %alloc_17 = memref.alloc() {name = "a"} : memref<f32>
            memref.store %cst_1, %alloc_17[] : memref<f32>
            %alloc_18 = memref.alloc() {name = "b"} : memref<f32>
            memref.store %cst_0, %alloc_18[] : memref<f32>
            %alloc_19 = memref.alloc() {name = "c0"} : memref<f32>
            memref.store %cst, %alloc_19[] : memref<f32>
            %6 = memref.load %alloc_17[] : memref<f32>
            %7 = memref.load %alloc[] : memref<f32>
            %8 = arith.mulf %6, %7 : f32
            %9 = memref.load %alloc_18[] : memref<f32>
            %10 = memref.load %alloc_15[] : memref<f32>
            %11 = arith.mulf %9, %10 : f32
            %12 = arith.addf %8, %11 : f32
            %13 = memref.load %alloc_19[] : memref<f32>
            %14 = memref.load %alloc_16[] : memref<f32>
            %15 = arith.mulf %13, %14 : f32
            %16 = arith.addf %12, %15 : f32
            memref.store %16, %arg1[%arg2, %arg3, %arg4, %arg5] : memref<1x3x10x10xf32>
          }
        }
      }
    }
    return
  }
}

