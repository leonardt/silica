

module uart_transmitter
(
  output tx,
  input [8-1:0] data,
  input valid,
  input CLK,
  input RESET
);

  reg [3-1:0] i;
  reg [3-1:0] i_0;
  reg valid_0;
  reg [8-1:0] data_0;
  reg tx_0;
  reg [8-1:0] message_0;
  reg tx_1;
  reg [8-1:0] message_1;
  reg tx_2;
  reg [8-1:0] message_2;
  reg tx_3;
  reg [8-1:0] message_3;
  reg tx_4;
  reg [8-1:0] message_4;
  reg tx_5;
  reg [8-1:0] message_5;
  reg tx_6;
  reg [8-1:0] message_6;
  reg tx_7;
  reg [8-1:0] message_7;
  reg tx_8;
  reg [8-1:0] message_8;
  reg tx_9;
  reg [8-1:0] message;
  reg [4-1:0] yield_state;
  reg [4-1:0] yield_state_next;

  always @(message or data or valid or CLK or RESET or yield_state) begin
    if(yield_state == 3) begin
      yield_state_next = 4;
    end else if(yield_state == 4) begin
      yield_state_next = 5;
    end else if(yield_state == 6) begin
      yield_state_next = 7;
    end else if((yield_state == 0) && ~valid_0 || (yield_state == 9)) begin
      yield_state_next = 0;
    end else if(yield_state == 2) begin
      yield_state_next = 3;
    end else if(yield_state == 7) begin
      yield_state_next = 8;
    end else if(yield_state == 1) begin
      yield_state_next = 2;
    end else if((yield_state == 0) && valid_0) begin
      yield_state_next = 1;
    end else if(yield_state == 8) begin
      yield_state_next = 9;
    end else begin
      yield_state_next = 6;
    end
  end


  always @(message or data or valid or CLK or RESET or yield_state) begin
    tx_0 = 1;
  end


  always @(message or data or valid or CLK or RESET or yield_state) begin
    valid_0 = valid;
  end


  always @(message or data or valid or CLK or RESET or yield_state) begin
    data_0 = data;
  end


  always @(message or data or valid or CLK or RESET or yield_state) begin
    message_0 = data_0;
  end


  always @(message or data or valid or CLK or RESET or yield_state) begin
    tx_1 = 0;
  end


  always @(message or data or valid or CLK or RESET or yield_state) begin
    message_1 = message;
  end


  always @(message or data or valid or CLK or RESET or yield_state) begin
    tx_2 = message_1[7];
  end


  always @(message or data or valid or CLK or RESET or yield_state) begin
    message_2 = message;
  end


  always @(message or data or valid or CLK or RESET or yield_state) begin
    tx_3 = message_2[6];
  end


  always @(message or data or valid or CLK or RESET or yield_state) begin
    message_3 = message;
  end


  always @(message or data or valid or CLK or RESET or yield_state) begin
    tx_4 = message_3[5];
  end


  always @(message or data or valid or CLK or RESET or yield_state) begin
    message_4 = message;
  end


  always @(message or data or valid or CLK or RESET or yield_state) begin
    tx_5 = message_4[4];
  end


  always @(message or data or valid or CLK or RESET or yield_state) begin
    message_5 = message;
  end


  always @(message or data or valid or CLK or RESET or yield_state) begin
    tx_6 = message_5[3];
  end


  always @(message or data or valid or CLK or RESET or yield_state) begin
    message_6 = message;
  end


  always @(message or data or valid or CLK or RESET or yield_state) begin
    tx_7 = message_6[2];
  end


  always @(message or data or valid or CLK or RESET or yield_state) begin
    message_7 = message;
  end


  always @(message or data or valid or CLK or RESET or yield_state) begin
    tx_8 = message_7[1];
  end


  always @(message or data or valid or CLK or RESET or yield_state) begin
    message_8 = message;
  end


  always @(message or data or valid or CLK or RESET or yield_state) begin
    tx_9 = message_8[0];
  end


  always @(message or data or valid or CLK or RESET or yield_state) begin
    if((yield_state == 0) && valid_0) begin
      tx = tx_1;
    end 
  end


  always @(message or data or valid or CLK or RESET or yield_state) begin
    if((yield_state == -1) || (yield_state == 0) && ~valid_0 || (yield_state == 9)) begin
      tx = tx_0;
    end 
  end


  always @(message or data or valid or CLK or RESET or yield_state) begin
    if(yield_state == 1) begin
      tx = tx_2;
    end 
  end


  always @(message or data or valid or CLK or RESET or yield_state) begin
    if(yield_state == 2) begin
      tx = tx_3;
    end 
  end


  always @(message or data or valid or CLK or RESET or yield_state) begin
    if(yield_state == 3) begin
      tx = tx_4;
    end 
  end


  always @(message or data or valid or CLK or RESET or yield_state) begin
    if(yield_state == 4) begin
      tx = tx_5;
    end 
  end


  always @(message or data or valid or CLK or RESET or yield_state) begin
    if(yield_state == 5) begin
      tx = tx_6;
    end 
  end


  always @(message or data or valid or CLK or RESET or yield_state) begin
    if(yield_state == 6) begin
      tx = tx_7;
    end 
  end


  always @(message or data or valid or CLK or RESET or yield_state) begin
    if(yield_state == 7) begin
      tx = tx_8;
    end 
  end


  always @(message or data or valid or CLK or RESET or yield_state) begin
    if(yield_state == 8) begin
      tx = tx_9;
    end 
  end


  always @(posedge CLK or posedge RESET) begin
    if(RESET) begin
      yield_state <= 0;
    end else begin
      if((yield_state == 0) && valid_0) begin
        message <= message_0;
      end 
      if(yield_state == 1) begin
        message <= message_1;
      end 
      if(yield_state == 2) begin
        message <= message_2;
      end 
      if(yield_state == 3) begin
        message <= message_3;
      end 
      if(yield_state == 4) begin
        message <= message_4;
      end 
      if(yield_state == 5) begin
        message <= message_5;
      end 
      if(yield_state == 6) begin
        message <= message_6;
      end 
      if(yield_state == 7) begin
        message <= message_7;
      end 
      yield_state <= yield_state_next;
    end
  end


endmodule

