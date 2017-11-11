module detect111(
  input clk,
  input I,
  output O
) 
  reg [1:0] cnt = 0;

  wire [1:0] cnt_next;

  always @(posedge clk) begin
    cnt <= cnt_next;
  end

  assign cnt_next = i ? (cnt==3 ? cnt+1 : cnt) : 0;
  assign O = (cnt==3);

endmodule
