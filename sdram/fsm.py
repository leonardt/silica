import sys
sys.path.append("../jtag")
from compile import FSM, Bit, State, Bits, compile


CLK_FREQUENCY = 133   # Mhz
REFRESH_TIME = 32     # ms     (how often we need to refresh)
REFRESH_COUNT = 8192  # cycles (how many refreshes required per refresh time)

# clk / refresh =  clk / sec
#                , sec / refbatch
#                , ref / refbatch
CYCLES_BETWEEN_REFRESH = \
    (CLK_FREQUENCY * 1_000 * REFRESH_TIME) // REFRESH_COUNT

IDLE = "5'b00000"

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

CMD_PALL = "8'b10010001"
CMD_REF = "8'b10001000"
CMD_NOP = "8'b10111000"
CMD_MRS = "8'b1000000x"
CMD_BACT = "8'b10011xxx"
CMD_READ = "8'b10101xx1"
CMD_WRIT = "8'b10100xx1"


class SDRAM(FSM):
    inputs = {
        "refresh_cnt": Bits[10],
        "rd_enable": Bit,
        "wr_enable": Bit
    }
    outputs = {
        "state": State,
        "cmd": Bits[8]
    }
    registers = {
        "_": Bits[3]
    }

    def __call__(self):
        yield from self.init()

    def init(self):
        refresh_cnt, rd_enable, wr_enable = yield INIT_NOP1, CMD_NOP
        refresh_cnt, rd_enable, wr_enable = yield INIT_PRE1, CMD_PALL
        refresh_cnt, rd_enable, wr_enable = yield INIT_NOP1_1, CMD_NOP
        refresh_cnt, rd_enable, wr_enable = yield INIT_REF1, CMD_REF
        for _ in range(7, -1, -1):
            refresh_cnt, rd_enable, wr_enable = yield INIT_NOP2, CMD_NOP
        refresh_cnt, rd_enable, wr_enable = yield INIT_REF2, CMD_REF
        for _ in range(7, -1, -1):
            refresh_cnt, rd_enable, wr_enable = yield INIT_NOP3, CMD_NOP
        refresh_cnt, rd_enable, wr_enable = yield INIT_LOAD, CMD_MRS
        for _ in range(2, -1, -1):
            refresh_cnt, rd_enable, wr_enable = yield INIT_NOP4, CMD_NOP
        yield from self.idle()

    def idle(self):
        refresh_cnt, rd_enable, wr_enable = yield IDLE, CMD_NOP
        if refresh_cnt >= CYCLES_BETWEEN_REFRESH:
            yield from self.refresh()
        elif rd_enable:
            yield from self.read()
        elif wr_enable:
            yield from self.write()

    def refresh(self):
        refresh_cnt, rd_enable, wr_enable = yield REF_PRE, CMD_PALL
        refresh_cnt, rd_enable, wr_enable = yield REF_NOP1, CMD_NOP
        refresh_cnt, rd_enable, wr_enable = yield REF_REF, CMD_REF
        for _ in range(7, -1, -1):
            refresh_cnt, rd_enable, wr_enable = yield REF_NOP2, CMD_NOP
        yield from self.idle()

    def write(self):
        refresh_cnt, rd_enable, wr_enable = yield WRIT_ACT, CMD_BACT
        for _ in range(2, -1, -1):
            refresh_cnt, rd_enable, wr_enable = yield WRIT_NOP1, CMD_NOP
        refresh_cnt, rd_enable, wr_enable = yield WRIT_CAS, CMD_WRIT
        for _ in range(2, -1, -1):
            refresh_cnt, rd_enable, wr_enable = yield WRIT_NOP2, CMD_NOP
        yield from self.idle()

    def read(self):
        refresh_cnt, rd_enable, wr_enable = yield READ_ACT, CMD_BACT
        for _ in range(2, -1, -1):
            refresh_cnt, rd_enable, wr_enable = yield READ_NOP1, CMD_NOP
        refresh_cnt, rd_enable, wr_enable = yield READ_CAS, CMD_READ
        for _ in range(2, -1, -1):
            refresh_cnt, rd_enable, wr_enable = yield READ_NOP2, CMD_NOP
        refresh_cnt, rd_enable, wr_enable = yield READ_READ, CMD_NOP
        yield from self.idle()


compile("fsm.py")
