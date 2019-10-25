module verilog_jtag(input tms, output [3:0] state, input CLK, input RESET);
  localparam TEST_LOGIC_RESET = 4'd15 ,
             RUN_TEST_IDLE = 4'd12 ,
             SELECT_DR_SCAN = 4'd7 ,
             CAPTURE_DR = 4'd6 ,
             SHIFT_DR = 4'd2 ,
             EXIT1_DR = 4'd1 ,
             PAUSE_DR = 4'd3 ,
             EXIT2_DR = 4'd0 ,
             UPDATE_DR = 4'd5 ,
             SELECT_IR_SCAN = 4'd4 ,
             CAPTURE_IR = 4'd14 ,
             SHIFT_IR = 4'd10 ,
             EXIT1_IR = 4'd9 ,
             PAUSE_IR = 4'd11 ,
             EXIT2_IR = 4'd8 ,
             UPDATE_IR = 4'd13;
  reg [3:0] CS;
  reg [3:0] NS;
  assign state = CS;
  always @(posedge CLK, posedge RESET) begin
    if (RESET) begin
      CS <= TEST_LOGIC_RESET;
    end else begin
      CS <= NS;
    end
  end
  always @(*) begin
    case(CS)
      TEST_LOGIC_RESET : NS = tms ? TEST_LOGIC_RESET : RUN_TEST_IDLE;
      RUN_TEST_IDLE : NS = tms ? SELECT_DR_SCAN : RUN_TEST_IDLE ;
      SELECT_DR_SCAN : NS = tms ? SELECT_IR_SCAN : CAPTURE_DR ;
      CAPTURE_DR : NS = tms ? EXIT1_DR : SHIFT_DR ;
      SHIFT_DR : NS = tms ? EXIT1_DR : SHIFT_DR ;
      EXIT1_DR : NS = tms ? UPDATE_DR : PAUSE_DR ;
      PAUSE_DR : NS = tms ? EXIT2_DR : PAUSE_DR ;
      EXIT2_DR : NS = tms ? UPDATE_DR : SHIFT_DR ;
      UPDATE_DR : NS = tms ? SELECT_DR_SCAN : RUN_TEST_IDLE ;
      SELECT_IR_SCAN : NS = tms ? TEST_LOGIC_RESET : CAPTURE_IR ;
      CAPTURE_IR : NS = tms ? EXIT1_IR : SHIFT_IR ;
      SHIFT_IR : NS = tms ? EXIT1_IR : SHIFT_IR ;
      EXIT1_IR : NS = tms ? UPDATE_IR : PAUSE_IR ;
      PAUSE_IR : NS = tms ? EXIT2_IR : PAUSE_IR ;
      EXIT2_IR : NS = tms ? UPDATE_IR : SHIFT_IR ;
      UPDATE_IR : NS = tms ? SELECT_DR_SCAN : RUN_TEST_IDLE ;
    endcase
  end
endmodule
