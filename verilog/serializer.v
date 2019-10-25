
module serializer( input CLK, input RESET, input [15:0] I0, input [15:0] I1, input [15:0] I2, input [15:0] I3, output [15:0] O);
  reg [15:0] s1;
  reg [15:0] s2;
  reg [15:0] s3;
  reg [1:0] cnt;
  always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
      cnt <= 0;
    end else begin
      cnt <= (cnt==3) ? 0 : (cnt + 1);
      if (cnt==2'h0) begin
        s1 <= I1;
        s2 <= I2;
        s3 <= I3;
      end
    end
  end
  always @(*) begin
    case(cnt)
      2'h0 : O = I0;
      2'h1 : O = s1;
      2'h2 : O = s2;
      2'h3 : O = s3;
    endcase
  end
endmodule
