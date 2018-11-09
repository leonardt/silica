
module serializer(
  input CLK,
  input valid,
  // yosys doesn't like this syntax
  // input [3:0][15:0] I,
  input [15:0] I0,
  input [15:0] I1,
  input [15:0] I2,
  input [15:0] I3,
  output [15:0] O
);
  reg [15:0] s1;
  reg [15:0] s2;
  reg [15:0] s3;
  reg state = 1'b0;

  reg [1:0] cnt = 2'h0;

  always @(posedge CLK) begin
    if (state == 1'b0 && valid) begin
      cnt <= 2'h0;
      // s1 <= I[1];
      // s2 <= I[2];
      // s3 <= I[3];
      s1 <= I1;
      s2 <= I2;
      s3 <= I3;
      state <= 1'b1;
    end else begin
        cnt <= cnt + 1'b1;
        state <= cnt == 2'h2 ? 1'b0 : 1'b1;
    end
  end

  always @(*) begin
    case(cnt)
      // 2'h0 : O = I[0][15:0];
      2'h0 : O = I0;
      2'h1 : O = s1;
      2'h2 : O = s2;
      2'h3 : O = s3;
    endcase
  end

endmodule

