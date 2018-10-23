import silica as si
from silica import coroutine, uint, Bit, BitVector, compile, Array, Bits, bits
import pytest
import shutil
from tests.common import evaluate_circuit
import magma as m
import fault


class TAPDriver:
    Regs = set(["REGA", "REGB"])
    DRAddrs = dict(REGA=2, REGB=14)
    DRBits = dict(REGA=5, REGB=7)
    IR_bits = 4

    def __init__(self, tester, tap_v):
        self.tester = tester
        self.TCK = tap_v.TCK
        self.TMS = tap_v.TMS
        self.TDI = tap_v.TDI
        self.TDO = tap_v.TDO
        self.IR = tap_v.IR
        self.update_ir = tap_v.update_ir
        self.update_dr = tap_v.update_dr
        self.cs = tap_v.cs
        self.ns = tap_v.ns
        self.sigs = tap_v

    #This would be useful to be a fault helper function
    def next(self, poke_map, exp_map={}, print_list=[]):
        assert isinstance(poke_map, dict), str(poke_map)
        assert isinstance(exp_map, dict)
        assert isinstance(print_list, list)
        #Just finshed posedge of clk

        #set inputs
        for sig, val in poke_map.items():
            print(sig, val)
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
        print("shift_val", in_bv)
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


def test_tap():

    shutil.copy("verilog/tap.v", "tests/build/tap_verilog.v")
    tap_v = m.DefineFromVerilogFile(
        "tests/build/tap_verilog.v", type_map={"TCK": m.In(m.Clock)})[0]

    v_tester = fault.Tester(tap_v, tap_v.TCK)

    tap_driver = TAPDriver(v_tester, tap_v)
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

    #full_step({TMS:0},{cs:1})

    v_tester.expect(tap_v.update_dr, 0)
    #v_tester = tester.retarget(serializer_verilog, serializer_verilog.CLK)
    v_tester.compile_and_run(
        target="verilator", directory="tests/build", flags=['-Wno-fatal'])

    #if __name__ == '__main__':
    #    print("===== BEGIN : SILICA RESULTS =====")
    #    evaluate_circuit("serializer_si", "Serializer4")
    #    print("===== END   : SILICA RESULTS =====")

    #    print("===== BEGIN : VERILOG RESULTS =====")
    #    evaluate_circuit("serializer_verilog", "serializer")
    #    print("===== END   : VERILOG RESULTS =====")


if __name__ == '__main__':
    test_tap()
