
module serializer(
  input CLK,
  // yosys doesn't like this syntax
  // input [3:0][15:0] I,
  input [63:0] I,
  output [15:0] O
);
  reg [15:0] s1;
  reg [15:0] s2;
  reg [15:0] s3;
  
  reg [1:0] cnt = 0;

  always @(posedge CLK) begin
    cnt <= (cnt==3) ? 0 : (cnt + 1);
  end
  
  always @(posedge CLK) begin
    if (cnt==2'h0) begin
      // s1 <= I[1];
      // s2 <= I[2];
      // s3 <= I[3];
      s1 <= I[31:16];
      s2 <= I[47:32];
      s3 <= I[63:48];
    end
  end

  always @(*) begin
    case(cnt)
      // 2'h0 : O = I[0][15:0];
      2'h0 : O = I[15:0];
      2'h1 : O = s1;
      2'h2 : O = s2;
      2'h3 : O = s3;
    endcase
  end

endmodule

