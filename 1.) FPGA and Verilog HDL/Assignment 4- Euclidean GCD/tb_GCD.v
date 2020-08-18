`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/25/2019 06:47:56 PM
// Design Name: 
// Module Name: tb_GCD
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


module tb_GCD();


reg  clk, rst, start;
reg  [7:0] P, Q;
wire [7:0] R;
wire valid;
wire [1:0] State_Y;
           
    GCD UUT(clk, rst, start, P, Q, R, valid, State_Y);
    
    initial begin
        start = 0;
        P     = 8'b00000010;
        Q     = 8'b00001000;    
        rst   = 0;
    #10 start = 1;
    #10 start = 0; 
        
    end
        
    initial begin
    clk = 0;
        forever begin
            #10 clk = 1;
            #10 clk = 0;
               
        end   
    end
    
    
endmodule





















