`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/06/2019 06:38:33 PM
// Design Name: 
// Module Name: tb_sum
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


module tb_sum();
    
    reg a, b, c;
    wire f;
    
    testsum UUT(f, a, b, c);
    
    initial begin
    
    #10 a = 0;
        b = 0; //no delay here because this is sequential remember so 'a' has a delay of 10 first and then b activates.
    #10 c = 0;
    #10 c = 1; 
    #10 c = 0;
    #10 b = 1;
    #10 a = 1;
        c = 1;    
    end
endmodule




