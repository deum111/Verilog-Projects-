`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/25/2020 07:04:00 PM
// Design Name: 
// Module Name: tb_ALU_32bit
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
    S0 S1  ALU OP
    0  0   Addition
    0  1   Subtraction 
    1  0   Multiplication
    1  1   Shift Right 
    
    SW switches 1 and 2 should represent S0 and S1. Use SW switch 4 as reset.
    GPIO LEDs should be used to indicate the ALU Operation called.
*/

module tb_ALU_32bit();

    reg  SW1;    // Represents S0
    reg  SW2;    // Represents S1
    reg  SW4;    // Represents Reset
    reg  clock_100Mhz;
    wire [7:0] a_to_g;
    wire [7:0] an;
    wire LED1,LED2,LED4;
    wire [31:0] aluout;

    ALU_32bit UUT 
        (
         .SW1          ( SW1          ),
         .SW2          ( SW2          ),
         .SW4          ( SW4          ),
         .clock_100Mhz ( clock_100Mhz ),
         .a_to_g       ( a_to_g       ),
         .an           ( an           ),
         .LED1         ( LED1         ),
         .LED2         ( LED2         ),
         .LED4         ( LED4         ),
         .aluout       ( aluout       )
        );

    initial 
    begin
      SW1 = 0;
      SW2 = 0;
      SW4 = 1;
      clock_100Mhz = 0; 
        forever #5 clock_100Mhz = ~clock_100Mhz;
    end
    
    // parameter a = 16'h8089
    // parameter b = 16'h3000
    // parameter cin = 0;
    // parameter bin = 0;
    initial 
    begin
      #10 SW4 = 0;
      
      #15 SW1 = 0; SW2 = 0; //aluout = hb089
      
      #10 SW1 = 0; SW2 = 1; //aluout = h5089
      
      #10 SW1 = 1; SW2 = 0; //aluout = h1819b000
      
      #10 SW1 = 1; SW2 = 1; //aluout = h4044
      
      #10 SW4 = 1; SW1 = 0; SW2 = 0;
    end

endmodule
    





