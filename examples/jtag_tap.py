def TAP():
    """
    Based on https://www.xjtag.com/about-jtag/jtag-a-technical-overview/

    Interface Signals:
        TCK (Test Clock) - synchronizes the internal state machine operations
            (implicit in the coroutine control)
        TMS (Test Mode Select) - sampled at the rising edge of TCK of determine
            the next state
        TDI (Test Data In) - represents data shifted into the device's test or
            programming logic. Sampled on rising edge of TCK when the internal
            state machine is in the correct state.
        TDO (Test Data Out) - data shifted out of the device's test or
            programming logic and is valid on the falling edge of TCK when the
            internal state machien is in the correct state
        TRST (Test Reset) - optional pin which, when available, can reset the
            TAP controller's state machine (implicit in the coroutine control)

    Registers:
        IR (Instruction Register) - holds the current instruction.  Contents
            are used by the TAP controller to decide what to do with signals
            that are received. Most commonly, the contents defines which data
            register signals should be passed.
        DR (Data Register) - three primary types
            BSR (Boundary Scan Register) - main testing data register. Move data
                to and from the I/O pins of a device.
            BYPASS - single-bit register that passes infromation from TDI to
                TDO. Allows other devices in the circuit to be tested with
                minimal overhead
            IDCODES - contains the ID code and revision number of the device.
                Allows the device to be linked to its Boundary Scan Description
                Language (BDSL) file which contains the details of the Boundary
                Scan configuration for the device.
    """
    TMS = yield
    while True:
        test_logic_reset()
        # If TMS == 0, we enter `run test idle`, and stay in that state until
        # TMS = 1
        while TMS == 0:
            while True:
                yield run_test_idle()
                if TMS == 1:
                    while True:
                        yield select_DR_scan()
                        if TMS == 1:
                            yield select_IR_scan()
                            if TMS == 1:
                                # We need to go back to line 37
                        else:
                            yield capture_DR()
                            while True:
                                while TMS == 0:
                                    yield shift_DR()
                                yield exit_1_DR()
                                if TMS == 0:
                                    while TMS == 0:
                                        yield pause_DR()
                                    yield exit_2_DR()
                                    # Backedge
                                    if TMS == 1:
                                        break
                                    else:
                                        continue # Go back to line 50
                                else:
                                    break
                            yield update_DR()
                            if TMS == 0:
                                break  # Go back to line 41
                            else:
                                continue # Go back to line 43


def TAP():
    def test_logic_reset():
        TMS = yield
        while TMS == 1:
            TMS = yield
        run_test_idle.send()

    run_test_idle = RunTestIdle()
    select_DR_scan = SelectDRScan()
    select_IR_scan = SelectIRScan()

    while True:
        run_test_idle.send()

class TAP(FSM):
    def __init__(self):
        self.IR = SIPO(5, hase_ce=True)
        self.IR_Scan = IRScan(self, self.IR)
        self.DR_Scan = Scan(self)

    @coroutine
    def test_logic_reset(self):
        TMS = yield
        while TMS == 1:
            TMS = yield
        self.run_test_idle.send()

    @coroutine
    def run_test_idle(self):
        TMS = yield
        while TMS == 0:
            TMS = yield
        self.select_DR_scan.send()

    @coroutine
    def select_DR_scan(self):
        TMS = yield
        if TMS == 1:
            self.select_IR_scan.send()
        else:
            self.capture_DR.send()

    @coroutine
    def select_IR_scan(self):
        TMS = yield
        if TMS == 1:
            self.test_logic_reset.send()
        else:
            self.IR_scan.capture.send()

class Scan(FSM):
    def __init__(self, TAP):
        self.TAP = TAP

    @coroutine
    def capture(self):
        TMS = yield
        if TMS == 1:
            self.exit_1.send()
        else:
            self.shift.send()

    @coroutine
    def shift(self):
        TMS = yield
        while TMS == 0:
            TMS = yield shift = 1
        self.exit_1.send()

    @coroutine
    def exit_1(self):
        TMS = yield
        if TMS == 0:
            while TMS == 0:
                # pause
                TMS = yield
            if TMS == 0:
                self.shift.send()
        if TMS == 1:
            self.TAP.select_DR_scan.send()
        else:
            self.TAP.run_test_idle.send()


class IRScan(Scan):
    def __init__(self, TAP, shift_register):
        self.TAP = TAP
        self.shift_register = shift_register
        self.shift_register.CE = 0

    @coroutine
    def shift(self):
        TMS = yield
        while TMS == 0:
            self.shift_register.CE = 1
            TMS = yield
        self.shift_register.CE = 0
        self.exit_1.send()


def Circuit(TDI: In(Bit), TDO: Out(Bit), TCK: In(Clock), TMS: In(Bit)):
    tap = TAP().clock(TCK)
    wire(TMS, tap.TMS)

    DRs = [SIPO(5, has_ce=True) for _ in range(num_drs)]
    for ID, DR in enumerate(DRs):
        wire(TDI, DR.I)
        wire(And()(tap.DR_Scan.shift, EQ(IR.O, bits(ID, 5))), IR.CE)

    # tdo_mux = Mux(height=len(DRs) + 2, width=1)
    # wire(tdo_mux.O, TDO)
    # wire(IR.O[-1], tdo_mux.I[0])
    # for i, DR in enumerate(DRs):
    #     wire(DR.O[-1], tdo_mux.I[i + 1])

    # NOTE: Tricky to generate the mux select for TDO, in Verilog we would use
    # an always_comb (included below) to generate for us, magma should consider
    # adding a construct for easily constructing muxes. Chisel has the `when`
    # statement

    def TDO_MUX():
        if tap.IR_Scan.shift:
            TDO = IR.O[-1]
        elif tap.DR_Scan.shift:
            if IR.O == 0:
                TDO = DRs[0].O[-1]
            elif IR.O == 1:
                TDO = DRs[1].O[-1]
            elif IR.O == 2:
                TDO = DRs[2].O[-1]
            elif IR.O == 3:
                TDO = DRs[3].O[-1]
            elif IR.O == 4:
                TDO = DRs[4].O[-1]
        else:
            TDO = 0

    TDO_MUX()


    # always_comb() begin
    #     if tap.IR_Scan.shift:
    #         TDO = IR.O[-1]
    #     elif tap.DR_Scan.shift:
    #         case IR.O:
    #             1: TDO = DRs[0].O[-1]
    #             2: TDO = DRs[1].O[-1]
    #             3: TDO = DRs[2].O[-1]
    #             ...
    #     else:
    #         TDO = 0
    # end
