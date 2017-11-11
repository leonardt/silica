
module serializer(
  input clk,
  input [3:0][15:0] I,
  output O
) 
  reg [15:0] s1;
  reg [15:0] s2;
  reg [15:0] s3;
  
  reg [1:0] cnt = 0;

  always @(posedge clk) begin
    cnt <= (cnt==3) ? 0 : (cnt + 1)
  end
  
  always @(posedge clk) begin
    if (cnt==2'h0) begin
      s1 <= I[1];
      s2 <= I[2];
      s3 <= I[3];
    end
  end

  always @(*) begin
    case(cnt) begin
      2'h0 : O = I[0][15:0];
      2'h1 : O = s1;
      2'h2 : O = s2;
      2'h3 : O = s3;
    end
  end

endmodule

