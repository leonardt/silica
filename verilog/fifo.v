module fifo(
  input clk,
  input [15:0] wdata,
  input wen,
  output full,
  output [15:0] rdata,
  input ren,
  output empty
); 

  reg [6:0] waddr = 0;
  reg [6:0] raddr = 0;
  
  reg [15:0] data[64];
  
  wire wvalid;
  wire rvalid;
  assign wvalid = wen & ~full;
  assign rvalid = ren & ~empty;

  always @(posedge clk) begin
    if (wvalid) waddr <= waddr+1;
  end

  always @(posedge clk) begin
    if (rvalid) raddr <= raddr+1;
  end

  always @(posedge clk) begin
    if (wvalid) data[waddr[5:0]] <= wdata;
  end
  
  assign rdata = data[raddr[5:0]];
  assign empty = waddr == raddr;
  assign full = (waddr[5:0] == raddr[5:0]) & (waddr[6] == ~raddr[6]);


endmodule
