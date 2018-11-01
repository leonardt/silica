from silica import Bit, Bits, coroutine
import silica
import fault
import magma as m
from tests.common import evaluate_circuit

# TIME = 0x1adb
TIME = 0x10

@coroutine
def si_uart_tx(io_enq_valid: Bit, io_enq_bits: Bits(8)) -> {"io_txd": Bit, "io_enq_ready": Bit}:
    io_enq_valid, io_enq_bits = yield
    while True:
        buffer = bits(0b111111111, 9)
        if io_enq_valid:
            buffer[1:9] = io_enq_bits
            buffer[0] = bit(0)
            # for _ in range(10):
            j = bits(10, 4)
            while j != bits(0, 4):
                j = j - bits(1, 4)
                # for i in range(0x10 + 1):
                i = bits(0x10 + 1, 13)
                while i != bits(0, 13):
                    i = i - bits(1, 13)
                    io_txd = buffer[0]
                    io_enq_ready = bit(0)
                    io_enq_valid, io_enq_bits = yield io_txd, io_enq_ready
                    # BUG! This doesn't work
                    # io_enq_valid, io_enq_bits = yield buffer[0], 0
                buffer[0:8] = buffer[1:9]
                buffer[8] = 1
        io_txd = buffer[0]
        io_enq_ready = bit(1)
        io_enq_valid, io_enq_bits = yield io_txd, io_enq_ready

def test_chisel_uart():
    uart = si_uart_tx()
    si_uart = silica.compile(uart, "tests/build/si_chisel_uart.v")
    # si_uart = m.DefineFromVerilogFile(
    #     'tests/build/si_chisel_uart.v', type_map={'CLK': m.In(m.Clock)})[0]
    tester = fault.Tester(si_uart, si_uart.CLK)
    tester.poke(si_uart.RESET, 1)
    tester.step(2)
    tester.poke(si_uart.RESET, 0)
    tester.step(2)
    for message in [0xDE, 0xAD]:
        tester.expect(si_uart.io_enq_ready, 1)
        tester.poke(si_uart.io_enq_bits, message)
        tester.poke(si_uart.io_enq_valid, 1)
        for _ in range(0, TIME + 1):
            tester.step(2)
            tester.expect(si_uart.io_txd, 0)
            tester.expect(si_uart.io_enq_ready, 0)
            tester.poke(si_uart.io_enq_bits, 0xFF)
            tester.poke(si_uart.io_enq_valid, 0)

        for i in range(8):
            break
            for _ in range(0, TIME + 1):
                tester.step(2)
                tester.expect(si_uart.io_txd, (message >> i) & 1)
                tester.expect(si_uart.io_enq_ready, 0)
        break
        for _ in range(0, TIME + 1):
            tester.step(2)
            tester.expect(si_uart.io_txd, 1)
        tester.step(2)
        tester.expect(si_uart.io_enq_ready, 1)

    tester.compile_and_run(target="verilator", directory="tests/build",
                           flags=['-Wno-fatal'])

    chisel_uart = m.DefineFromVerilogFile(
        'chisel/uart.v', type_map={'CLK': m.In(m.Clock)},
        target_modules=["UartTx"])[0]

    chisel_tester = tester.retarget(chisel_uart, chisel_uart.CLK)
    chisel_tester.compile_and_run(target="verilator", directory="tests/build",
                           flags=['-Wno-fatal'])

    if __name__ == '__main__':
        print("===== BEGIN : SILICA RESULTS =====")
        evaluate_circuit("si_chisel_uart", "si_uart_tx")
        print("===== END   : SILICA RESULTS =====")
        import shutil
        shutil.copy('chisel/uart.v', 'tests/build/chisel_uart.v')
        print("===== BEGIN : CHISEL RESULTS =====")
        evaluate_circuit("chisel_uart", "UartTx")
        print("===== END   : CHISEL RESULTS =====")

if __name__ == '__main__':
    test_chisel_uart()
