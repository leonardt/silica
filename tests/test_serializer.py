import silica as si
from silica import coroutine, uint, Bit, BitVector, compile, Array, Bits, bits
import pytest
import shutil
from common import evaluate_circuit
import magma as m
import fault


@coroutine(inputs={"I0" : Bits(16), "I1" : Bits(16), "I2" : Bits(16), "I3" : Bits(16)})
def Serializer4():
    # data = [bits(0, 16) for _ in range(3)]
    data0 = bits(0, 16)
    data1 = bits(0, 16)
    data2 = bits(0, 16)
    # I0, I1, I2, I3 = yield
    I0, I1, I2, I3 = yield
    while True:
        O = I0
        # data = I[1:]
        data0 = I1
        data1 = I2
        data2 = I3
        I0, I1, I2, I3 = yield O
        O = data0
        I0, I1, I2, I3 = yield O
        O = data1
        I0, I1, I2, I3 = yield O
        O = data2
        I0, I1, I2, I3 = yield O
        # for i in range(3):
        #     O = data[i]
        #     I0, I1, I2, I3 = yield O


@coroutine
def inputs_generator(inputs):
    while True:
        for i in inputs:
            I = [BitVector(x, 16) for x in i]
            yield I
            for _ in range(3):
                I = [BitVector((_ * len(i)) + j, 16) for j in range(len(i))]
                yield I

inputs = [[4,5,6,7],[10,16,8,3]]

def test_ser4():
    ser = Serializer4()
    serializer_si = si.compile(ser, "tests/build/serializer_si.v")
    # serializer_si = m.DefineFromVerilogFile("tests/build/serializer_si.v",
    #                             type_map={"CLK": m.In(m.Clock)})[0]
    tester = fault.Tester(serializer_si, serializer_si.CLK)
    for I in inputs:
        for j in range(len(I)):
            tester.poke(getattr(serializer_si, f"I{j}"), I[j])
        tester.step(1)
        ser.send(I)
        assert ser.O == I[0]
        tester.print(serializer_si.O)
        tester.expect(serializer_si.O, I[0])
        tester.step(1)
        for i in range(3):
            for j in range(len(I)):
                tester.poke(getattr(serializer_si, f"I{j}"), 0)
            tester.step(1)
            ser.send([0,0,0,0])
            assert ser.O == I[i + 1]
            tester.expect(serializer_si.O, I[i + 1])
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
        evaluate_circuit("serializer_si", "Serializer4")
        print("===== END   : SILICA RESULTS =====")

        print("===== BEGIN : VERILOG RESULTS =====")
        evaluate_circuit("serializer_verilog", "serializer")
        print("===== END   : VERILOG RESULTS =====")

if __name__ == '__main__':
    test_ser4()
