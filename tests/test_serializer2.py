import silica as si
from silica import coroutine, uint, Bit, BitVector, compile, Array, Bits, bits
import pytest
import shutil
from common import evaluate_circuit
import magma as m
import fault

@coroutine
def Serializer4(I0 : Bits(16), I1 : Bits(16), I2 : Bits(16), I3 : Bits(16)):
    I0, I1, I2, I3 = yield
    while True:
        data = [I0, I1, I2, I3]
        for O in data:
            # yield O
            I0, I1, I2, I3 = yield O

def inputs_generator(inputs):
    @coroutine
    def gen():
        while True:
            for i in inputs:
                I = [BitVector(x, 16) for x in i]
                yield I
                for _ in range(3):
                    I = [BitVector((_ * len(i)) + j, 16) for j in range(len(i))]
                    yield I
    return gen()

inputs = [[4,5,6,7],[10,16,8,3]]

def test_ser4():
    ser = Serializer4()
    serializer2_si = si.compile(ser, "tests/build/serializer2_si.v")
    # serializer2_si = m.DefineFromVerilogFile("tests/build/serializer2_si.v",
    #                             type_map={"CLK": m.In(m.Clock)})[0]
    tester = fault.Tester(serializer2_si, serializer2_si.CLK)
    for I in inputs:
        for j in range(len(I)):
            tester.poke(getattr(serializer2_si, f"I{j}"), I[j])
        tester.step(1)
        ser.send(I)
        assert ser.O == I[0]
        tester.expect(serializer2_si.O, I[0])
        tester.step(1)
        for i in range(3):
            for j in range(len(I)):
                tester.poke(getattr(serializer2_si, f"I{j}"), 0)
            tester.step(1)
            ser.send([0,0,0,0])
            assert ser.O == I[i + 1]
            tester.expect(serializer2_si.O, I[i + 1])
            tester.step(1)
    tester.compile_and_run(target="verilator", directory="tests/build",
                           flags=['-Wno-fatal'])

    shutil.copy("verilog/serializer.v", "tests/build/serializer_verilog.v")
    serializer_verilog = \
        m.DefineFromVerilogFile("tests/build/serializer_verilog.v",
                                type_map={"CLK": m.In(m.Clock)})[0]

    verilog_tester = tester.retarget(serializer_verilog, serializer_verilog.CLK)
    verilog_tester.compile_and_run(target="verilator", directory="tests/build",
                                   flags=['-Wno-fatal'])

    if __name__ == '__main__':
        print("===== BEGIN : SILICA RESULTS =====")
        evaluate_circuit("serializer2_si", "Serializer4")
        print("===== END   : SILICA RESULTS =====")

        print("===== BEGIN : VERILOG RESULTS =====")
        evaluate_circuit("serializer_verilog", "serializer")
        print("===== END   : VERILOG RESULTS =====")

if __name__ == '__main__':
    test_ser4()
