`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/14/2020 06:02:17 PM
// Design Name: 
// Module Name: tb_RISC_16bit_test
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


module tb_RISC_16bit_test#( parameter W = 16 )();

    reg  clk;
    reg  reset;
    
    wire [W-9:0] PC_addr;
    wire [W-1:0] alu_out;
    wire [2:0]   alu_s;
    wire [2:0]   state;
    wire [2:0]   nstate;
    
    RISC_16bit_test UUT 
        ( 
         .clk     ( clk     ),
         .reset   ( reset   ),
         .PC_addr ( PC_addr ),
         .alu_out ( alu_out ),
         .alu_s   ( alu_s   ),
         .state   ( state   ),
         .nstate  ( nstate  )
        );
    
    initial 
    begin
      clk   = 0;
      reset = 1;  
      forever #5 clk = ~clk;
    end
    
    initial 
    begin
    #10 reset = 0;
    #15;
    #10;
    end
    
    
endmodule










