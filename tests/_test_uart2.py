import magma as m
m.set_mantle_target("ice40")
import mantle
import silica
from silica import bit, bits
import fault
from tests.common import evaluate_circuit

@silica.coroutine
def uart_transmitter(data : silica.Bits(8), valid : silica.Bit) -> {"tx": silica.Bit, "ready": silica.Bit}:
    data, valid = yield
    while True:
        if valid:
            message = data
            tx = bit(0)  # start bit
            ready = bit(0)
            data, valid = yield tx, ready
            i = bits(7, 3)
            # for i in range(7, -1, -1):
            while True:
                tx = message[i]
                ready = bit(0)
                i = i - bits(1, 3)
                data, valid = yield tx, ready
                if i == bits(7, 3):
                    break
            ready = bit(0)
            tx = bit(1)
            data, valid = yield tx, ready
        else:
            ready = bit(1)
            tx = bit(1)
            data, valid = yield tx, ready


def test_UART():
    uart = uart_transmitter()
    si_uart = silica.compile(uart, "tests/build/si_uart2.v")
    # si_uart = m.DefineFromVerilogFile("tests/build/si_uart2.v",
    #                                  type_map={"CLK": m.In(m.Clock)})[0]
    tester = fault.Tester(si_uart, si_uart.CLK)
    tester.step(2)
    for message in [0xDE, 0xAD]:
        tester.step(1)
        tester.expect(si_uart.ready, 1)
        tester.poke(si_uart.data, message)
        tester.poke(si_uart.valid, 1)
        tester.step(2)
        tester.expect(si_uart.tx, 0)
        tester.poke(si_uart.data, 0xFF)
        tester.poke(si_uart.valid, 0)
        tester.expect(si_uart.ready, 0)
        tester.step(1)

        # start bit
        for i in range(8):
            tester.print(si_uart.CLK)
            tester.expect(si_uart.tx, (message >> (7-i)) & 1)
            tester.step(2)
        # end bit
        tester.expect(si_uart.tx, 1)
        tester.step(2)
        tester.expect(si_uart.ready, 1)

    tester.compile_and_run(target="verilator", directory="tests/build",
                           flags=['-Wno-fatal'])
    verilog_uart = m.DefineFromVerilogFile(
        'verilog/uart.v', type_map={'CLK': m.In(m.Clock)})[0]
    verilog_tester = tester.retarget(verilog_uart, verilog_uart.CLK)

    verilog_tester.compile_and_run(target="verilator", directory="tests/build",
                                   flags=['-Wno-fatal'])
    if __name__ == '__main__':
        print("===== BEGIN : SILICA RESULTS =====")
        evaluate_circuit("si_uart2", "uart_transmitter")
        print("===== END   : SILICA RESULTS =====")
        import shutil
        shutil.copy('verilog/uart.v', 'tests/build/verilog_uart.v')
        print("===== BEGIN : MAGMA RESULTS =====")
        evaluate_circuit("verilog_uart", "uart_tx")
        print("===== END   : MAGMA RESULTS =====")

if __name__ == '__main__':
    test_UART()
