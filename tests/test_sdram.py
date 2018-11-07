import silica as si
from silica import coroutine, uint, Bit, BitVector, compile, Array, Bits, bits
import pytest
import shutil
from tests.common import evaluate_circuit
import magma as m
import fault


# class TAPDriver:
#     Regs = set(["REGA", "REGB"])
#     DRAddrs = dict(REGA=2, REGB=14)
#     DRBits = dict(REGA=5, REGB=7)
#     IR_bits = 4

#     def __init__(self, tester, tap_v, clock):
#         self.tester = tester
#         self.TCK = clock
#         self.TMS = tap_v.TMS
#         self.TDI = tap_v.TDI
#         self.TDO = tap_v.TDO
#         # self.IR = tap_v.IR
#         self.update_ir = tap_v.update_ir
#         self.update_dr = tap_v.update_dr
#         # self.cs = tap_v.cs
#         # self.ns = tap_v.ns
#         self.sigs = tap_v

#     #This would be useful to be a fault helper function
#     def next(self, poke_map, exp_map={}, print_list=[]):
#         assert isinstance(poke_map, dict), str(poke_map)
#         assert isinstance(exp_map, dict)
#         assert isinstance(print_list, list)
#         #Just finshed posedge of clk

#         #set inputs
#         for sig, val in poke_map.items():
#             #print(sig, val)
#             self.tester.poke(sig, val)
#         self.tester.eval()
#         #negedge
#         self.tester.poke(self.TCK, 0)
#         self.tester.eval()

#         #check/print outputs
#         for sig, val in exp_map.items():
#             self.tester.expect(sig, val)

#         #self.tester.print(self.cs)
#         #self.tester.print(self.IR)
#         #self.tester.print(self.sigs.shift_dr)
#         #self.tester.print(self.sigs.regA)
#         #self.tester.print(self.TDI)
#         #self.tester.print(self.IR)
#         for sig in print_list:
#             self.tester.print(sig)
#         #self.tester.print(self.cs)

#         self.tester.poke(self.TCK, 1)
#         self.tester.eval()
#         #posedge

#     #Will stick controller in run_test_idle
#     def init_tap(self):
#         self.tester.poke(self.TCK, 1)
#         self.tester.eval()
#         for i in range(20):  #This is actually how TAP controllers reset
#             self.next({self.TMS: 1})
#         self.next({self.TMS: 0})  #go to run_test_idle

#     #optional expect a value
#     def shift(self, value, bits, expect=None):
#         if (bits < 32):
#             assert (value >> bits) == 0  #Check only 'size' bits are set
#         in_bv = BitVector(value, bits)
#         #print("shift_val", in_bv)
#         if expect:
#             expect_bv = BitVector(expect, bits)
#         for i in range(bits):  #lsb first
#             tms = 1 if (i == bits - 1) else 0  #Exit on last
#             tdi = in_bv[i]
#             exp_map = {}
#             if expect:
#                 exp_map = {self.TDO: expect_bv[i]}
#             self.next({self.TMS: tms, self.TDI: tdi}, exp_map=exp_map)
#             #self.next({self.TMS:tms,self.TDI:tdi},print_list=[self.TDO,self.TDI,self.IR,self.sigs.shift_ir])

#     def write_IR(self, dr_addr, ir_exp=None):
#         assert dr_addr in TAPDriver.Regs
#         dr_addr_value = TAPDriver.DRAddrs[dr_addr]
#         ir_exp_value = None
#         if ir_exp:
#             assert ir_exp in TAPDriver.Regs
#             ir_exp_value = TAPDriver.DRAddrs[ir_exp]
#         self.next({self.TMS: 1})  #select DR
#         self.next({self.TMS: 1})  #select IR
#         self.next({self.TMS: 0})  #capture IR
#         self.next({self.TMS: 0})  #shift IR
#         self.shift(
#             dr_addr_value, TAPDriver.IR_bits,
#             expect=ir_exp_value)  #Shift in the data and exit1
#         self.next({self.TMS: 1})  #update IR
#         self.next({self.TMS: 0}, {self.update_ir: 1})  # idle

#     def write_DR(self, dr_val, bits, dr_exp=None):
#         self.next({self.TMS: 1})  #select DR
#         self.next({self.TMS: 0})  #capture DR
#         self.next({self.TMS: 0})  #shift DR
#         self.shift(dr_val, bits, expect=dr_exp)  #Shift in the data and exit1
#         self.next({self.TMS: 1})  #update DR
#         self.next({self.TMS: 0}, {self.update_dr: 1})  # idle

@si.coroutine
def SilicaSDRAM(
        cmd_enable      : Bits(1),
        cmd_wr          : Bits(1),
        cmd_address     : Bits(23),
        cmd_byte_enable : Bits(4),
        cmd_data_in     : Bits(32),
        SDRAM_DATA_in   : Bits(16)
):
    # Commands
    # CMD_UNSELECTED    = (bits(1, 1), bits(0, 1), bits(0, 1), bits(0, 1)) #bits(int("1000", 2), 4)
    # CMD_NOP           = bits(int("0111", 2), 4)
    # # CMD_NOP           = (bits(0, 1), bits(1, 1), bits(1, 1), bits(1, 1)) #bits(int("0111", 2), 4)
    # CMD_ACTIVE        = (bits(0, 1), bits(0, 1), bits(1, 1), bits(1, 1)) #bits(int("0011", 2), 4)
    # CMD_READ          = (bits(0, 1), bits(1, 1), bits(0, 1), bits(1, 1)) #bits(int("0101", 2), 4)
    # CMD_WRITE         = (bits(0, 1), bits(1, 1), bits(0, 1), bits(0, 1)) #bits(int("0100", 2), 4)
    # CMD_TERMINATE     = (bits(0, 1), bits(1, 1), bits(1, 1), bits(0, 1)) #bits(int("0110", 2), 4)
    # CMD_PRECHARGE     = (bits(0, 1), bits(0, 1), bits(1, 1), bits(0, 1)) #bits(int("0010", 2), 4)
    # CMD_REFRESH       = (bits(0, 1), bits(0, 1), bits(0, 1), bits(1, 1)) #bits(int("0001", 2), 4)
    # CMD_LOAD_MODE_REG = (bits(0, 1), bits(0, 1), bits(0, 1), bits(0, 1)) #bits(int("0000", 2), 4)
    # MODE_REG          = bits(int("000 0 00 010 0 000".replace(" ", ""), 2), 13)

    # Outputs
    cmd_ready      = bits(0, 1)
    data_out       = bits(0, 32)
    data_valid     = bits(0, 1)
    SDRAM_CKE      = bits(0, 1)
    SDRAM_CS       = bits(0, 1)
    SDRAM_RAS      = bits(1, 1)
    SDRAM_CAS      = bits(1, 1)
    SDRAM_WE       = bits(1, 1)
    SDRAM_DQM      = bits(0, 2)
    SDRAM_ADDR     = bits(0, 13)
    SDRAM_BA       = bits(0, 2)
    SDRAM_DATA_ctl = bits(0, 1)
    SDRAM_DATA_out = bits(0, 16)

    cmd_enable, cmd_wr, cmd_address, cmd_byte_enable, cmd_data_in, SDRAM_DATA_in = yield cmd_ready, data_out, data_valid, SDRAM_CKE, SDRAM_CS, SDRAM_RAS, SDRAM_CAS, SDRAM_WE, SDRAM_DQM, SDRAM_ADDR, SDRAM_BA, SDRAM_DATA_ctl, SDRAM_DATA_out

    ##################
    # Startup sequence
    ##################
    # CLOCK_FREQ = int(100 * 1e6) # 100MHz
    # CYCLES_FOR_100us = int(CLOCK_FREQ * (100 * 1e-6))

    # enable clock
    SDRAM_CKE = bits(1, 1)

    # wait 100us
    # for i in range(CYCLES_FOR_100us):
    count = bits(10000, 14)
    while count != 0:
    # for i in range(10000):
        # CMD_NOP
        SDRAM_CS  = bits(0, 1)
        SDRAM_RAS = bits(1, 1)
        SDRAM_CAS = bits(1, 1)
        SDRAM_WE  = bits(1, 1)

        SDRAM_ADDR = bits(0, 13)
        SDRAM_BA   = bits(0, 2)
        SDRAM_DQM  = bits(0, 2)

        count = count - 1

        cmd_enable, cmd_wr, cmd_address, cmd_byte_enable, cmd_data_in, SDRAM_DATA_in = yield cmd_ready, data_out, data_valid, SDRAM_CKE, SDRAM_CS, SDRAM_RAS, SDRAM_CAS, SDRAM_WE, SDRAM_DQM, SDRAM_ADDR, SDRAM_BA, SDRAM_DATA_ctl, SDRAM_DATA_out

    # wait at least one cycle
    cmd_enable, cmd_wr, cmd_address, cmd_byte_enable, cmd_data_in, SDRAM_DATA_in = yield cmd_ready, data_out, data_valid, SDRAM_CKE, SDRAM_CS, SDRAM_RAS, SDRAM_CAS, SDRAM_WE, SDRAM_DQM, SDRAM_ADDR, SDRAM_BA, SDRAM_DATA_ctl, SDRAM_DATA_out

    # PRECHARGE ALL
    # precharge
    SDRAM_CS  = bits(0, 1)
    SDRAM_RAS = bits(0, 1)
    SDRAM_CAS = bits(0, 1)
    SDRAM_WE  = bits(0, 1)

    # all banks
    # SDRAM_ADDR = bits(int("0010000000000", 2), 13)
    SDRAM_ADDR = bits(1024, 13)
    # SDRAM_ADDR = bits(0, 13)
    # SDRAM_ADDR[10] = bits(1, 1)
    SDRAM_BA   = bits(0, 2)

    cmd_enable, cmd_wr, cmd_address, cmd_byte_enable, cmd_data_in, SDRAM_DATA_in = yield cmd_ready, data_out, data_valid, SDRAM_CKE, SDRAM_CS, SDRAM_RAS, SDRAM_CAS, SDRAM_WE, SDRAM_DQM, SDRAM_ADDR, SDRAM_BA, SDRAM_DATA_ctl, SDRAM_DATA_out

    # wait tRP (20ns)
    for i in range(2):
        # CMD_NOP
        SDRAM_CS  = bits(0, 1)
        SDRAM_RAS = bits(1, 1)
        SDRAM_CAS = bits(1, 1)
        SDRAM_WE  = bits(1, 1)

        SDRAM_ADDR = bits(0, 13)
        SDRAM_BA   = bits(0, 2)
        SDRAM_DQM  = bits(0, 2)

        cmd_enable, cmd_wr, cmd_address, cmd_byte_enable, cmd_data_in, SDRAM_DATA_in = yield cmd_ready, data_out, data_valid, SDRAM_CKE, SDRAM_CS, SDRAM_RAS, SDRAM_CAS, SDRAM_WE, SDRAM_DQM, SDRAM_ADDR, SDRAM_BA, SDRAM_DATA_ctl, SDRAM_DATA_out

    # AUTO REFRESH
    SDRAM_CKE = bits(1, 1)
    SDRAM_CS  = bits(0, 1)
    SDRAM_RAS = bits(0, 1)
    SDRAM_CAS = bits(0, 1)
    SDRAM_WE  = bits(1, 1)

    cmd_enable, cmd_wr, cmd_address, cmd_byte_enable, cmd_data_in, SDRAM_DATA_in = yield cmd_ready, data_out, data_valid, SDRAM_CKE, SDRAM_CS, SDRAM_RAS, SDRAM_CAS, SDRAM_WE, SDRAM_DQM, SDRAM_ADDR, SDRAM_BA, SDRAM_DATA_ctl, SDRAM_DATA_out

    # wait tRFC (66ns)
    for i in range(7):
        # CMD_NOP
        SDRAM_CS  = bits(0, 1)
        SDRAM_RAS = bits(1, 1)
        SDRAM_CAS = bits(1, 1)
        SDRAM_WE  = bits(1, 1)

        SDRAM_ADDR = bits(0, 13)
        SDRAM_BA   = bits(0, 2)
        SDRAM_DQM  = bits(0, 2)

        cmd_enable, cmd_wr, cmd_address, cmd_byte_enable, cmd_data_in, SDRAM_DATA_in = yield cmd_ready, data_out, data_valid, SDRAM_CKE, SDRAM_CS, SDRAM_RAS, SDRAM_CAS, SDRAM_WE, SDRAM_DQM, SDRAM_ADDR, SDRAM_BA, SDRAM_DATA_ctl, SDRAM_DATA_out

    # AUTO REFRESH
    SDRAM_CKE = bits(1, 1)
    SDRAM_CS  = bits(0, 1)
    SDRAM_RAS = bits(0, 1)
    SDRAM_CAS = bits(0, 1)
    SDRAM_WE  = bits(1, 1)

    cmd_enable, cmd_wr, cmd_address, cmd_byte_enable, cmd_data_in, SDRAM_DATA_in = yield cmd_ready, data_out, data_valid, SDRAM_CKE, SDRAM_CS, SDRAM_RAS, SDRAM_CAS, SDRAM_WE, SDRAM_DQM, SDRAM_ADDR, SDRAM_BA, SDRAM_DATA_ctl, SDRAM_DATA_out

    # wait tRFC (66ns)
    for i in range(7):
        # CMD_NOP
        SDRAM_CS  = bits(0, 1)
        SDRAM_RAS = bits(1, 1)
        SDRAM_CAS = bits(1, 1)
        SDRAM_WE  = bits(1, 1)

        SDRAM_ADDR = bits(0, 13)
        SDRAM_BA   = bits(0, 2)
        SDRAM_DQM  = bits(0, 2)

        cmd_enable, cmd_wr, cmd_address, cmd_byte_enable, cmd_data_in, SDRAM_DATA_in = yield cmd_ready, data_out, data_valid, SDRAM_CKE, SDRAM_CS, SDRAM_RAS, SDRAM_CAS, SDRAM_WE, SDRAM_DQM, SDRAM_ADDR, SDRAM_BA, SDRAM_DATA_ctl, SDRAM_DATA_out

    # load mode register
    SDRAM_CS  = bits(0, 1)
    SDRAM_RAS = bits(0, 1)
    SDRAM_CAS = bits(0, 1)
    SDRAM_WE  = bits(0, 1)

    # MODE_REG          = bits(int("000 0 00 010 0 000".replace(" ", ""), 2), 13)
    # SDRAM_ADDR = MODE_REG
    SDRAM_ADDR = bits(32, 13)

    cmd_enable, cmd_wr, cmd_address, cmd_byte_enable, cmd_data_in, SDRAM_DATA_in = yield cmd_ready, data_out, data_valid, SDRAM_CKE, SDRAM_CS, SDRAM_RAS, SDRAM_CAS, SDRAM_WE, SDRAM_DQM, SDRAM_ADDR, SDRAM_BA, SDRAM_DATA_ctl, SDRAM_DATA_out

    ####

    pending_refresh = bits(eval(int(6400000/8192+1)), 10)

    # Idle state
    while True:
        cmd_ready = bits(0, 1)
        data_out = bits(0, 32)
        data_valid = bits(0, 1)

        # Default to NOP
        # CMD_NOP()
        # SDRAM_CS, SDRAM_RAS, SDRAM_CAS, SDRAM_WE = CMD_NOP
        # SDRAM_CS, SDRAM_RAS, SDRAM_CAS, SDRAM_WE = CMD_NOP[3], CMD_NOP[2], CMD_NOP[1], CMD_NOP[0]
        # SDRAM_CS, SDRAM_RAS, SDRAM_CAS, SDRAM_WE = bits(0, 1), bits(1, 1), bits(1, 1), bits(1, 1)
        # SDRAM_CS  = CMD_NOP[3]
        # SDRAM_RAS = CMD_NOP[2]
        # SDRAM_CAS = CMD_NOP[1]
        # SDRAM_WE  = CMD_NOP[0]
        SDRAM_CS  = bits(0, 1)
        SDRAM_RAS = bits(1, 1)
        SDRAM_CAS = bits(1, 1)
        SDRAM_WE  = bits(1, 1)

        SDRAM_ADDR = bits(0, 13)
        SDRAM_BA = bits(0, 2)
        SDRAM_DQM = bits(0, 2)

        is_write = bits(0, 1)

        pending_refresh = pending_refresh - 1

        # Refresh
        if pending_refresh == 0:
            SDRAM_CKE = bits(1, 1)
            SDRAM_CS  = bits(0, 1)
            SDRAM_RAS = bits(0, 1)
            SDRAM_CAS = bits(0, 1)
            SDRAM_WE  = bits(1, 1)

            pending_refresh = bits(eval(int(6400000/8192+1)), 10)
            cmd_enable, cmd_wr, cmd_address, cmd_byte_enable, cmd_data_in, SDRAM_DATA_in = yield cmd_ready, data_out, data_valid, SDRAM_CKE, SDRAM_CS, SDRAM_RAS, SDRAM_CAS, SDRAM_WE, SDRAM_DQM, SDRAM_ADDR, SDRAM_BA, SDRAM_DATA_ctl, SDRAM_DATA_out

            # wait tRFC (66ns)
            for i in range(7):
                # CMD_NOP
                SDRAM_CS  = bits(0, 1)
                SDRAM_RAS = bits(1, 1)
                SDRAM_CAS = bits(1, 1)
                SDRAM_WE  = bits(1, 1)

                SDRAM_ADDR = bits(0, 13)
                SDRAM_BA   = bits(0, 2)
                SDRAM_DQM  = bits(0, 2)

                pending_refresh = pending_refresh - 1
                cmd_enable, cmd_wr, cmd_address, cmd_byte_enable, cmd_data_in, SDRAM_DATA_in = yield cmd_ready, data_out, data_valid, SDRAM_CKE, SDRAM_CS, SDRAM_RAS, SDRAM_CAS, SDRAM_WE, SDRAM_DQM, SDRAM_ADDR, SDRAM_BA, SDRAM_DATA_ctl, SDRAM_DATA_out

        # Read/Write
        elif cmd_enable:
            is_write = cmd_wr
            rwaddr   = cmd_address
            wdata    = cmd_data_in

            row  = rwaddr[21:9]
            bank = rwaddr[8:7]
            col  = bits(0, 7)

            # ACTIVE
            SDRAM_CS  = bits(0, 1)
            SDRAM_RAS = bits(0, 1)
            SDRAM_CAS = bits(1, 1)
            SDRAM_WE  = bits(1, 1)

            SDRAM_ADDR = row & ~bits(1024, 13) # no auto prefresh
            SDRAM_BA   = bank

            cmd_enable, cmd_wr, cmd_address, cmd_byte_enable, cmd_data_in, SDRAM_DATA_in = yield cmd_ready, data_out, data_valid, SDRAM_CKE, SDRAM_CS, SDRAM_RAS, SDRAM_CAS, SDRAM_WE, SDRAM_DQM, SDRAM_ADDR, SDRAM_BA, SDRAM_DATA_ctl, SDRAM_DATA_out

            # wait tRP (20ns)
            for i in range(2):
                # CMD_NOP
                SDRAM_CS  = bits(0, 1)
                SDRAM_RAS = bits(1, 1)
                SDRAM_CAS = bits(1, 1)
                SDRAM_WE  = bits(1, 1)

                SDRAM_ADDR = bits(0, 13)
                SDRAM_BA   = bits(0, 2)
                SDRAM_DQM  = bits(0, 2)

                cmd_enable, cmd_wr, cmd_address, cmd_byte_enable, cmd_data_in, SDRAM_DATA_in = yield cmd_ready, data_out, data_valid, SDRAM_CKE, SDRAM_CS, SDRAM_RAS, SDRAM_CAS, SDRAM_WE, SDRAM_DQM, SDRAM_ADDR, SDRAM_BA, SDRAM_DATA_ctl, SDRAM_DATA_out

            # # wait a cycle...
            # cmd_enable, cmd_wr, cmd_address, cmd_byte_enable, cmd_data_in, SDRAM_DATA_in = yield cmd_ready, data_out, data_valid, SDRAM_CKE, SDRAM_CS, SDRAM_RAS, SDRAM_CAS, SDRAM_WE, SDRAM_DQM, SDRAM_ADDR, SDRAM_BA, SDRAM_DATA_ctl, SDRAM_DATA_out

            # Write
            if is_write:
                # WRITE
                SDRAM_CS  = bits(0, 1)
                SDRAM_RAS = bits(1, 1)
                SDRAM_CAS = bits(0, 1)
                SDRAM_WE  = bits(0, 1)

                # write lower 16 bits
                SDRAM_ADDR = bits(col << 1, 13) & ~bits(1024, 13) # no auto prefresh
                SDRAM_BA   = bank
                SDRAM_DQM  = bits(0, 2)
                SDRAM_DATA = wdata[15:0]

                cmd_enable, cmd_wr, cmd_address, cmd_byte_enable, cmd_data_in, SDRAM_DATA_in = yield cmd_ready, data_out, data_valid, SDRAM_CKE, SDRAM_CS, SDRAM_RAS, SDRAM_CAS, SDRAM_WE, SDRAM_DQM, SDRAM_ADDR, SDRAM_BA, SDRAM_DATA_ctl, SDRAM_DATA_out

                # CMD_NOP
                SDRAM_CS  = bits(0, 1)
                SDRAM_RAS = bits(1, 1)
                SDRAM_CAS = bits(1, 1)
                SDRAM_WE  = bits(1, 1)

                # write upper 16 bits
                SDRAM_ADDR = bits(col << 1, 13) & ~bits(1024, 13) # no auto prefresh
                SDRAM_BA   = bank
                SDRAM_DQM  = bits(0, 2)
                SDRAM_DATA = wdata[31:16]

                cmd_enable, cmd_wr, cmd_address, cmd_byte_enable, cmd_data_in, SDRAM_DATA_in = yield cmd_ready, data_out, data_valid, SDRAM_CKE, SDRAM_CS, SDRAM_RAS, SDRAM_CAS, SDRAM_WE, SDRAM_DQM, SDRAM_ADDR, SDRAM_BA, SDRAM_DATA_ctl, SDRAM_DATA_out

                # Wait a cycle for tRDL to elapse
                SDRAM_CS  = bits(0, 1)
                SDRAM_RAS = bits(1, 1)
                SDRAM_CAS = bits(1, 1)
                SDRAM_WE  = bits(1, 1)

                SDRAM_ADDR = bits(0, 13)
                SDRAM_BA   = bits(0, 2)
                SDRAM_DQM  = bits(0, 2)
                SDRAM_DATA = bits(0, 16)

                cmd_enable, cmd_wr, cmd_address, cmd_byte_enable, cmd_data_in, SDRAM_DATA_in = yield cmd_ready, data_out, data_valid, SDRAM_CKE, SDRAM_CS, SDRAM_RAS, SDRAM_CAS, SDRAM_WE, SDRAM_DQM, SDRAM_ADDR, SDRAM_BA, SDRAM_DATA_ctl, SDRAM_DATA_out

            # Read
            else:
                # READ
                SDRAM_CS  = bits(0, 1)
                SDRAM_RAS = bits(1, 1)
                SDRAM_CAS = bits(0, 1)
                SDRAM_WE  = bits(1, 1)

                SDRAM_ADDR = bits(col << 1, 13) & ~bits(1024, 13) # no auto prefresh
                SDRAM_BA   = bank

                cmd_enable, cmd_wr, cmd_address, cmd_byte_enable, cmd_data_in, SDRAM_DATA_in = yield cmd_ready, data_out, data_valid, SDRAM_CKE, SDRAM_CS, SDRAM_RAS, SDRAM_CAS, SDRAM_WE, SDRAM_DQM, SDRAM_ADDR, SDRAM_BA, SDRAM_DATA_ctl, SDRAM_DATA_out

                # Wait a bit...
                # CMD_NOP
                SDRAM_CS  = bits(0, 1)
                SDRAM_RAS = bits(1, 1)
                SDRAM_CAS = bits(1, 1)
                SDRAM_WE  = bits(1, 1)

                SDRAM_ADDR = bits(0, 13)
                SDRAM_BA   = bits(0, 2)
                SDRAM_DQM  = bits(0, 2)

                cmd_enable, cmd_wr, cmd_address, cmd_byte_enable, cmd_data_in, SDRAM_DATA_in = yield cmd_ready, data_out, data_valid, SDRAM_CKE, SDRAM_CS, SDRAM_RAS, SDRAM_CAS, SDRAM_WE, SDRAM_DQM, SDRAM_ADDR, SDRAM_BA, SDRAM_DATA_ctl, SDRAM_DATA_out

                # CMD_NOP
                SDRAM_CS  = bits(0, 1)
                SDRAM_RAS = bits(1, 1)
                SDRAM_CAS = bits(1, 1)
                SDRAM_WE  = bits(1, 1)

                SDRAM_ADDR = bits(0, 13)
                SDRAM_BA   = bits(0, 2)
                SDRAM_DQM  = bits(0, 2)

                cmd_enable, cmd_wr, cmd_address, cmd_byte_enable, cmd_data_in, SDRAM_DATA_in = yield cmd_ready, data_out, data_valid, SDRAM_CKE, SDRAM_CS, SDRAM_RAS, SDRAM_CAS, SDRAM_WE, SDRAM_DQM, SDRAM_ADDR, SDRAM_BA, SDRAM_DATA_ctl, SDRAM_DATA_out

                # CMD_NOP
                SDRAM_CS  = bits(0, 1)
                SDRAM_RAS = bits(1, 1)
                SDRAM_CAS = bits(1, 1)
                SDRAM_WE  = bits(1, 1)

                SDRAM_ADDR = bits(0, 13)
                SDRAM_BA   = bits(0, 2)
                SDRAM_DQM  = bits(0, 2)

                cmd_enable, cmd_wr, cmd_address, cmd_byte_enable, cmd_data_in, SDRAM_DATA_in = yield cmd_ready, data_out, data_valid, SDRAM_CKE, SDRAM_CS, SDRAM_RAS, SDRAM_CAS, SDRAM_WE, SDRAM_DQM, SDRAM_ADDR, SDRAM_BA, SDRAM_DATA_ctl, SDRAM_DATA_out

                # These two cycles can be overlapped with the
                # precharge but you would need to duplicate the logic
                # everywhere...
                SDRAM_CS  = bits(0, 1)
                SDRAM_RAS = bits(1, 1)
                SDRAM_CAS = bits(1, 1)
                SDRAM_WE  = bits(1, 1)

                SDRAM_ADDR = bits(0, 13)
                SDRAM_BA   = bits(0, 2)
                SDRAM_DQM  = bits(0, 2)

                data_out = bits(SDRAM_DATA_in, 32)

                cmd_enable, cmd_wr, cmd_address, cmd_byte_enable, cmd_data_in, SDRAM_DATA_in = yield cmd_ready, data_out, data_valid, SDRAM_CKE, SDRAM_CS, SDRAM_RAS, SDRAM_CAS, SDRAM_WE, SDRAM_DQM, SDRAM_ADDR, SDRAM_BA, SDRAM_DATA_ctl, SDRAM_DATA_out

                SDRAM_CS  = bits(0, 1)
                SDRAM_RAS = bits(1, 1)
                SDRAM_CAS = bits(1, 1)
                SDRAM_WE  = bits(1, 1)

                SDRAM_ADDR = bits(0, 13)
                SDRAM_BA   = bits(0, 2)
                SDRAM_DQM  = bits(0, 2)

                data_out   = bits(SDRAM_DATA_in << 16, 32) | data_out
                data_valid = bits(1, 1)

                cmd_enable, cmd_wr, cmd_address, cmd_byte_enable, cmd_data_in, SDRAM_DATA_in = yield cmd_ready, data_out, data_valid, SDRAM_CKE, SDRAM_CS, SDRAM_RAS, SDRAM_CAS, SDRAM_WE, SDRAM_DQM, SDRAM_ADDR, SDRAM_BA, SDRAM_DATA_ctl, SDRAM_DATA_out

                data_valid = bits(0, 1)



            # PRECHARGE ALL
            # precharge
            SDRAM_CS  = bits(0, 1)
            SDRAM_RAS = bits(0, 1)
            SDRAM_CAS = bits(0, 1)
            SDRAM_WE  = bits(0, 1)

            # all banks
            # SDRAM_ADDR = bits(int("0010000000000", 2), 13)
            SDRAM_ADDR = bits(1024, 13)
            # SDRAM_ADDR = bits(0, 13)
            # SDRAM_ADDR[10] = bits(1, 1)
            SDRAM_BA   = bits(0, 2)

            cmd_enable, cmd_wr, cmd_address, cmd_byte_enable, cmd_data_in, SDRAM_DATA_in = yield cmd_ready, data_out, data_valid, SDRAM_CKE, SDRAM_CS, SDRAM_RAS, SDRAM_CAS, SDRAM_WE, SDRAM_DQM, SDRAM_ADDR, SDRAM_BA, SDRAM_DATA_ctl, SDRAM_DATA_out

            # wait 10 cycles instead of tRP (20ns) for some reason?
            for i in range(10):
                # CMD_NOP
                SDRAM_CS  = bits(0, 1)
                SDRAM_RAS = bits(1, 1)
                SDRAM_CAS = bits(1, 1)
                SDRAM_WE  = bits(1, 1)

                SDRAM_ADDR = bits(0, 13)
                SDRAM_BA   = bits(0, 2)
                SDRAM_DQM  = bits(0, 2)

                cmd_enable, cmd_wr, cmd_address, cmd_byte_enable, cmd_data_in, SDRAM_DATA_in = yield cmd_ready, data_out, data_valid, SDRAM_CKE, SDRAM_CS, SDRAM_RAS, SDRAM_CAS, SDRAM_WE, SDRAM_DQM, SDRAM_ADDR, SDRAM_BA, SDRAM_DATA_ctl, SDRAM_DATA_out


        # Idle
        else:
            cmd_ready = bits(1, 1)
            cmd_enable, cmd_wr, cmd_address, cmd_byte_enable, cmd_data_in, SDRAM_DATA_in = yield cmd_ready, data_out, data_valid, SDRAM_CKE, SDRAM_CS, SDRAM_RAS, SDRAM_CAS, SDRAM_WE, SDRAM_DQM, SDRAM_ADDR, SDRAM_BA, SDRAM_DATA_ctl, SDRAM_DATA_out


def test_sdram():
    sdram = SilicaSDRAM()
    si_sdram = si.compile(sdram, file_name="tests/build/si_sdram.v")

    tester = fault.Tester(si_sdram, si_sdram.CLK)

    # sdram_driver = SDRAMDriver(tester, si_sdram, si_sdram.CLK)
    # sdram_driver.init_sdram()

    # sdram_driver.write_IR("REGA")
    # sdram_driver.write_IR("REGB", ir_exp="REGA")
    # sdram_driver.write_IR("REGA", ir_exp="REGB")
    # sdram_driver.write_DR(25, 5)
    # sdram_driver.write_DR(15, 5, dr_exp=25)
    # sdram_driver.write_DR(2, 5, dr_exp=15)
    # sdram_driver.write_IR("REGB", ir_exp="REGA")
    # sdram_driver.write_DR(100, 7)
    # sdram_driver.write_DR(50, 7, dr_exp=100)

    tester.compile_and_run(
        target="verilator", directory="tests/build", flags=['-Wno-fatal'])


    # shutil.copy("verilog/sdram.v", "tests/build/sdram_verilog.v")
    # sdram_v = m.DefineFromVerilogFile(
    #     "tests/build/sdram_verilog.v", type_map={"TCK": m.In(m.Clock)})[0]

    # v_tester = tester.retarget(sdram_v, sdram_v.TCK)
    # v_tester.compile_and_run(
    #     target="verilator", directory="tests/build", flags=['-Wno-fatal'])


    #if __name__ == '__main__':
    #    print("===== BEGIN : SILICA RESULTS =====")
    #    evaluate_circuit("serializer_si", "Serializer4")
    #    print("===== END   : SILICA RESULTS =====")

    #    print("===== BEGIN : VERILOG RESULTS =====")
    #    evaluate_circuit("serializer_verilog", "serializer")
    #    print("===== END   : VERILOG RESULTS =====")


if __name__ == '__main__':
    test_sdram()
