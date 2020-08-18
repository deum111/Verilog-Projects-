`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/27/2019 08:04:39 PM
// Design Name: 
// Module Name: tb_counter
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


module tb_counter();

    reg clk;
    reg reset;
    reg UpOrDown;

    // Outputs
    wire [15:0] Count;

 
    counter UUT(.clk(clk), .reset(reset), .UpOrDown(UpOrDown), .Count(Count));

//Generate clk with 10 ns clk period.
    initial clk = 0;
    always 
    #1
    clk = ~clk;
    
    initial begin
        // Apply Inputs
        reset = 0;
        UpOrDown = 1;
        #500
        UpOrDown = 0;  
    end
      
endmodule
