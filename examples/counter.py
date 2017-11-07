from silica import coroutine, bits, add, compile


@coroutine
def Counter(width, init=0, incr=1):
    value = bits(init, width)
    while True:
        O = value
        value, cout = add(value, bits(incr, width), cout=True)
        yield O, cout


@coroutine
def CounterIncr(width, init=0):
    value = bits(init, width)
    while True:
        incr = receive()
        O = value
        value, cout = add(value, bits(incr, width), cout=True)
        yield O, cout


if __name__ == "__main__":
    counter = Counter(4)
    for i in range((1 << 4) * 2):
        print(f"O={counter.O}, COUT={counter.cout}")
        next(counter)

    compile(counter, file_name="counter.magma.py")
