import mantle
import os
import logging
logging.basicConfig(level=logging.DEBUG)
import fault
import magma as m
from silica import Bit, coroutine, Bits, generator, compile, bit, \
    Register, bits

CLK_FREQUENCY = 133   # Mhz
REFRESH_TIME = 32     # ms     (how often we need to refresh)
REFRESH_COUNT = 8192  # cycles (how many refreshes required per refresh time)

# clk / refresh =  clk / sec
#                , sec / refbatch
#                , ref / refbatch
CYCLES_BETWEEN_REFRESH = \
    (CLK_FREQUENCY * 1_000 * REFRESH_TIME) // REFRESH_COUNT

IDLE = "5'b00000"
# IDLE = 0b00000

INIT_NOP1 = "5'b01000"
INIT_PRE1 = "5'b01001"
INIT_NOP1_1 = "5'b00101"
INIT_REF1 = "5'b01010"
INIT_NOP2 = "5'b01011"
INIT_REF2 = "5'b01100"
INIT_NOP3 = "5'b01101"
INIT_LOAD = "5'b01110"
INIT_NOP4 = "5'b01111"

REF_PRE = "5'b00001"
REF_NOP1 = "5'b00010"
REF_REF = "5'b00011"
REF_NOP2 = "5'b00100"

READ_ACT = "5'b10000"
READ_NOP1 = "5'b10001"
READ_CAS = "5'b10010"
READ_NOP2 = "5'b10011"
READ_READ = "5'b10100"

WRIT_ACT = "5'b11000"
WRIT_NOP1 = "5'b11001"
WRIT_CAS = "5'b11010"
WRIT_NOP2 = "5'b11011"

# INIT_NOP1 = 0b01000
# INIT_PRE1 = 0b01001
# INIT_NOP1_1 = 0b00101
# INIT_REF1 = 0b01010
# INIT_NOP2 = 0b01011
# INIT_REF2 = 0b01100
# INIT_NOP3 = 0b01101
# INIT_LOAD = 0b01110
# INIT_NOP4 = 0b01111

# REF_PRE = 0b00001
# REF_NOP1 = 0b00010
# REF_REF = 0b00011
# REF_NOP2 = 0b00100

# READ_ACT = 0b10000
# READ_NOP1 = 0b10001
# READ_CAS = 0b10010
# READ_NOP2 = 0b10011
# READ_READ = 0b10100

# WRIT_ACT = 0b11000
# WRIT_NOP1 = 0b11001
# WRIT_CAS = 0b11010
# WRIT_NOP2 = 0b11011

CMD_PALL = "8'b10010001"
CMD_REF = "8'b10001000"
CMD_NOP = "8'b10111000"
CMD_MRS = "8'b1000000x"
CMD_BACT = "8'b10011xxx"
CMD_READ = "8'b10101xx1"
CMD_WRIT = "8'b10100xx1"

# CMD_PALL = bits(0b10010001, 8)
# CMD_REF = bits(0b10001000, 8)
# CMD_NOP = bits(0b10111000, 8)
# CMD_MRS = bits(0b10000000, 8)
# CMD_BACT = bits(0b10011000, 8)
# CMD_READ = bits(0b10101001, 8)
# CMD_WRIT = bits(0b10100001, 8)


@coroutine
def _SDRAMController(refresh_cnt: Bits[10], rd_enable: Bit, wr_enable: Bit) -> {
        "state": Register(Bits[5]),
        "cmd": Register(Bits[8]),
        "n": Bits[4]
}:
    refresh_cnt, rd_enable, wr_enable = yield from init()
    while True:
        refresh_cnt, rd_enable, wr_enable = yield IDLE, CMD_NOP, 0
        if refresh_cnt >= CYCLES_BETWEEN_REFRESH:
            refresh_cnt, rd_enable, wr_enable = yield from refresh()
        elif wr_enable:
            refresh_cnt, rd_enable, wr_enable = yield from write()
        elif rd_enable:
            refresh_cnt, rd_enable, wr_enable = yield from read()


@generator
def init():
    refresh_cnt, rd_enable, wr_enable = yield INIT_NOP1, CMD_NOP, 15
    refresh_cnt, rd_enable, wr_enable = yield INIT_PRE1, CMD_PALL, 0
    refresh_cnt, rd_enable, wr_enable = yield INIT_NOP1_1, CMD_NOP, 0
    refresh_cnt, rd_enable, wr_enable = yield INIT_REF1, CMD_REF, 0
    refresh_cnt, rd_enable, wr_enable = yield INIT_NOP2, CMD_NOP, 7
    refresh_cnt, rd_enable, wr_enable = yield INIT_REF2, CMD_REF, 0
    refresh_cnt, rd_enable, wr_enable = yield INIT_NOP3, CMD_NOP, 7
    refresh_cnt, rd_enable, wr_enable = yield INIT_LOAD, CMD_MRS, 0
    refresh_cnt, rd_enable, wr_enable = yield INIT_NOP4, CMD_NOP, 1
    return refresh_cnt, rd_enable, wr_enable


@generator
def refresh():
    refresh_cnt, rd_enable, wr_enable = yield REF_PRE, CMD_PALL, 0
    refresh_cnt, rd_enable, wr_enable = yield REF_NOP1, CMD_NOP, 0
    refresh_cnt, rd_enable, wr_enable = yield REF_REF, CMD_REF, 0
    refresh_cnt, rd_enable, wr_enable = yield REF_NOP2, CMD_NOP, 7
    return refresh_cnt, rd_enable, wr_enable


@generator
def write():
    refresh_cnt, rd_enable, wr_enable = yield WRIT_ACT, CMD_BACT, 0
    refresh_cnt, rd_enable, wr_enable = yield WRIT_NOP1, CMD_NOP, 1
    refresh_cnt, rd_enable, wr_enable = yield WRIT_CAS, CMD_WRIT, 0
    refresh_cnt, rd_enable, wr_enable = yield WRIT_NOP2, CMD_NOP, 1
    return refresh_cnt, rd_enable, wr_enable

@generator
def read():
    refresh_cnt, rd_enable, wr_enable = yield READ_ACT, CMD_BACT, 0
    refresh_cnt, rd_enable, wr_enable = yield READ_NOP1, CMD_NOP, 1
    refresh_cnt, rd_enable, wr_enable = yield READ_CAS, CMD_READ, 0
    refresh_cnt, rd_enable, wr_enable = yield READ_NOP2, CMD_NOP, 1
    refresh_cnt, rd_enable, wr_enable = yield READ_READ, CMD_NOP, 0
    return refresh_cnt, rd_enable, wr_enable


class SDRAMController(m.Circuit):
    IO = ["refresh_cnt", m.In(m.Bits[10]), "rd_enable", m.In(m.Bit), "wr_enable", m.In(m.Bit), "state", m.Out(m.Bits[5]), "cmd", m.Out(m.Bits[8])] + m.ClockInterface(has_reset=True)

    @classmethod
    def definition(io):
        silica_sdram = _SDRAMController()
        inst = compile(silica_sdram, file_name="si_sdram.v", strategy="by_path", reset_type="negedge", has_ce=True)()
        enable = m.DefineFromVerilog("""
module enable(input CLK, input RESET, input [3:0] n, output CE);
reg [3:0] count;

always @(posedge CLK or negedge RESET) begin
    if (!RESET) begin
        count <= 4'hf;
    end else begin
        count <= count == 0 ? n : count - 1;
    end
end

assign CE = count == 0;

endmodule
""", type_map={"CLK": m.In(m.Clock), "RESET": m.In(m.Reset)})[0]()
        inst.refresh_cnt <= io.refresh_cnt
        inst.rd_enable <= io.rd_enable
        inst.wr_enable <= io.wr_enable
        io.state <= inst.state
        io.cmd <= inst.cmd
        inst.CE <= enable(inst.n, CLK=io.CLK, RESET=io.RESET)


def test_sdram():
    circ = SDRAMController

    tester = fault.Tester(circ, circ.CLK)
    tester.circuit.RESET = 1
    tester.eval()
    tester.circuit.RESET = 0
    tester.eval()
    tester.circuit.RESET = 1
    tester.eval()
    for i in range(16):
        tester.circuit.state.expect(0b01000)
        tester.circuit.cmd.expect(0b10111000)
        tester.step(2)
    tester.circuit.state.expect(0b01001)
    tester.circuit.cmd.expect(0b10010001)
    tester.step(2)
    tester.circuit.state.expect(0b00101)
    tester.circuit.cmd.expect(0b10111000)
    tester.step(2)
    tester.circuit.state.expect(0b01010)
    tester.circuit.cmd.expect(0b10001000)
    tester.step(2)
    print(tester)

    tester.compile_and_run("verilator", magma_output="coreir-verilog")