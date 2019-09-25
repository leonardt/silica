import silica as si
from silica import coroutine, uint, Bit, BitVector, compile, Array, Bits, \
    bits, memory
import pytest
import shutil
from tests.common import evaluate_circuit
import magma as m
import fault


@coroutine
def Serializer4(I0: Bits[16], I1: Bits[16], I2: Bits[16], I3: Bits[16]) -> \
        {"O": si.Bits[16]}:
    i = bits(0, 2)
    data = memory(3, 16)
    I0, I1, I2, I3 = yield
    while True:
        if i == 0:
            O = I0
            data[0] = I1
            data[1] = I2
            data[2] = I3
        else:
            O = data[i - 1]
        i = i + bits(1, 2)
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


inputs = [[4, 5, 6, 7], [10, 16, 8, 3]]


@pytest.mark.parametrize("strategy", ["by_path", "by_statement"])
def test_ser4(strategy):
    ser = Serializer4()
    serializer_si = si.compile(ser, "tests/build/serializer_si.v",
                               strategy=strategy)
    # serializer_si = m.DefineFromVerilogFile("tests/build/serializer_si.v",
    #                             type_map={"CLK": m.In(m.Clock)})[0]
    tester = fault.Tester(serializer_si, serializer_si.CLK)
    for I in inputs:
        # tester.poke(serializer_si.valid, 1)
        for j in range(len(I)):
            tester.poke(getattr(serializer_si, f"I{j}"), I[j])
        tester.eval()
        # ser.send([1] + I)
        ser.send(I)
        assert ser.O == I[0]
        tester.print("serializer_si.O=%d", serializer_si.O)
        tester.expect(serializer_si.O, I[0])
        tester.step(2)
        for i in range(3):
            # tester.poke(serializer_si.valid, 0)
            for j in range(len(I)):
                tester.poke(getattr(serializer_si, f"I{j}"), 0)
            tester.eval()
            # ser.send([0,0,0,0,0])
            ser.send([0, 0, 0, 0])
            assert ser.O == I[i + 1]
            tester.expect(serializer_si.O, I[i + 1])
            tester.step(2)
    tester.compile_and_run(target="verilator", directory="tests/build",
                           flags=['-Wno-fatal', '--trace'],
                           magma_output="verilog")

    shutil.copy("verilog/serializer.v", "tests/build/serializer_verilog.v")
    serializer_verilog = \
        m.DefineFromVerilogFile("tests/build/serializer_verilog.v",
                                type_map={"CLK": m.In(m.Clock)})[0]

    verilog_tester = tester.retarget(serializer_verilog,
                                     serializer_verilog.CLK)
    verilog_tester.compile_and_run(target="verilator", directory="tests/build",
                                   flags=['-Wno-fatal', '--trace'],
                                   magma_output="verilog")

    if __name__ == '__main__':
        print("===== BEGIN : SILICA RESULTS =====")
        evaluate_circuit("serializer_si", "Serializer4")
        print("===== END   : SILICA RESULTS =====")

        print("===== BEGIN : VERILOG RESULTS =====")
        evaluate_circuit("serializer_verilog", "serializer")
        print("===== END   : VERILOG RESULTS =====")


if __name__ == '__main__':
    test_ser4()
