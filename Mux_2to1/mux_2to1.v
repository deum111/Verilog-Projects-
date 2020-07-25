`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/18/2019 06:05:45 PM
// Design Name: 
// Module Name: mux_2to1
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


module mux_2to1
    ( s0,
      d0, 
      d1, 
      out1
    );
    
    input  s0;
    input  d0;
    input  d1;
    output out1;
    
   // assign out1 = d0&~s0 | d1&s0;
    assign out1 = s0 ? d1 : d0;   //if s0 is 1, then d1 (1) else d0. 

//reg out1;                        //Stores the memory of the value everytime it's run.
                                   //Needs to be remembered. 
                                   //check only at this part. Otherwise it will continously check.   
//always @(s0 or d1 or d0) begin   //at any of these changes begin.
//     if(s0) 
//        assign out1 = d1;
//     else 
//        assign out1 = d0;
//     end        
/*
always @(*) begin   // * means at any change of input.
    case (s0)
     0: out1 = d0;
     1: out1 = d1;

    endcase
end
*/  
endmodule



















