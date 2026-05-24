import allo
from allo.ir.types import int32
import numpy as np


def increase(A: int32, B: int32[1]):
    B[0] = A + 1

s = allo.customize(increase)
print(s.module)