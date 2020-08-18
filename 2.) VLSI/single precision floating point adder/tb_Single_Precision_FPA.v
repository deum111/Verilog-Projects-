`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/17/2020 08:33:54 PM
// Design Name: 
// Module Name: tb_Single_Precision_FPA
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


module tb_Single_Precision_FPA#( parameter W = 32 )();

    reg          clk;
    reg          reset;
    reg  [W-1:0] A;
    reg  [W-1:0] B;
    wire [W-1:0] Result;
    wire         Done;
    wire         ovf_flag;
    wire   [3:0] state;
    wire   [3:0] nstate;
    
    Single_Precision_FPA UUT
        ( 
          .clk      ( clk      ),
          .reset    ( reset    ),
          .A        ( A        ),
          .B        ( B        ),
          .Result   ( Result   ),
          .Done     ( Done     ),
          .ovf_flag ( ovf_flag ),
          .state    ( state    ),
          .nstate   ( nstate   )
        );
  
    initial 
    begin
      clk = 0;
      reset = 1;
      forever #5 clk = ~clk; 
    end       
  
    initial 
    begin
      #10 
      reset = 0;
      A     = 32'b0_11010111_11100111010000011000011;
      B     = 32'b0_11010111_00011100101111100011100;
    
    end
  
  
endmodule









