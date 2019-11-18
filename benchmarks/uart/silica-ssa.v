

module uart_transmitter
(
  output tx,
  input [8-1:0] data,
  input valid,
  input CLK,
  input RESET
);

  reg [3-1:0] i_0;
  reg [8-1:0] data_0;
  reg valid_0;
  reg [3-1:0] i_1;
  reg [8-1:0] message_0;
  reg [8-1:0] message_1;
  reg tx_0;
  reg [3-1:0] i_2;
  reg tx_1;
  reg [8-1:0] message_2;
  reg [3-1:0] i_3;
  reg [3-1:0] i_4;
  reg [8-1:0] message_3;
  reg tx_2;
  reg [3-1:0] i;
  reg [8-1:0] message;
  reg [2-1:0] yield_state;
  reg [2-1:0] yield_state_next;

  always @(i or message or data or valid or CLK or RESET or yield_state) begin
    if((yield_state == 0) && valid_0) begin
      yield_state_next = 1;
    end else if((yield_state == 0) && ~valid_0 || (yield_state == 2) && (i_1 == 0)) begin
      yield_state_next = 0;
    end else begin
      yield_state_next = 2;
    end
  end


  always @(i or message or data or valid or CLK or RESET or yield_state) begin
    i_1 = i;
  end


  always @(i or message or data or valid or CLK or RESET or yield_state) begin
    message_0 = message;
  end


  always @(i or message or data or valid or CLK or RESET or yield_state) begin
    tx_1 = 1;
  end


  always @(i or message or data or valid or CLK or RESET or yield_state) begin
    data_0 = data;
  end


  always @(i or message or data or valid or CLK or RESET or yield_state) begin
    valid_0 = valid;
  end


  always @(i or message or data or valid or CLK or RESET or yield_state) begin
    message_1 = data_0;
  end


  always @(i or message or data or valid or CLK or RESET or yield_state) begin
    tx_0 = 0;
  end


  always @(i or message or data or valid or CLK or RESET or yield_state) begin
    message_2 = message;
  end


  always @(i or message or data or valid or CLK or RESET or yield_state) begin
    i_3 = 7;
  end


  always @(i or message or data or valid or CLK or RESET or yield_state) begin
    i_2 = i_1 - 1;
  end


  always @(i or message or data or valid or CLK or RESET or yield_state) begin
    if(1 & (yield_state == 1)) begin
      i_4 = i_3;
    end else begin
      i_4 = i_2;
    end
  end


  always @(i or message or data or valid or CLK or RESET or yield_state) begin
    if(1 & (yield_state == 1)) begin
      message_3 = message_2;
    end else begin
      message_3 = message_0;
    end
  end


  always @(i or message or data or valid or CLK or RESET or yield_state) begin
    tx_2 = message_3[i_4];
  end


  always @(i or message or data or valid or CLK or RESET or yield_state) begin
    if((yield_state == 0) && valid_0) begin
      tx = tx_0;
    end 
  end


  always @(i or message or data or valid or CLK or RESET or yield_state) begin
    if((yield_state == -1) || (yield_state == 0) && ~valid_0 || (yield_state == 2) && (i_1 == 0)) begin
      tx = tx_1;
    end 
  end


  always @(i or message or data or valid or CLK or RESET or yield_state) begin
    if((yield_state == 1) || (yield_state == 2) && ~(i_1 == 0)) begin
      tx = tx_2;
    end 
  end


  always @(posedge CLK or posedge RESET) begin
    if(RESET) begin
      yield_state <= 0;
    end else begin
      if((yield_state == 0) && valid_0) begin
        message <= message_1;
      end 
      if((yield_state == 1) || (yield_state == 2) && ~(i_1 == 0)) begin
        i <= i_4;
      end 
      if((yield_state == 1) || (yield_state == 2) && ~(i_1 == 0)) begin
        message <= message_3;
      end 
      yield_state <= yield_state_next;
    end
  end


endmodule

