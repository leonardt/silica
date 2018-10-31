import silica as si
from silica import coroutine, uint, Bit, BitVector, compile, Array, Bits, bits
import pytest
import shutil
from tests.common import evaluate_circuit
import magma as m
import fault
import shutil


class TAPDriver:
    Regs = set(["REGA", "REGB"])
    DRAddrs = dict(REGA=2, REGB=14)
    DRBits = dict(REGA=5, REGB=7)
    IR_bits = 4
    
    def __init__(self, tester, tap_v, clock):
        self.tester = tester
        self.TCK = clock
        self.TMS = tap_v.TMS
        self.TDI = tap_v.TDI
        self.TDO = tap_v.TDO
        # self.IR = tap_v.IR
        self.update_ir = tap_v.update_ir
        self.update_dr = tap_v.update_dr
        # self.cs = tap_v.cs
        # self.ns = tap_v.ns
        self.sigs = tap_v

    #This would be useful to be a fault helper function
    def next(self, poke_map, exp_map={}, print_list=[]):
        assert isinstance(poke_map, dict), str(poke_map)
        assert isinstance(exp_map, dict)
        assert isinstance(print_list, list)
        #Just finshed posedge of clk

        #set inputs
        for sig, val in poke_map.items():
            #print(sig, val)
            self.tester.poke(sig, val)
        self.tester.eval()
        #negedge
        self.tester.poke(self.TCK, 0)
        self.tester.eval()

        #check/print outputs
        for sig, val in exp_map.items():
            self.tester.expect(sig, val)

        #self.tester.print(self.cs)
        #self.tester.print(self.IR)
        #self.tester.print(self.sigs.shift_dr)
        #self.tester.print(self.sigs.regA)
        #self.tester.print(self.TDI)
        #self.tester.print(self.IR)
        for sig in print_list:
            self.tester.print(sig)
        #self.tester.print(self.cs)

        self.tester.poke(self.TCK, 1)
        self.tester.eval()
        #posedge

    #Will stick controller in run_test_idle
    def init_tap(self):
        self.tester.poke(self.TCK, 1)
        self.tester.eval()
        for i in range(20):  #This is actually how TAP controllers reset
            self.next({self.TMS: 1})
        self.next({self.TMS: 0})  #go to run_test_idle

    #optional expect a value
    def shift(self, value, bits, expect=None):
        if (bits < 32):
            assert (value >> bits) == 0  #Check only 'size' bits are set
        in_bv = BitVector(value, bits)
        #print("shift_val", in_bv)
        if expect:
            expect_bv = BitVector(expect, bits)
        for i in range(bits):  #lsb first
            tms = 1 if (i == bits - 1) else 0  #Exit on last
            tdi = in_bv[i]
            exp_map = {}
            if expect:
                exp_map = {self.TDO: expect_bv[i]}
            self.next({self.TMS: tms, self.TDI: tdi}, exp_map=exp_map)
            #self.next({self.TMS:tms,self.TDI:tdi},print_list=[self.TDO,self.TDI,self.IR,self.sigs.shift_ir])

    def write_IR(self, dr_addr, ir_exp=None):
        assert dr_addr in TAPDriver.Regs
        dr_addr_value = TAPDriver.DRAddrs[dr_addr]
        ir_exp_value = None
        if ir_exp:
            assert ir_exp in TAPDriver.Regs
            ir_exp_value = TAPDriver.DRAddrs[ir_exp]
        self.next({self.TMS: 1})  #select DR
        self.next({self.TMS: 1})  #select IR
        self.next({self.TMS: 0})  #capture IR
        self.next({self.TMS: 0})  #shift IR
        self.shift(
            dr_addr_value, TAPDriver.IR_bits,
            expect=ir_exp_value)  #Shift in the data and exit1
        self.next({self.TMS: 1})  #update IR
        self.next({self.TMS: 0}, {self.update_ir: 1})  # idle

    def write_DR(self, dr_val, bits, dr_exp=None):
        self.next({self.TMS: 1})  #select DR
        self.next({self.TMS: 0})  #capture DR
        self.next({self.TMS: 0})  #shift DR
        self.shift(dr_val, bits, expect=dr_exp)  #Shift in the data and exit1
        self.next({self.TMS: 1})  #update DR
        self.next({self.TMS: 0}, {self.update_dr: 1})  # idle




TEST_LOGIC_RESET = bits(0, 4)
RUN_TEST_IDLE = bits(1, 4)
SELECT_DR_SCAN = bits(2, 4)
CAPTURE_DR = bits(3, 4)
SHIFT_DR = bits(4, 4)
EXIT1_DR = bits(5, 4)
PAUSE_DR = bits(6, 4)
EXIT2_DR = bits(7, 4)
UPDATE_DR = bits(8, 4)
SELECT_IR_SCAN = bits(9, 4)
CAPTURE_IR = bits(10, 4)
SHIFT_IR = bits(11, 4)
EXIT1_IR = bits(12, 4)
PAUSE_IR = bits(13, 4)
EXIT2_IR = bits(14, 4)
UPDATE_IR = bits(15, 4)

@si.coroutine
def SilicaTAP(TMS : Bit, TDI : Bit):
    CS = bits(TEST_LOGIC_RESET,4)
    IR = bits(0, 4)
    regA = bits(0, 5)
    regB = bits(0, 7)
    TMS, TDI = yield
    while True:
        NS = TEST_LOGIC_RESET
        if CS == TEST_LOGIC_RESET:
            NS = TEST_LOGIC_RESET if TMS else RUN_TEST_IDLE
        if CS == RUN_TEST_IDLE:
            NS = SELECT_DR_SCAN if TMS else RUN_TEST_IDLE
        if CS == SELECT_DR_SCAN:
            NS = SELECT_IR_SCAN if TMS else CAPTURE_DR
        if CS == CAPTURE_DR:
            NS = EXIT1_DR if TMS else SHIFT_DR
        if CS == SHIFT_DR:
            NS = EXIT1_DR if TMS else SHIFT_DR
        if CS == EXIT1_DR:
            NS = UPDATE_DR if TMS else PAUSE_DR
        if CS == PAUSE_DR:
            NS = EXIT2_DR if TMS else PAUSE_DR
        if CS == EXIT2_DR:
            NS = UPDATE_DR if TMS else SHIFT_DR
        if CS == UPDATE_DR:
            NS = SELECT_DR_SCAN if TMS else RUN_TEST_IDLE
        if CS == SELECT_IR_SCAN:
            NS = TEST_LOGIC_RESET if TMS else CAPTURE_IR
        if CS == CAPTURE_IR:
            NS = EXIT1_IR if TMS else SHIFT_IR
        if CS == SHIFT_IR:
            NS = EXIT1_IR if TMS else SHIFT_IR
        if CS == EXIT1_IR:
            NS = UPDATE_IR if TMS else PAUSE_IR
        if CS == PAUSE_IR:
            NS = EXIT2_IR if TMS else PAUSE_IR
        if CS == EXIT2_IR:
            NS = UPDATE_IR if TMS else SHIFT_IR
        if CS == UPDATE_IR:
            NS = SELECT_IR_SCAN if TMS else RUN_TEST_IDLE
        
        update_dr = (CS == UPDATE_DR)
        update_ir = (CS == UPDATE_IR)
        shift_dr = (CS == SHIFT_DR)
        shift_ir = (CS == SHIFT_IR)
        shift_regA = shift_dr & (IR == 2) #2 is address of regA
        shift_regB = shift_dr & (IR == 14) #14 is address of regB
        TDO = bit(0) #Can this just be 0?
        if shift_ir:
            TDO = IR[0]
        elif shift_regA:
            TDO = regA[0]
        elif shift_regB:
            TDO = regB[0]
        
        if shift_ir:
            # emulating {TDI,IR[3:1]}   
            IR = (IR>>1 & ((1<<4)-1)) | (bits(TDI, 4) << 3) #TODO how to concat?
        if shift_regA:
            # emulating {TDI,regA[4:1]}   
            regA = (regA>>1 & ((1<<5)-1)) | (bits(TDI, 5) << 4)
        if shift_regB:
            # emulating {TDI,regB[3:1]}   
            regB = (regB>>1 & ((1<<7)-1)) | (bits(TDI, 7) << 6)

        CS = NS
        TMS, TDI = yield TDO, update_dr,update_ir

def test_tap():
    tap = SilicaTAP()
    si_tap = si.compile(tap, file_name="tests/build/si_tap.v")
    # si_tap = m.DefineFromVerilogFile(
    #     "tests/build/si_tap.v", type_map={"CLK": m.In(m.Clock)})[0]

    tester = fault.Tester(si_tap, si_tap.CLK)

    tap_driver = TAPDriver(tester, si_tap, si_tap.CLK)
    tap_driver.init_tap()

    tap_driver.write_IR("REGA")
    tap_driver.write_IR("REGB", ir_exp="REGA")
    tap_driver.write_IR("REGA", ir_exp="REGB")
    tap_driver.write_DR(25, 5)
    tap_driver.write_DR(15, 5, dr_exp=25)
    tap_driver.write_DR(2, 5, dr_exp=15)
    tap_driver.write_IR("REGB", ir_exp="REGA")
    tap_driver.write_DR(100, 7)
    tap_driver.write_DR(50, 7, dr_exp=100)

    tester.compile_and_run(
        target="verilator", directory="tests/build", flags=['-Wno-fatal'])


    shutil.copy("verilog/tap.v", "tests/build/verilog_tap.v")
    tap_v = m.DefineFromVerilogFile(
        "tests/build/tap_verilog.v", type_map={"CLK": m.In(m.Clock)})[0]

    v_tester = tester.retarget(tap_v, tap_v.CLK)
    v_tester.compile_and_run(
        target="verilator", directory="tests/build", flags=['-Wno-fatal'])


    if __name__ == '__main__':
        print("===== BEGIN : SILICA RESULTS =====")
        evaluate_circuit("si_tap", "SilicaTAP")
        print("===== END   : SILICA RESULTS =====")

        print("===== BEGIN : VERILOG RESULTS =====")
        evaluate_circuit("verilog_tap", "tap")
        print("===== END   : VERILOG RESULTS =====")


if __name__ == '__main__':
    test_tap()
