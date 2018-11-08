import silica as si
from silica import coroutine_create, bits, bit, uint
import magma as m
from bit_vector import BitVector


SOH = bits(0x01, 8)
EOT = bits(0x04, 8)

MESSAGE_BUFFER_SIZE = 64


@si.coroutine
def uart_tx(data : si.Bits(8), valid : si.Bit) -> {"tx": si.Bit}:
    data, valid = yield
    while True:
        if valid:
            message = data
            data, valid = yield bit(0)  # start bit
            for i in range(7, -1, -1):
                data, valid = yield message[i]
            data, valid = yield bit(1)  # end bit
        else:
            data, valid = yield bit(1)


@si.generator
def send_byte(uart, value) -> {"idle": si.Bit, "tx": si.Bit}:
    tx = uart.send((value, 1))
    yield 0, tx
    for i in range(9):
        tx = uart.send((value, 0))
        yield 0, tx


@si.coroutine
def XModemTx(message: si.Array(MESSAGE_BUFFER_SIZE,
                               si.Array(128, si.Bits(8))),
              length: si.Bits(m.bitutils.clog2(MESSAGE_BUFFER_SIZE)),
              send: si.Bit) -> {"idle": si.Bit, "tx": si.Bit}:
    uart = coroutine_create(uart_tx)
    while True:
        message, length, send = yield 1, 1
        if not send: continue
        yield from send_byte(uart, SOH)
        for i in range(0, length):
            yield from send_byte(uart, bits(i, 8))
            yield from send_byte(uart, ~bits(i, 8))
            checksum = uint(0, 8)
            for b in range(128):
                checksum = checksum + message[i][b]
                yield from send_byte(uart, message[i][b])
            yield from send_byte(uart, checksum)
        yield from send_byte(uart, EOT)


def get_output(xmodem_tx, message, length):
    outputs = []
    for i in range(10):
        idle, tx = xmodem_tx.send((message, length, 0))
        outputs.append(tx)
    assert outputs[0] == 0, "Start bit"
    assert outputs[-1] == 1, "End bit"
    return eval("0b" + "".join(str(x) for x in outputs[1:-1]))


def test_xmodem_python():
    xmodem_tx = XModemTx()
    message = [
        [BitVector(i * j + j, 8) for j in range(128)]
        for i in range(5)
    ]
    outputs = []
    idle, tx = xmodem_tx.send((message, len(message), 0))
    assert xmodem_tx.idle == 1, "Should start idle"
    idle, tx = xmodem_tx.send((message, len(message), 1))
    assert idle == 0, "Should start sending"
    outputs.append(tx)
    for i in range(9):
        idle, tx = xmodem_tx.send((message, len(message), 0))
        outputs.append(tx)
    assert outputs[0] == 0, "Start bit"
    assert outputs[-1] == 1, "End bit"
    assert eval("0b" + "".join(str(x) for x in outputs[1:-1])) == SOH
    for i in range(5):
        assert i == get_output(xmodem_tx, message, len(message)), "Packet number"
        assert ~bits(i, 8) == get_output(xmodem_tx, message, len(message)), "Complement"
        checksum = bits(0, 8)
        for j in range(128):
            assert BitVector(i * j + j, 8) == get_output(xmodem_tx, message, len(message)), (i, j)
            checksum += BitVector(i * j + j, 8)
        assert checksum == get_output(xmodem_tx, message, len(message)), (i, j)
    assert EOT == get_output(xmodem_tx, message, len(message)), (i, j)
