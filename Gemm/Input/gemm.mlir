module {
  func.func @gemm(%arg0: memref<32x32xi32>, %arg1: memref<32x32xi32>, %arg2: memref<32x32xi32>) attributes {itypes = "sss", otypes = ""} {
    affine.for %arg3 = 0 to 32 {
      affine.for %arg4 = 0 to 32 {
        affine.for %arg5 = 0 to 32 {
          %0 = affine.load %arg0[%arg3, %arg5] {from = "A"} : memref<32x32xi32>
          %1 = affine.load %arg1[%arg5, %arg4] {from = "B"} : memref<32x32xi32>
          %2 = arith.extsi %0 : i32 to i64
          %3 = arith.extsi %1 : i32 to i64
          %4 = arith.muli %2, %3 : i64
          %5 = affine.load %arg2[%arg3, %arg4] {from = "C"} : memref<32x32xi32>
          %6 = arith.extsi %5 : i32 to i65
          %7 = arith.extsi %4 : i64 to i65
          %8 = arith.addi %6, %7 : i65
          %9 = arith.trunci %8 : i65 to i32
          affine.store %9, %arg2[%arg3, %arg4] {to = "C"} : memref<32x32xi32>
        } {loop_name = "k"}
      } {loop_name = "j"}
    } {loop_name = "i", op_name = "S_i_j_k_0"}
    return
  }
}
