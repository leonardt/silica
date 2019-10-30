import pytest
import magma as m
from silica import Bit, coroutine, Bits, generator, compile, bit, \
    Register
import fault
from tests.common import evaluate_circuit


TEST_LOGIC_RESET = 15
RUN_TEST_IDLE = 12
SELECT_DR_SCAN = 7
CAPTURE_DR = 6
SHIFT_DR = 2
EXIT1_DR = 1
PAUSE_DR = 3
EXIT2_DR = 0
UPDATE_DR = 5
SELECT_IR_SCAN = 4
CAPTURE_IR = 14
SHIFT_IR = 10
EXIT1_IR = 9
PAUSE_IR = 11
EXIT2_IR = 8
UPDATE_IR = 13


@generator
def Scan(capture, shift, exit_1, pause, exit_2, update):
    tms = yield capture
    while True:
        if (tms == 0):
            while tms == 0:
                tms = yield shift
        tms = yield exit_1
        if tms == 0:
            while tms == 0:
                tms = yield pause
            tms = yield exit_2
            if tms != 0:
                break
        else:
            break
    tms = yield update
    return tms


@coroutine
def SilicaJTAG(tms: Bit) -> {"state": Register(Bits[4])}:
    while True:
        while True:
            tms = yield TEST_LOGIC_RESET
            if tms == 0:
                break
        while tms == 0:
            tms = yield RUN_TEST_IDLE
        while tms == 1:
            tms = yield SELECT_DR_SCAN
            if tms == 0:
                # dr
                tms = yield from Scan(CAPTURE_DR, SHIFT_DR, EXIT1_DR, PAUSE_DR,
                                      EXIT2_DR, UPDATE_DR)
            else:
                tms = yield SELECT_IR_SCAN
                if tms == 0:
                    # ir
                    tms = yield from Scan(CAPTURE_IR, SHIFT_IR, EXIT1_IR,
                                          PAUSE_IR, EXIT2_IR, UPDATE_IR)
                else:
                    break


@pytest.mark.parametrize("strategy", ["by_path", "by_statement"])
def test_jtag(strategy):
    silica_jtag = SilicaJTAG()
    circ = compile(silica_jtag, file_name="si_tap.v", strategy=strategy)
    tester = fault.Tester(circ, circ.CLK)
    tester.circuit.tms = 1
    tester.circuit.RESET = 0
    tester.eval()
    tester.circuit.RESET = 1
    tester.eval()
    tester.circuit.RESET = 0
    tester.eval()
    tester.step(2)
    tester.circuit.state.expect(TEST_LOGIC_RESET)
    tester.circuit.tms = 1
    tester.step(2)
    tester.circuit.state.expect(TEST_LOGIC_RESET)

    tester.circuit.tms = 0
    tester.step(2)
    tester.circuit.state.expect(RUN_TEST_IDLE)

    tester.step(2)
    tester.circuit.state.expect(RUN_TEST_IDLE)

    tester.circuit.tms = 1
    tester.step(2)
    tester.circuit.state.expect(SELECT_DR_SCAN)

    tester.circuit.tms = 0
    tester.step(2)
    tester.circuit.state.expect(CAPTURE_DR)

    tester.circuit.tms = 1
    tester.step(2)
    tester.circuit.state.expect(EXIT1_DR)

    tester.circuit.tms = 0
    tester.step(2)
    tester.circuit.state.expect(PAUSE_DR)

    tester.circuit.tms = 0
    tester.step(2)
    tester.circuit.state.expect(PAUSE_DR)

    tester.circuit.tms = 1
    tester.step(2)
    tester.circuit.state.expect(EXIT2_DR)

    tester.circuit.tms = 0
    tester.step(2)
    tester.circuit.state.expect(SHIFT_DR)

    tester.circuit.tms = 0
    tester.step(2)
    tester.circuit.state.expect(SHIFT_DR)

    tester.circuit.tms = 0
    tester.step(2)
    tester.circuit.state.expect(SHIFT_DR)

    tester.circuit.tms = 1
    tester.step(2)
    tester.circuit.state.expect(EXIT1_DR)

    tester.circuit.tms = 1
    tester.step(2)
    tester.circuit.state.expect(UPDATE_DR)

    tester.circuit.tms = 1
    tester.step(2)
    tester.circuit.state.expect(SELECT_DR_SCAN)

    tester.circuit.tms = 1
    tester.step(2)
    tester.circuit.state.expect(SELECT_IR_SCAN)

# BEGIN REPEAT FOR IR
    tester.circuit.tms = 0
    tester.step(2)
    tester.circuit.state.expect(CAPTURE_IR)

    tester.circuit.tms = 1
    tester.step(2)
    tester.circuit.state.expect(EXIT1_IR)

    tester.circuit.tms = 0
    tester.step(2)
    tester.circuit.state.expect(PAUSE_IR)

    tester.circuit.tms = 0
    tester.step(2)
    tester.circuit.state.expect(PAUSE_IR)

    tester.circuit.tms = 1
    tester.step(2)
    tester.circuit.state.expect(EXIT2_IR)

    tester.circuit.tms = 0
    tester.step(2)
    tester.circuit.state.expect(SHIFT_IR)

    tester.circuit.tms = 0
    tester.step(2)
    tester.circuit.state.expect(SHIFT_IR)

    tester.circuit.tms = 0
    tester.step(2)
    tester.circuit.state.expect(SHIFT_IR)

    tester.circuit.tms = 1
    tester.step(2)
    tester.circuit.state.expect(EXIT1_IR)

    tester.circuit.tms = 1
    tester.step(2)
    tester.circuit.state.expect(UPDATE_IR)
# END REPEAT FOR IR

    tester.circuit.tms = 1
    tester.step(2)
    tester.circuit.state.expect(SELECT_DR_SCAN)

    tester.circuit.tms = 1
    tester.step(2)
    tester.circuit.state.expect(SELECT_IR_SCAN)

    tester.circuit.tms = 1
    tester.step(2)
    tester.circuit.state.expect(TEST_LOGIC_RESET)

    flags = []
    # if strategy == "by_statement":
    # flags += ["-Wno-fatal"]
    tester.compile_and_run("verilator", magma_output="verilog", flags=flags,
                           directory="tests/build")
    ref = m.DefineFromVerilogFile("jtag/reference.v",
                                  type_map={"CLK": m.In(m.Clock),
                                            "RESET": m.In(m.Reset)})[0]

    ref_tester = tester.retarget(ref, ref.CLK)
    ref_tester.compile_and_run("verilator", magma_output="verilog",
                               directory="tests/build")

    chisel_ref = m.DefineFromVerilogFile("jtag/chisel.v",
                                         type_map={"clk": m.In(m.Clock),
                                                   "reset": m.In(m.Reset)},
                                         target_modules=["chisel_JtagStateMachine"])[0]

    class ChiselWrapper(m.Circuit):
        IO = ["CLK", m.In(m.Clock), "tms", m.In(m.Bit), "state", m.Out(m.Bits[4]),
              "RESET", m.In(m.Reset)]
        @classmethod
        def definition(io):
            fsm = chisel_ref()
            fsm.clock <= io.CLK
            fsm.reset <= io.RESET
            fsm.io_tms <= io.tms
            io.state <= fsm.io_currState


    chisel_tester = tester.retarget(ChiselWrapper, ChiselWrapper.CLK)
    chisel_tester.compile_and_run("verilator", magma_output="verilog",
                                  directory="tests/build")

    if __name__ == '__main__':
        print("===== BEGIN : SILICA RESULTS =====")
        evaluate_circuit("SilicaJTAG", "SilicaJTAG")
        print("===== END   : SILICA RESULTS =====")
        import shutil
        shutil.copy('jtag/reference.v', 'tests/build/verilog_jtag.v')
        print("===== BEGIN : VERILOG RESULTS =====")
        evaluate_circuit("verilog_jtag", "verilog_jtag")
        print("===== END   : VERILOG RESULTS =====")
        shutil.copy('jtag/chisel.v', 'tests/build/chisel_jtag.v')
        print("===== BEGIN : CHISEL RESULTS =====")
        evaluate_circuit("chisel_jtag", "chisel_JtagStateMachine")
        print("===== END   : CHISEL RESULTS =====")


if __name__ == "__main__":
    import sys
    test_jtag(sys.argv[1])
