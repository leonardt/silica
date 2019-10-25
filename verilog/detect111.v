module detect111(
  input CLK,
  input RESET,
  input I,
  output O
);
  reg [1:0] cnt;
  wire [1:0] cnt_next;
  always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
      cnt <= 0;
    end else begin
      cnt <= cnt_next;
    end
  end
  assign cnt_next = I ? (cnt==2'h3 ? cnt : cnt+1'b1) : 2'h0;
  assign O = (cnt_next==2'h3);
endmodule
