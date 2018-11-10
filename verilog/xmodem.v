`define TIMEOUT 1<<20
`define SOH = 8'h1
`define EOT = 8'h4
`define ACK = 8'h6
`define NAK = 8'h15
`define ASCIC = 8'h43
`define MAX_TIME = 1<<16-1

//This module behaves as the xmodem sender.
module xmodem_sender(
    input clk,
 
    //Interface to outside world.
    input send_data,
    input [9:0] data_length, //in multiples of 128 bytes. Available on the clock cycle that send_data is valid. 
    output [9:0] data_addr, //Which of the 'data_length' 128 byte chuncks
    output [6:0] byte_addr, //Which byte of the 128 byte chunk
    input [7:0] data, //  0 latency available from data_addr, and byte_addr
    output done, //Indicates the data was successfully sent
 
    //Interface to xmodem_receiver
    output tx,
    input rx
);

    localparam WAIT_FOR_SEND = 2'h0,
               WAIT_FOR_HOST = 2'h1,
               SEND_MESSAGE = 2'h2,
               WAIT_FOR_MESSAGE = 2'h3;
    
    always @(*) begin
        get_response = 1'b0;
        case(CS):
            WAIT_FOR_SEND begin
                NS = send_data ? WAIT_FOR_HOST : WAIT_FOR_SEND;
                get_response = send_data;
            end
            WAIT_FOR_HOST begin
                NS = host_ready ? SEND_MESSAGE : WAIT_FOR_HOST;
            end
            SEND_MESSAGE begin
                NS = WAIT_FOR_MESSAGE;
            end
            WAIT_FOR_MESSAGE begin
                NS = message_sent ? WAIT_FOR_RESPONSE : WAIT_FOR_MESSAGE;
                get_response = message_sent;
            end
            WAIT_FOR_RESPONSE begin
                NS = message_done ? (is_last ? WAIT_FOR_SEND : SEND_MESSAGE) : WAIT_FOR_MESSAGE;
            end
    end

    reg [9:0] data_addr_cur;
    
    wire send_message;
    assign send_message = (CS==SEND_MESSAGE);
    assign done = message_sent & is_list;


    wire get_response;
    wire saw_ACK;
    wire saw_NAK
    wire saw_C;
    wire timed_out;
    wire [7:0] response;
    wire response_valid;
    assign saw_ACK = response_valid & (response == `ACK)
    assign saw_NAK = response_valid & (response == `NAK)
    assign saw_C = response_valid & (response == `ASCIC)

    byte_rx byte_rx_inst(
        .clk(clk),
        .get_response(get_response),
        .data(response),
        .data_valid(response_valid),
        .rx(rx)
    )


endmodule


//triggered by get_response, then returns the data
module byte_rx(
    input clk,
    input get_response,
    output reg [7:0] data,
    output data_valid,

    input rx,
)


endmodule


//This will send a full message
module message_tx(
    input clk,
    input send_message,
    input [9:0] data_addr,
    output message_sent,
       
    output [6:0] byte_addr,
    input [7:0] data,
 
    output tx,
);
    localparam WAIT=0,
               SEND_SOH=1,
               SEND_DP1=2,
               SEND_DP2=3,
               SEND_DATA=4,
               SEND_CHECKSUM=5;
    
    reg [6:0] data_cnt = 'h0;
    assign byte_addr = data_cnt;
    
    always @(*) begin
        if (CS==SEND_DATA) begin
            
    end

);


module byte_tx(
    input clk,
    input send,
    input [7:0] data,
    output done,

    output tx


)

endmodule


//module xmodem_rx(
//  input clk,
//  
//  //
//  output
//  rx
//
//
//);
