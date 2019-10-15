from compile import FSM, Bit, State


class TAP(FSM):
    inputs = {"tms": Bit}
    outputs = {"state": State}

    def __init__(self):
        self.ir_scan = Scan(self, capture=14, shift=10, exit_1=9, pause=11,
                            exit_2=8, update=13)
        self.dr_scan = Scan(self, capture=6, shift=2, exit_1=1, pause=3,
                            exit_2=0, update=5)

    def __call__(self):
        yield from self.test_logic_reset()

    def test_logic_reset(self):
        while True:
            tms = yield 15
            if ~tms:
                break
        yield from self.run_test_idle()

    def run_test_idle(self):
        while True:
            tms = yield 12
            if tms:
                break
        yield from self.select_dr_scan()

    def select_dr_scan(self):
        tms = yield 7
        if tms == 1:
            yield from self.select_ir_scan()
        else:
            yield from self.dr_scan.capture()

    def select_ir_scan(self):
        tms = yield 4
        if tms == 1:
            yield from self.test_logic_reset()
        else:
            yield from self.ir_scan.capture()


class Scan(FSM):
    inputs = {"tms": Bit}
    outputs = {"state": State}

    def __init__(self, tap, **encodings):
        self.tap = tap
        self.encodings = encodings

    def capture(self):
        tms = yield self.encodings["capture"]
        if tms == 1:
            yield from self.exit_1()
        else:
            yield from self.shift()

    def shift(self):
        while True:
            tms = yield self.encodings["shift"]
            if tms == 0:
                break
        yield from self.exit_1()

    def exit_1(self):
        tms = yield self.encodings["exit_1"]
        if tms == 0:
            while tms == 0:
                # pause
                tms = yield self.encodings["pause"]
            tms = yield self.encodings["exit_2"]
            if tms == 0:
                yield from self.shift()
                return
        tms = yield self.encodings["update"]
        if tms == 1:
            yield from self.tap.select_dr_scan()
        else:
            yield from self.tap.run_test_idle()
