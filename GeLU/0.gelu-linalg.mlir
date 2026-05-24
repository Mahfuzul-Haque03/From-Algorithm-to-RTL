module {
  func.func @gelu(%arg0: memref<1x3x10x10xf32>) -> memref<1x3x10x10xf32> attributes {itypes = "_", otypes = "_"} {
    %alloc = memref.alloc() {name = "Z"} : memref<1x3x10x10xf32>
    %cst = arith.constant 0.000000e+00 : f32
    linalg.fill ins(%cst : f32) outs(%alloc : memref<1x3x10x10xf32>)
    affine.for %arg1 = 0 to 1 {
      affine.for %arg2 = 0 to 3 {
        affine.for %arg3 = 0 to 10 {
          affine.for %arg4 = 0 to 10 {
            %0 = affine.load %arg0[%arg1, %arg2, %arg3, %arg4] {from = "X"} : memref<1x3x10x10xf32>
            %alloc_0 = memref.alloc() {name = "x"} : memref<f32>
            affine.store %0, %alloc_0[] {to = "x"} : memref<f32>
            %1 = affine.load %alloc_0[] {from = "x"} : memref<f32>
            %2 = affine.load %alloc_0[] {from = "x"} : memref<f32>
            %3 = arith.mulf %1, %2 : f32
            %alloc_1 = memref.alloc() {name = "x2"} : memref<f32>
            affine.store %3, %alloc_1[] {to = "x2"} : memref<f32>
            %4 = affine.load %alloc_1[] {from = "x2"} : memref<f32>
            %5 = affine.load %alloc_0[] {from = "x"} : memref<f32>
            %6 = arith.mulf %4, %5 : f32
            %alloc_2 = memref.alloc() {name = "x3"} : memref<f32>
            affine.store %6, %alloc_2[] {to = "x3"} : memref<f32>
            %cst_3 = arith.constant 5.000000e-01 : f32
            %cst_4 = arith.constant 5.000000e-01 : f32
            %alloc_5 = memref.alloc() {name = "a"} : memref<f32>
            affine.store %cst_4, %alloc_5[] {to = "a"} : memref<f32>
            %cst_6 = arith.constant 3.989000e-01 : f32
            %cst_7 = arith.constant 3.989000e-01 : f32
            %alloc_8 = memref.alloc() {name = "b"} : memref<f32>
            affine.store %cst_7, %alloc_8[] {to = "b"} : memref<f32>
            %cst_9 = arith.constant 3.570000e-02 : f32
            %cst_10 = arith.constant 3.570000e-02 : f32
            %alloc_11 = memref.alloc() {name = "c0"} : memref<f32>
            affine.store %cst_10, %alloc_11[] {to = "c0"} : memref<f32>
            %7 = affine.load %alloc_5[] {from = "a"} : memref<f32>
            %8 = affine.load %alloc_0[] {from = "x"} : memref<f32>
            %9 = arith.mulf %7, %8 : f32
            %10 = affine.load %alloc_8[] {from = "b"} : memref<f32>
            %11 = affine.load %alloc_1[] {from = "x2"} : memref<f32>
            %12 = arith.mulf %10, %11 : f32
            %13 = arith.addf %9, %12 : f32
            %14 = affine.load %alloc_11[] {from = "c0"} : memref<f32>
            %15 = affine.load %alloc_2[] {from = "x3"} : memref<f32>
            %16 = arith.mulf %14, %15 : f32
            %17 = arith.addf %13, %16 : f32
            affine.store %17, %alloc[%arg1, %arg2, %arg3, %arg4] {to = "Z"} : memref<1x3x10x10xf32>
          } {loop_name = "w"}
        } {loop_name = "h"}
      } {loop_name = "c"}
    } {loop_name = "n", op_name = "S_n_c_h_w_0"}
    return %alloc : memref<1x3x10x10xf32>
  }
}

