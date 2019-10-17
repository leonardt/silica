
module fsm(input [9:0] refresh_cnt, input rd_enable, input wr_enable, output [4:0] state, output [7:0] cmd, input CLK, input RESET);

reg [4:0] curr_state;
reg [4:0] next_state;
assign state = curr_state;

reg [7:0] curr_cmd;
reg [7:0] next_cmd;
assign cmd = curr_cmd;


always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
        curr_state <= 5'b01000;
        curr_cmd <= 8'b10010001;

    end else begin
        curr_state <= next_state;
        curr_cmd <= next_cmd;
    end
end
always @(*) begin
     case (state)
        5'b01000: begin
            next_state = 5'b01001;
            next_cmd = 8'b10010001;
        end
        5'b01001: begin
            next_state = 5'b00101;
            next_cmd = 8'b10111000;
        end
        5'b00101: begin
            next_state = 5'b01010;
            next_cmd = 8'b10001000;
        end
        5'b01010: if (range(8)) begin
            next_state = 5'b01011;
            next_cmd = 8'b10111000;
        end else if () begin
            next_state = 5'b01100;
            next_cmd = 8'b10001000;
        end
        5'b01011: if (range(8)) begin
            next_state = 5'b01011;
            next_cmd = 8'b10111000;
        end else if () begin
            next_state = 5'b01100;
            next_cmd = 8'b10001000;
        end
        5'b01100: if (range(8)) begin
            next_state = 5'b01101;
            next_cmd = 8'b10111000;
        end else if () begin
            next_state = 5'b01110;
            next_cmd = 8'b1000000x;
        end
        5'b01101: if (range(8)) begin
            next_state = 5'b01101;
            next_cmd = 8'b10111000;
        end else if () begin
            next_state = 5'b01110;
            next_cmd = 8'b1000000x;
        end
        5'b01110: if (range(2)) begin
            next_state = 5'b01111;
            next_cmd = 8'b10111000;
        end else if () begin
            next_state = 5'b00000;
            next_cmd = 8'b10111000;
        end
        5'b01111: if (range(2)) begin
            next_state = 5'b01111;
            next_cmd = 8'b10111000;
        end else if () begin
            next_state = 5'b00000;
            next_cmd = 8'b10111000;
        end
        5'b00000: if ((refresh_cnt >= 519)) begin
            next_state = 5'b00001;
            next_cmd = 8'b10010001;
        end else if ((refresh_cnt < 519) && rd_enable) begin
            next_state = 5'b10000;
            next_cmd = 8'b10011xxx;
        end else if ((~ rd_enable) && wr_enable && (refresh_cnt < 519)) begin
            next_state = 5'b11000;
            next_cmd = 8'b10011xxx;
        end
        5'b00001: begin
            next_state = 5'b00010;
            next_cmd = 8'b10111000;
        end
        5'b00010: begin
            next_state = 5'b00011;
            next_cmd = 8'b10001000;
        end
        5'b00011: if (range(8)) begin
            next_state = 5'b00100;
            next_cmd = 8'b10111000;
        end else if () begin
            next_state = 5'b00000;
            next_cmd = 8'b10111000;
        end
        5'b00100: if (range(8)) begin
            next_state = 5'b00100;
            next_cmd = 8'b10111000;
        end else if () begin
            next_state = 5'b00000;
            next_cmd = 8'b10111000;
        end
        5'b11000: if (range(2)) begin
            next_state = 5'b11001;
            next_cmd = 8'b10111000;
        end else if () begin
            next_state = 5'b11010;
            next_cmd = 8'b10100xx1;
        end
        5'b11001: if (range(2)) begin
            next_state = 5'b11001;
            next_cmd = 8'b10111000;
        end else if () begin
            next_state = 5'b11010;
            next_cmd = 8'b10100xx1;
        end
        5'b11010: if (range(2)) begin
            next_state = 5'b11011;
            next_cmd = 8'b10111000;
        end else if () begin
            next_state = 5'b00000;
            next_cmd = 8'b10111000;
        end
        5'b11011: if (range(2)) begin
            next_state = 5'b11011;
            next_cmd = 8'b10111000;
        end else if () begin
            next_state = 5'b00000;
            next_cmd = 8'b10111000;
        end
        5'b10000: if (range(2)) begin
            next_state = 5'b10001;
            next_cmd = 8'b10111000;
        end else if () begin
            next_state = 5'b10010;
            next_cmd = 8'b10101xx1;
        end
        5'b10001: if (range(2)) begin
            next_state = 5'b10001;
            next_cmd = 8'b10111000;
        end else if () begin
            next_state = 5'b10010;
            next_cmd = 8'b10101xx1;
        end
        5'b10010: if (range(2)) begin
            next_state = 5'b10011;
            next_cmd = 8'b10111000;
        end else if () begin
            next_state = 5'b10100;
            next_cmd = 8'b10111000;
        end
        5'b10011: if (range(2)) begin
            next_state = 5'b10011;
            next_cmd = 8'b10111000;
        end else if () begin
            next_state = 5'b10100;
            next_cmd = 8'b10111000;
        end
        5'b10100: begin
            next_state = 5'b00000;
            next_cmd = 8'b10111000;
        end
    endcase
end
endmodule
    