`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/20/2019 07:15:54 PM
// Design Name: 
// Module Name: tb_encoder
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_encoder();

    reg  [7:0] i;
    wire [2:0] out;

    encoder UUT
        (
         .i   ( i   ),
         .out ( out )
        );

    initial 
    begin
      #10 i = 8'd128;
      #10 i = 8'd64;
      #10 i = 8'd32;
      #10 i = 8'd16;
      #10 i = 8'd8;
      #10 i = 8'd4;
      #10 i = 8'd2;
      #10 i = 8'd1; 
    end
    
endmodule
