import silica
from silica import bits, add
from magma.bit_vector import BitVector
from magma.testing.coroutine import check


@silica.coroutine
def SilicaCounter(width, init=0, incr=1):
    value = bits(init, width)
    O = value
    COUT = False
    while True:
        yield O, COUT
        O = value
        value, COUT = add(value, bits(incr, width), cout=True)

def test_counter():
    N = 3
    counter = SilicaCounter(3)
    for _ in range(2):
        for i in range(1 << 3):
            print(counter.O, counter.COUT)
            next(counter)
            assert counter.O == i
            assert counter.COUT == (i == (1 << 3) - 1)

    magma_counter = silica.compile(counter, file_name="tests/magma_counter.py")
    check(magma_counter, SilicaCounter(3), 1<<3 * 2)
    from mantle import DefineCounter

    check(DefineCounter(4), SilicaCounter(4), 1<<4 * 2)
