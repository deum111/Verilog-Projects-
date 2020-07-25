`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/20/2019 06:32:20 PM
// Design Name: 
// Module Name: tb_demux
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
module tb_demux();

    reg  i; 
    reg  [1:0] s;
    wire [3:0] op;

    demux UUT
        ( 
         .i  ( i  ),
         .s  ( s  ),
         .op ( op )
        );

    initial 
    begin
      #10 s = 2'b00;
          i = 0;
      #10 s = 2'b01;
          i = 1;
      #10 s = 2'b10;
          i = 1;            
    end
endmodule

*/

module demux_tb();
    
    reg  [1:0] s;
    reg  i;
    wire [3:0] op;

    demux M1
        (
         .s  ( s  ),
         .i  ( i  ), 
         .op ( op )
        );
    
    initial 
    begin
          i = 1;
      #10 s = 2'b00;
      #10 s = 2'b01;
      #10 s = 2'b10;
      #10 s = 2'b11;
      #10 s = 2'b00;
      #10 s = 2'b01;
      #10 s = 2'b10;
      #10 s = 2'b11;
    end
endmodule











