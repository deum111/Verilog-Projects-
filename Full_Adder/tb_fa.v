`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/05/2019 10:20:39 PM
// Design Name: 
// Module Name: tb_fa
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


module tb_fa();
  
    reg  a;
    reg  b;
    reg  cin;
    
    wire sum;
    wire cout;
    
    full_adder UUT
        ( 
         .a    ( a    ),
         .b    ( b    ),
         .cin  ( cin  ), 
         .sum  ( sum  ), 
         .cout ( cout )
        );
    
    initial 
    begin
      #10 a = 0; b = 0; cin = 0;
        
      #10 a = 0; b = 1;
       
      #10 a = 1; b = 0;
        
      #10 a = 1; b = 1;
        
      #10 a = 0; b = 0; cin = 1;
        
      #10 a = 1; b = 1;
      
   end
   
endmodule













