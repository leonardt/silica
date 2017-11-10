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

silica.compile(DefinePISO(10)(), "build/piso_silica.py")
