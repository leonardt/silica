import pytest
import logging
logging.basicConfig(level=logging.DEBUG)
import silica as si
from silica import bit, bits
import fault
from tests.common import evaluate_circuit
import magma as m
m.set_mantle_target("ice40")
import mantle

# @si.coroutine
# def uart_transmitter(data : In(Array(8, Bit)), valid : In(Bit),
#                      tx : Out(Bit)):
#     while True:
#         if valid:
#             tx = 0  # start bit
#             yield
#             for i in range(0, 8):
#                 tx = data[i]
#                 yield
#             tx = 1  # end bit
#             yield
#         else:
#             tx = 1
#             yield


@si.coroutine
def uart_transmitter(data: si.Bits[8], valid: si.Bit) -> \
        {"tx": si.Bit}:
    i = bits(0, 3)
    while True:
        tx = bit(1)
        data, valid = yield tx
        if valid:
            message = data
            tx = bit(0)  # start bit
            data, valid = yield tx
            for i in range(7, -1, -1):
                tx = message[i]
                data, valid = yield tx


@pytest.mark.parametrize("strategy", ["by_path", "by_statement"])
def test_UART(strategy):
    uart = uart_transmitter()
    si_uart = si.compile(uart, "tests/build/si_uart.v", strategy=strategy)
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
        tester.poke(si_uart.data, message)
        tester.poke(si_uart.valid, 1)
        tester.eval()
        # start bit
        tester.expect(si_uart.tx, 0)
        tester.step(2)
        tester.poke(si_uart.data, 0xFF)
        tester.poke(si_uart.valid, 0)

        for i in range(8):
            tester.expect(si_uart.tx, (message >> (7-i)) & 1)
            tester.step(2)
        # end bit
        tester.expect(si_uart.tx, 1)
        tester.step(2)
    print(tester)

    tester.compile_and_run(target="verilator", directory="tests/build",
                           flags=['-Wno-unused', "--trace"],
                           magma_output="verilog")
    verilog_uart = m.DefineFromVerilogFile(
        'verilog/uart.v', type_map={"CLK": m.In(m.Clock), "RESET": m.In(m.Reset)})[0]
    verilog_tester = tester.retarget(verilog_uart, verilog_uart.CLK)

    verilog_tester.compile_and_run(target="verilator", directory="tests/build",
                                   flags=['-Wno-fatal'],
                                   magma_output="verilog")
    if __name__ == '__main__':
        print("===== BEGIN : SILICA RESULTS =====")
        evaluate_circuit("si_uart", "uart_transmitter")
        print("===== END   : SILICA RESULTS =====")
        import shutil
        shutil.copy('verilog/uart.v', 'tests/build/verilog_uart.v')
        print("===== BEGIN : MAGMA RESULTS =====")
        evaluate_circuit("verilog_uart", "uart_tx")
        print("===== END   : MAGMA RESULTS =====")


if __name__ == '__main__':
    import sys
    test_UART(sys.argv[1])
