
`define TIMEOUT 1<<20

//This module behaves as the xmodem sender.
module xmodem_sender(
  input clk,

  //Interface to outside world.
  input send_data;
  input [4:0] data_length; //in multiples of 128 bytes. Available on the clock cycle that send_data is valid. 
  output [31:0] data_addr; //Which of the 'data_length' 128 byte chuncks
  output [6:0] byte_addr; //Which byte of the 128 byte chunk
  input [7:0] data; //  0 latency available from data_addr, and byte_addr
  output done; //Indicates the data was successfully sent

  //Interface to xmodem_receiver
  output tx,
  input rx
);

endmodule
