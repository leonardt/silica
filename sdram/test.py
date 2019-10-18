import logging
logging.basicConfig(level=logging.DEBUG)
import fault
import magma as m


circ = m.DefineFromVerilogFile("fsm.v", type_map={"CLK": m.In(m.Clock),
                                                  "RESET": m.In(m.Reset)})[0]
tester = fault.Tester(circ, circ.CLK)
tester.circuit.RESET = 0
tester.eval()
tester.circuit.RESET = 1
tester.eval()
tester.circuit.RESET = 0
tester.eval()
tester.circuit.state.expect(0b01000)
tester.step(2)
tester.circuit.state.expect(0b01001)
tester.step(2)
tester.circuit.state.expect(0b00101)
tester.step(2)
tester.circuit.state.expect(0b01010)
tester.step(2)

tester.compile_and_run("verilator", magma_output="verilog")
