module {
  func.func @linear2d_0(%arg0: memref<48x64xf32>, %arg1: memref<48x64xf32>, %arg2: memref<48xf32>) -> memref<48x48xf32> attributes {itypes = "___", otypes = "_"} {
    %alloc = memref.alloc() {name = "Z"} : memref<48x48xf32>
    %alloc_0 = memref.alloc() {name = "buf"} : memref<48xf32>
    affine.for %arg3 = 0 to 48 {
      affine.for %arg4 = 0 to 48 {
        %c0_i32 = arith.constant 0 : i32
        %0 = arith.sitofp %c0_i32 : i32 to f32
        affine.store %0, %alloc_0[%arg4] {to = "buf"} : memref<48xf32>
      } {loop_name = "j_init", op_name = "S_j_init_0", pipeline_ii = 1 : ui32}
      affine.for %arg4 = 0 to 64 {
        %0 = affine.load %arg0[%arg3, %arg4] {from = "X"} : memref<48x64xf32>
        %alloc_1 = memref.alloc() {name = "x"} : memref<f32>
        affine.store %0, %alloc_1[] {to = "x"} : memref<f32>
        affine.for %arg5 = 0 to 48 {
          %1 = affine.load %alloc_1[] {from = "x"} : memref<f32>
          %2 = affine.load %arg1[%arg5, %arg4] {from = "W"} : memref<48x64xf32>
          %3 = arith.mulf %1, %2 : f32
          %4 = affine.load %alloc_0[%arg5] {from = "buf"} : memref<48xf32>
          %5 = arith.addf %4, %3 : f32
          affine.store %5, %alloc_0[%arg5] {to = "buf"} : memref<48xf32>
        } {loop_name = "j", op_name = "S_j_1", pipeline_ii = 1 : ui32}
      } {loop_name = "k", op_name = "S_k_1"}
      affine.for %arg4 = 0 to 48 {
        %0 = affine.load %alloc_0[%arg4] {from = "buf"} : memref<48xf32>
        %1 = affine.load %arg2[%arg4] {from = "b"} : memref<48xf32>
        %2 = arith.addf %0, %1 : f32
        affine.store %2, %alloc[%arg3, %arg4] {to = "Z"} : memref<48x48xf32>
      } {loop_name = "j_back", op_name = "S_j_back_3", pipeline_ii = 1 : ui32}
    } {loop_name = "i", op_name = "S_i_0"}
    return %alloc : memref<48x48xf32>
  }
  func.func @relu2d_0(%arg0: memref<48x48xf32>) -> memref<48x48xf32> attributes {itypes = "_", otypes = "_"} {
    %alloc = memref.alloc() {name = "Z"} : memref<48x48xf32>
    affine.for %arg1 = 0 to 48 {
      affine.for %arg2 = 0 to 48 {
        %0 = affine.load %arg0[%arg1, %arg2] {from = "X"} : memref<48x48xf32>
        %cst = arith.constant 0.000000e+00 : f32
        %1 = arith.maximumf %cst, %0 : f32
        affine.store %1, %alloc[%arg1, %arg2] {to = "Z"} : memref<48x48xf32>
      } {loop_name = "w", pipeline_ii = 1 : ui32}
    } {loop_name = "h", op_name = "S_h_w_0"}
    return %alloc : memref<48x48xf32>
  }
  func.func @linear2d_1(%arg0: memref<48x48xf32>, %arg1: memref<4x48xf32>, %arg2: memref<4xf32>) -> memref<48x4xf32> attributes {itypes = "___", otypes = "_"} {
    %alloc = memref.alloc() {name = "Z"} : memref<48x4xf32>
    %alloc_0 = memref.alloc() {name = "buf"} : memref<4xf32>
    affine.for %arg3 = 0 to 48 {
      affine.for %arg4 = 0 to 4 {
        %c0_i32 = arith.constant 0 : i32
        %0 = arith.sitofp %c0_i32 : i32 to f32
        affine.store %0, %alloc_0[%arg4] {to = "buf"} : memref<4xf32>
      } {loop_name = "j_init", op_name = "S_j_init_0", pipeline_ii = 1 : ui32}
      affine.for %arg4 = 0 to 48 {
        %0 = affine.load %arg0[%arg3, %arg4] {from = "X"} : memref<48x48xf32>
        %alloc_1 = memref.alloc() {name = "x"} : memref<f32>
        affine.store %0, %alloc_1[] {to = "x"} : memref<f32>
        affine.for %arg5 = 0 to 4 {
          %1 = affine.load %alloc_1[] {from = "x"} : memref<f32>
          %2 = affine.load %arg1[%arg5, %arg4] {from = "W"} : memref<4x48xf32>
          %3 = arith.mulf %1, %2 : f32
          %4 = affine.load %alloc_0[%arg5] {from = "buf"} : memref<4xf32>
          %5 = arith.addf %4, %3 : f32
          affine.store %5, %alloc_0[%arg5] {to = "buf"} : memref<4xf32>
        } {loop_name = "j", op_name = "S_j_1", pipeline_ii = 1 : ui32}
      } {loop_name = "k", op_name = "S_k_1"}
      affine.for %arg4 = 0 to 4 {
        %0 = affine.load %alloc_0[%arg4] {from = "buf"} : memref<4xf32>
        %1 = affine.load %arg2[%arg4] {from = "b"} : memref<4xf32>
        %2 = arith.addf %0, %1 : f32
        affine.store %2, %alloc[%arg3, %arg4] {to = "Z"} : memref<48x4xf32>
      } {loop_name = "j_back", op_name = "S_j_back_3", pipeline_ii = 1 : ui32}
    } {loop_name = "i", op_name = "S_i_0"}
    return %alloc : memref<48x4xf32>
  }
    // UPDATED: weights/biases are arguments; no memref.get_global
  func.func @forward(%x: memref<48x64xf32>,
                     %l1_w: memref<48x64xf32>,
                     %l1_b: memref<48xf32>,
                     %l2_w: memref<4x48xf32>,
                     %l2_b: memref<4xf32>) -> memref<48x4xf32>
      attributes {itypes = "_____", otypes = "_"} {
    %4 = call @linear2d_0(%x, %l1_w, %l1_b) {name = "l1"} :
         (memref<48x64xf32>, memref<48x64xf32>, memref<48xf32>) -> memref<48x48xf32>
    %5 = call @relu2d_0(%4) {name = "relu"} :
         (memref<48x48xf32>) -> memref<48x48xf32>
    %6 = call @linear2d_1(%5, %l2_w, %l2_b) {name = "l2"} :
         (memref<48x48xf32>, memref<4x48xf32>, memref<4xf32>) -> memref<48x4xf32>
    return %6 : memref<48x4xf32>
  }
}

