module uart_tx(input CLK, input [7:0] data, input valid, output tx, output ready);
    reg [7:0] message;
    reg [2:0] send_cnt;
    reg [1:0] state = 2'h0;
    always @(posedge CLK) begin
        case (state)
            2'h0: 
                if (valid) begin
                    message <= data;
                    tx <= 1'b0;  // start bit
                    state <= 2'h1;
                    send_cnt <= 3'h7;
                    ready <= 1'b0;
                end else begin
                    tx <= 1'b1;
                    state <= 2'h0;
                    ready <= 1'b1;
                end
            2'h1:
                begin
                    ready <= 1'b0;
                    tx <= message[send_cnt];
                    send_cnt <= send_cnt - 1'b1;
                    if (send_cnt > 0) begin
                        state <= 2'h1;
                    end else begin
                        state <= 2'h2;
                    end
                end
            2'h2:
                begin
                    ready <= 1'b0;
                    tx <= 1'b1; // end bit
                    state <= 2'h0;
                end
        endcase
        /* $display("valid=%d", valid); */
        /* $display("tx=%d", tx); */
        /* $display("send_cnt=%d", send_cnt); */
    end
    /* assign ready = state == 0 & ~valid; */
endmodule
