module tap(
  input TCK,
  input TMS,
  input TDI,
  output TDO,
 
  output reg [3:0] IR, //Instruction Register
  output reg [4:0] regA, //Register at IR=2, which is 5 bits wide
  output reg [6:0] regB, //Register at IR=14, which is 7 bits wide
  output update_dr,
  output update_ir,

  //Debug signals.
  output [3:0] cs, 
  output [3:0] ns, 
  output shift_ir, 
  output shift_dr 
);

  localparam TEST_LOGIC_RESET = 4'd0 ,
             RUN_TEST_IDLE = 4'd1 ,
             SELECT_DR_SCAN = 4'd2 ,
             CAPTURE_DR = 4'd3 ,
             SHIFT_DR = 4'd4 ,
             EXIT1_DR = 4'd5 ,
             PAUSE_DR = 4'd6 ,
             EXIT2_DR = 4'd7 ,
             UPDATE_DR = 4'd8 ,
             SELECT_IR_SCAN = 4'd9 ,
             CAPTURE_IR = 4'd10 ,
             SHIFT_IR = 4'd11 ,
             EXIT1_IR = 4'd12 ,
             PAUSE_IR = 4'd13 ,
             EXIT2_IR = 4'd14 ,
             UPDATE_IR = 4'd15;
  
  reg [3:0] CS = TEST_LOGIC_RESET;
  reg [3:0] NS;

  assign cs = CS;
  assign ns = NS;

  always @(posedge TCK) begin
    CS <= NS;
  end

  always @(*) begin
    case(CS)
      TEST_LOGIC_RESET : NS = TMS ? TEST_LOGIC_RESET : RUN_TEST_IDLE;
      RUN_TEST_IDLE : NS = TMS ? SELECT_DR_SCAN : RUN_TEST_IDLE ;
      SELECT_DR_SCAN : NS = TMS ? SELECT_IR_SCAN : CAPTURE_DR ;
      CAPTURE_DR : NS = TMS ? EXIT1_DR : SHIFT_DR ;
      SHIFT_DR : NS = TMS ? EXIT1_DR : SHIFT_DR ;
      EXIT1_DR : NS = TMS ? UPDATE_DR : PAUSE_DR ;
      PAUSE_DR : NS = TMS ? EXIT2_DR : PAUSE_DR ;
      EXIT2_DR : NS = TMS ? UPDATE_DR : SHIFT_DR ;
      UPDATE_DR : NS = TMS ? SELECT_DR_SCAN : RUN_TEST_IDLE ;
      SELECT_IR_SCAN : NS = TMS ? TEST_LOGIC_RESET : CAPTURE_IR ;
      CAPTURE_IR : NS = TMS ? EXIT1_IR : SHIFT_IR ;
      SHIFT_IR : NS = TMS ? EXIT1_IR : SHIFT_IR ;
      EXIT1_IR : NS = TMS ? UPDATE_IR : PAUSE_IR ;
      PAUSE_IR : NS = TMS ? EXIT2_IR : PAUSE_IR ;
      EXIT2_IR : NS = TMS ? UPDATE_IR : SHIFT_IR ;
      UPDATE_IR : NS = TMS ? SELECT_IR_SCAN : RUN_TEST_IDLE ;
    endcase
  end
  
  //wire update_dr;
  assign update_dr = CS==UPDATE_DR;

  //wire shift_dr;
  assign shift_dr = CS==SHIFT_DR;

  //Do not need this right now
  //wire update_ir;
  assign update_ir = CS==UPDATE_IR;

  //wire shift_ir;
  assign shift_ir = CS==SHIFT_IR;

  wire shift_regA = shift_dr & (IR==4'd2);
  wire shift_regB = shift_dr & (IR==4'd14);

  assign TDO = shift_ir ? IR[0] : (shift_regA ? regA[0] : (shift_regB ? regB[0] : 1'b0 ));

  always @(posedge TCK) begin
    if (shift_ir) begin
      IR <= {TDI,IR[3:1]};
    end
  end
  
  always @(posedge TCK) begin
    if (shift_regA) begin
      regA <= {TDI,regA[4:1]};
    end
  end
  
  always @(posedge TCK) begin
    if (shift_regB) begin
      regB <= {TDI,regB[6:1]};
    end
  end

  //Registers required:
  //BYPASS = all ones single bit register
  //SAMPLE
  //PRELOAD
  //EXTEST
endmodule
