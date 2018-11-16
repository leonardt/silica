module vcounter(input CLK, output [2:0] O);
reg [2:0] O;
always @(posedge CLK) begin
    O <= O + 1'b1;
end
endmodule
