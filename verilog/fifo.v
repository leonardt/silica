module fifo(input CLK, input RESET, input [3:0] wdata, input wen, output full, output [3:0] rdata, input ren, output empty); 
  reg [2:0] waddr;
  reg [2:0] raddr;
  reg [3:0] data [0:3];
  wire wvalid;
  wire rvalid;
  assign wvalid = wen & ~full;
  assign rvalid = ren & ~empty;
  always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
        waddr <= 3'h0;
        raddr <= 3'h0;
    end else begin
      if (wvalid) waddr <= waddr+1'b1;
      if (rvalid) raddr <= raddr+1'b1;
      if (wvalid) data[waddr[1:0]] <= wdata;
    end
  end
  assign rdata = data[raddr[1:0]];
  assign empty = waddr == raddr;
  assign full = (waddr[1:0] == raddr[1:0]) & (waddr[2] == ~raddr[2]);
endmodule
