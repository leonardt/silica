import silica as si
py_eval = eval
from silica import coroutine_create, bits, bit, uint, eval
import magma as m
from bit_vector import BitVector
import fault
import functools


SOH = bits(0x01, 8)
EOT = bits(0x04, 8)

MESSAGE_BUFFER_SIZE = 12


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
    message, length, send = yield 0, tx
    for j in range(9):
    # i = bits(0, 4)
    # while i != 9:
        # i = i + 1
        tx = uart.send((value, 0))
        message, length, send = yield 0, tx
    return


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
        # for i in range(0, length):
        i = bits(0, eval(m.bitutils.clog2(MESSAGE_BUFFER_SIZE)))
        while i != length:
            yield from send_byte(uart, bits(i, 8))
            yield from send_byte(uart, ~bits(i, 8))
            checksum = uint(0, 8)
            # for b in range(128):
            b = bits(0, 8)
            while b != bits(128, 8):
                checksum = checksum + message[i][b]
                yield from send_byte(uart, message[i][b])
                b = b + 1
            i = i + 1
            yield from send_byte(uart, checksum)
        yield from send_byte(uart, EOT)


def get_output(xmodem_tx, message, length):
    outputs = []
    for i in range(10):
        idle, tx = xmodem_tx.send((message, length, 0))
        outputs.append(tx)
    assert outputs[0] == 0, "Start bit"
    assert outputs[-1] == 1, "End bit"
    return py_eval("0b" + "".join(str(x) for x in outputs[1:-1]))


def test_xmodem_python():
    xmodem_tx = XModemTx()
    message = si.List(
        si.List(BitVector(i * j + j, 8) for j in range(128))
        for i in range(5)
    )
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
    assert py_eval("0b" + "".join(str(x) for x in outputs[1:-1])) == SOH
    for i in range(5):
        assert i == get_output(xmodem_tx, message, len(message)), "Packet number"
        assert ~bits(i, 8) == get_output(xmodem_tx, message, len(message)), "Complement"
        checksum = bits(0, 8)
        for j in range(128):
            assert BitVector(i * j + j, 8) == get_output(xmodem_tx, message, len(message)), (i, j)
            checksum += BitVector(i * j + j, 8)
        assert checksum == get_output(xmodem_tx, message, len(message)), (i, j)
    assert EOT == get_output(xmodem_tx, message, len(message)), (i, j)


class XModemTester(fault.Tester):
    def send(self, message, length, send):
        self.poke(self.circuit.message, message)
        self.poke(self.circuit.length, length)
        self.poke(self.circuit.send, send)
        self.step(2)

    def expect_packet(self, value):
        for expected in [0] + m.bitutils.int2seq(value) + [1]:
            self.step(2)
            self.expect(self.circuit.tx, expected)

def test_xmodem_silica():
    xmodem_tx = XModemTx()
    si_xmodem_tx = si.compile(xmodem_tx, "tests/build/si_xmodem.v")
    message = functools.reduce(lambda x, y: x.concat(x, y),
        (BitVector(i * j + j, 8) for j in range(128) for i in range(5)))
    message = BitVector(message, (MESSAGE_BUFFER_SIZE - 5) * 128 * 8 + message.num_bits)
    print(len(message))
    outputs = []
    tester = XModemTester(si_xmodem_tx, si_xmodem_tx.CLK)
    tester.send(message, len(message), 0)
    tester.expect(si_xmodem_tx.idle, 1)
    tester.send(message, len(message), 1)
    tester.expect(si_xmodem_tx.idle, 0)
    tester.expect(si_xmodem_tx.tx, 0)
    for expected in m.bitutils.int2seq(SOH) + [1]:
        tester.send(message, len(message), 0)
        tester.expect(si_xmodem_tx.tx, expected)
    for i in range(5):
        tester.expect_packet(i)
        tester.expect_packet(~bits(i, 8))
        checksum = bits(0, 8)
        for j in range(128):
            tester.expect_packet(BitVector(i * j + j, 8))
            checksum += BitVector(i * j + j, 8)
        tester.expect_packet(checksum)
    tester.expect_packet(EOT)
    tester.compile_and_run(target="verilator", directory="tests/build",
                           flags=['-Wno-fatal'])
