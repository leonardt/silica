module lbmem(input CLK, input RESET, input [7:0] wdata, input wen, output [7:0] rdata, output valid);
  reg [7:0] data [0:63];
  reg state;
  reg [2:0] cnt;
  reg [5:0] waddr;
  wire [5:0] raddr;
  always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
        state <= 1'b0;
        cnt <= 5'h0;
        waddr <= 6'h0;
    end else begin
      if (state==1'b0) begin
        cnt <= cnt + {3'h0,wen};
        state <= (cnt==3'h7 & wen); //cnt will be 8 on transition
      end
      else begin
        cnt <= wen ? cnt : cnt-1'b1;
        state <= (cnt!=3'h1 | wen);
      end
      if (wen) begin
        data[waddr] <= wdata;
        waddr <= waddr+1'b1;
      end
    end
  end
  assign valid = (state & (cnt!=3'h1 | wen)) | (cnt == 3'h7 & wen); 
  assign raddr = waddr - {2'h0, (wen ? cnt : cnt-1'b1)};
  assign rdata = data[raddr];
endmodule
