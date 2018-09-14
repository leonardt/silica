module detect111(
  input CLK,
  input I,
  output O
);
  reg [1:0] cnt = 0;

  /* wire [1:0] cnt_next; */

  always @(posedge CLK) begin
    cnt <= I ? (cnt==3 ? cnt : cnt+1) : 0;
  end

  // mealey version
  /* assign cnt_next = I ? (cnt==3 ? cnt : cnt+1) : 0; */
  // assign O = (cnt_next==3);
  assign O = (cnt==3);

endmodule
