// Generated from
// https://github.com/nyuichi/chisel-uart/blob/master/src/main/scala/Uart.scala
// commit fdede27c1a1d123f64e100639fbcedaf9caa3250
module UartTx(input CLK, input RESET,
    output io_txd,
    output io_enq_ready,
    input  io_enq_valid,
    input [7:0] io_enq_bits
);

  wire T0;
  reg [3:0] state;
  wire[3:0] T39;
  wire[3:0] T1;
  wire[3:0] T2;
  wire T3;
  wire T4;
  wire[3:0] T5;
  wire T6;
  wire T7;
  reg [12:0] count;
  wire[12:0] T40;
  wire[12:0] T8;
  wire[12:0] T9;
  wire[12:0] T10;
  wire[12:0] T11;
  wire T12;
  wire T13;
  wire T14;
  wire T15;
  wire T16;
  wire T17;
  wire T18;
  wire T19;
  wire T20;
  wire T21;
  wire T22;
  wire T23;
  wire T24;
  wire T25;
  wire T26;
  wire T27;
  wire T28;
  wire T29;
  wire T30;
  wire T31;
  wire T32;
  wire T33;
  reg [8:0] buf_;
  wire[8:0] T41;
  wire[8:0] T34;
  wire[8:0] T35;
  wire[8:0] T36;
  wire[8:0] T37;
  wire[7:0] T38;

`ifndef SYNTHESIS
// synthesis translate_off
  integer initvar;
  initial begin
    #0.002;
    state = {1{$random}};
    count = {1{$random}};
    buf_ = {1{$random}};
  end
// synthesis translate_on
`endif

  assign io_enq_ready = T0;
  assign T0 = state == 4'h0;
  assign T39 = RESET ? 4'h0 : T1;
  assign T1 = T6 ? T5 : T2;
  assign T2 = T3 ? 4'ha : state;
  assign T3 = T4 & io_enq_valid;
  assign T4 = 4'h0 == state;
  assign T5 = state - 4'h1;
  assign T6 = T14 & T7;
  assign T7 = count == 13'h0;
  assign T40 = RESET ? 13'h10 : T8;
  assign T8 = T12 ? T11 : T9;
  assign T9 = T6 ? 13'h10 : T10;
  assign T10 = T3 ? 13'h10 : count;
  assign T11 = count - 13'h1;
  assign T12 = T14 & T13;
  assign T13 = T7 ^ 1'h1;
  assign T14 = T16 | T15;
  assign T15 = 4'ha == state;
  assign T16 = T18 | T17;
  assign T17 = 4'h9 == state;
  assign T18 = T20 | T19;
  assign T19 = 4'h8 == state;
  assign T20 = T22 | T21;
  assign T21 = 4'h7 == state;
  assign T22 = T24 | T23;
  assign T23 = 4'h6 == state;
  assign T24 = T26 | T25;
  assign T25 = 4'h5 == state;
  assign T26 = T28 | T27;
  assign T27 = 4'h4 == state;
  assign T28 = T30 | T29;
  assign T29 = 4'h3 == state;
  assign T30 = T32 | T31;
  assign T31 = 4'h2 == state;
  assign T32 = 4'h1 == state;
  assign io_txd = T33;
  assign T33 = buf_[0];
  assign T41 = RESET ? 9'h1ff : T34;
  assign T34 = T6 ? T37 : T35;
  assign T35 = T3 ? T36 : buf_;
  assign T36 = {io_enq_bits, 1'h0};
  assign T37 = {1'h1, T38};
  assign T38 = buf_[8:1];

  always @(posedge CLK) begin
    if(RESET) begin
      state <= 4'h0;
    end else if(T6) begin
      state <= T5;
    end else if(T3) begin
      state <= 4'ha;
    end
    if(RESET) begin
      count <= 13'h10;
    end else if(T12) begin
      count <= T11;
    end else if(T6) begin
      count <= 13'h10;
    end else if(T3) begin
      count <= 13'h10;
    end
    if(RESET) begin
      buf_ <= 9'h1ff;
    end else if(T6) begin
      buf_ <= T37;
    end else if(T3) begin
      buf_ <= T36;
    end
  end
endmodule
