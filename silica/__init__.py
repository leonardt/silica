from .coroutine import coroutine, Coroutine, generator, Generator
from .compile import compile

import magma
from magma import Bit, zext, concat, Array, Bits
from magma.bit_vector import BitVector
import operator


class BitVector(BitVector):
    def __repr__(self):
        return f"bits({self._value}, {self.num_bits})"


class Memory(list):
    def __getitem__(self, key):
        if isinstance(key, magma.bit_vector.BitVector):
            key = key.as_int()
        return super().__getitem__(key)

    def __setitem__(self, key, value):
        if isinstance(key, magma.bit_vector.BitVector):
            key = key.as_int()
        return super().__setitem__(key, value)

def memory(height, width):
    return Memory(bits(0, width) for _ in range(height))

def bits(value, width):
    # TODO: Only support bitwise ops
    return BitVector(value, width)

def uint(value, width):
    return BitVector(value, num_bits=width)

def zext(value, n):
    assert isinstance(value, BitVector)
    return BitVector(value, num_bits=n + value.num_bits)

def add(a, b, cout=False):
    assert isinstance(a, magma.bit_vector.BitVector) and isinstance(b, magma.bit_vector.BitVector)
    assert len(a) == len(b)
    if cout:
        width = len(a)
        c = BitVector(a, width + 1) + BitVector(b, width + 1)
        return c[:-1], c[-1]
    else:
        return a + b

def lt(a, b):
    return a < b

def le(a, b):
    return a <= b

def not_(a):
    return ~a

operators = {
    "lt": lt,
    "le": le,
    "not_": not_,
    "uint": uint,
    "BitVector": BitVector
}


def eval(x):
    return x

def coroutine_create(x):
    return x()

def and_(a, b):
    return operator.and_(a, b)
