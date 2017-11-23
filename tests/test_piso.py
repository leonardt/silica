import silica
from silica import bits
from magma.bitutils import seq2int, int2seq
from magma.testing.coroutine import check


def DefinePISO(n):
    @silica.coroutine(inputs={"PI": silica.Bits(n), "SI": silica.Bit, "LOAD": silica.Bit})
    def PISO():
        values = bits(0, n)
        O = values[-1]
        while True:
            PI, SI, LOAD = yield O
            O = values[-1]
            if LOAD:
                values = PI
            else:
                # values = [SI] + values[:-1]
                for i in range(n - 1, 0, -1):
                    values[i] = values[i - 1]
                values[0] = SI
    return PISO


@silica.coroutine
def inputs_generator(message):
    while True:
        for byte in message:
            PI = [bool(x) for x in [0] + int2seq(byte) + [1]]
            SI = False
            LOAD = True
            yield PI, SI, LOAD
            for i in range(10):
                LOAD = False
                PI = [bool(x) for x in int2seq(0xFF, 10)]
                yield PI, SI, LOAD


def test_PISO():
    piso = DefinePISO(10)()
    message = [0xDE, 0xAD, 0xBE, 0xEF]
    inputs = inputs_generator(message)
    for i in range(len(message)):
        expected_outputs = inputs.PI[:]
        expected_state = inputs.PI[:]
        piso.send((inputs.PI, inputs.SI, inputs.LOAD))
        # print(f"PI={inputs.PI}, SI={inputs.SI}, LOAD={inputs.LOAD}, O={piso.O}, values={piso.values}")
        next(inputs)
        actual_outputs = []
        for i in range(10):
            expected_state = [inputs.SI] + expected_state[:-1]
            piso.send((inputs.PI, inputs.SI, inputs.LOAD))
            assert piso.values == expected_state
            actual_outputs.insert(0, piso.O)
            # print(f"PI={inputs.PI}, SI={inputs.SI}, LOAD={inputs.LOAD}, O={piso.O}, values={piso.values}")
            next(inputs)
        assert actual_outputs == expected_outputs
    magma_piso = silica.compile(piso, "build/piso_magma.py")
    print(repr(magma_piso))
    check(magma_piso, DefinePISO(10)(), 20, inputs_generator(message))
