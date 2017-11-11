import silica as si
from silica import uint, eval, list
import math


def saturating_add(a, b, max_):
    c = a + b
    if c == max_:
        c = 0
    return c

@si.generator
def FillingState(lbmem_width, depth, lbmem, raddr, waddr):
    """
    Linebuffer filling state
    rdata is always invalid
    Remains in this state until `lbmem_width` writes have occured (wen is high for `lbmem` cycles)
    """
    for i in range(lbmem_width):
        valid = 0
        rdata = lbmem[raddr]
        wdata, wen = yield rdata, valid
        while not wen:
            wdata, wen = yield rdata, valid
        lbmem[waddr] = wdata
        waddr = saturating_add(waddr, 1, depth)
    return waddr

@si.generator
def DrainingState(lbmem_width, depth, lbmem, raddr, waddr):
    """
    Linebuffer draining state
    rdata is always valid
    Remains in this state until `lbmem_width` cycles without a write have occured
    """
    not_drained = lbmem_width
    while not_drained:
        valid = 1
        rdata = lbmem[raddr]
        wdata, wen = yield rdata, valid
        raddr = saturating_add(raddr, 1, depth)
        if wen:
            lbmem[waddr] = wdata
            waddr = saturating_add(waddr, 1, depth)
        else:
            not_drained -= 1
    return waddr, raddr

@si.coroutine
def LbMem(depth=64, lbmem_width=8):
    lbmem = list(uint(0, lbmem_width) for i in range(depth))
    raddr = uint(0, eval(math.ceil(math.log2(depth))))
    waddr = uint(0, eval(math.ceil(math.log2(depth))))
    while True:
        waddr = yield from FillingState(lbmem_width, depth, lbmem, raddr, waddr)
        waddr, raddr = yield from DrainingState(lbmem_width, depth, lbmem, raddr, waddr)

@si.coroutine
def inputs_generator(inputs):
    while True:
        for wdata, wen in inputs:
            yield wdata, wen

def test_lbmem():
    lbmem = LbMem()
    wdata = [i for i in range(40)]
    wen =   [i%2 for i in range(40)]
    expected_written = []
    expected_valid = False
    num_writes = 0
    for cycle, inputs in enumerate(zip(wdata,wen)):
        lbmem.send(inputs)
        # print(f"inputs={inputs}, rdata={lbmem.rdata}, valid={lbmem.valid}")
        wen = inputs[1]
        if wen:
            expected_written.append(inputs[0])
        num_writes += wen
        if not expected_valid and num_writes == 8:
            expected_valid = True
            drain_state = 8
        if expected_valid and drain_state and not wen:
            drain_state -= 1
        if expected_valid and not drain_state:
            expected_valid = False
            num_writes = 0
        assert expected_valid == lbmem.valid
        if expected_valid:
            assert lbmem.rdata == expected_written.pop(0)
    # lbmem_magma = si.compile(lbmem, file_name="lbmem_magma.py")
    # check(lbmem_magma, LbMem(), len(inputs), inputs_generator(list(zip(wdata,wen))))
