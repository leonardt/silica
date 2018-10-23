module vdot(input CLK, input I, 
            output cb, output is_);
  reg [1:0] state;
  always @(posedge CLK) begin
    case (state)
      0: begin
        state <= I ? 1 : 0;
      end 
      1: begin
        state <= ~I ? 1 : 2;
      end
      2: begin
        state <= I ? 2 : 0;
      end
    endcase
  end
  assign cb = (state == 0) ? I : 0;
  assign is_ = (state == 1) ? ~I : 0;
endmodule
