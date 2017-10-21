from magma.bitutils import int2seq
import silica

@silica.coroutine
def SISO(width, init=0):
    values = int2seq(init, width)
    O = values[-1]
    while True:
        I = yield O
        O = values[-1]
        values[0] = I
        for i in reversed(range(1, width)):
            values[i] = values[i - 1]


if __name__ == "__main__":
    siso = SISO(8, 3)
    print(f"Should be initialized to {int2seq(3, 8)[-1]}")
    print(f"    siso: O={siso.O}")
    assert siso.O == int2seq(3, 8)[-1]
    inputs = [1, 0, 0, 1, 0, 1, 1, 0] * 2
    expected = list(reversed(int2seq(3, 8)[1:])) + list(inputs[:-8])
    print("Expected : {}".format(" ".join(str(i) for i in expected)))
    print("Actual   : ", end="")
    for input_, expected_output in zip(inputs, expected):
        siso.send(input_)
        print(f"{siso.O} ", end="")
        assert siso.O == expected_output
