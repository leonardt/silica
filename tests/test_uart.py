import silica
from silica import bits, Bits, coroutine_create
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


@silica.coroutine(inputs={"message": Bits(8)})
def UART_TX():
    piso = coroutine_create(DefinePISO(8))
    message = yield
    while True:
        O = piso.send((message, 1, 1))
        O = False
        message = yield O
        for j in range(8):
            O = piso.send((message, 1, 0))
            message = yield O
        O = piso.send((message, 1, 0))
        message = yield O

@silica.coroutine
def inputs_generator(messages):
    while True:
        for message in messages:
            message = int2seq(message, 8)
            yield message
            for j in range(9):
                message = int2seq(0, 8)
                yield message


def test_UART():
    messages = [0xDE, 0xAD, 0xBE, 0xEF]
    uart_tx = UART_TX()
    inputs = inputs_generator(messages)
    for i in range(4):
        message = []
        for j in range(10):
            uart_tx.send(inputs.message)
            next(inputs)
            message.insert(0, uart_tx.O)
        print(f"Got      : {seq2int(message[1:-1])}")
        print(f"Expected : {messages[i]}")
        assert message[0] == 1
        assert message[-1] == 0
        assert seq2int(message[1:-1]) == messages[i]
        # print(f"{seq2int(message[1:-1]):X}")

    magma_uart = silica.compile(uart_tx, "uart_magma.py")
    print(repr(magma_uart))
    check(magma_uart, UART_TX(), len(messages) * 10, inputs_generator(messages))
