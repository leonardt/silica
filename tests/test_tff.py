import pytest
from silica import bit
import silica as si
import magma as m
m.set_mantle_target("ice40")
import fault
from tests.common import evaluate_circuit
from hwtypes import BitVector


def TFF(init=0):
    @si.coroutine
    def tff(I : si.Bit) -> {"O": si.Bit}:
        state = bit(init)
        I = yield
        while True:
            O = state
            state = I ^ state
            I = yield O

    return tff()


@pytest.mark.parametrize("strategy", ["by_path", "by_statement"])
def test_TFF(strategy):
    tff = TFF()
    si_tff = si.compile(tff, file_name="tests/build/si_tff.v",
                        strategy=strategy)
    # si_tff = m.DefineFromVerilogFile("tests/build/si_tff.v",
    #                                  type_map={"CLK": m.In(m.Clock)})[0]
    tester = fault.Tester(si_tff, si_tff.CLK)
    # Should toggle
    for i in range(5):
        tff.send(BitVector[1](1))
        assert tff.O == i % 2
        tester.poke(si_tff.I, 1)
        tester.expect(si_tff.O, i % 2)
        tester.step(2)
    # Should stay high
    for i in range(3):
        tff.send(BitVector[1](0))
        assert tff.O == True
        tester.poke(si_tff.I, 0)
        tester.expect(si_tff.O, 1)
        tester.step(2)

    tester.compile_and_run(target="verilator", directory="tests/build",
                           flags=['-Wno-fatal'], magma_output="verilog")
    from mantle import FF, LUT2, I0, I1
    class MantleTFF(m.Circuit):
        IO = ["I", m.In(m.Bit), "O", m.Out(m.Bit)] + m.ClockInterface()
        @classmethod
        def definition(io):
            tff = FF()
            lut = LUT2( I0^I1 )
            tff(lut)

            m.wire(tff.O, lut.I0)
            m.wire(io.I, lut.I1)
            m.wire(io.O, tff.O)

    mantle_tester = tester.retarget(MantleTFF, MantleTFF.CLK)
    mantle_tester.compile_and_run(target="verilator", directory="tests/build",
                                  flags=['-Wno-fatal'],
                                  include_verilog_libraries=['../cells_sim.v'],
                                  magma_output="verilog")
    if __name__ == '__main__':
        m.compile("tests/build/mantle_tff", MantleTFF)
        print("===== BEGIN : SILICA RESULTS =====")
        evaluate_circuit("si_tff", "tff")
        print("===== END   : SILICA RESULTS =====")
        print("===== BEGIN : MANTLE RESULTS =====")
        evaluate_circuit("mantle_tff", "MantleTFF")
        print("===== END   : MANTLE RESULTS =====")

if __name__ == '__main__':
    import sys
    test_TFF(sys.argv[1])
