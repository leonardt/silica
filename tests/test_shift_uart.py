import pytest
from silica import bit, bits, coroutine_create
import fault
from tests.common import evaluate_circuit
from tests.test_piso import DefinePISO
import silica as si
import magma as m
m.set_mantle_target("ice40")
import mantle


@si.coroutine
def PISO(PI: si.Bits[9], LOAD: si.Bit) -> {"O": si.Bit}:
    values = bits(0xff, 9)
    # O = values[-1]
    PI, LOAD = yield
    while True:
        if LOAD:
            values = PI
        else:
            # values = [SI] + values[:-1]
            values = (bits(1, 9) | (values << 1))
        O = values[8]
        PI, LOAD = yield O


@si.coroutine
def uart_shift(data: si.Bits[8], valid: si.Bit) -> \
        {"tx": si.Bit, "ready": si.Bit}:
    piso = coroutine_create(PISO)
    data, valid = yield
    while True:
        if valid:
            tx = bit(0)
            ready = bit(0)
            load = bit(1)
            count = bits(0, 4)
            message = data
            tx = piso.send((message, load))
            # for i in range(10):
            while count != bits(10, 4):
                ready = bit(0)
                count = count + bits(1, 4)
                data, valid = yield tx, ready
                load = bit(0)
                message = data
                tx = piso.send((message, load))
        else:
            message = data
            load = bit(0)
            tx = piso.send((message, load))
            ready = bit(1)
            data, valid = yield tx, ready


@pytest.mark.parametrize("strategy", ["by_path", "by_statement"])
def test_UART(strategy):
    uart = uart_shift()
    si_uart = si.compile(uart, "tests/build/si_uart_shift.v",
                         strategy=strategy)
    # si_uart = m.DefineFromVerilogFile("tests/build/si_uart.v",
    #                                  type_map={"CLK": m.In(m.Clock)})[0]
    tester = fault.Tester(si_uart, si_uart.CLK)
    tester.poke(si_uart.RESET, 0)
    tester.eval()
    tester.poke(si_uart.RESET, 1)
    tester.eval()
    tester.poke(si_uart.RESET, 0)
    tester.eval()
    tester.step(2)
    for message in [0xDE, 0xAD]:
        tester.expect(si_uart.ready, 1)
        tester.poke(si_uart.data, message)
        tester.poke(si_uart.valid, 1)
        tester.eval()
        tester.expect(si_uart.tx, 0)
        tester.expect(si_uart.ready, 0)
        tester.step(2)
        tester.poke(si_uart.data, 0xFF)
        tester.poke(si_uart.valid, 0)

        # start bit
        for i in range(8):
            tester.expect(si_uart.tx, (message >> (7-i)) & 1)
            tester.step(2)
        # end bit
        tester.expect(si_uart.tx, 1)
        tester.step(2)
        tester.expect(si_uart.ready, 1)

    tester.compile_and_run(target="verilator", directory="tests/build",
                           flags=['-Wno-fatal', '--trace'],
                           magma_output="verilog")
    verilog_uart = m.DefineFromVerilogFile(
        'verilog/uart.v', type_map={"CLK": m.In(m.Clock), "RESET": m.In(m.Reset)})[0]
    verilog_tester = tester.retarget(verilog_uart, verilog_uart.CLK)

    verilog_tester.compile_and_run(target="verilator", directory="tests/build",
                                   flags=['-Wno-fatal'],
                                   magma_output="verilog")
    if __name__ == '__main__':
        print("===== BEGIN : SILICA RESULTS =====")
        evaluate_circuit("si_uart_shift", "uart_shift")
        print("===== END   : SILICA RESULTS =====")
        import shutil
        shutil.copy('verilog/uart.v', 'tests/build/verilog_uart.v')
        print("===== BEGIN : MAGMA RESULTS =====")
        evaluate_circuit("verilog_uart", "uart_tx")
        print("===== END   : MAGMA RESULTS =====")


if __name__ == '__main__':
    test_UART()
