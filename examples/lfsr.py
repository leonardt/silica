import silica
from magma.bitutils import int2seq, seq2int
import operator
from functools import reduce
from collections import Counter

xor = lambda *args: reduce(operator.xor, args)


@silica.coroutine
def LFSR(n, taps, init=1):
    """taps : tuple of tap indices"""
    if init == 0: 
        raise ValueError("LFSR must be initialized with non-zero value")
    values = int2seq(init, n)
    O = values
    yield O
    while True:
        O = values
        I = xor(*(values[i] for i in taps))
        for i in reversed(range(1, n)):
            values[i] = values[i - 1]
        values[0] = I
        yield O


if __name__ == "__main__":
    width = 8
    taps = {
        8: [3, 4, 5, 7],      # Period = 255
        19: [18, 17, 16, 13]  # Period = 524287
    }
    lfsr = LFSR(width, taps=taps[width])
    counter = Counter()
    print("For a counter of width {width}, it should produce 2 * {width} - 1 distinct values before repeating")
    for i in range(2 ** width - 1):
        O = seq2int(lfsr.O)
        counter[O] += 1
        print(f"O={O}")
        next(lfsr)

    for item, count in counter.items():
        assert count == 1, f"Should only see each binary sequence once every 2 ^ {width} - 1 cycles"

    for i in range(2 ** width - 1):
        O = seq2int(lfsr.O)
        counter[O] += 1
        print(f"O={O}")
        next(lfsr)

    for item, count in counter.items():
        assert count == 2, f"Should only see each binary sequence twice every 2 * (2 ^ {width} - 1) cycles"
