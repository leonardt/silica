import silica
import magma as m
m.set_mantle_target("ice40")
import fault
from common import evaluate_circuit


@silica.coroutine(inputs={"I": silica.Bit})
def TFF(init=False):
    O = init
    while True:
        I = yield O
        O = I ^ O


def test_TFF():
    tff = TFF()
    si_tff = silica.compile(tff, file_name="tests/build/si_tff.v")
    tester = fault.Tester(si_tff, si_tff.CLK)
    # Should toggle
    for i in range(5):
        assert tff.O == i % 2
        tff.send(True)
        tester.poke(si_tff.I, 1)
        tester.expect(si_tff.O, i % 2)
        tester.step(2)
    # Should stay high
    for i in range(3):
        tff.send(False)
        assert tff.O == True
        tester.poke(si_tff.I, 0)
        tester.expect(si_tff.O, 1)
        tester.step(2)

    tester.compile_and_run(target="verilator", directory="tests/build",
                           flags=['-Wno-fatal'])
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
                                  include_verilog_files=['../cells_sim.v'])
    if __name__ == '__main__':
        m.compile("tests/build/mantle_tff", MantleTFF)
        print("===== BEGIN : SILICA RESULTS =====")
        evaluate_circuit("si_tff", "TFF")
        print("===== END   : SILICA RESULTS =====")
        print("===== BEGIN : MANTLE RESULTS =====")
        evaluate_circuit("mantle_tff", "MantleTFF")
        print("===== END   : MANTLE RESULTS =====")

if __name__ == '__main__':
    test_TFF()
