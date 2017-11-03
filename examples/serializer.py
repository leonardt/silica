from silica import coroutine, uint, Bit, BitVector, compile


#strange initialization of input
@coroutine(inputs={"I" : [BitVector(0,16) for i in range(3)]})
def Serializer3():
    data = [uint(0,16) for i in range(3)]
    cnt = 2
    while True:
        O = data[cnt]
        I = yield O
        data = I
        cnt = 0
        O = data[cnt]
        yield O
        cnt = 1
        O = data[cnt]
        yield O
        cnt = 2
        O = data[cnt]

if __name__ == "__main__":
    ser = Serializer3()
    for I in [[4,5,6],[10,16,8]]:
      ser.send(I)
      print(f"O={ser.O}")
      next(ser)
      print(f"O={ser.O}")
      next(ser)
      print(f"O={ser.O}")

    compile(ser, file_name="detect.magma.py")
