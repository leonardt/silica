// Generated from rocket-chip@9be1621ce3dfd2ffa971d106649657db38288d5a
// using CONFIG=DefaultConfigRBB
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif

module AsyncResetReg (d, q, en, clk, rst);
parameter RESET_VALUE = 0;

input  wire d;
output reg  q;
input  wire en;
input  wire clk;
input  wire rst;

   // There is a lot of initialization
   // here you don't normally find in Verilog
   // async registers because of scenarios in which reset
   // is not actually asserted cleanly at time 0,
   // and we want to make sure to properly model
   // that, yet Chisel codebase is absolutely intolerant
   // of Xs.
`ifndef SYNTHESIS
  initial begin:B0
    `ifdef RANDOMIZE
    integer    initvar;
    reg [31:0] _RAND;
    _RAND = {1{$random}};
    q = _RAND[0];
    `endif // RANDOMIZE
    if (rst) begin
      q = RESET_VALUE[0];
    end 
  end
`endif

   always @(posedge clk or posedge rst) begin

      if (rst) begin
         q <= RESET_VALUE[0];
      end else if (en) begin
         q <= d;
      end
   end
 
endmodule // AsyncResetReg


module AsyncResetRegVec_w4_i15( // @[:freechips.rocketchip.system.DefaultConfigRBB.fir@168434.2]
  input        clock, // @[:freechips.rocketchip.system.DefaultConfigRBB.fir@168435.4]
  input        reset, // @[:freechips.rocketchip.system.DefaultConfigRBB.fir@168436.4]
  input  [3:0] io_d, // @[:freechips.rocketchip.system.DefaultConfigRBB.fir@168437.4]
  output [3:0] io_q // @[:freechips.rocketchip.system.DefaultConfigRBB.fir@168437.4]
);
  wire  reg_0_d; // @[AsyncResetReg.scala 61:11:freechips.rocketchip.system.DefaultConfigRBB.fir@168442.4]
  wire  reg_0_q; // @[AsyncResetReg.scala 61:11:freechips.rocketchip.system.DefaultConfigRBB.fir@168442.4]
  wire  reg_0_en; // @[AsyncResetReg.scala 61:11:freechips.rocketchip.system.DefaultConfigRBB.fir@168442.4]
  wire  reg_0_clk; // @[AsyncResetReg.scala 61:11:freechips.rocketchip.system.DefaultConfigRBB.fir@168442.4]
  wire  reg_0_rst; // @[AsyncResetReg.scala 61:11:freechips.rocketchip.system.DefaultConfigRBB.fir@168442.4]
  wire  reg_1_d; // @[AsyncResetReg.scala 61:11:freechips.rocketchip.system.DefaultConfigRBB.fir@168448.4]
  wire  reg_1_q; // @[AsyncResetReg.scala 61:11:freechips.rocketchip.system.DefaultConfigRBB.fir@168448.4]
  wire  reg_1_en; // @[AsyncResetReg.scala 61:11:freechips.rocketchip.system.DefaultConfigRBB.fir@168448.4]
  wire  reg_1_clk; // @[AsyncResetReg.scala 61:11:freechips.rocketchip.system.DefaultConfigRBB.fir@168448.4]
  wire  reg_1_rst; // @[AsyncResetReg.scala 61:11:freechips.rocketchip.system.DefaultConfigRBB.fir@168448.4]
  wire  reg_2_d; // @[AsyncResetReg.scala 61:11:freechips.rocketchip.system.DefaultConfigRBB.fir@168454.4]
  wire  reg_2_q; // @[AsyncResetReg.scala 61:11:freechips.rocketchip.system.DefaultConfigRBB.fir@168454.4]
  wire  reg_2_en; // @[AsyncResetReg.scala 61:11:freechips.rocketchip.system.DefaultConfigRBB.fir@168454.4]
  wire  reg_2_clk; // @[AsyncResetReg.scala 61:11:freechips.rocketchip.system.DefaultConfigRBB.fir@168454.4]
  wire  reg_2_rst; // @[AsyncResetReg.scala 61:11:freechips.rocketchip.system.DefaultConfigRBB.fir@168454.4]
  wire  reg_3_d; // @[AsyncResetReg.scala 61:11:freechips.rocketchip.system.DefaultConfigRBB.fir@168460.4]
  wire  reg_3_q; // @[AsyncResetReg.scala 61:11:freechips.rocketchip.system.DefaultConfigRBB.fir@168460.4]
  wire  reg_3_en; // @[AsyncResetReg.scala 61:11:freechips.rocketchip.system.DefaultConfigRBB.fir@168460.4]
  wire  reg_3_clk; // @[AsyncResetReg.scala 61:11:freechips.rocketchip.system.DefaultConfigRBB.fir@168460.4]
  wire  reg_3_rst; // @[AsyncResetReg.scala 61:11:freechips.rocketchip.system.DefaultConfigRBB.fir@168460.4]
  wire [1:0] _T_4; // @[Cat.scala 30:58:freechips.rocketchip.system.DefaultConfigRBB.fir@168486.4]
  wire [1:0] _T_5; // @[Cat.scala 30:58:freechips.rocketchip.system.DefaultConfigRBB.fir@168487.4]
  AsyncResetReg #(.RESET_VALUE(1)) reg_0 ( // @[AsyncResetReg.scala 61:11:freechips.rocketchip.system.DefaultConfigRBB.fir@168442.4]
    .d(reg_0_d),
    .q(reg_0_q),
    .en(reg_0_en),
    .clk(reg_0_clk),
    .rst(reg_0_rst)
  );
  AsyncResetReg #(.RESET_VALUE(1)) reg_1 ( // @[AsyncResetReg.scala 61:11:freechips.rocketchip.system.DefaultConfigRBB.fir@168448.4]
    .d(reg_1_d),
    .q(reg_1_q),
    .en(reg_1_en),
    .clk(reg_1_clk),
    .rst(reg_1_rst)
  );
  AsyncResetReg #(.RESET_VALUE(1)) reg_2 ( // @[AsyncResetReg.scala 61:11:freechips.rocketchip.system.DefaultConfigRBB.fir@168454.4]
    .d(reg_2_d),
    .q(reg_2_q),
    .en(reg_2_en),
    .clk(reg_2_clk),
    .rst(reg_2_rst)
  );
  AsyncResetReg #(.RESET_VALUE(1)) reg_3 ( // @[AsyncResetReg.scala 61:11:freechips.rocketchip.system.DefaultConfigRBB.fir@168460.4]
    .d(reg_3_d),
    .q(reg_3_q),
    .en(reg_3_en),
    .clk(reg_3_clk),
    .rst(reg_3_rst)
  );
  assign _T_4 = {reg_1_q,reg_0_q}; // @[Cat.scala 30:58:freechips.rocketchip.system.DefaultConfigRBB.fir@168486.4]
  assign _T_5 = {reg_3_q,reg_2_q}; // @[Cat.scala 30:58:freechips.rocketchip.system.DefaultConfigRBB.fir@168487.4]
  assign io_q = {_T_5,_T_4}; // @[AsyncResetReg.scala 73:8:freechips.rocketchip.system.DefaultConfigRBB.fir@168489.4]
  assign reg_0_d = io_d[0]; // @[AsyncResetReg.scala 67:16:freechips.rocketchip.system.DefaultConfigRBB.fir@168469.4]
  assign reg_0_en = 1'h1; // @[AsyncResetReg.scala 68:16:freechips.rocketchip.system.DefaultConfigRBB.fir@168470.4]
  assign reg_0_clk = clock; // @[AsyncResetReg.scala 65:16:freechips.rocketchip.system.DefaultConfigRBB.fir@168466.4]
  assign reg_0_rst = reset; // @[AsyncResetReg.scala 66:16:freechips.rocketchip.system.DefaultConfigRBB.fir@168467.4]
  assign reg_1_d = io_d[1]; // @[AsyncResetReg.scala 67:16:freechips.rocketchip.system.DefaultConfigRBB.fir@168474.4]
  assign reg_1_en = 1'h1; // @[AsyncResetReg.scala 68:16:freechips.rocketchip.system.DefaultConfigRBB.fir@168475.4]
  assign reg_1_clk = clock; // @[AsyncResetReg.scala 65:16:freechips.rocketchip.system.DefaultConfigRBB.fir@168471.4]
  assign reg_1_rst = reset; // @[AsyncResetReg.scala 66:16:freechips.rocketchip.system.DefaultConfigRBB.fir@168472.4]
  assign reg_2_d = io_d[2]; // @[AsyncResetReg.scala 67:16:freechips.rocketchip.system.DefaultConfigRBB.fir@168479.4]
  assign reg_2_en = 1'h1; // @[AsyncResetReg.scala 68:16:freechips.rocketchip.system.DefaultConfigRBB.fir@168480.4]
  assign reg_2_clk = clock; // @[AsyncResetReg.scala 65:16:freechips.rocketchip.system.DefaultConfigRBB.fir@168476.4]
  assign reg_2_rst = reset; // @[AsyncResetReg.scala 66:16:freechips.rocketchip.system.DefaultConfigRBB.fir@168477.4]
  assign reg_3_d = io_d[3]; // @[AsyncResetReg.scala 67:16:freechips.rocketchip.system.DefaultConfigRBB.fir@168484.4]
  assign reg_3_en = 1'h1; // @[AsyncResetReg.scala 68:16:freechips.rocketchip.system.DefaultConfigRBB.fir@168485.4]
  assign reg_3_clk = clock; // @[AsyncResetReg.scala 65:16:freechips.rocketchip.system.DefaultConfigRBB.fir@168481.4]
  assign reg_3_rst = reset; // @[AsyncResetReg.scala 66:16:freechips.rocketchip.system.DefaultConfigRBB.fir@168482.4]
endmodule

module chisel_JtagStateMachine( // @[:freechips.rocketchip.system.DefaultConfigRBB.fir@168491.2]
  input        clock, // @[:freechips.rocketchip.system.DefaultConfigRBB.fir@168492.4]
  input        reset, // @[:freechips.rocketchip.system.DefaultConfigRBB.fir@168493.4]
  input        io_tms, // @[:freechips.rocketchip.system.DefaultConfigRBB.fir@168494.4]
  output [3:0] io_currState // @[:freechips.rocketchip.system.DefaultConfigRBB.fir@168494.4]
);
  wire  currStateReg_clock; // @[JtagStateMachine.scala 82:29:freechips.rocketchip.system.DefaultConfigRBB.fir@168501.4]
  wire  currStateReg_reset; // @[JtagStateMachine.scala 82:29:freechips.rocketchip.system.DefaultConfigRBB.fir@168501.4]
  wire [3:0] currStateReg_io_d; // @[JtagStateMachine.scala 82:29:freechips.rocketchip.system.DefaultConfigRBB.fir@168501.4]
  wire [3:0] currStateReg_io_q; // @[JtagStateMachine.scala 82:29:freechips.rocketchip.system.DefaultConfigRBB.fir@168501.4]
  wire  _T; // @[Conditional.scala 37:30:freechips.rocketchip.system.DefaultConfigRBB.fir@168507.4]
  wire [3:0] _T_1; // @[JtagStateMachine.scala 90:23:freechips.rocketchip.system.DefaultConfigRBB.fir@168509.6]
  wire  _T_2; // @[Conditional.scala 37:30:freechips.rocketchip.system.DefaultConfigRBB.fir@168513.6]
  wire [3:0] _T_3; // @[JtagStateMachine.scala 93:23:freechips.rocketchip.system.DefaultConfigRBB.fir@168515.8]
  wire  _T_4; // @[Conditional.scala 37:30:freechips.rocketchip.system.DefaultConfigRBB.fir@168519.8]
  wire [3:0] _T_5; // @[JtagStateMachine.scala 96:23:freechips.rocketchip.system.DefaultConfigRBB.fir@168521.10]
  wire  _T_6; // @[Conditional.scala 37:30:freechips.rocketchip.system.DefaultConfigRBB.fir@168525.10]
  wire [3:0] _T_7; // @[JtagStateMachine.scala 99:23:freechips.rocketchip.system.DefaultConfigRBB.fir@168527.12]
  wire  _T_8; // @[Conditional.scala 37:30:freechips.rocketchip.system.DefaultConfigRBB.fir@168531.12]
  wire  _T_10; // @[Conditional.scala 37:30:freechips.rocketchip.system.DefaultConfigRBB.fir@168537.14]
  wire [3:0] _T_11; // @[JtagStateMachine.scala 105:23:freechips.rocketchip.system.DefaultConfigRBB.fir@168539.16]
  wire  _T_12; // @[Conditional.scala 37:30:freechips.rocketchip.system.DefaultConfigRBB.fir@168543.16]
  wire [3:0] _T_13; // @[JtagStateMachine.scala 108:23:freechips.rocketchip.system.DefaultConfigRBB.fir@168545.18]
  wire  _T_14; // @[Conditional.scala 37:30:freechips.rocketchip.system.DefaultConfigRBB.fir@168549.18]
  wire [3:0] _T_15; // @[JtagStateMachine.scala 111:23:freechips.rocketchip.system.DefaultConfigRBB.fir@168551.20]
  wire  _T_16; // @[Conditional.scala 37:30:freechips.rocketchip.system.DefaultConfigRBB.fir@168555.20]
  wire  _T_18; // @[Conditional.scala 37:30:freechips.rocketchip.system.DefaultConfigRBB.fir@168561.22]
  wire [3:0] _T_19; // @[JtagStateMachine.scala 117:23:freechips.rocketchip.system.DefaultConfigRBB.fir@168563.24]
  wire  _T_20; // @[Conditional.scala 37:30:freechips.rocketchip.system.DefaultConfigRBB.fir@168567.24]
  wire [3:0] _T_21; // @[JtagStateMachine.scala 120:23:freechips.rocketchip.system.DefaultConfigRBB.fir@168569.26]
  wire  _T_22; // @[Conditional.scala 37:30:freechips.rocketchip.system.DefaultConfigRBB.fir@168573.26]
  wire  _T_24; // @[Conditional.scala 37:30:freechips.rocketchip.system.DefaultConfigRBB.fir@168579.28]
  wire [3:0] _T_25; // @[JtagStateMachine.scala 126:23:freechips.rocketchip.system.DefaultConfigRBB.fir@168581.30]
  wire  _T_26; // @[Conditional.scala 37:30:freechips.rocketchip.system.DefaultConfigRBB.fir@168585.30]
  wire [3:0] _T_27; // @[JtagStateMachine.scala 129:23:freechips.rocketchip.system.DefaultConfigRBB.fir@168587.32]
  wire  _T_28; // @[Conditional.scala 37:30:freechips.rocketchip.system.DefaultConfigRBB.fir@168591.32]
  wire [3:0] _T_29; // @[JtagStateMachine.scala 132:23:freechips.rocketchip.system.DefaultConfigRBB.fir@168593.34]
  wire [3:0] _GEN_1; // @[Conditional.scala 39:67:freechips.rocketchip.system.DefaultConfigRBB.fir@168592.32]
  wire [3:0] _GEN_2; // @[Conditional.scala 39:67:freechips.rocketchip.system.DefaultConfigRBB.fir@168586.30]
  wire [3:0] _GEN_3; // @[Conditional.scala 39:67:freechips.rocketchip.system.DefaultConfigRBB.fir@168580.28]
  wire [3:0] _GEN_4; // @[Conditional.scala 39:67:freechips.rocketchip.system.DefaultConfigRBB.fir@168574.26]
  wire [3:0] _GEN_5; // @[Conditional.scala 39:67:freechips.rocketchip.system.DefaultConfigRBB.fir@168568.24]
  wire [3:0] _GEN_6; // @[Conditional.scala 39:67:freechips.rocketchip.system.DefaultConfigRBB.fir@168562.22]
  wire [3:0] _GEN_7; // @[Conditional.scala 39:67:freechips.rocketchip.system.DefaultConfigRBB.fir@168556.20]
  wire [3:0] _GEN_8; // @[Conditional.scala 39:67:freechips.rocketchip.system.DefaultConfigRBB.fir@168550.18]
  wire [3:0] _GEN_9; // @[Conditional.scala 39:67:freechips.rocketchip.system.DefaultConfigRBB.fir@168544.16]
  wire [3:0] _GEN_10; // @[Conditional.scala 39:67:freechips.rocketchip.system.DefaultConfigRBB.fir@168538.14]
  wire [3:0] _GEN_11; // @[Conditional.scala 39:67:freechips.rocketchip.system.DefaultConfigRBB.fir@168532.12]
  wire [3:0] _GEN_12; // @[Conditional.scala 39:67:freechips.rocketchip.system.DefaultConfigRBB.fir@168526.10]
  wire [3:0] _GEN_13; // @[Conditional.scala 39:67:freechips.rocketchip.system.DefaultConfigRBB.fir@168520.8]
  wire [3:0] _GEN_14; // @[Conditional.scala 39:67:freechips.rocketchip.system.DefaultConfigRBB.fir@168514.6]
  AsyncResetRegVec_w4_i15 currStateReg ( // @[JtagStateMachine.scala 82:29:freechips.rocketchip.system.DefaultConfigRBB.fir@168501.4]
    .clock(currStateReg_clock),
    .reset(currStateReg_reset),
    .io_d(currStateReg_io_d),
    .io_q(currStateReg_io_q)
  );
  assign _T = 4'hf == currStateReg_io_q; // @[Conditional.scala 37:30:freechips.rocketchip.system.DefaultConfigRBB.fir@168507.4]
  assign _T_1 = io_tms ? 4'hf : 4'hc; // @[JtagStateMachine.scala 90:23:freechips.rocketchip.system.DefaultConfigRBB.fir@168509.6]
  assign _T_2 = 4'hc == currStateReg_io_q; // @[Conditional.scala 37:30:freechips.rocketchip.system.DefaultConfigRBB.fir@168513.6]
  assign _T_3 = io_tms ? 4'h7 : 4'hc; // @[JtagStateMachine.scala 93:23:freechips.rocketchip.system.DefaultConfigRBB.fir@168515.8]
  assign _T_4 = 4'h7 == currStateReg_io_q; // @[Conditional.scala 37:30:freechips.rocketchip.system.DefaultConfigRBB.fir@168519.8]
  assign _T_5 = io_tms ? 4'h4 : 4'h6; // @[JtagStateMachine.scala 96:23:freechips.rocketchip.system.DefaultConfigRBB.fir@168521.10]
  assign _T_6 = 4'h6 == currStateReg_io_q; // @[Conditional.scala 37:30:freechips.rocketchip.system.DefaultConfigRBB.fir@168525.10]
  assign _T_7 = io_tms ? 4'h1 : 4'h2; // @[JtagStateMachine.scala 99:23:freechips.rocketchip.system.DefaultConfigRBB.fir@168527.12]
  assign _T_8 = 4'h2 == currStateReg_io_q; // @[Conditional.scala 37:30:freechips.rocketchip.system.DefaultConfigRBB.fir@168531.12]
  assign _T_10 = 4'h1 == currStateReg_io_q; // @[Conditional.scala 37:30:freechips.rocketchip.system.DefaultConfigRBB.fir@168537.14]
  assign _T_11 = io_tms ? 4'h5 : 4'h3; // @[JtagStateMachine.scala 105:23:freechips.rocketchip.system.DefaultConfigRBB.fir@168539.16]
  assign _T_12 = 4'h3 == currStateReg_io_q; // @[Conditional.scala 37:30:freechips.rocketchip.system.DefaultConfigRBB.fir@168543.16]
  assign _T_13 = io_tms ? 4'h0 : 4'h3; // @[JtagStateMachine.scala 108:23:freechips.rocketchip.system.DefaultConfigRBB.fir@168545.18]
  assign _T_14 = 4'h0 == currStateReg_io_q; // @[Conditional.scala 37:30:freechips.rocketchip.system.DefaultConfigRBB.fir@168549.18]
  assign _T_15 = io_tms ? 4'h5 : 4'h2; // @[JtagStateMachine.scala 111:23:freechips.rocketchip.system.DefaultConfigRBB.fir@168551.20]
  assign _T_16 = 4'h5 == currStateReg_io_q; // @[Conditional.scala 37:30:freechips.rocketchip.system.DefaultConfigRBB.fir@168555.20]
  assign _T_18 = 4'h4 == currStateReg_io_q; // @[Conditional.scala 37:30:freechips.rocketchip.system.DefaultConfigRBB.fir@168561.22]
  assign _T_19 = io_tms ? 4'hf : 4'he; // @[JtagStateMachine.scala 117:23:freechips.rocketchip.system.DefaultConfigRBB.fir@168563.24]
  assign _T_20 = 4'he == currStateReg_io_q; // @[Conditional.scala 37:30:freechips.rocketchip.system.DefaultConfigRBB.fir@168567.24]
  assign _T_21 = io_tms ? 4'h9 : 4'ha; // @[JtagStateMachine.scala 120:23:freechips.rocketchip.system.DefaultConfigRBB.fir@168569.26]
  assign _T_22 = 4'ha == currStateReg_io_q; // @[Conditional.scala 37:30:freechips.rocketchip.system.DefaultConfigRBB.fir@168573.26]
  assign _T_24 = 4'h9 == currStateReg_io_q; // @[Conditional.scala 37:30:freechips.rocketchip.system.DefaultConfigRBB.fir@168579.28]
  assign _T_25 = io_tms ? 4'hd : 4'hb; // @[JtagStateMachine.scala 126:23:freechips.rocketchip.system.DefaultConfigRBB.fir@168581.30]
  assign _T_26 = 4'hb == currStateReg_io_q; // @[Conditional.scala 37:30:freechips.rocketchip.system.DefaultConfigRBB.fir@168585.30]
  assign _T_27 = io_tms ? 4'h8 : 4'hb; // @[JtagStateMachine.scala 129:23:freechips.rocketchip.system.DefaultConfigRBB.fir@168587.32]
  assign _T_28 = 4'h8 == currStateReg_io_q; // @[Conditional.scala 37:30:freechips.rocketchip.system.DefaultConfigRBB.fir@168591.32]
  assign _T_29 = io_tms ? 4'hd : 4'ha; // @[JtagStateMachine.scala 132:23:freechips.rocketchip.system.DefaultConfigRBB.fir@168593.34]
  assign _GEN_1 = _T_28 ? _T_29 : _T_3; // @[Conditional.scala 39:67:freechips.rocketchip.system.DefaultConfigRBB.fir@168592.32]
  assign _GEN_2 = _T_26 ? _T_27 : _GEN_1; // @[Conditional.scala 39:67:freechips.rocketchip.system.DefaultConfigRBB.fir@168586.30]
  assign _GEN_3 = _T_24 ? _T_25 : _GEN_2; // @[Conditional.scala 39:67:freechips.rocketchip.system.DefaultConfigRBB.fir@168580.28]
  assign _GEN_4 = _T_22 ? _T_21 : _GEN_3; // @[Conditional.scala 39:67:freechips.rocketchip.system.DefaultConfigRBB.fir@168574.26]
  assign _GEN_5 = _T_20 ? _T_21 : _GEN_4; // @[Conditional.scala 39:67:freechips.rocketchip.system.DefaultConfigRBB.fir@168568.24]
  assign _GEN_6 = _T_18 ? _T_19 : _GEN_5; // @[Conditional.scala 39:67:freechips.rocketchip.system.DefaultConfigRBB.fir@168562.22]
  assign _GEN_7 = _T_16 ? _T_3 : _GEN_6; // @[Conditional.scala 39:67:freechips.rocketchip.system.DefaultConfigRBB.fir@168556.20]
  assign _GEN_8 = _T_14 ? _T_15 : _GEN_7; // @[Conditional.scala 39:67:freechips.rocketchip.system.DefaultConfigRBB.fir@168550.18]
  assign _GEN_9 = _T_12 ? _T_13 : _GEN_8; // @[Conditional.scala 39:67:freechips.rocketchip.system.DefaultConfigRBB.fir@168544.16]
  assign _GEN_10 = _T_10 ? _T_11 : _GEN_9; // @[Conditional.scala 39:67:freechips.rocketchip.system.DefaultConfigRBB.fir@168538.14]
  assign _GEN_11 = _T_8 ? _T_7 : _GEN_10; // @[Conditional.scala 39:67:freechips.rocketchip.system.DefaultConfigRBB.fir@168532.12]
  assign _GEN_12 = _T_6 ? _T_7 : _GEN_11; // @[Conditional.scala 39:67:freechips.rocketchip.system.DefaultConfigRBB.fir@168526.10]
  assign _GEN_13 = _T_4 ? _T_5 : _GEN_12; // @[Conditional.scala 39:67:freechips.rocketchip.system.DefaultConfigRBB.fir@168520.8]
  assign _GEN_14 = _T_2 ? _T_3 : _GEN_13; // @[Conditional.scala 39:67:freechips.rocketchip.system.DefaultConfigRBB.fir@168514.6]
  assign io_currState = currStateReg_io_q; // @[JtagStateMachine.scala 139:16:freechips.rocketchip.system.DefaultConfigRBB.fir@168602.4]
  assign currStateReg_clock = clock; // @[:freechips.rocketchip.system.DefaultConfigRBB.fir@168503.4]
  assign currStateReg_reset = reset; // @[:freechips.rocketchip.system.DefaultConfigRBB.fir@168504.4]
  assign currStateReg_io_d = _T ? _T_1 : _GEN_14; // @[JtagStateMachine.scala 85:22:freechips.rocketchip.system.DefaultConfigRBB.fir@168506.4]
endmodule
