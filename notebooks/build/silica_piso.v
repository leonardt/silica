

module coreir_reg #(parameter init=1, parameter width=1) (
  input clk,
  input [width-1:0] in,
  output [width-1:0] out
);
reg [width-1:0] outReg=init;
always @(posedge clk) begin
  outReg <= in;
end
assign out = outReg;

endmodule //coreir_reg

module coreir_or #(parameter width=1) (
  input [width-1:0] in0,
  input [width-1:0] in1,
  output [width-1:0] out
);
  assign out = in0 | in1;

endmodule //coreir_or

module corebit_not (
  input in,
  output out
);
  assign out = ~in;

endmodule //corebit_not

module or10_wrapped (
  input [9:0] I0,
  input [9:0] I1,
  output [9:0] O
);
  //Wire declarations for instance 'inst0' (Module coreir_or)
  wire [9:0] inst0_in0;
  wire [9:0] inst0_out;
  wire [9:0] inst0_in1;
  coreir_or #(.width(10)) inst0(
    .in0(inst0_in0),
    .in1(inst0_in1),
    .out(inst0_out)
  );

  //All the connections
  assign inst0_in0[9:0] = I0[9:0];
  assign inst0_in1[9:0] = I1[9:0];
  assign O[9:0] = inst0_out[9:0];

endmodule //or10_wrapped

module coreir_and #(parameter width=1) (
  input [width-1:0] in0,
  input [width-1:0] in1,
  output [width-1:0] out
);
  assign out = in0 & in1;

endmodule //coreir_and

module and10_wrapped (
  input [9:0] I0,
  input [9:0] I1,
  output [9:0] O
);
  //Wire declarations for instance 'inst0' (Module coreir_and)
  wire [9:0] inst0_in0;
  wire [9:0] inst0_out;
  wire [9:0] inst0_in1;
  coreir_and #(.width(10)) inst0(
    .in0(inst0_in0),
    .in1(inst0_in1),
    .out(inst0_out)
  );

  //All the connections
  assign inst0_in0[9:0] = I0[9:0];
  assign inst0_in1[9:0] = I1[9:0];
  assign O[9:0] = inst0_out[9:0];

endmodule //and10_wrapped

module corebit_and (
  input in0,
  input in1,
  output out
);
  assign out = in0 & in1;

endmodule //corebit_and

module corebit_or (
  input in0,
  input in1,
  output out
);
  assign out = in0 | in1;

endmodule //corebit_or

module __silica_BufferPISO (
  input [1:0] I,
  output [1:0] O
);
  //All the connections
  assign O[1:0] = I[1:0];

endmodule //__silica_BufferPISO

module and_wrapped (
  input  I0,
  input  I1,
  output  O
);
  //Wire declarations for instance 'inst0' (Module corebit_and)
  wire  inst0_in0;
  wire  inst0_out;
  wire  inst0_in1;
  corebit_and inst0(
    .in0(inst0_in0),
    .in1(inst0_in1),
    .out(inst0_out)
  );

  //All the connections
  assign inst0_in0 = I0;
  assign inst0_in1 = I1;
  assign O = inst0_out;

endmodule //and_wrapped

module or_wrapped (
  input  I0,
  input  I1,
  output  O
);
  //Wire declarations for instance 'inst0' (Module corebit_or)
  wire  inst0_in0;
  wire  inst0_out;
  wire  inst0_in1;
  corebit_or inst0(
    .in0(inst0_in0),
    .in1(inst0_in1),
    .out(inst0_out)
  );

  //All the connections
  assign inst0_in0 = I0;
  assign inst0_in1 = I1;
  assign O = inst0_out;

endmodule //or_wrapped

module reg_U0 #(parameter init=1) (
  input  clk,
  input [0:0] in,
  output [0:0] out
);
  //Wire declarations for instance 'reg0' (Module coreir_reg)
  wire  reg0_clk;
  wire [0:0] reg0_in;
  wire [0:0] reg0_out;
  coreir_reg #(.init(init),.width(1)) reg0(
    .clk(reg0_clk),
    .in(reg0_in),
    .out(reg0_out)
  );

  //All the connections
  assign reg0_clk = clk;
  assign reg0_in[0:0] = in[0:0];
  assign out[0:0] = reg0_out[0:0];

endmodule //reg_U0

module DFF_init0_has_ceFalse_has_resetFalse (
  input  CLK,
  input  I,
  output  O
);
  //Wire declarations for instance 'inst0' (Module reg_U0)
  wire [0:0] inst0_in;
  wire  inst0_clk;
  wire [0:0] inst0_out;
  reg_U0 #(.init(1'd0)) inst0(
    .clk(inst0_clk),
    .in(inst0_in),
    .out(inst0_out)
  );

  //All the connections
  assign inst0_clk = CLK;
  assign inst0_in[0] = I;
  assign O = inst0_out[0];

endmodule //DFF_init0_has_ceFalse_has_resetFalse

module Register10 (
  input  CLK,
  input [9:0] I,
  output [9:0] O
);
  //Wire declarations for instance 'inst0' (Module DFF_init0_has_ceFalse_has_resetFalse)
  wire  inst0_CLK;
  wire  inst0_I;
  wire  inst0_O;
  DFF_init0_has_ceFalse_has_resetFalse inst0(
    .CLK(inst0_CLK),
    .I(inst0_I),
    .O(inst0_O)
  );

  //Wire declarations for instance 'inst1' (Module DFF_init0_has_ceFalse_has_resetFalse)
  wire  inst1_CLK;
  wire  inst1_I;
  wire  inst1_O;
  DFF_init0_has_ceFalse_has_resetFalse inst1(
    .CLK(inst1_CLK),
    .I(inst1_I),
    .O(inst1_O)
  );

  //Wire declarations for instance 'inst2' (Module DFF_init0_has_ceFalse_has_resetFalse)
  wire  inst2_CLK;
  wire  inst2_I;
  wire  inst2_O;
  DFF_init0_has_ceFalse_has_resetFalse inst2(
    .CLK(inst2_CLK),
    .I(inst2_I),
    .O(inst2_O)
  );

  //Wire declarations for instance 'inst3' (Module DFF_init0_has_ceFalse_has_resetFalse)
  wire  inst3_CLK;
  wire  inst3_I;
  wire  inst3_O;
  DFF_init0_has_ceFalse_has_resetFalse inst3(
    .CLK(inst3_CLK),
    .I(inst3_I),
    .O(inst3_O)
  );

  //Wire declarations for instance 'inst4' (Module DFF_init0_has_ceFalse_has_resetFalse)
  wire  inst4_CLK;
  wire  inst4_I;
  wire  inst4_O;
  DFF_init0_has_ceFalse_has_resetFalse inst4(
    .CLK(inst4_CLK),
    .I(inst4_I),
    .O(inst4_O)
  );

  //Wire declarations for instance 'inst5' (Module DFF_init0_has_ceFalse_has_resetFalse)
  wire  inst5_CLK;
  wire  inst5_I;
  wire  inst5_O;
  DFF_init0_has_ceFalse_has_resetFalse inst5(
    .CLK(inst5_CLK),
    .I(inst5_I),
    .O(inst5_O)
  );

  //Wire declarations for instance 'inst6' (Module DFF_init0_has_ceFalse_has_resetFalse)
  wire  inst6_CLK;
  wire  inst6_I;
  wire  inst6_O;
  DFF_init0_has_ceFalse_has_resetFalse inst6(
    .CLK(inst6_CLK),
    .I(inst6_I),
    .O(inst6_O)
  );

  //Wire declarations for instance 'inst7' (Module DFF_init0_has_ceFalse_has_resetFalse)
  wire  inst7_CLK;
  wire  inst7_I;
  wire  inst7_O;
  DFF_init0_has_ceFalse_has_resetFalse inst7(
    .CLK(inst7_CLK),
    .I(inst7_I),
    .O(inst7_O)
  );

  //Wire declarations for instance 'inst8' (Module DFF_init0_has_ceFalse_has_resetFalse)
  wire  inst8_CLK;
  wire  inst8_I;
  wire  inst8_O;
  DFF_init0_has_ceFalse_has_resetFalse inst8(
    .CLK(inst8_CLK),
    .I(inst8_I),
    .O(inst8_O)
  );

  //Wire declarations for instance 'inst9' (Module DFF_init0_has_ceFalse_has_resetFalse)
  wire  inst9_CLK;
  wire  inst9_I;
  wire  inst9_O;
  DFF_init0_has_ceFalse_has_resetFalse inst9(
    .CLK(inst9_CLK),
    .I(inst9_I),
    .O(inst9_O)
  );

  //All the connections
  assign inst0_CLK = CLK;
  assign inst0_I = I[0];
  assign O[0] = inst0_O;
  assign inst1_CLK = CLK;
  assign inst1_I = I[1];
  assign O[1] = inst1_O;
  assign inst2_CLK = CLK;
  assign inst2_I = I[2];
  assign O[2] = inst2_O;
  assign inst3_CLK = CLK;
  assign inst3_I = I[3];
  assign O[3] = inst3_O;
  assign inst4_CLK = CLK;
  assign inst4_I = I[4];
  assign O[4] = inst4_O;
  assign inst5_CLK = CLK;
  assign inst5_I = I[5];
  assign O[5] = inst5_O;
  assign inst6_CLK = CLK;
  assign inst6_I = I[6];
  assign O[6] = inst6_O;
  assign inst7_CLK = CLK;
  assign inst7_I = I[7];
  assign O[7] = inst7_O;
  assign inst8_CLK = CLK;
  assign inst8_I = I[8];
  assign O[8] = inst8_O;
  assign inst9_CLK = CLK;
  assign inst9_I = I[9];
  assign O[9] = inst9_O;

endmodule //Register10

module PISO (
  input  CLK,
  input  LOAD,
  output  O,
  input [9:0] PI,
  input  SI
);
  //Wire declarations for instance 'inst0' (Module __silica_BufferPISO)
  wire [1:0] inst0_I;
  wire [1:0] inst0_O;
  __silica_BufferPISO inst0(
    .I(inst0_I),
    .O(inst0_O)
  );

  //Wire declarations for instance 'inst1' (Module Register10)
  wire  inst1_CLK;
  wire [9:0] inst1_I;
  wire [9:0] inst1_O;
  Register10 inst1(
    .CLK(inst1_CLK),
    .I(inst1_I),
    .O(inst1_O)
  );

  //Wire declarations for instance 'inst2' (Module or10_wrapped)
  wire [9:0] inst2_I0;
  wire [9:0] inst2_I1;
  wire [9:0] inst2_O;
  or10_wrapped inst2(
    .I0(inst2_I0),
    .I1(inst2_I1),
    .O(inst2_O)
  );

  //Wire declarations for instance 'inst3' (Module and10_wrapped)
  wire [9:0] inst3_I0;
  wire [9:0] inst3_I1;
  wire [9:0] inst3_O;
  and10_wrapped inst3(
    .I0(inst3_I0),
    .I1(inst3_I1),
    .O(inst3_O)
  );

  //Wire declarations for instance 'inst4' (Module and10_wrapped)
  wire [9:0] inst4_I0;
  wire [9:0] inst4_I1;
  wire [9:0] inst4_O;
  and10_wrapped inst4(
    .I0(inst4_I0),
    .I1(inst4_I1),
    .O(inst4_O)
  );

  //Wire declarations for instance 'inst5' (Module or_wrapped)
  wire  inst5_I0;
  wire  inst5_I1;
  wire  inst5_O;
  or_wrapped inst5(
    .I0(inst5_I0),
    .I1(inst5_I1),
    .O(inst5_O)
  );

  //Wire declarations for instance 'inst6' (Module and_wrapped)
  wire  inst6_I0;
  wire  inst6_I1;
  wire  inst6_O;
  and_wrapped inst6(
    .I0(inst6_I0),
    .I1(inst6_I1),
    .O(inst6_O)
  );

  //Wire declarations for instance 'inst7' (Module and_wrapped)
  wire  inst7_I0;
  wire  inst7_I1;
  wire  inst7_O;
  and_wrapped inst7(
    .I0(inst7_I0),
    .I1(inst7_I1),
    .O(inst7_O)
  );

  //Wire declarations for instance 'inst8' (Module corebit_not)
  wire  inst8_in;
  wire  inst8_out;
  corebit_not inst8(
    .in(inst8_in),
    .out(inst8_out)
  );

  //All the connections
  assign inst1_CLK = CLK;
  assign inst1_I[9:0] = inst2_O[9:0];
  assign inst2_I0[9:0] = inst3_O[9:0];
  assign inst2_I1[9:0] = inst4_O[9:0];
  assign inst3_I1[9:0] = PI[9:0];
  assign inst5_I0 = inst6_O;
  assign inst5_I1 = inst7_O;
  assign O = inst5_O;
  assign inst6_I0 = inst0_O[0];
  assign inst6_I1 = inst1_O[9];
  assign inst7_I0 = inst0_O[1];
  assign inst7_I1 = inst1_O[9];
  assign inst8_in = LOAD;
  assign inst0_I[1] = inst8_out;
  assign inst0_I[0] = LOAD;
  assign inst4_I1[0] = SI;
  assign inst3_I0[0] = inst0_O[0];
  assign inst3_I0[1] = inst0_O[0];
  assign inst3_I0[2] = inst0_O[0];
  assign inst3_I0[3] = inst0_O[0];
  assign inst3_I0[4] = inst0_O[0];
  assign inst3_I0[5] = inst0_O[0];
  assign inst3_I0[6] = inst0_O[0];
  assign inst3_I0[7] = inst0_O[0];
  assign inst3_I0[8] = inst0_O[0];
  assign inst3_I0[9] = inst0_O[0];
  assign inst4_I0[0] = inst0_O[1];
  assign inst4_I0[1] = inst0_O[1];
  assign inst4_I0[2] = inst0_O[1];
  assign inst4_I0[3] = inst0_O[1];
  assign inst4_I0[4] = inst0_O[1];
  assign inst4_I0[5] = inst0_O[1];
  assign inst4_I0[6] = inst0_O[1];
  assign inst4_I0[7] = inst0_O[1];
  assign inst4_I0[8] = inst0_O[1];
  assign inst4_I0[9] = inst0_O[1];
  assign inst4_I1[1] = inst1_O[0];
  assign inst4_I1[2] = inst1_O[1];
  assign inst4_I1[3] = inst1_O[2];
  assign inst4_I1[4] = inst1_O[3];
  assign inst4_I1[5] = inst1_O[4];
  assign inst4_I1[6] = inst1_O[5];
  assign inst4_I1[7] = inst1_O[6];
  assign inst4_I1[8] = inst1_O[7];
  assign inst4_I1[9] = inst1_O[8];

endmodule //PISO
