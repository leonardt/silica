

module SilicaJTAG
(
  output [4-1:0] state,
  input tms,
  input CLK,
  input RESET
);

  reg tms_0;
  reg tms_1;
  reg tms_2;
  reg tms_3;
  reg tms_4;
  reg tms_5;
  reg tms_6;
  reg tms_7;
  reg tms_8;
  reg tms_9;
  reg tms_10;
  reg tms_11;
  reg tms_12;
  reg tms_13;
  reg tms_14;
  reg tms_15;
  reg tms_16;
  reg tms_17;
  reg tms_18;
  reg tms_19;
  reg tms_20;
  reg tms_21;
  reg [4-1:0] yield_state;
  reg [4-1:0] yield_state_next;

  always @(tms or CLK or RESET or yield_state) begin
    if((yield_state == 2) && (tms_7 == 0)) begin
      yield_state_next = 3;
    end else if((yield_state == 3) && (tms_11 == 0) || (yield_state == 4) && (tms_11 == 0) || (yield_state == 7) && ~(tms_8 != 0) && (tms_11 == 0)) begin
      yield_state_next = 4;
    end else if((yield_state == 5) && (tms_12 == 0) && (tms_14 == 0) || (yield_state == 6) && (tms_14 == 0)) begin
      yield_state_next = 6;
    end else if((yield_state == 12) && (tms_19 == 0) && (tms_21 == 0) || (yield_state == 13) && (tms_21 == 0)) begin
      yield_state_next = 13;
    end else if((yield_state == 0) && ~(tms_0 == 0) || (yield_state == 8) && ~(tms_6 == 1) || (yield_state == 9) && ~(tms_1 == 0) || (yield_state == 15) && ~(tms_6 == 1)) begin
      yield_state_next = 0;
    end else if((yield_state == 1) && ~(tms_3 == 0) && (tms_6 == 1) || (yield_state == 8) && (tms_6 == 1) || (yield_state == 15) && (tms_6 == 1)) begin
      yield_state_next = 2;
    end else if((yield_state == 12) && ~(tms_19 == 0) || (yield_state == 14) && (tms_15 != 0)) begin
      yield_state_next = 15;
    end else if((yield_state == 5) && ~(tms_12 == 0) || (yield_state == 7) && (tms_8 != 0)) begin
      yield_state_next = 8;
    end else if((yield_state == 9) && (tms_1 == 0)) begin
      yield_state_next = 10;
    end else if((yield_state == 13) && ~(tms_21 == 0)) begin
      yield_state_next = 14;
    end else if((yield_state == 2) && ~(tms_7 == 0)) begin
      yield_state_next = 9;
    end else if((yield_state == 10) && (tms_18 == 0) || (yield_state == 11) && (tms_18 == 0) || (yield_state == 14) && ~(tms_15 != 0) && (tms_18 == 0)) begin
      yield_state_next = 11;
    end else if((yield_state == 0) && (tms_0 == 0) && (tms_3 == 0) || (yield_state == 1) && (tms_3 == 0)) begin
      yield_state_next = 1;
    end else if((yield_state == 3) && ~(tms_11 == 0) || (yield_state == 4) && ~(tms_11 == 0)) begin
      yield_state_next = 5;
    end else if((yield_state == 6) && ~(tms_14 == 0)) begin
      yield_state_next = 7;
    end else begin
      yield_state_next = 12;
    end
  end


  always @(tms or CLK or RESET or yield_state) begin
    tms_0 = tms;
  end


  always @(tms or CLK or RESET or yield_state) begin
    tms_2 = tms;
  end


  always @(tms or CLK or RESET or yield_state) begin
    if(tms_0 == (0 & (yield_state == 0))) begin
      tms_3 = tms_0;
    end else begin
      tms_3 = tms_2;
    end
  end


  always @(tms or CLK or RESET or yield_state) begin
    tms_4 = tms;
  end


  always @(tms or CLK or RESET or yield_state) begin
    tms_5 = tms;
  end


  always @(tms or CLK or RESET or yield_state) begin
    if(~(tms_3 == 0) & (yield_state == 1)) begin
      tms_6 = tms_3;
    end else if((tms == (1 & (yield_state == 8))) | ~(tms == 1) & (yield_state == 8)) begin
      tms_6 = tms_4;
    end else begin
      tms_6 = tms_5;
    end
  end


  always @(tms or CLK or RESET or yield_state) begin
    tms_7 = tms;
  end


  always @(tms or CLK or RESET or yield_state) begin
    tms_9 = tms;
  end


  always @(tms or CLK or RESET or yield_state) begin
    tms_10 = tms;
  end


  always @(tms or CLK or RESET or yield_state) begin
    if((tms == (0 & (yield_state == 4))) | ~(tms == 0) & (yield_state == 4)) begin
      tms_11 = tms_9;
    end else if((tms == 0) & (yield_state == 3) | ~(tms == 0) & (yield_state == 3)) begin
      tms_11 = tms_10;
    end else begin
      tms_11 = tms_8;
    end
  end


  always @(tms or CLK or RESET or yield_state) begin
    tms_12 = tms;
  end


  always @(tms or CLK or RESET or yield_state) begin
    tms_13 = tms;
  end


  always @(tms or CLK or RESET or yield_state) begin
    if(tms_12 == (0 & (yield_state == 5))) begin
      tms_14 = tms_12;
    end else begin
      tms_14 = tms_13;
    end
  end


  always @(tms or CLK or RESET or yield_state) begin
    tms_8 = tms;
  end


  always @(tms or CLK or RESET or yield_state) begin
    tms_1 = tms;
  end


  always @(tms or CLK or RESET or yield_state) begin
    tms_16 = tms;
  end


  always @(tms or CLK or RESET or yield_state) begin
    tms_17 = tms;
  end


  always @(tms or CLK or RESET or yield_state) begin
    if((tms == (0 & (yield_state == 11))) | ~(tms == 0) & (yield_state == 11)) begin
      tms_18 = tms_16;
    end else if((tms == 0) & (yield_state == 10) | ~(tms == 0) & (yield_state == 10)) begin
      tms_18 = tms_17;
    end else begin
      tms_18 = tms_15;
    end
  end


  always @(tms or CLK or RESET or yield_state) begin
    tms_19 = tms;
  end


  always @(tms or CLK or RESET or yield_state) begin
    tms_20 = tms;
  end


  always @(tms or CLK or RESET or yield_state) begin
    if(tms_19 == (0 & (yield_state == 12))) begin
      tms_21 = tms_19;
    end else begin
      tms_21 = tms_20;
    end
  end


  always @(tms or CLK or RESET or yield_state) begin
    tms_15 = tms;
  end


  always @(posedge CLK or posedge RESET) begin
    if(RESET) begin
      yield_state <= 0;
    end else begin
      yield_state <= yield_state_next;
    end
  end


endmodule

