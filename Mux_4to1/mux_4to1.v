`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/18/2019 07:12:36 PM
// Design Name: 
// Module Name: mux_4to1
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


module mux_4to1
    ( s0,
      s1,
      d0,
      d1,
      d2,
      d3,
      out1
    );

    input  s0;
    input  s1;
    input  d0;
    input  d1;
    input  d2;
    input  d3;
    output out1;
    
    // Design implementation
    // Continuous assignments used to model combinational logic.

    // if input s0 is '1' then see expression ( s1 ? d3:d2 ) else ( s1 ? d1:d0 ),
    // if s1 if 'high' then out1 is equal to d3, else d2.
    assign out1 = s0 ? ( s1 ? d3:d2 ):( s1 ? d1:d0 );
    
    
endmodule
    
//--------------------------------------
//    reg out1;

//    always @( s1 or s0 ) 
//      begin
    
//        if((s0==0)&(s1==0))
//            out1 = d0;
//         else ...

//    end
//endmodule
//---------------------------------------
/*     
    reg out1;

    always @(*) 
    begin
      case({s1, s0})
        2'b00: out1 = d0;
        2'b01: out1 = d1;
        2'b10: out1 = d2;
        2'b11: out1 = d3;
      endcase
    end
endmodule
*/














