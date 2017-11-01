import silica
from magma.bit_vector import BitVector


def bits(value, width):
    return BitVector(value, width)


def add(a, b, with_cout=False):
    assert isinstance(a, BitVector) and isinstance(b, BitVector)
    assert len(a) == len(b)
    if with_cout:
        width = len(a)
        c = BitVector(a, width + 1) + BitVector(b, width + 1)
        return c[:-1], c[-1]
    else:
        return a + b


@silica.coroutine
def Counter(width, init=0, incr=1):
    value = bits(init, width)
    while True:
        O = value
        value, cout = add(value, bits(incr, width), with_cout=True)
        yield O, cout

def test_counter4():
    counter = Counter(4)
    for _ in range(2):
        for i in range(1 << 4):
            assert counter.O == i
            assert counter.cout == (i == (1 << 4) - 1)
            next(counter)

    silica.compile(counter)
