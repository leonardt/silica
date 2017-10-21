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
    lfsr = LFSR(8, taps=[3, 4, 5, 7])
    counter = Counter()
    print("For a counter of width 8, it should produce 2 * 8 - 1 distinct values before repeating")
    for i in range((2 * 8 - 1) * 2):
        O = seq2int(lfsr.O)
        counter[O] += 1
        print(f"O={O}")
        next(lfsr)

    for item, count in counter.items():
        assert count == 1, "Should only see each binary sequence once every 2 * N - 1 cycles"

    for i in range((2 * 8 - 1) * 2):
        O = seq2int(lfsr.O)
        counter[O] += 1
        print(f"O={O}")
        next(lfsr)

    for item, count in counter.items():
        assert count == 1, "Should only see each binary sequence twice every 2 * (2 * N - 1) cycles"
