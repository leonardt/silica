import silica
from magma.testing.coroutine import check


@silica.coroutine(inputs={"I": silica.Bit})
def TFF(init=False):
    value = init
    I = yield
    while True:
        O = value
        value = I ^ O
        I = yield O


@silica.coroutine
def inputs_generator():
    while True:
        for i in range(5):
            I = True
            yield I
        for i in range(3):
            I = False
            yield I


def test_TFF():
    tff = TFF()
    # Should toggle
    for i in range(5):
        tff.send(True)
        assert tff.O == i % 2
    # Should stay high
    for i in range(3):
        tff.send(False)
        assert tff.O == True

    magma_tff = silica.compile(tff)
    check(magma_tff, TFF(), 8, inputs_generator())
