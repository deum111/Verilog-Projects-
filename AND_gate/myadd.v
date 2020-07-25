`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/05/2019 10:04:30 PM
// Design Name: 
// Module Name: myadd
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


module myadd
    ( a,
      b,
      f   
    );
    
    input  a;
    input  b;
    output f;
    
    and U1( f, a, b );
    // note: output is listed first in primitive gates that have one output
    // and may have 2 or more inputs
    
endmodule







