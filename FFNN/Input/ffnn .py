import torch
import torch.nn as nn
import torch.nn.functional as F
import json

import allo

torch.set_printoptions(precision=4)

input_size = 64
hidden_size = 48
output_size = 4

mean = 3
std = 5

lower_bound = 2
upper_bound = 6

torch.manual_seed(42)

random_tensor = torch.randn(hidden_size, input_size) * std + mean

clipped_tensor = torch.clamp(random_tensor, min=lower_bound, max=upper_bound)


class Model(nn.Module):
    def __init__(self, input_size, hidden_size, output_size):
        super(Model, self).__init__()
        self.l1 = nn.Linear(input_size, hidden_size)
        self.activation = F.relu
        self.l2 = nn.Linear(hidden_size, output_size)

    def forward(self, x):
        output = self.l1(x)
        output = self.activation(output)
        output = self.l2(output)
        return output

model = Model(input_size, hidden_size, output_size)
model.eval()
example_inputs = [clipped_tensor]
mlir_mod = allo.frontend.from_pytorch(
    model, example_inputs=example_inputs, verbose=False, target="mlir",
)
print(mlir_mod.module)

# print(example_inputs[0])
# print(model.l1.weight.data)
# print(model.l1.bias.data)
# print(model.l2.weight.data)
# print(model.l2.bias.data)
# expected_output = model(example_inputs[0])
# print("Expected Output:", expected_output)