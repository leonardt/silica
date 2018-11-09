import silica as si
py_eval = eval
from silica import coroutine_create, bits, bit, uint, eval
import magma as m
from bit_vector import BitVector
import fault
import functools


SOH = bits(0x01, 8)
EOT = bits(0x04, 8)
ACK = bits(0x06, 8)
NAK = bits(0x15, 8)
C = bits(0x43, 8)

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
def send_byte(uart, value) -> {"tx": si.Bit}:
    tx = uart.send((value, 1))
    message, length, send = yield tx
    for j in range(9):
        tx = uart.send((value, 0))
        message, length, send = yield tx
    return


@si.generator
def send_message(data_num : si.Bits(8), data: si.Bits(8)) 
    -> {"data_addr" : si.Bits(8),"byte_addr": si.Bits(7)}:
    uart_t = coroutine_create(uart_tx)
    yield from send_byte(uart_t, SOH)
    yield from send_byte(uart_t, data_num)
    yield from send_byte(uart_t, ~data_num)
    checksum = uint(0, 8)
    b = bits(0, 8)
    while b != bits(128, 8):
        checksum = checksum + data
        yield from send_byte(uart, data)
        b = b + 1
    yield from send_byte(uart, checksum)
    yield from send_byte(uart, EOT)
    return

@si.coroutine
def uart_rx(rx : si.Bit) -> {"valid" : si.Bit, "data": si.Bits(8)}:
    rx = yield
    while (True):
        data = bits(0,8)
        while (rx):
            rx = yield 0, data 
        for i in range(8):
            rx = yield 0, data 
            data[i] = rx
        rx = yield 1, data
        #assert rx == 1 TODO it would be cool to add in assertions that would materialize somehow

#This should either receiver a byte or time out
MAX_TIME = bits(1<<16-1,16)
@si.generator
def receive_byte() -> {}
    uart_r = coroutine_create(uart_rx)
    valid,data = uart_r.send(rx)
    yield
    #assert !valid
    timeout_cnt = bits(0,16)
    rx = yield 
    while (!valid and timout_cnt != MAX_TIME):
        valid,data = uart_r.send(rx)
        rx = yield
    return timeout_cnt==MAX_TIME, data


@si.coroutine
def xmodem_host(send : si.Bit, data_len : si.Bits(10), data_byte : si.Bits(8), rx : si.Bit) 
    -> {"data_addr" : si.Bits(10),"byte_addr": si.Bits(7), "done": si.Bit, "tx": si.Bit}:
    send, data_len, _,_ = yield 
    while True:
        #Wait for host to decide to send
        while(!send):
            send,data_len,_,_ = yield 0,0,0,1
        #Wait for client to be ready
        timeout, response = yield from receive_byte()
        while (timeout or response!= C)
            timeout,response = yield from receive_byte() 
        #Send all data
        i = bits(0,10)
        while i != data_len:
            yield from send_message(i,data)
            timeout,response = yield from receive_byte()
            if timeout or response == NAK:
                continue
            elif response == ACK:
                i = i + 1
            #assert resposne == NAK
        #Send done bit
        send,data_len,_,_ = yield 0,0,1,1


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
