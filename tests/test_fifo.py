import silica as si
from silica import bits, uint, list
from magma.testing.coroutine import check

@si.coroutine(inputs={"wdata": si.Bits(4), "wen": si.Bit, "ren": si.Bit})
def Fifo():
    memory = list(bits(0, 4) for i in range(4))
    raddr = uint(0, 2)
    waddr = uint(0, 2)
    empty = True
    full  = False
    wdata, wen, ren = yield
    while True:
        if wen and not full:
            memory[waddr] = wdata
            waddr += 1
            full = raddr == waddr
            empty = False
        rdata = memory[raddr]
        if ren and not empty:
            raddr += 1
            empty = raddr == waddr
            full = False
        wdata, wen, ren = yield rdata, empty, full

def test_fifo():
    fifo = Fifo()
    wdata = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
    wen =   [0,1,1,1,0,1,1,0,0, 0, 1, 1, 1, 1, 1]
    ren =   [1,1,1,0,1,0,1,1,1, 1, 0, 0, 0, 0, 0]

    expected_trace = [
        {'wdata': 1, 'wen': 0, 'ren': 1, 'rdata': 0, 'full': False, 'empty': True, 'memory': [0, 0, 0, 0], 'raddr': 0, 'waddr': 0},
        {'wdata': 2, 'wen': 1, 'ren': 1, 'rdata': 2, 'full': False, 'empty': True, 'memory': [2, 0, 0, 0], 'raddr': 1, 'waddr': 1},
        {'wdata': 3, 'wen': 1, 'ren': 1, 'rdata': 3, 'full': False, 'empty': True, 'memory': [2, 3, 0, 0], 'raddr': 2, 'waddr': 2},
        {'wdata': 4, 'wen': 1, 'ren': 0, 'rdata': 4, 'full': False, 'empty': False, 'memory': [2, 3, 4, 0], 'raddr': 2, 'waddr': 3},
        {'wdata': 5, 'wen': 0, 'ren': 1, 'rdata': 4, 'full': False, 'empty': True, 'memory': [2, 3, 4, 0], 'raddr': 3, 'waddr': 3},
        {'wdata': 6, 'wen': 1, 'ren': 0, 'rdata': 6, 'full': False, 'empty': False, 'memory': [2, 3, 4, 6], 'raddr': 3, 'waddr': 0},
        {'wdata': 7, 'wen': 1, 'ren': 1, 'rdata': 6, 'full': False, 'empty': False, 'memory': [7, 3, 4, 6], 'raddr': 0, 'waddr': 1},
        {'wdata': 8, 'wen': 0, 'ren': 1, 'rdata': 7, 'full': False, 'empty': True, 'memory': [7, 3, 4, 6], 'raddr': 1, 'waddr': 1},
        {'wdata': 9, 'wen': 0, 'ren': 1, 'rdata': 3, 'full': False, 'empty': True, 'memory': [7, 3, 4, 6], 'raddr': 1, 'waddr': 1},
        {'wdata': 10, 'wen': 0, 'ren': 1, 'rdata': 3, 'full': False, 'empty': True, 'memory': [7, 3, 4, 6], 'raddr': 1, 'waddr': 1},
        {'wdata': 11, 'wen': 1, 'ren': 0, 'rdata': 11, 'full': False, 'empty': False, 'memory': [7, 11, 4, 6], 'raddr': 1, 'waddr': 2},
        {'wdata': 12, 'wen': 1, 'ren': 0, 'rdata': 11, 'full': False, 'empty': False, 'memory': [7, 11, 12, 6], 'raddr': 1, 'waddr': 3},
        {'wdata': 13, 'wen': 1, 'ren': 0, 'rdata': 11, 'full': False, 'empty': False, 'memory': [7, 11, 12, 13], 'raddr': 1, 'waddr': 0},
        {'wdata': 14, 'wen': 1, 'ren': 0, 'rdata': 11, 'full': True, 'empty': False, 'memory': [14, 11, 12, 13], 'raddr': 1, 'waddr': 1},
        {'wdata': 15, 'wen': 1, 'ren': 0, 'rdata': 11, 'full': True, 'empty': False, 'memory': [14, 11, 12, 13], 'raddr': 1, 'waddr': 1}
]

    inputs = ("wdata", "wen", "ren")
    outputs = ("rdata", "full", "empty")
    states = ("memory", "raddr", "waddr")
    for trace in expected_trace:
        args = ()
        for input_ in inputs:
            args += (trace[input_], )
        fifo.send(args)
        for output in outputs:
            assert getattr(fifo, output) == trace[output]
        for state in states:
            assert getattr(fifo, state) == trace[state]

    @si.coroutine
    def inputs_generator(N):
        while True:
            for trace in expected_trace:
                wdata = bits(trace["wdata"], N)
                wen = bool(trace["wen"])
                ren = bool(trace["ren"])
                yield wdata, wen, ren

    si.compile(fifo, file_name="fifo_magma.py")
    import fifo_magma
    check(fifo_magma.Fifo, Fifo(), len(inputs), inputs_generator(2))

if __name__ == "__main__":
    test_fifo()
