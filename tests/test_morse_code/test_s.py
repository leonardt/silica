from test_dot import Dot
from test_dash import Dash
from test_space import Space

import silica as si
from silica import bit, Bit, coroutine_create
import fault
import magma as m
from tests.common import evaluate_circuit
import shutil
from bit_vector import BitVector
import pytest

@si.coroutine
def S(I: Bit) -> {"cb": si.Bit, "is_": si.Bit}:
    dot = coroutine_create(Dot)
    dash = coroutine_create(Dash)
    space = coroutine_create(Space)
    I = yield
    while True:
        dot.send(I)
        dash.send(I)
        space.send(I)
        space_is = space.is_
        if space_is:
            while True:
                while True:
                    cb = bit(1)
                    is_ = bit(0)
                    I = yield cb, is_
                    dot.send(I)
                    dash.send(I)
                    space.send(I)
                    dot_cb = dot.cb
                    space_is = space.is_
                    if ~(dot_cb | space_is):
                        break
                dot_is = dot.is_
                if ~dot_is:
                    continue
                while True:
                    cb = bit(1)
                    is_ = bit(0)
                    I = yield cb, is_
                    dot.send(I)
                    dash.send(I)
                    space.send(I)
                    dot_is = dot.is_
                    dot_cb = dot.cb
                    if dot_is | ~dot_cb:
                        break
                dot_is = dot.is_
                if ~dot_is:
                    continue
                while True:
                    cb = bit(1)
                    is_ = bit(0)
                    I = yield cb, is_
                    dot.send(I)
                    dash.send(I)
                    space.send(I)
                    dot_is = dot.is_
                    dot_cb = dot.cb
                    if dot_is | ~dot_cb:
                        break
                dot_is = dot.is_
                if ~dot_is:
                    continue
                while True:
                    cb = bit(1)
                    is_ = bit(0)
                    I = yield cb, is_
                    dot.send(I)
                    dash.send(I)
                    space.send(I)
                    space_cb = space.cb
                    space_is = space.is_
                    if ~space_cb | space_is:
                        break
                space_is = space.is_
                if ~space_is:
                    break
                is_ = bit(1)
                cb = bit(0)
                I = yield cb, is_
        cb = bit(0)
        is_ = bit(0)
        I = yield cb, is_


@pytest.mark.skip("Broken after sub coroutine mux changes")
def test_s():
    detect_s = S()
    si_detect_s = si.compile(detect_s, file_name="tests/build/si_detect_s.v")
    # si_detect_s = m.DefineFromVerilogFile("tests/build/si_detect_s.v",
    #                                       type_map={"CLK": m.In(m.Clock)},
    #                                       module="S")
    tester = fault.Tester(si_detect_s, si_detect_s.CLK)
    for i in range(2):
        detect_s.send(BitVector(0, 1))
        detect_s.send(BitVector(0, 1))
        detect_s.send(BitVector(0, 1))
        assert detect_s.cb == 1
        detect_s.send(BitVector(1, 1))
        detect_s.send(BitVector(0, 1))
        assert detect_s.cb == 1
        detect_s.send(BitVector(1, 1))
        detect_s.send(BitVector(0, 1))
        assert detect_s.cb == 1
        detect_s.send(BitVector(1, 1))
        detect_s.send(BitVector(0, 1))
        assert detect_s.cb == 1
        detect_s.send(BitVector(0, 1))
        detect_s.send(BitVector(0, 1))
        assert detect_s.cb == 0
        assert detect_s.is_ == 1

    tester.step(1)
    for i in range(2):
        tester.poke(si_detect_s.I, False)
        tester.step(2)
        tester.poke(si_detect_s.I, False)
        tester.step(2)
        tester.poke(si_detect_s.I, False)
        tester.step(2)
        tester.expect(si_detect_s.cb, 1)
        tester.poke(si_detect_s.I, True)
        tester.step(2)
        tester.poke(si_detect_s.I, False)
        tester.step(2)
        tester.expect(si_detect_s.cb, 1)
        tester.poke(si_detect_s.I, True)
        tester.step(2)
        tester.poke(si_detect_s.I, False)
        tester.step(2)
        tester.expect(si_detect_s.cb, 1)
        tester.poke(si_detect_s.I, True)
        tester.step(2)
        tester.poke(si_detect_s.I, False)
        tester.step(2)
        tester.expect(si_detect_s.cb, 1)
        tester.poke(si_detect_s.I, False)
        tester.step(2)
        tester.poke(si_detect_s.I, False)
        tester.step(2)
        tester.poke(si_detect_s.I, False)
        tester.step(2)
        tester.expect(si_detect_s.cb, 0)
        tester.expect(si_detect_s.is_, 1)

    tester.compile_and_run(target="verilator", directory="tests/build",
                           flags=['-Wno-fatal', '--trace'])

    # verilog_dot = m.DefineFromVerilogFile("verilog/dot.v", type_map={"CLK": m.In(m.Clock)})[0]
    # verilog_tester = tester.retarget(verilog_dot, verilog_dot.CLK)
    # verilog_tester.compile_and_run(target="verilator", directory="tests/build",
    #                               flags=['-Wno-fatal'])
    # if __name__ == '__main__':
    #     print("===== BEGIN : SILICA RESULTS =====")
    #     evaluate_circuit("si_dot", "Dot")
    #     print("===== END   : SILICA RESULTS =====")
    #     print("===== BEGIN : VERILOG RESULTS =====")
    #     shutil.copy("verilog/dot.v", "tests/build/vdot.v")
    #     evaluate_circuit("vdot", "vdot")
    #     print("===== END   : VERILOG RESULTS =====")

# if __name__ == '__main__':
    # test_dot()
