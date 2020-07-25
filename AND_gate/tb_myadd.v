`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/05/2019 10:05:27 PM
// Design Name: 
// Module Name: tb_myadd
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


module tb_myadd();
    
    reg  a;
    reg  b;
    wire f;
    
    myadd UUT1
        ( 
         .a ( a ),
         .b ( b ),
         .f ( f )
        );
    // match parameters with the myadd module
      
    initial 
    begin
      #10 a = 0; b = 0;   
      
      #10 a = 0; b = 1;
      
      #10 a = 1; b = 0;
      
      #10 a = 1; b = 1;   
    end
        
endmodule







