import silica
from magma.bit_vector import BitVector


def add(a, b, cout=False):
    assert isinstance(a, BitVector) and isinstance(b, BitVector)
    assert len(a) == len(b)
    c = a + b
    if cout:
        return c, (BitVector(a, len(a) + 1) + BitVector(b, len(b) + 1))[-1]
    else:
        return c


@silica.coroutine
def Counter(width, init=0, incr=1):
    value = BitVector(init, width)
    while True:
        O = value
        value, cout = add(O, BitVector(incr, width), cout=True)
        yield O, cout

if __name__ == "__main__":
    counter = Counter(4)
    for i in range((1 << 4) * 2):
        print(f"O={counter.O}, COUT={counter.cout}")
        next(counter)
