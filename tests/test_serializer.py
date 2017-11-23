from silica import coroutine, uint, Bit, BitVector, compile, Array, Bits, bits
from magma.testing.coroutine import check
from silica.testing import check_verilog
import pytest
import shutil


@coroutine(inputs={"I" : Array(4, Bits(16))})
def Serializer4():
    data = [bits(0, 16) for _ in range(3)]
    I = yield
    while True:
        O = I[0]
        # data = I[1:]
        for i in range(3):
            data[i] = I[i + 1]
        I = yield O
        for i in range(3):
            O = data[i]
            I = yield O


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
@pytest.fixture
def serializer():
    ser = Serializer4()
    return compile(ser, "build/serializer4_magma.py")

def test_ser3(serializer):
    ser = Serializer4()
    for I in inputs:
      ser.send(I)
      print(ser.O)
      assert ser.O == I[0]
      for i in range(3):
        next(ser)
        print(ser.O)
        assert ser.O == I[i+1]
    # assert False

    print(repr(serializer))
    check(serializer, Serializer4(), 9, inputs_generator(inputs))

@pytest.mark.skipif(shutil.which("verilator") is None, reason="verilator not installed")
def test_verilog(serializer):
    check_verilog("serializer", serializer, Serializer4(), 9, inputs_generator(inputs))
