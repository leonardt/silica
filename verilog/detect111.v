module detect111(
  input CLK,
  input I,
  output O
);
  reg [1:0] cnt = 2'h0;

  wire [1:0] cnt_next;

  always @(posedge CLK) begin
    cnt <= cnt_next;
  end

  // mealey version
  assign cnt_next = I ? (cnt==2'h3 ? cnt : cnt+1'b1) : 2'h0;
  assign O = (cnt_next==2'h3);
  /* assign O = (cnt==3); */

endmodule
