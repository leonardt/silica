module uart_tx(input CLK, input RESET, input [7:0] data, input valid, output tx, output ready);
    reg [7:0] message;
    reg [2:0] send_cnt;
    reg [2:0] next_send_cnt;
    reg [1:0] state;
    reg [1:0] next_state;
    always @(*) begin
        case (state)
            2'h0: 
                if (valid) begin
                    message <= data;
                    tx <= 1'b0;  // start bit
                    next_state <= 2'h1;
                    next_send_cnt <= 3'h7;
                    ready <= 1'b0;
                end else begin
                    tx <= 1'b1;
                    next_state <= 2'h0;
                    ready <= 1'b1;
                end
            2'h1:
                begin
                    ready <= 1'b0;
                    tx <= message[send_cnt];
                    next_send_cnt <= send_cnt - 1'b1;
                    next_state <= (send_cnt > 0) ? 2'h1 : 2'h2;
                end
            2'h2:
                begin
                    ready <= 1'b0;
                    tx <= 1'b1; // end bit
                    next_state <= 2'h0;
                end
        endcase
    end
    always @(posedge CLK or posedge RESET) begin
        if (RESET) begin
            state <= 2'h0;
            send_cnt <= 3'h0;
        end else begin
            state <= next_state;
            send_cnt <= next_send_cnt;
        end
    end
endmodule
