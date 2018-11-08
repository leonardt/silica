module lbmem(
  input CLK,
  input [7:0] wdata,
  input wen,
  output [7:0] rdata,
  output valid
);
  
  //parameter LWIDTH = 8;
  //parameter DEPTH = 64;

  reg [7:0] data [0:63];

  reg state = 0;
  
  reg [4:0] cnt = 0;

  always @(posedge CLK) begin
    if (state==0) begin
      cnt <= cnt + {3'h0,wen};
    end
    else begin
      cnt <= wen ? cnt : cnt-1;
    end
  end

  always @(posedge CLK) begin
    if (state==0) begin
      state <= (cnt==7 & wen); //cnt will be 8 on transition
    end
    else begin 
      state <= (cnt!=1 | wen);
    end
  end
  assign valid = (state & (cnt!=1 | wen)) | (cnt == 7 & wen); 

  reg [5:0] waddr = 0;
  wire [5:0] raddr;
  assign raddr = waddr - {2'h0, wen ? cnt : cnt-1};

  always @(posedge CLK) begin
    if (wen) begin
      data[waddr] <= wdata;
      waddr <= waddr+1;
    end
  end

  assign rdata = data[raddr];
endmodule
