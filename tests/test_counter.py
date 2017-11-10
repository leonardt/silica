import silica
from silica import bits, add
from magma.bit_vector import BitVector
from magma.testing.coroutine import check


@silica.coroutine
def Counter(width, init=0, incr=1):
    value = bits(init, width)
    O = value
    cout = False
    while True:
        yield O, cout
        O = value
        value, cout = add(value, bits(incr, width), cout=True)

def test_counter():
    N = 3
    counter = Counter(3)
    for _ in range(2):
        for i in range(1 << 3):
            next(counter)
            assert counter.O == i
            assert counter.cout == (i == (1 << 3) - 1)

    magma_counter = silica.compile(counter, file_name="magma_counter.py")
    print(magma_counter)
    check(magma_counter, Counter(3), 1<<3 * 2)
