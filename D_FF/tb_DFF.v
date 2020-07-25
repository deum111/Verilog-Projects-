`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/14/2019 06:47:12 PM
// Design Name: 
// Module Name: tb_DFF
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


module tb_DFF();

    reg d;
    reg clk;
    
    wire q;
    wire qbar;
    
    DFF UUT
        (
         .d    ( d    ),
         .clk  ( clk  ),
         .q    ( q    ),
         .qbar ( qbar )
        );
    
    initial
    begin 
      clk = 0;
      forever #10 clk = ~clk;
    end
       
    initial 
    begin
      #10 d = 0;
      
      #20 d = 1;
      
      #20 d = 0;
      
      #20 d = 1;    
    end

endmodule
