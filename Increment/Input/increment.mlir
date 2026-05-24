module {
  func.func @main() {
    %c3 = arith.constant 3 : index
    // Changed f64 constants to i64 integers
    %cst = arith.constant 3 : i64
    %cst_0 = arith.constant 2 : i64
    %cst_1 = arith.constant 1 : i64
    
    %c2 = arith.constant 2 : index
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    
    // Changed memref type from f64 to i64
    %alloc = memref.alloc() : memref<3xi64>
    affine.store %cst_1, %alloc[%c0] : memref<3xi64>
    affine.store %cst_0, %alloc[%c1] : memref<3xi64>
    affine.store %cst, %alloc[%c2] : memref<3xi64>
    
    %alloc_2 = memref.alloc() : memref<3xi64>
    affine.store %cst_1, %alloc_2[%c0] : memref<3xi64>
    affine.store %cst_0, %alloc_2[%c1] : memref<3xi64>
    affine.store %cst, %alloc_2[%c2] : memref<3xi64>
    
    %alloc_3 = memref.alloc() : memref<3xi64>
    
    scf.for %arg0 = %c0 to %c3 step %c1 {
      %0 = memref.load %alloc[%arg0] : memref<3xi64>
      %1 = memref.load %alloc_2[%arg0] : memref<3xi64>
      // Changed arith.addf (float) to arith.addi (integer)
      %2 = arith.addi %0, %1 : i64
      memref.store %2, %alloc_3[%arg0] : memref<3xi64>
    }
    return
  }
}