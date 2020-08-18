`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/17/2020 02:17:54 PM
// Design Name: 
// Module Name: tb_MAF_pipelined
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


module tb_MAF_pipelined#( parameter W = 64 )();
    reg  clk;
    
    reg [W-33:0] A;
    reg [W-33:0] B;
    reg [W-33:0] C;
    reg    [1:0] func;
    
    wire [W-1:0] Result;
    
    MAF_pipelined UUT
        ( 
         .clk    ( clk   ),
         .A      ( A     ),
         .B      ( B     ),
         .C      ( C     ),
         .func   ( func  ),
         .Result ( Result )
        );    
    
    initial 
    begin
      clk  = 0;
      //A    = 32'h0000_0000;
      //B    = 32'h0000_0000;
      //C    = 32'h0000_0000;
      //func = 2'b00;
      forever #5 clk = ~clk;
    end
    
    initial 
    begin
      #10 func = 2'b00;        // A x B
          A    = 32'h0000_0007;
          B    = 32'h0000_0007;
          C    = 32'h0000_ffff;
      
      #10 func = 2'b01;         // A + C
          A    = 32'h0000_007D; //125
          B    = 32'h0000_ffff;
          C    = 32'h0000_007D; //125
          
      #10 func = 2'b10;         // ( A x B ) + C
          A    = 32'h0000_0005;
          B    = 32'h0000_0004;
          C    = 32'h0000_0005;
      
      #10 func = 2'b11;       // Don't Care
          A    = 32'h0000_0502;
          B    = 32'h0000_0a04;
          C    = 32'h0000_0002;
    
    end
    
    

endmodule







