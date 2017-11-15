module fifo(
  input CLK,
  input [4:0] wdata,
  input wen,
  output full,
  output [4:0] rdata,
  input ren,
  output empty
); 

  reg [2:0] waddr = 0;
  reg [2:0] raddr = 0;
  
  reg [4:0] data[4];
  
  wire wvalid;
  wire rvalid;
  assign wvalid = wen & ~full;
  assign rvalid = ren & ~empty;

  always @(posedge CLK) begin
    if (wvalid) waddr <= waddr+1;
  end

  always @(posedge CLK) begin
    if (rvalid) raddr <= raddr+1;
  end

  always @(posedge CLK) begin
    if (wvalid) data[waddr[1:0]] <= wdata;
  end
  
  assign rdata = data[raddr[1:0]];
  assign empty = waddr == raddr;
  assign full = (waddr[1:0] == raddr[1:0]) & (waddr[2] == ~raddr[2]);


endmodule
