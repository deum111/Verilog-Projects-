`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/18/2019 07:23:34 PM
// Design Name: 
// Module Name: tb_mux_4to1
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


module tb_mux_4to1();

    reg  s1;
    reg  s0;
    reg  d0;
    reg  d1;
    reg  d2;
    reg  d3;
    
    wire out1;


    mux_4to1 UUT
        ( .s0   ( s0   ),
          .s1   ( s1   ),
          .d0   ( d0   ),
          .d1   ( d1   ),
          .d2   ( d2   ),
          .d3   ( d3   ),
          .out1 ( out1 )
        );

    /* s1 s0 = d3 d2 d1 d0
       
       0  0  = d0
       0  1  = d1
       1  0  = d2
       1  1  = d3 
    */
    
    // In this instance, one must remember to initialize the 
    // values for d3 d2 d1 d0 before and not at the same time the switch values are activated
    // to achieve the desired output. This it to AVOID race conditions.
    initial 
    begin
          d3 = 0; d2 = 0; d1 = 0; d0 = 1;
      #10 s0 = 0; s1 = 0; 
      
      #10 d3 = 0; d2 = 0; d1 = 1; d0 = 0;
          s0 = 0; s1 = 1;                          
      
      #10 d3 = 0; d2 = 1; d1 = 0; d0 = 0;     
          s0 = 1; s1 = 0; 
      
      #10 d3 = 1; d2 = 0; d1 = 0; d0 = 0;
          s0 = 1; s1 = 1;         
    end

endmodule


















