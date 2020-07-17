`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/07/2019 08:58:30 PM
// Design Name: 
// Module Name: JK
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


module JK
    ( q_bar,
      q,
      clk,
      j,
      k
    );
         
    input  j;
    input  k;
    input  clk;
    output q;
    output q_bar;   
    
    reg q;
    reg q_bar;
    
    always @( posedge clk )
    begin
      case ( {j,k} )
        2'b00 : q <= q;
        2'b01 : begin 
                  q     <= 1'b0; 
                  q_bar <= 1'b1;
                end 
        2'b10 : begin 
                  q     <= 1'b1;
                  q_bar <= 1'b0;
                end
        2'b11 : begin
                   q     <= ~q;
                   q_bar <= ~q_bar;
                end      
      endcase
    end             
    
endmodule










