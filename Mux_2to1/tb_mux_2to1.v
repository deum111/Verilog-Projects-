`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/18/2019 06:06:57 PM
// Design Name: 
// Module Name: tb_mux_2to1
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


module tb_mux_2to1();

    reg  s0;
    reg  d0;
    reg  d1;
    
    wire out1;

    mux_2to1 UUT
        (
         .s0   ( s0   ),
         .d0   ( d0   ),
         .d1   ( d1   ),
         .out1 ( out1 )
        );

    initial 
    begin
        #10 d0 = 1; d1 = 0; s0 = 1;
        #10 s0 = 0;
        #10 s0 = 1;     
    end
    
endmodule
