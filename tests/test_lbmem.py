import silica as si
from silica import uint, eval, list
import math


def saturating_add(a, b, max_):
    c = a + b
    if c == max_:
        c = 0
    return c

@si.generator
def State0(lbmem_width, depth, lbmem, raddr, waddr):
    valid = 0
    rdata = lbmem[raddr]
    wdata, wen = yield
    for i in range(lbmem_width):
        wdata, wen = yield rdata, valid
        while not wen:
            wdata, wen = yield rdata, valid
        lbmem[waddr] = wdata
        waddr = saturating_add(waddr, 1, depth - 1)

@si.generator
def State1(lbmem_width, depth, lbmem, raddr, waddr):
    valid = 1
    rdata = lbmem[raddr]
    wdata, wen = yield
    for i in range(lbmem_width):
        rdata = lbmem[raddr]
        wdata, wen = yield rdata, valid
        raddr = saturating_add(raddr, 1, depth - 1)
        if wen:
            lbmem[waddr] = wdata
            waddr = saturating_add(waddr, 1, depth - 1)

@si.coroutine
def LbMem(depth=1024,lbmem_width=5):
    lbmem = list(uint(0, lbmem_width) for i in range(depth))
    raddr = uint(0, eval(math.ceil(math.log2(depth))))
    waddr = uint(0, eval(math.ceil(math.log2(depth))))
    while True:
        yield from State0(lbmem_width, depth, lbmem, raddr, waddr)
        yield from State1(lbmem_width, depth, lbmem, raddr, waddr)

def test_lbmem():
    lbmem = LbMem()
    wdata = [i for i in range(30)]
    wen =   [i%2 for i in range(30)]
    for inputs in zip(wdata,wen):
        lbmem.send(inputs)
        print(f"inputs={inputs}, rdata={lbmem.rdata}, valid={lbmem.valid}")
    # si.compile(lbmem, file_name="lbmem.magma.py")
