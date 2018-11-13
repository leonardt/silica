import fault
import silica as si
from silica import bits, Bit, uint, zext, bit
import pytest
import shutil
import magma as m
from tests.common import evaluate_circuit

@si.coroutine
def SIDetect111(I : Bit) -> {"O": si.Bit}:
    cnt = uint(0, 2)
    I = yield
    while True:
        if (I):
            if (cnt<3):
                cnt = cnt+1
        else:
            cnt = 0
        O = (cnt == 3)
        I = yield O

def inputs_generator(inputs):
    @si.coroutine
    def gen():
        while True:
            for i in inputs:
                I = i
                yield I
    return gen()

def test_detect111():
    detect = SIDetect111()
    inputs =  list(map(bool, [1,1,0,1,1,1,0,1,0,1,1,1,1,1,1]))
    outputs = list(map(bool, [0,0,0,0,0,1,0,0,0,0,0,1,1,1,1]))
    si_detect = si.compile(detect, file_name="tests/build/si_detect.v")
    # si_detect = m.DefineFromVerilogFile("tests/build/si_detect.v",
    #                             type_map={"CLK": m.In(m.Clock)})[0]
    tester = fault.Tester(si_detect, si_detect.CLK)
    for i, o in zip(inputs, outputs):
        tester.poke(si_detect.I, i)
        tester.step(1)
        tester.expect(si_detect.O, o)
        assert o == detect.send(i)
        tester.step(1)
    tester.compile_and_run(target="verilator", directory="tests/build",
                           flags=['-Wno-fatal'],
                           include_verilog_libraries=['../cells_sim.v'])

    verilog_detect = m.DefineFromVerilogFile(
        'verilog/detect111.v', type_map={'CLK': m.In(m.Clock)})[0]
    verilog_tester = tester.retarget(verilog_detect, verilog_detect.CLK)

    verilog_tester.compile_and_run(target="verilator", directory="tests/build",
                                   flags=['-Wno-fatal'])
    if __name__ == '__main__':
        print("===== BEGIN : SILICA RESULTS =====")
        evaluate_circuit("si_detect", "SIDetect111")
        print("===== END   : SILICA RESULTS =====")
        import shutil
        shutil.copy('verilog/detect111.v', 'tests/build/verilog_detect.v')
        print("===== BEGIN : VERILOG RESULTS =====")
        evaluate_circuit("verilog_detect", "detect111")
        print("===== END   : VERILOG RESULTS =====")

if __name__ == '__main__':
    test_detect111()
