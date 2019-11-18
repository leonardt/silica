module uart_tx(
  input CLK, input RESET,
  input [7:0] data, input valid, output tx
);
reg [7:0] msg;
reg [7:0] msg_next;
reg [2:0] count;
reg [2:0] count_next;
reg [1:0] state;
reg [1:0] state_next;
localparam IDLE = 2'd0, SEND = 2'd1, 
           END = 2'd2;
always @(*) begin
  msg_next = msg;
  state_next = state;
  count_next = count;
  case (state)
    IDLE: begin
      tx = valid ? 0 : 1;
      state_next = valid ? SEND : IDLE;
      msg_next = valid ? data : msg;
    end
    SEND: begin
      tx = msg[count];
      count_next = count - 1;
      state_next = count > 0 ? SEND : END;
    end
    END: begin
      state_next = IDLE;
      tx = 1;
    end
  endcase
end
always @(posedge CLK, posedge RESET) begin
  if (RESET) begin
    state <= IDLE;
    count <= 3'd7;
    msg <= 8'd0;
  end else begin
    state <= state_next;
    count <= count_next;
    msg <= msg_next;
  end
end
endmodule
