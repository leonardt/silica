import silica as si
from silica import bit, Bit
import fault
import magma as m
from tests.common import evaluate_circuit
import shutil


@si.coroutine
def Dot(I: Bit):
    I = yield
    while True:
        if I:
            cb = bit(1)
            is_ = bit(0)
            while True:
                I = yield cb, is_
                cb = bit(0)
                is_ = bit(1)
                if I:
                    break
            while True:
                cb = bit(0)
                is_ = bit(0)
                I = yield cb, is_
                if ~I:
                    break
        cb = bit(0)
        is_ = bit(0)
        I = yield cb, is_


def test_dot():
    dot = Dot()
    si_dot = si.compile(dot, file_name="tests/build/si_dot.v")
    # si_dot = m.DefineFromVerilogFile("tests/build/si_dot.v",
    #                                  type_map={"CLK": m.In(m.Clock)})[0]
    tester = fault.Tester(si_dot, si_dot.CLK)
    for i in range(2):
        dot.send(True)
        assert dot.cb == 1
        dot.send(False)
        assert dot.cb == 0
        assert dot.is_ == 1
        dot.send(False)
        assert dot.cb == 0
        assert dot.is_ == 1
        dot.send(True)
        assert dot.cb == 0
        assert dot.is_ == 0
        dot.send(False)
        assert dot.cb == 0
        assert dot.is_ == 0

    for i in range(2):
        tester.poke(si_dot.I, True)
        tester.step(1)
        tester.expect(si_dot.cb, 1)
        tester.step(1)
        tester.poke(si_dot.I, False)
        tester.step(1)
        tester.expect(si_dot.cb, 0)
        tester.expect(si_dot.is_, 1)
        tester.step(1)
        tester.poke(si_dot.I, False)
        tester.step(1)
        tester.expect(si_dot.cb, 0)
        tester.expect(si_dot.is_, 1)
        tester.step(1)
        tester.poke(si_dot.I, True)
        tester.step(1)
        tester.expect(si_dot.cb, 0)
        tester.expect(si_dot.is_, 0)
        tester.step(1)
        tester.poke(si_dot.I, False)
        tester.step(1)
        tester.expect(si_dot.cb, 0)
        tester.expect(si_dot.is_, 0)
        tester.step(1)

    tester.compile_and_run(target="verilator", directory="tests/build",
                           flags=['-Wno-fatal'])

    verilog_dot = m.DefineFromVerilogFile("verilog/dot.v", type_map={"CLK": m.In(m.Clock)})[0]
    verilog_tester = tester.retarget(verilog_dot, verilog_dot.CLK)
    verilog_tester.compile_and_run(target="verilator", directory="tests/build",
                                  flags=['-Wno-fatal'])
    if __name__ == '__main__':
        print("===== BEGIN : SILICA RESULTS =====")
        evaluate_circuit("si_dot", "Dot")
        print("===== END   : SILICA RESULTS =====")
        print("===== BEGIN : VERILOG RESULTS =====")
        shutil.copy("verilog/dot.v", "tests/build/vdot.v")
        evaluate_circuit("vdot", "vdot")
        print("===== END   : VERILOG RESULTS =====")

if __name__ == '__main__':
    test_dot()
