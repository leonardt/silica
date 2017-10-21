import silica


@silica.coroutine
def TFF(init=False):
    value = init
    O = value
    while True:
        I = yield O
        O = value
        value = I ^ O


if __name__ == "__main__":
    tff = TFF()
    print("Should Toggle")
    # Should toggle
    for i in range(5):
        tff.send(True)
        print(f"    tff: I={tff.I}, O={tff.O}")
        assert tff.O == i % 2
    print("Should stay True")
    # Should stay high
    for i in range(3):
        tff.send(False)
        print(f"    tff: I={tff.I}, O={tff.O}")
        assert tff.O == True
