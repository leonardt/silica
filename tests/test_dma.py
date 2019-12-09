import silica as si
from silica import bits


# input              clk,
# input              rst,
#
# input              start_pulse,
# // AXI read interface

# axi_if.master      axi_rd,
#
# // Input image read address, byte units
# input [AW-1:0]     addr_input,
#
# // Input image bytes to the pyramid core
# output logic [7:0] cam_stream_rsc_dat,
# output logic       cam_stream_rsc_vld,
# input              cam_stream_rsc_rdy,
#
# input [9:0]        ctrlreg_width,
# input [9:0]        ctrlreg_height,
#
# // Flag if an error occurred during a read
# output logic       error_read_response

# AXI signals
# ===========
# ARADDR
# ARBURST
# ARSIZE
# ARVALID
# ARREADY
# RDATA
# RVALID
# RREADY

AW = 8
DW = 64
RESET = 1


@si.coroutine
def dma(
    start_pulse: si.Bit,
    addr_input: si.Bits[AW],
    cam_stream_rsc_rdy: si.Bit,
    ctrlreg_width: si.Bits[10],
    ctrlreg_height: si.Bits[10],
    RDATA: si.Bits[DW],
    RVALID: si.Bit,
    ARREADY: si.Bit
) -> {
    "ARADDR": si.Bits[AW],
    "ARBURST": si.Bits[2],
    "ARSIZE": si.Bits[3],
    "ARLENGTH": si.Bits[8],
    "ARVALID": si.Bit,
    "RREADY": si.Bit,
    "cam_stream_rsc_dat": si.Bits[8],
    "cam_stream_rsc_vld": si.Bit,
    "error_read_response": si.Bit
}:
    i = bits(0, 10)
    j = bits(0, 5)
    k = bits(0, 4)
    while True:
        ARADDR = bits(0, AW)
        ARBURST = 1
        ARSIZE = 3
        ARLENGTH = 15
        ARVALID = 0
        RREADY = 0
        cam_stream_rsc_vld = 0
        cam_stream_rsc_dat = bits(0, 8)
        yield
        if start_pulse:
            # AXI Read Request
            num_requests = (ctrlreg_width * ctrlreg_height) >> bits(7, 10)
            for i in range(num_requests):
                ARADDR = ARADDR + 128
                ARVALID = 1
                while ~ARREADY:
                    yield
                yield  # complete handshake
                ARVALID = 0

                # Handle Read Responses
                for j in range(16):
                    RREADY = 1
                    while ~RVALID:
                        yield
                    yield
                    RREADY = 0
                    data = RDATA
                    # Push each byte cam_stream_channel
                    for k in range(DW // 8):
                        # cam_stream_rsc_dat = data[k*8:(k+1)*8 + 1]
                        cam_stream_rsc_dat = data[0:9]
                        data = data >> 8
                        cam_stream_rsc_vld = 1
                        while ~cam_stream_rsc_rdy:
                            yield
                        yield
                        cam_stream_rsc_vld = 0

si.compile(dma(), file_name="dma.v")
