module {
  func.func @linear2d_0(%arg0: memref<3072xf32>, %arg1: memref<3072xf32>, %arg2: memref<48xf32>, %arg3: memref<2304xf32>) attributes {itypes = "___", otypes = "_"} {
    %c64 = arith.constant 64 : index
    %c1 = arith.constant 1 : index
    %c48 = arith.constant 48 : index
    %c0 = arith.constant 0 : index
    %cst = arith.constant 0.000000e+00 : f32
    %alloc = memref.alloc() {name = "buf"} : memref<48xf32>
    scf.for %arg4 = %c0 to %c48 step %c1 {
      scf.for %arg5 = %c0 to %c48 step %c1 {
        memref.store %cst, %alloc[%arg5] : memref<48xf32>
      }
      scf.for %arg5 = %c0 to %c64 step %c1 {
        %c6 = arith.constant 6 : index
        %0 = arith.shli %arg4, %c6 : index
        %1 = arith.addi %0, %arg5 : index
        %2 = memref.load %arg0[%1] : memref<3072xf32>
        %alloc_0 = memref.alloc() : memref<1xf32>
        %c0_1 = arith.constant 0 : index
        memref.store %2, %alloc_0[%c0_1] : memref<1xf32>
        scf.for %arg6 = %c0 to %c48 step %c1 {
          %c0_2 = arith.constant 0 : index
          %3 = memref.load %alloc_0[%c0_2] : memref<1xf32>
          %c6_3 = arith.constant 6 : index
          %4 = arith.shli %arg6, %c6_3 : index
          %5 = arith.addi %4, %arg5 : index
          %6 = memref.load %arg1[%5] : memref<3072xf32>
          %7 = arith.mulf %3, %6 : f32
          %8 = memref.load %alloc[%arg6] : memref<48xf32>
          %9 = arith.addf %8, %7 : f32
          memref.store %9, %alloc[%arg6] : memref<48xf32>
        }
      }
      scf.for %arg5 = %c0 to %c48 step %c1 {
        %0 = memref.load %alloc[%arg5] : memref<48xf32>
        %1 = memref.load %arg2[%arg5] : memref<48xf32>
        %2 = arith.addf %0, %1 : f32
        %c48_0 = arith.constant 48 : index
        %3 = arith.muli %arg4, %c48_0 : index
        %4 = arith.addi %3, %arg5 : index
        memref.store %2, %arg3[%4] : memref<2304xf32>
      }
    }
    return
  }
  func.func @relu2d_0(%arg0: memref<2304xf32>, %arg1: memref<2304xf32>) attributes {itypes = "_", otypes = "_"} {
    %cst = arith.constant 0.000000e+00 : f32
    %c0 = arith.constant 0 : index
    %c48 = arith.constant 48 : index
    %c1 = arith.constant 1 : index
    scf.for %arg2 = %c0 to %c48 step %c1 {
      scf.for %arg3 = %c0 to %c48 step %c1 {
        %c48_0 = arith.constant 48 : index
        %0 = arith.muli %arg2, %c48_0 : index
        %1 = arith.addi %0, %arg3 : index
        %2 = memref.load %arg0[%1] : memref<2304xf32>
        %3 = arith.cmpf ugt, %2, %cst : f32
        %4 = arith.select %3, %2, %cst : f32
        %c48_1 = arith.constant 48 : index
        %5 = arith.muli %arg2, %c48_1 : index
        %6 = arith.addi %5, %arg3 : index
        memref.store %4, %arg1[%6] : memref<2304xf32>
      }
    }
    return
  }
  func.func @linear2d_1(%arg0: memref<2304xf32>, %arg1: memref<192xf32>, %arg2: memref<4xf32>, %arg3: memref<192xf32>) attributes {itypes = "___", otypes = "_"} {
    %c4 = arith.constant 4 : index
    %c1 = arith.constant 1 : index
    %c48 = arith.constant 48 : index
    %c0 = arith.constant 0 : index
    %cst = arith.constant 0.000000e+00 : f32
    %alloc = memref.alloc() {name = "buf"} : memref<4xf32>
    scf.for %arg4 = %c0 to %c48 step %c1 {
      scf.for %arg5 = %c0 to %c4 step %c1 {
        memref.store %cst, %alloc[%arg5] : memref<4xf32>
      }
      scf.for %arg5 = %c0 to %c48 step %c1 {
        %c48_0 = arith.constant 48 : index
        %0 = arith.muli %arg4, %c48_0 : index
        %1 = arith.addi %0, %arg5 : index
        %2 = memref.load %arg0[%1] : memref<2304xf32>
        %alloc_1 = memref.alloc() : memref<1xf32>
        %c0_2 = arith.constant 0 : index
        memref.store %2, %alloc_1[%c0_2] : memref<1xf32>
        scf.for %arg6 = %c0 to %c4 step %c1 {
          %c0_3 = arith.constant 0 : index
          %3 = memref.load %alloc_1[%c0_3] : memref<1xf32>
          %c48_4 = arith.constant 48 : index
          %4 = arith.muli %arg6, %c48_4 : index
          %5 = arith.addi %4, %arg5 : index
          %6 = memref.load %arg1[%5] : memref<192xf32>
          %7 = arith.mulf %3, %6 : f32
          %8 = memref.load %alloc[%arg6] : memref<4xf32>
          %9 = arith.addf %8, %7 : f32
          memref.store %9, %alloc[%arg6] : memref<4xf32>
        }
      }
      scf.for %arg5 = %c0 to %c4 step %c1 {
        %0 = memref.load %alloc[%arg5] : memref<4xf32>
        %1 = memref.load %arg2[%arg5] : memref<4xf32>
        %2 = arith.addf %0, %1 : f32
        %c2 = arith.constant 2 : index
        %3 = arith.shli %arg4, %c2 : index
        %4 = arith.addi %3, %arg5 : index
        memref.store %2, %arg3[%4] : memref<192xf32>
      }
    }
    return
  }
  func.func @forward(%arg0: memref<3072xf32>, %arg1: memref<3072xf32>, %arg2: memref<48xf32>, %arg3: memref<192xf32>, %arg4: memref<4xf32>, %arg5: memref<192xf32>) attributes {itypes = "_____", otypes = "_"} {
    %c4 = arith.constant 4 : index
    %c64 = arith.constant 64 : index
    %c1 = arith.constant 1 : index
    %c48 = arith.constant 48 : index
    %c0 = arith.constant 0 : index
    %cst = arith.constant 0.000000e+00 : f32
    %alloc = memref.alloc() : memref<2304xf32>
    %alloc_0 = memref.alloc() {name = "buf"} : memref<48xf32>
    scf.for %arg6 = %c0 to %c48 step %c1 {
      scf.for %arg7 = %c0 to %c48 step %c1 {
        memref.store %cst, %alloc_0[%arg7] : memref<48xf32>
      }
      scf.for %arg7 = %c0 to %c64 step %c1 {
        %c6 = arith.constant 6 : index
        %0 = arith.shli %arg6, %c6 : index
        %1 = arith.addi %0, %arg7 : index
        %2 = memref.load %arg0[%1] : memref<3072xf32>
        %alloc_3 = memref.alloc() : memref<1xf32>
        %c0_4 = arith.constant 0 : index
        memref.store %2, %alloc_3[%c0_4] : memref<1xf32>
        scf.for %arg8 = %c0 to %c48 step %c1 {
          %c0_5 = arith.constant 0 : index
          %3 = memref.load %alloc_3[%c0_5] : memref<1xf32>
          %c6_6 = arith.constant 6 : index
          %4 = arith.shli %arg8, %c6_6 : index
          %5 = arith.addi %4, %arg7 : index
          %6 = memref.load %arg1[%5] : memref<3072xf32>
          %7 = arith.mulf %3, %6 : f32
          %8 = memref.load %alloc_0[%arg8] : memref<48xf32>
          %9 = arith.addf %8, %7 : f32
          memref.store %9, %alloc_0[%arg8] : memref<48xf32>
        }
      }
      scf.for %arg7 = %c0 to %c48 step %c1 {
        %0 = memref.load %alloc_0[%arg7] : memref<48xf32>
        %1 = memref.load %arg2[%arg7] : memref<48xf32>
        %2 = arith.addf %0, %1 : f32
        %c48_3 = arith.constant 48 : index
        %3 = arith.muli %arg6, %c48_3 : index
        %4 = arith.addi %3, %arg7 : index
        memref.store %2, %alloc[%4] : memref<2304xf32>
      }
    }
    %alloc_1 = memref.alloc() : memref<2304xf32>
    scf.for %arg6 = %c0 to %c48 step %c1 {
      scf.for %arg7 = %c0 to %c48 step %c1 {
        %c48_3 = arith.constant 48 : index
        %0 = arith.muli %arg6, %c48_3 : index
        %1 = arith.addi %0, %arg7 : index
        %2 = memref.load %alloc[%1] : memref<2304xf32>
        %3 = arith.cmpf ugt, %2, %cst : f32
        %4 = arith.select %3, %2, %cst : f32
        %c48_4 = arith.constant 48 : index
        %5 = arith.muli %arg6, %c48_4 : index
        %6 = arith.addi %5, %arg7 : index
        memref.store %4, %alloc_1[%6] : memref<2304xf32>
      }
    }
    %alloc_2 = memref.alloc() {name = "buf"} : memref<4xf32>
    scf.for %arg6 = %c0 to %c48 step %c1 {
      scf.for %arg7 = %c0 to %c4 step %c1 {
        memref.store %cst, %alloc_2[%arg7] : memref<4xf32>
      }
      scf.for %arg7 = %c0 to %c48 step %c1 {
        %c48_3 = arith.constant 48 : index
        %0 = arith.muli %arg6, %c48_3 : index
        %1 = arith.addi %0, %arg7 : index
        %2 = memref.load %alloc_1[%1] : memref<2304xf32>
        %alloc_4 = memref.alloc() : memref<1xf32>
        %c0_5 = arith.constant 0 : index
        memref.store %2, %alloc_4[%c0_5] : memref<1xf32>
        scf.for %arg8 = %c0 to %c4 step %c1 {
          %c0_6 = arith.constant 0 : index
          %3 = memref.load %alloc_4[%c0_6] : memref<1xf32>
          %c48_7 = arith.constant 48 : index
          %4 = arith.muli %arg8, %c48_7 : index
          %5 = arith.addi %4, %arg7 : index
          %6 = memref.load %arg3[%5] : memref<192xf32>
          %7 = arith.mulf %3, %6 : f32
          %8 = memref.load %alloc_2[%arg8] : memref<4xf32>
          %9 = arith.addf %8, %7 : f32
          memref.store %9, %alloc_2[%arg8] : memref<4xf32>
        }
      }
      scf.for %arg7 = %c0 to %c4 step %c1 {
        %0 = memref.load %alloc_2[%arg7] : memref<4xf32>
        %1 = memref.load %arg4[%arg7] : memref<4xf32>
        %2 = arith.addf %0, %1 : f32
        %c2 = arith.constant 2 : index
        %3 = arith.shli %arg6, %c2 : index
        %4 = arith.addi %3, %arg7 : index
        memref.store %2, %arg5[%4] : memref<192xf32>
      }
    }
    return
  }
}

