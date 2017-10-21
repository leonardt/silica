from magma.bitutils import int2seq
import silica

@silica.coroutine
def SISO(width, init=0):
    values = int2seq(init, width)
    O = values[-1]
    I = yield O
    while True:
        O = values[-1]
        for i in reversed(range(1, width)):
            values[i] = values[i - 1]
        values[0] = I
        I = yield O


if __name__ == "__main__":
    siso = SISO(8, 3)
    print(f"Should be initialized to {int2seq(3, 8)} so the last bit should be {int2seq(3, 8)[-1]}")
    print(f"    siso: O={siso.O}")
    assert siso.O == int2seq(3, 8)[-1]
    inputs = [1, 0, 0, 1, 0, 1, 1, 0] * 2
    expected = list(reversed(int2seq(3, 8))) + list(inputs[:-8])
    print("Inputs   : {}".format(" ".join(str(i) for i in inputs)))
    print("Outputs should be the last 7 bits of the initialization value, then then inputs")
    print("Expected : {}".format(" ".join(str(i) for i in expected)))
    print("Actual   : ", end="")
    for input_, expected_output in zip(inputs, expected):
        siso.send(input_)
        print(f"{siso.O} ", end="")
        assert siso.O == expected_output
