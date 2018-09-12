import silica as si
from silica import coroutine, uint, Bit, BitVector, compile, Array, Bits, bits
import pytest
import shutil
from common import evaluate_circuit
import magma as m
import fault


@coroutine(inputs={"I0" : Bits(16), "I1" : Bits(16), "I2" : Bits(16), "I3" : Bits(16)})
def Serializer4():
    data = [bits(0, 16) for _ in range(3)]
    I0, I1, I2, I3 = yield
    while True:
        O = I0
        # data = I[1:]
        data[0] = I1
        data[1] = I2
        data[2] = I3
        I0, I1, I2, I3 = yield O
        for i in range(3):
            O = data[i]
            I0, I1, I2, I3 = yield O


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

def test_ser3():
    ser = Serializer4()
    shutil.copy("verilog/serializer.v", "tests/build/serializer_verilog.v")
    serializer_verilog = \
        m.DefineFromVerilogFile("tests/build/serializer_verilog.v",
                                type_map={"CLK": m.In(m.Clock)})[0]
    tester = fault.Tester(serializer_verilog, serializer_verilog.CLK)
    for I in inputs:
        for j in range(len(I)):
            tester.poke(getattr(serializer_verilog, f"I{j}"), I[j])
        tester.step(2)
        ser.send(I)
        assert ser.O == I[0]
        tester.expect(serializer_verilog.O, I[0])
        for i in range(3):
            for j in range(len(I)):
                tester.poke(getattr(serializer_verilog, f"I{j}"), I[j])
            tester.step(2)
            ser.send([0,0,0,0])
            assert ser.O == I[i + 1]
            tester.expect(serializer_verilog.O, I[i + 1])
    tester.compile_and_run(target="verilator", directory="tests/build",
                           flags=['-Wno-fatal'])

    # serializer_si = si.compile(ser, "tests/build/serializer_si.v")

    print("===== BEGIN : VERILOG RESULTS =====")
    evaluate_circuit("serializer_verilog", "serializer")
    print("===== END   : VERILOG RESULTS =====")
    assert False
