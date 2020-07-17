`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/07/2019 09:00:37 PM
// Design Name: 
// Module Name: tb_JK
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


module tb_JK();

    reg  j;
    reg  k;
    reg  clk;

    wire q;
    wire q_bar;
        
    JK UUT
        (
         .j     ( j     ),
         .k     ( k     ),
         .clk   ( clk   ),
         .q     ( q     ),
         .q_bar ( q_bar )
        );
        
    initial
    begin
      clk=0;
        forever #10 clk = ~clk;  
    end    
    
    initial 
    begin
      #10 j = 0;
          k = 0;
      
      #20 j = 0;
          k = 1;
      
      #20 j = 1;
          k = 0;
      
      #20 k = 1;
      
      #20 j = 0;
          k = 0;    
     end
     
    
    
endmodule

















