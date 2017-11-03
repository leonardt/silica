import silica
from silica import bits, Bit, uint, zext
from magma.testing.coroutine import check

@silica.coroutine(inputs={"I" : Bit})
def detect111():
    cnt = uint(0, 2)
    while True:
        O = (cnt == 3)
        I = yield O
        if (I):
            if (cnt<3):
                cnt = cnt+1
        else:
            cnt = 0
      
@silica.coroutine
def inputs_generator(inputs):
    while True:
        for i in inputs:
            I = i
            yield I

def test_detect111():
    detect = detect111()
    inputs =  list(map(bool, [1,1,0,1,1,1,0,1,0,1,1,1,1,1,1]))
    outputs = list(map(bool, [0,0,0,0,0,1,0,0,0,0,0,1,1,1,1]))
    for i, o in zip(inputs, outputs):
        assert o == detect.send(i)
    
    magma_detect = silica.compile(detect)
    check(magma_detect, detect111(), len(inputs), inputs_generator(inputs))
