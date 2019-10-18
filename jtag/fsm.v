
module fsm(input tms, output [3:0] state, input CLK, input RESET);
reg [3:0] curr_state;
reg [3:0] next_state;
assign state = curr_state;

always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
        curr_state <= 15;
    end else begin
        curr_state <= next_state;
    end
end
always @(*) begin
     case (state)
        15: if ((tms == 0)) begin
            next_state = 12;
        end else begin
            next_state = 15;
        end
        12: if ((tms == 1)) begin
            next_state = 7;
        end else begin
            next_state = 12;
        end
        7: if ((tms == 1)) begin
            next_state = 4;
        end else begin
            next_state = 6;
        end
        4: if ((tms == 1)) begin
            next_state = 15;
        end else begin
            next_state = 14;
        end
        6: if ((tms == 1)) begin
            next_state = 1;
        end else begin
            next_state = 2;
        end
        2: if ((tms == 1)) begin
            next_state = 1;
        end else begin
            next_state = 2;
        end
        1: if ((tms == 0)) begin
            next_state = 3;
        end else begin
            next_state = 5;
        end
        5: if ((tms == 1)) begin
            next_state = 7;
        end else begin
            next_state = 12;
        end
        3: if ((tms == 0)) begin
            next_state = 3;
        end else begin
            next_state = 0;
        end
        0: if ((tms == 0)) begin
            next_state = 2;
        end else begin
            next_state = 5;
        end
        14: if ((tms == 1)) begin
            next_state = 9;
        end else begin
            next_state = 10;
        end
        10: if ((tms == 1)) begin
            next_state = 9;
        end else begin
            next_state = 10;
        end
        9: if ((tms == 0)) begin
            next_state = 11;
        end else begin
            next_state = 13;
        end
        13: if ((tms == 1)) begin
            next_state = 7;
        end else begin
            next_state = 12;
        end
        11: if ((tms == 0)) begin
            next_state = 11;
        end else begin
            next_state = 8;
        end
        8: if ((tms == 0)) begin
            next_state = 10;
        end else begin
            next_state = 13;
        end
    endcase
end
endmodule
    