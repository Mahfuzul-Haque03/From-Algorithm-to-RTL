import torch
import torch.nn as nn
import torch.nn.functional as F

class Model(nn.Module):
    def __init__(self):
        super().__init__()

    def forward(self, x, y):
        x = x + y
        x = F.gelu(x)          # GELU activation
        return x

model = Model().eval()

import allo
example_inputs = [torch.rand(1, 3, 10, 10), torch.rand(1, 3, 10, 10)]
llvm_mod = allo.frontend.from_pytorch(
    model,
    example_inputs=example_inputs,
    target="mlir",
)
print(llvm_mod.module)
