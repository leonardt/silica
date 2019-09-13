from .coroutine import coroutine, Coroutine, generator, Generator
from .function import function, compile_function
from .compile import compile
from ._config import Config
from .types import Channel, In, Out
config = Config()

import magma as m
from magma import Bit, zext, concat, Array, Bits, UInt
from hwtypes import BitVector
import hwtypes
import operator


class BitVector(BitVector):
    def __repr__(self):
        return f"bits({self._value}, {self.num_bits})"


class Memory(list):
    def __getitem__(self, key):
        if isinstance(key, hwtypes.BitVector):
            key = key.as_uint()
        return super().__getitem__(key)

    def __setitem__(self, key, value):
        if isinstance(key, hwtypes.BitVector):
            key = key.as_uint()
        return super().__setitem__(key, value)

def memory(height, width):
    return Memory(bits(0, width) for _ in range(height))

def bit(value):
    return BitVector[1](value)

def bits(value, width):
    return BitVector[width](value)

def uint(value, width):
    return BitVector[width](value)

def zext(value, n):
    assert isinstance(value, BitVector)
    return BitVector[n + len(value)](value)

def add(a, b, cout=False):
    assert isinstance(a, hwtypes.BitVector) and isinstance(b, hwtypes.BitVector)
    assert len(a) == len(b)
    if cout:
        width = len(a)
        c = BitVector[width + 1](a) + BitVector[width + 1](b)
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
    "bits": bits,
    "uint": uint,
    "BitVector": BitVector
}


def eval(x):
    return x

def coroutine_create(x):
    return x()

def and_(a, b):
    return operator.and_(a, b)

def combinational(fn):
    fn.__silica_combinational = True
    fn.__magma_circuit = m.circuit.combinational(fn).circuit_definition
    return fn
