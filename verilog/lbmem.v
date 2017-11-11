module lbmem(
  input clk,
  input [15:0] wdata,
  input wen,
  output full,
  output [15:0] rdata,
  input ren,
  output empty
) 
  
  localparam LWIDTH = 8;
  localparam DEPTH = 64;

  reg [15:0] data[64];

  reg state = 0;
  
  reg [3:0] cnt = 0;

  always @(posedge clk) begin
    if (state==0) begin
      cnt <= cnt + wen;
    end
    else begin
      cnt <= wen ? cnt : cnt-1;
    end
  end

  always @(posedge clk) begin
    state <= cnt==7 && 
  end

  reg [6:0] waddr = 0;
  reg [6:0] raddr = 0;
  
  reg [15:0] data[64];

  always @(posedge clk) begin
    if (wen) waddr <= waddr+1;
  end

  always @(posedge clk) begin
    if (ren) raddr <= raddr+1;
  end

  always @(posedge clk) begin
    if (ren) data[raddr] <= rdata;
    if (wen) data[waddr] <= wdata;
  end
  
  assign empty = waddr == raddr;
  assign full = (waddr[5:0] == raddr[5:0]) & (waddr[6] == ~raddr[6]);


endmodule
