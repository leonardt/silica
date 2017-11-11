module lbmem(
  input clk,
  input [15:0] wdata,
  input wen,
  output [15:0] rdata,
  output valid
);
  
  //parameter LWIDTH = 8;
  //parameter DEPTH = 64;

  reg [15:0] data[64];

  reg state = 0;
  
  reg [3:0] cnt = 0;

  always @(posedge clk) begin
    if (state==0) begin
      cnt <= cnt + {3'h0,wen};
    end
    else begin
      cnt <= wen ? cnt : cnt-1;
    end
  end

  always @(posedge clk) begin
    if (state==0) begin
      state <= (cnt==7 & wen); //cnt will be 8 on transition
    end
    else begin 
      state <= (cnt==1 & ~wen);
    end
  end
  assign valid = state; 

  reg [5:0] waddr = 0;
  wire [5:0] raddr;
  assign raddr = waddr - {2'h0,cnt};

  always @(posedge clk) begin
    if (wen) waddr <= waddr+1;
  end
endmodule
