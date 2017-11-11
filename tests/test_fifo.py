import silica as si
from silica import bits, uint, list
from magma.testing.coroutine import check

@si.coroutine(inputs={"wdata": si.Bits(4), "wen": si.Bit, "ren": si.Bit})
def Fifo():
    memory = list(bits(0, 4) for i in range(4))
    raddr = uint(0, 2)
    waddr = uint(0, 2)
    prev_empty = True
    prev_full  = False
    wdata, wen, ren = yield
    while True:
        full = prev_full
        empty = prev_empty
        if wen and not prev_full:
            memory[waddr] = wdata
            waddr = waddr + 1
            full = raddr == waddr
            empty = False
        rdata = memory[raddr]
        if ren and not prev_empty:
            raddr = raddr + 1
            empty = raddr == waddr
            full = False
        prev_full = full
        prev_empty = empty
        wdata, wen, ren = yield rdata, empty, full

def test_fifo():
    fifo = Fifo()

    expected_trace = [
        {'wdata': 1, 'wen': 0, 'ren': 1, 'rdata': 0, 'full': False, 'empty': True, 'memory': [0, 0, 0, 0], 'raddr': 0, 'waddr': 0},
        {'wdata': 2, 'wen': 1, 'ren': 0, 'rdata': 2, 'full': False, 'empty': False, 'memory': [2, 0, 0, 0], 'raddr': 0, 'waddr': 1},
        {'wdata': 3, 'wen': 1, 'ren': 1, 'rdata': 2, 'full': False, 'empty': False, 'memory': [2, 3, 0, 0], 'raddr': 1, 'waddr': 2},
        {'wdata': 4, 'wen': 1, 'ren': 0, 'rdata': 3, 'full': False, 'empty': False, 'memory': [2, 3, 4, 0], 'raddr': 1, 'waddr': 3},
        {'wdata': 5, 'wen': 0, 'ren': 1, 'rdata': 3, 'full': False, 'empty': False, 'memory': [2, 3, 4, 0], 'raddr': 2, 'waddr': 3},
        {'wdata': 6, 'wen': 0, 'ren': 1, 'rdata': 4, 'full': False, 'empty': True, 'memory': [2, 3, 4, 0], 'raddr': 3, 'waddr': 3},
        {'wdata': 7, 'wen': 1, 'ren': 0, 'rdata': 7, 'full': False, 'empty': False, 'memory': [2, 3, 4, 7], 'raddr': 3, 'waddr': 0},
        {'wdata': 8, 'wen': 0, 'ren': 1, 'rdata': 7, 'full': False, 'empty': True, 'memory': [2, 3, 4, 7], 'raddr': 0, 'waddr': 0},
        {'wdata': 9, 'wen': 1, 'ren': 1, 'rdata': 9, 'full': False, 'empty': False, 'memory': [9, 3, 4, 7], 'raddr': 0, 'waddr': 1},
        {'wdata': 10, 'wen': 1, 'ren': 0, 'rdata': 9, 'full': False, 'empty': False, 'memory': [9, 10, 4, 7], 'raddr': 0, 'waddr': 2},
        {'wdata': 11, 'wen': 1, 'ren': 0, 'rdata': 9, 'full': False, 'empty': False, 'memory': [9, 10, 11, 7], 'raddr': 0, 'waddr': 3},
        {'wdata': 12, 'wen': 1, 'ren': 0, 'rdata': 9, 'full': True, 'empty': False, 'memory': [9, 10, 11, 12], 'raddr': 0, 'waddr': 0},
        {'wdata': 13, 'wen': 1, 'ren': 0, 'rdata': 9, 'full': True, 'empty': False, 'memory': [9, 10, 11, 12], 'raddr': 0, 'waddr': 0},
        {'wdata': 13, 'wen': 0, 'ren': 1, 'rdata': 9, 'full': False, 'empty': False, 'memory': [9, 10, 11, 12], 'raddr': 1, 'waddr': 0},
        {'wdata': 14, 'wen': 1, 'ren': 1, 'rdata': 10, 'full': False, 'empty': False, 'memory': [14, 10, 11, 12], 'raddr': 2, 'waddr': 1},
]

    inputs = ("wdata", "wen", "ren")
    outputs = ("rdata", "full", "empty")
    states = ("memory", "raddr", "waddr")
    for i, trace in enumerate(expected_trace):
        args = ()
        for input_ in inputs:
            args += (trace[input_], )
        fifo.send(args)
        for output in outputs:
            assert getattr(fifo, output) == trace[output], i
        for state in states:
            assert getattr(fifo, state) == trace[state], i

    @si.coroutine
    def inputs_generator(N):
        while True:
            for trace in expected_trace:
                wdata = bits(trace["wdata"], N)
                wen = bool(trace["wen"])
                ren = bool(trace["ren"])
                yield wdata, wen, ren

    fifo_magma = si.compile(fifo, file_name="fifo_magma.py")
    check(fifo_magma, Fifo(), len(expected_trace), inputs_generator(4))

if __name__ == "__main__":
    test_fifo()
