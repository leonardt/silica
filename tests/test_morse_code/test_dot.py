import silica as si
from silica import bit, Bit
import fault
import magma as m
from tests.common import evaluate_circuit
import shutil
import pytest


@si.coroutine
def Dot(I: Bit) -> {"cb": Bit, "is_": Bit}:
    I = yield
    while True:
        if I:
            cb = bit(1)
            is_ = bit(0)
            I = yield cb, is_
            if ~I:
                cb = bit(0)
                is_ = bit(1)
            else:
                while True:
                    cb = bit(0)
                    is_ = bit(0)
                    I = yield cb, is_
                    if ~I:
                        cb = bit(0)
                        is_ = bit(0)
                        break
        else:
            cb = bit(0)
            is_ = bit(0)
        I = yield cb, is_


@pytest.mark.parametrize("strategy", ["by_path", "by_statement"])
def test_dot(strategy):
    dot = Dot()
    si_dot = si.compile(dot, file_name="tests/build/si_dot.v", strategy=strategy)
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
        assert dot.is_ == 0
        dot.send(False)
        assert dot.cb == 0
        assert dot.is_ == 0

    for i in range(2):
        tester.poke(si_dot.I, True)
        tester.eval()
        tester.expect(si_dot.cb, 1)
        tester.step(2)
        tester.poke(si_dot.I, False)
        tester.eval()
        tester.expect(si_dot.cb, 0)
        tester.expect(si_dot.is_, 1)
        tester.step(2)
        tester.poke(si_dot.I, False)
        tester.eval()
        tester.expect(si_dot.cb, 0)
        tester.expect(si_dot.is_, 0)
        tester.step(2)
        tester.poke(si_dot.I, False)
        tester.eval()
        tester.expect(si_dot.cb, 0)
        tester.expect(si_dot.is_, 0)
        tester.step(2)

    tester.compile_and_run(target="verilator", directory="tests/build",
                           flags=['-Wno-fatal'], magma_output="verilog")

    verilog_dot = m.DefineFromVerilogFile("verilog/dot.v",
                                          type_map={"CLK": m.In(m.Clock), "RESET": m.In(m.Reset)})[0]
    verilog_tester = tester.retarget(verilog_dot, verilog_dot.CLK)
    verilog_tester.compile_and_run(target="verilator", directory="tests/build",
                                   flags=['-Wno-fatal'],
                                   magma_output="verilog")
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
