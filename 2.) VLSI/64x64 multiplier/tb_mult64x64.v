`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/27/2019 06:14:21 PM
// Design Name: 
// Module Name: tb_mult64x64
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


module tb_mult64x64();
   reg  [63:0] a;
   reg  [63:0] b;
   wire [127:0] sum;
   
   mult64x64 UUT (a, b, sum);
   
   initial begin
  
   a = 64'h0000000000000011;
   b = 64'h0000000000000111;
   #100
   a = 64'habcde12345678911;
   b = 64'h01479230bfa1203d;
   #100
   a = 64'h0a00a0349182cfbb;
   b = 64'h01001ddab0298485;
   
   end
   
endmodule

