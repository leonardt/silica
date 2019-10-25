module vdot(input CLK, input RESET, input I, 
            output cb, output is_);
  reg [1:0] state;
  always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
        state <= 0;
    end else begin
      case (state)
        2'h0: begin
          state <= I ? 2'h1 : 2'h0;
        end 
        2'h1: begin
          state <= ~I ? 2'h0 : 2'h2;
        end
        2'h2: begin
          state <= I ? 2'h2 : 2'h0;
        end
      endcase
    end
  end
  assign is_ = (state == 2'h1) ? ~I : 1'b0;
  assign cb = (state == 2'h0) ? I : 1'b0;
endmodule
