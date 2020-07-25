`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/20/2019 07:09:03 PM
// Design Name: 
// Module Name: encoder
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


module encoder
    ( i,
      out
    );
    
    input  [7:0] i;
    output [2:0] out;

    reg [2:0] out;
    
    // Design implementation of Priority Encoder
    // Because a priority encoder generates an output depending on the high bit's position
    // one can use a CASEX statement to generate an output based solely on the position 
    // of the bit. Any other bit values can be ignored by using 'X'. 
    always @( * ) 
      begin
        casex ( i )    
          8'b1XXXXXXX:  out = 3'b111;
          8'b01XXXXXX:  out = 3'b110;
          8'b001XXXXX:  out = 3'b101;
          8'b0001XXXX:  out = 3'b100;
          8'b00001XXX:  out = 3'b011;
          8'b000001XX:  out = 3'b010;
          8'b0000001X:  out = 3'b001;
          8'b00000000:  out = 3'b000;
          default:      out = 3'b000;     
        endcase
      end
endmodule

























