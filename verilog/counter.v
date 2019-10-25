module vcounter(input CLK, input RESET, output [2:0] O);
reg [2:0] O;
always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
        O <= 0;
    end else begin
        O <= O + 1'b1;
    end
end
endmodule
