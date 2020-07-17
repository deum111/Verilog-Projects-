`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/06/2019 06:36:34 PM
// Design Name: 
// Module Name: sum
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


primitive sum(output f, input a, b, c); //any other combination not specified will output an ambiguous value X.
    table
      //a b c:f;
        0 0 0:0;
        0 0 1:1; 
        0 1 0:1;
        0 1 1:0;
        1 0 0:1;
        1 0 1:0;
        1 1 0:0;
        1 1 1:1;
     endtable   
endprimitive


module testsum(output f, input a, b, c);

   // sum S1(f, a, b, c);  //this is known as structural modeling
  
   assign f = (a & b & c); //known as behavioral modeling.

 
endmodule


