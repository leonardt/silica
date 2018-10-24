import silica as si
from silica import bit, Bit
import fault
import magma as m
from tests.common import evaluate_circuit
import shutil


@si.coroutine
def Dash(I: Bit) -> {"cb": Bit, "is_": Bit}:
    I = yield
    while True:
        if I:
            cb = bit(1)
            is_ = bit(0)
            I = yield cb, is_
            if I:
                cb = bit(1)
                is_ = bit(0)
                I = yield cb, is_
                if I:
                    cb = bit(1)
                    is_ = bit(0)
                    I = yield cb, is_
                    if ~I:
                        cb = bit(0)
                        is_ = bit(1)
                        I = yield cb, is_
                    else:
                        while True:
                            cb = bit(0)
                            is_ = bit(0)
                            I = yield cb, is_
                            if ~I:
                                break
        cb = bit(0)
        is_ = bit(0)
        I = yield cb, is_
        # if ~I:
        #     continue
        # cb = bit(1)
        # is_ = bit(0)
        # I = yield cb, is_
        # if ~I:
        #     continue
        # cb = bit(1)
        # is_ = bit(0)
        # I = yield cb, is_
        # if ~I:
        #     continue
        # cb = bit(1)
        # is_ = bit(0)
        # I = yield cb, is_
        # if ~I:
        #     cb = bit(0)
        #     is_ = bit(1)
        #     I = yield cb, is_
        # else:
        #     while True:
        #         cb = bit(0)
        #         is_ = bit(0)
        #         I = yield cb, is_
        #         if ~I:
        #             break
        # cb = bit(0)
        # is_ = bit(0)
        # I = yield cb, is_


def test_dash():
    dash = Dash()
    si_dash = si.compile(dash, file_name="tests/build/si_dash.v")
    # si_dash = m.DefineFromVerilogFile("tests/build/si_dash.v",
    #                                  type_map={"CLK": m.In(m.Clock)})[0]
    tester = fault.Tester(si_dash, si_dash.CLK)
    for i in range(2):
        dash.send(True)
        assert dash.cb == 1
        dash.send(True)
        assert dash.cb == 1
        dash.send(True)
        assert dash.cb == 1
        dash.send(False)
        assert dash.cb == 0
        assert dash.is_ == 1
        dash.send(False)
        assert dash.cb == 0
        assert dash.is_ == 0

    for i in range(2):
        tester.poke(si_dash.I, True)
        tester.step(1)
        tester.expect(si_dash.cb, 1)
        tester.step(1)
        tester.poke(si_dash.I, True)
        tester.step(1)
        tester.expect(si_dash.cb, 1)
        tester.step(1)
        tester.poke(si_dash.I, True)
        tester.step(1)
        tester.expect(si_dash.cb, 1)
        tester.step(1)
        tester.poke(si_dash.I, False)
        tester.step(1)
        tester.expect(si_dash.cb, 0)
        tester.expect(si_dash.is_, 1)
        tester.step(1)
        tester.poke(si_dash.I, False)
        tester.step(1)
        tester.expect(si_dash.cb, 0)
        tester.expect(si_dash.is_, 0)
        tester.step(1)

    tester.compile_and_run(target="verilator", directory="tests/build",
                           flags=['-Wno-fatal'])

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
