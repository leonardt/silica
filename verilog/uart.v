module uart_tx(input CLK, input [7:0] data, input valid, output tx, output ready);
    reg [7:0] message;
    reg [2:0] send_cnt;
    reg [1:0] state = 0;
    always @(posedge CLK) begin
        case (state)
            0: 
                if (valid) begin
                    message <= data;
                    tx <= 0;  // start bit
                    state <= 1;
                    send_cnt <= 7;
                end
            1:
                begin
                    tx <= message[send_cnt];
                    send_cnt <= send_cnt - 1;
                    if (send_cnt > 0) begin
                        state <= 1;
                    end else begin
                        state <= 2;
                    end
                end
            2:
                begin
                    tx <= 1; // end bit
                    state <= 0;
                end
        endcase
        $display("valid=%d", valid);
        $display("tx=%d", tx);
        $display("send_cnt=%d", send_cnt);
    end
    assign ready = state == 0 & ~valid;
endmodule
