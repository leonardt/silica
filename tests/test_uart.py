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


def concat(*args):
    result = []
    for arg in args:
        if isinstance(arg, list):
            result += arg
        elif isinstance(arg, silica.BitVector):
            result += arg.as_bool_list()
    return silica.BitVector(result)

@silica.coroutine
def UART_TX():
    message = [bits(0xDE, 8), bits(0xAD, 8), bits(0xBE, 8), bits(0xEF, 8)]
    piso = DefinePISO(10)()
    while True:
        for byte in message:
            O = piso.send((concat([False], byte, [True]), 0, 1))
            yield O
            for i in range(10):
                O = piso.send((concat([False], byte, [True]), 0, 0))
                yield O

def test_UART():
    uart_tx = UART_TX()
    for i in range(4):
        next(uart_tx)
        message = []
        for j in range(10):
            message.insert(0, uart_tx.O)
            next(uart_tx)
        # print(message)
        assert message[-1] == 1
        assert message[0] == 0
        assert seq2int(message[1:-1]) == [0xDE, 0xAD, 0xBE, 0xEF][i]
        # print(f"{seq2int(message[1:-1]):X}")

    # magma_piso = silica.compile(piso, "piso_magma.py")
    # check(magma_piso, DefinePISO(10)(), 20, inputs_generator(message))
