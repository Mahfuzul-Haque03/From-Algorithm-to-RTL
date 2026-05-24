import torch
import allo
import torch.nn.functional as F
import torch.nn as nn

class Model(nn.Module):
    def __init__(self):
        super(Model, self).__init__()

    def forward(self, x, y):
        x = x + y
        x = F.relu(x)
        return x

model = Model()
model.eval()

example_inputs = [torch.rand(1, 3, 10, 10), torch.rand(1, 3, 10, 10)]
mlir_mod = allo.frontend.from_pytorch(model, example_inputs=example_inputs, target="mlir")

print(mlir_mod.module)