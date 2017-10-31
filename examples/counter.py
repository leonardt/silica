import silica
from magma.bit_vector import BitVector


def add(a, b, cout=False):
    assert isinstance(a, BitVector) and isinstance(b, BitVector)
    assert len(a) == len(b)
    if cout:
        width = len(a)
        c = BitVector(a, width + 1) + BitVector(b, width + 1)
        return c[:-1], c[-1]
    else:
        return a + b


@silica.coroutine
def Counter(width, init=0, incr=1):
    value = BitVector(init, width)
    while True:
        O = value
        value, cout = add(value, BitVector(incr, width), cout=True)
        yield O, cout


@silica.coroutine
def CounterIncr(width, init=0):
    value = BitVector(init, width)
    while True:
        incr = receive()
        O = value
        value, cout = add(value, BitVector(incr, width), cout=True)
        yield O, cout


@silica.coroutine
def main():
    counter = CounterIncr(8)
    cout = 0
    while True:
        O, cout = counter.peek(cout)
        yield O

if __name__ == "__main__":
    counter = Counter(4)
    for i in range((1 << 4) * 2):
        print(f"O={counter.O}, COUT={counter.cout}")
        next(counter)
