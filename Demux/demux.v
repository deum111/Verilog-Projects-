`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/20/2019 06:29:49 PM
// Design Name: 
// Module Name: demux
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

/*
module demux
    ( i,
      s,
      op
    );
    
    input  i;
    input  [1:0] s;
    output [3:0] op;

    reg [3:0] op;

    always @( * ) 
      begin
        case( s ) 
          2'b00:   op[0] = i;
          2'b01:   op[1] = i;
          2'b10:   op[2] = i;
          2'b11:   op[3] = i;
          default: op[0] = 1'bx;
        endcase
      end
        
endmodule
*/

module demux
    ( i,
      s,
      op
    );
    
    // Demultiplexer calls for a single input and multiple outputs controlled by select lines.
    // Can create vector values for multiple bits required for select and output instead of 
    // writing out scalar inputs and outputs.
    input  i;
    input  [1:0] s;
    output [3:0] op;
   
    reg [3:0] op;
    
    // Design implementation
    // '*' in sensitivity list means triggers on any update
    // Based on the binary value of 's' the case statement will execute 
    // the appropriate select line for the output.
    // The 4 bit output is separated into each bit and assigned the input at 
    // the correct index based on the select line.
    always @( * ) 
      begin
        case ( s )
          2'b00: begin
                   op[0] = i;
                   op[1] = 0;
                   op[2] = 0;
                   op[3] = 0;
                 end
          2'b01: begin
                   op[0] = 0;
                   op[1] = i;
                   op[2] = 0;
                   op[3] = 0;
                 end
          2'b10: begin
                   op[0] = 0;
                   op[1] = 0;
                   op[2] = i;
                   op[3] = 0;
                 end
          2'b11: begin
                   op[0] = 0;
                   op[1] = 0;
                   op[2] = 0;
                   op[3] = i;
                 end
            /* can manupilate numbers as 
		  2'b11: op = i * 8;
	     */
          default: op[0] = 1'bx;
        endcase    
      end  
        
endmodule










