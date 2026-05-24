module {
  func.func @linear2d_0(%arg0: memref<48x64xf32>, %arg1: memref<48x64xf32>, %arg2: memref<48xf32>, %arg3: memref<48x48xf32>) attributes {itypes = "___", otypes = "_"} {
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
        %0 = memref.load %arg0[%arg4, %arg5] : memref<48x64xf32>
        %alloc_0 = memref.alloc() {name = "x"} : memref<f32>
        memref.store %0, %alloc_0[] : memref<f32>
        scf.for %arg6 = %c0 to %c48 step %c1 {
          %1 = memref.load %alloc_0[] : memref<f32>
          %2 = memref.load %arg1[%arg6, %arg5] : memref<48x64xf32>
          %3 = arith.mulf %1, %2 : f32
          %4 = memref.load %alloc[%arg6] : memref<48xf32>
          %5 = arith.addf %4, %3 : f32
          memref.store %5, %alloc[%arg6] : memref<48xf32>
        }
      }
      scf.for %arg5 = %c0 to %c48 step %c1 {
        %0 = memref.load %alloc[%arg5] : memref<48xf32>
        %1 = memref.load %arg2[%arg5] : memref<48xf32>
        %2 = arith.addf %0, %1 : f32
        memref.store %2, %arg3[%arg4, %arg5] : memref<48x48xf32>
      }
    }
    return
  }
  func.func @relu2d_0(%arg0: memref<48x48xf32>, %arg1: memref<48x48xf32>) attributes {itypes = "_", otypes = "_"} {
    %cst = arith.constant 0.000000e+00 : f32
    %c0 = arith.constant 0 : index
    %c48 = arith.constant 48 : index
    %c1 = arith.constant 1 : index
    scf.for %arg2 = %c0 to %c48 step %c1 {
      scf.for %arg3 = %c0 to %c48 step %c1 {
        %0 = memref.load %arg0[%arg2, %arg3] : memref<48x48xf32>
        %1 = arith.cmpf ugt, %0, %cst : f32
        %2 = arith.select %1, %0, %cst : f32
        memref.store %2, %arg1[%arg2, %arg3] : memref<48x48xf32>
      }
    }
    return
  }
  func.func @linear2d_1(%arg0: memref<48x48xf32>, %arg1: memref<4x48xf32>, %arg2: memref<4xf32>, %arg3: memref<48x4xf32>) attributes {itypes = "___", otypes = "_"} {
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
        %0 = memref.load %arg0[%arg4, %arg5] : memref<48x48xf32>
        %alloc_0 = memref.alloc() {name = "x"} : memref<f32>
        memref.store %0, %alloc_0[] : memref<f32>
        scf.for %arg6 = %c0 to %c4 step %c1 {
          %1 = memref.load %alloc_0[] : memref<f32>
          %2 = memref.load %arg1[%arg6, %arg5] : memref<4x48xf32>
          %3 = arith.mulf %1, %2 : f32
          %4 = memref.load %alloc[%arg6] : memref<4xf32>
          %5 = arith.addf %4, %3 : f32
          memref.store %5, %alloc[%arg6] : memref<4xf32>
        }
      }
      scf.for %arg5 = %c0 to %c4 step %c1 {
        %0 = memref.load %alloc[%arg5] : memref<4xf32>
        %1 = memref.load %arg2[%arg5] : memref<4xf32>
        %2 = arith.addf %0, %1 : f32
        memref.store %2, %arg3[%arg4, %arg5] : memref<48x4xf32>
      }
    }
    return
  }
  func.func @forward(%arg0: memref<48x64xf32>, %arg1: memref<48x64xf32>, %arg2: memref<48xf32>, %arg3: memref<4x48xf32>, %arg4: memref<4xf32>, %arg5: memref<48x4xf32>) attributes {itypes = "_____", otypes = "_"} {
    %c4 = arith.constant 4 : index
    %c64 = arith.constant 64 : index
    %c1 = arith.constant 1 : index
    %c48 = arith.constant 48 : index
    %c0 = arith.constant 0 : index
    %cst = arith.constant 0.000000e+00 : f32
    %alloc = memref.alloc() {name = "Z"} : memref<48x48xf32>
    %alloc_0 = memref.alloc() {name = "buf"} : memref<48xf32>
    scf.for %arg6 = %c0 to %c48 step %c1 {
      scf.for %arg7 = %c0 to %c48 step %c1 {
        memref.store %cst, %alloc_0[%arg7] : memref<48xf32>
      }
      scf.for %arg7 = %c0 to %c64 step %c1 {
        %0 = memref.load %arg0[%arg6, %arg7] : memref<48x64xf32>
        %alloc_3 = memref.alloc() {name = "x"} : memref<f32>
        memref.store %0, %alloc_3[] : memref<f32>
        scf.for %arg8 = %c0 to %c48 step %c1 {
          %1 = memref.load %alloc_3[] : memref<f32>
          %2 = memref.load %arg1[%arg8, %arg7] : memref<48x64xf32>
          %3 = arith.mulf %1, %2 : f32
          %4 = memref.load %alloc_0[%arg8] : memref<48xf32>
          %5 = arith.addf %4, %3 : f32
          memref.store %5, %alloc_0[%arg8] : memref<48xf32>
        }
      }
      scf.for %arg7 = %c0 to %c48 step %c1 {
        %0 = memref.load %alloc_0[%arg7] : memref<48xf32>
        %1 = memref.load %arg2[%arg7] : memref<48xf32>
        %2 = arith.addf %0, %1 : f32
        memref.store %2, %alloc[%arg6, %arg7] : memref<48x48xf32>
      }
    }
    %alloc_1 = memref.alloc() {name = "Z"} : memref<48x48xf32>
    scf.for %arg6 = %c0 to %c48 step %c1 {
      scf.for %arg7 = %c0 to %c48 step %c1 {
        %0 = memref.load %alloc[%arg6, %arg7] : memref<48x48xf32>
        %1 = arith.cmpf ugt, %0, %cst : f32
        %2 = arith.select %1, %0, %cst : f32
        memref.store %2, %alloc_1[%arg6, %arg7] : memref<48x48xf32>
      }
    }
    %alloc_2 = memref.alloc() {name = "buf"} : memref<4xf32>
    scf.for %arg6 = %c0 to %c48 step %c1 {
      scf.for %arg7 = %c0 to %c4 step %c1 {
        memref.store %cst, %alloc_2[%arg7] : memref<4xf32>
      }
      scf.for %arg7 = %c0 to %c48 step %c1 {
        %0 = memref.load %alloc_1[%arg6, %arg7] : memref<48x48xf32>
        %alloc_3 = memref.alloc() {name = "x"} : memref<f32>
        memref.store %0, %alloc_3[] : memref<f32>
        scf.for %arg8 = %c0 to %c4 step %c1 {
          %1 = memref.load %alloc_3[] : memref<f32>
          %2 = memref.load %arg3[%arg8, %arg7] : memref<4x48xf32>
          %3 = arith.mulf %1, %2 : f32
          %4 = memref.load %alloc_2[%arg8] : memref<4xf32>
          %5 = arith.addf %4, %3 : f32
          memref.store %5, %alloc_2[%arg8] : memref<4xf32>
        }
      }
      scf.for %arg7 = %c0 to %c4 step %c1 {
        %0 = memref.load %alloc_2[%arg7] : memref<4xf32>
        %1 = memref.load %arg4[%arg7] : memref<4xf32>
        %2 = arith.addf %0, %1 : f32
        memref.store %2, %arg5[%arg6, %arg7] : memref<48x4xf32>
      }
    }
    return
  }
}

