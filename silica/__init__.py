from .coroutine import coroutine, Coroutine
from .compile import compile

from magma import Bit
from magma.bit_vector import BitVector

def bits(value, width):
    return BitVector(value, width)


def add(a, b, cout=False):
    assert isinstance(a, BitVector) and isinstance(b, BitVector)
    assert len(a) == len(b)
    if cout:
        width = len(a)
        c = BitVector(a, width + 1) + BitVector(b, width + 1)
        return c[:-1], c[-1]
    else:
        return a + b
