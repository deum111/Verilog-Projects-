`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/25/2019 06:47:20 PM
// Design Name: 
// Module Name: tb_sm
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


module tb_sm();

    reg  n;
    reg  d;
    reg  clk;
    reg  rst;
    wire op;
    wire [1:0] state;
    wire [1:0] nstate;  
    
    sm UUT
        ( 
         .n   ( n   ),
         .d   ( d   ),
         .clk ( clk ),
         .rst ( rst ),
         .op  ( op  ),
         .state ( state ),
         .nstate ( nstate )
        );
    
    initial
    begin
      clk = 0;
      rst = 1;
      forever #5 clk = ~clk;         
    end
      
    initial 
    begin          
      #10 n   = 0; // next state s0
          d   = 0;
          rst = 0;
     
      #15 n   = 1; // state s0
          d   = 0; // next state s1
          
      #10 n   = 1; // state s1
                   // next state s2
      
      #10 n   = 1; // next state s3 output
      
      #10 n   = 0; // state s3. output
                   // next state s0
      
      #10 d   = 1; // state s0
                   // next state s2
      
      #10 n   = 1; // state s2
          d   = 0; // next state s3 output
          
     // If this reset is activated here then
     // the previous output will not be displayed
     // this is because the output is NOT seen until the next
     // clock cycle. 
     // Any input or changes of states are registered until
     // the next clock cycle.
     
     // #10 rst = 1; //
      
      #10 n   = 0;  // state s3. output
          d   = 1;  // next state s2
      
      #10 rst = 1;  // state s0 reset                                        
    end
    
endmodule














