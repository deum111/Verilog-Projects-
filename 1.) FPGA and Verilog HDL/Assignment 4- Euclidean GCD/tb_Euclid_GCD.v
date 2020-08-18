`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/26/2020 08:08:51 PM
// Design Name: 
// Module Name: tb_Euclid_GCD
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


module tb_Euclid_GCD #( parameter W = 16 )();
    
    reg clk;
    
    // Data signals
    reg  [W-1:0] operand_A;
    reg  [W-1:0] operand_B;
    wire [W-1:0] result_data;
    
    // Control signals
    wire input_available;
    reg  reset;
    wire result_taken;
    wire result_rdy;
    
    wire [1:0] state;
    wire [1:0] nstate;
    
    Euclid_GCD UUT
        (
         .clk             ( clk             ),
         .reset           ( reset           ),
         .operand_A       ( operand_A       ),
         .operand_B       ( operand_B       ),
         .result_data     ( result_data     ),
         .input_available ( input_available ),
         .result_rdy      ( result_rdy      ),
         .result_taken    ( result_taken    ),
         .state           ( state           ),
         .nstate          ( nstate          )
        );
    
    // if A < B, swap A and B
    // else if B does not equal zero, A = A - B;
     
    initial 
    begin
      // GCD of 270 and 192 is 6 = 16'h0006;
      operand_A = 16'h010E; operand_B = 16'h00C0;
      
      reset = 1;
      clk = 0;
      forever #5 clk = ~clk;
    end
    
    // operation seen in simulation waveform
    // A = 270, B = 192  result_data = A            
    // A = 270 - 192
    // A = 78, B = 192   result_data = A
    // A = 192, B = 78   result_data = A
    // A = 192 - 78
    // A = 114, B = 78   result_data = A
    // A = 114 - 78     
    // A = 36, B = 78    result_data = A
    // A = 78, B = 36    result_data = A
    // A = 78 - 36
    // A = 42, B = 36    result_data = A
    // A = 42 - 36
    // A = 6, B = 36     result_data = A
    // A = 36, B = 6     result_data = A
    // A = 30, B = 6     result_data = A
    // A = 24, B = 6     result_data = A
    // A = 24 - 6  
    // A = 18, B = 6     result_data = A
    // A = 12, B = 6     result_data = A
    // A = 12 - 6
    // A = 6, B = 6      result_data = A
    // A = 6 - 6 
    // A = 0, B = 6      result_data = A
    // A = 6, B = 0      result_data = A
    
    initial       
    begin
      #10 reset = 0; 
      
      #200 reset = 1;    
    end
    
endmodule











