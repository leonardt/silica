import logging
logging.basicConfig(level=logging.DEBUG)
import fault
import magma as m


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

circ = m.DefineFromVerilogFile("fsm.v", type_map={"CLK": m.In(m.Clock),
                                                  "RESET": m.In(m.Reset)})[0]
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

tester.compile_and_run("verilator", magma_output="verilog")
ref = m.DefineFromVerilogFile("reference.v",
                              type_map={"CLK": m.In(m.Clock),
                                        "RESET": m.In(m.Reset)})[0]

ref_tester = tester.retarget(ref, ref.CLK)
ref_tester.compile_and_run("verilator", magma_output="verilog")

chisel_ref = m.DefineFromVerilogFile("chisel.v",
                                     type_map={"clk": m.In(m.Clock),
                                               "reset": m.In(m.Reset)},
                                     target_modules=["JtagStateMachine"])[0]

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
chisel_tester.compile_and_run("verilator", magma_output="verilog")
