import allo
from allo.ir.types import int32

# C: int32[32, 32] = 0
def gemm(A: int32[32, 32], B: int32[32, 32], C: int32[32, 32]):
    # C: int32[32, 32] = 0
    for i, j, k in allo.grid(32, 32, 32):
        C[i, j] += A[i, k] * B[k, j]
    # return C

s = allo.customize(gemm)
print(s.module)

# mlir_content = str(s.module)
# file_name = "hello.mlir"
# with open(file_name, "w") as f:
#     f.write(mlir_content)
#     print(f"MLIR successfully saved to {file_name}")

# s.split("i", factor=8)

# print(s.module)
# 2. Write it to a file
# file_name = "hello.mlir"
# with open(file_name, "w") as f:
#     f.write(mlir_content)
#     print(f"MLIR successfully saved to {file_name}")
    
# s.split("j", factor=8)
# print(s.module)

# s.reorder("i.outer", "j.outer", "i.inner", "j.inner")
# print(s.module)

# mod = s.build(target="llvm")

# print(f"MLIR successfully saved to {file_name}")

# import numpy as np

# np_A = np.random.randint(0, 100, (32, 32)).astype(np.int32)
# np_B = np.random.randint(0, 100, (32, 32)).astype(np.int32)
# np_C = np.zeros((32, 32), dtype=np.int32)

# mod(np_A, np_B, np_C)
# golden_C = np.matmul(np_A, np_B)
# np.testing.assert_allclose(np_C, golden_C, rtol=1e-5, atol=1e-5)
# print("Results are correct!")
