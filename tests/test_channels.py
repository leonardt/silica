import silica as si
from silica import bits


@si.coroutine
def Downsample(data_in: si.Channel(si.Bits[16])) -> \
        {"data_out": si.Channel(si.Bits[16])}:
    data_in = yield
    while True:
        for y in range(32):
            for x in range(32):
                data = data_in.pop()
                if ((x % bits(2, 5)) == 0) & ((y % bits(2, 5)) == 0):
                    data_out.push(data)
                data_in = yield data_out

magma_downsample = si.compile(Downsample(),
                              file_name="tests/build/channel_downsample")
