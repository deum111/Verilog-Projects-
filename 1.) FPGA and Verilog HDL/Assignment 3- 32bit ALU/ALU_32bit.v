`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/25/2020 07:03:43 PM
// Design Name: 
// Module Name: ALU_32bit
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
  
    Store initial values in memory. Display answers in seven-segment display units.
    
*/

module ALU_32bit
    ( SW1,
      SW2,
      SW4,
      clock_100Mhz,
      //reset,
      a_to_g,
      an,
      LED1,
      LED2,
      LED4,
      aluout
    );
    
    input  SW1;    // Represents S0
    input  SW2;    // Represents S1
    input  SW4;    // Represents Reset
    input  clock_100Mhz;
    //input  reset;    
    output reg [7:0] a_to_g;
    output reg [7:0] an;
    output LED1,LED2,LED4;
    output [31:0] aluout;

    parameter [15:0] a   = 16'h8089;
    parameter [15:0] b   = 16'h3000;
    parameter        cin = 1'b0;
    parameter        bin = 1'b0;
    
    reg  [31:0] aluout;
    
    wire cout;
    wire bout;
    wire [31:0] sum;
    wire [31:0] diff;
    wire [31:0] shift;
    wire [31:0] product;
     
    reg  [3:0]  LED_BCD;
    wire [3:0]  LED_activating_counter;
    reg  [19:0] refresh_counter;
    
    FA_16bit     U1( .a( a ), .b( b ), .cin( cin ), .sum( sum ), .cFlag( cout )  );
    FS_16bit     U2( .a( a ), .b( b ), .bin( bin ), .diff( diff ), .bout( bout ) );
    mult_16bit   U3( .a( a ), .b( b ), .mult( product ) );
    Shift_RightA U4( .a( a ), .shift_a( shift )         );
   
    assign LED1 = ( ~SW4 & SW1 );
    assign LED2 = ( ~SW4 & SW2 );
    assign LED4 = SW4;  
    
    always @( posedge clock_100Mhz  )
      begin
        if ( SW4 )   //Switch 4 is reset
          refresh_counter <= 0;
        else
          refresh_counter <= refresh_counter + 1;
      end

    assign LED_activating_counter = refresh_counter[19:17];

    always @(*)
      begin
        casex ( {SW4,SW1,SW2} )
          3'b000:  begin 
                     aluout <= sum;  
                   end
          
          3'b001:  begin
                     aluout <= diff;
                   end
          
          3'b010:  aluout <= product;
          
          3'b011:  aluout <= shift;
          
          3'b1xx:  aluout <= 16'h0000;
          
          default: aluout <= 16'h0000;
        endcase
        
      case ( LED_activating_counter )
        3'b000: begin
                  an = 8'b01111111;
                  LED_BCD = aluout[31:28];
                end
        3'b001: begin
                  an = 8'b10111111;
                  LED_BCD = aluout[27:24];
                end
        3'b010: begin
                  an = 8'b11011111;
                  LED_BCD = aluout[23:20];
                end
        3'b011: begin
                  an = 8'b11101111;
                  LED_BCD = aluout[19:16];
                end          
        3'b100: begin
                  an = 8'b11110111;
                  LED_BCD = aluout[15:12];
                end
        3'b101: begin
                  an = 8'b11111011;
                  LED_BCD = aluout[11:8];
                end
        3'b110: begin
                  an = 8'b11111101;
                  LED_BCD = aluout[7:4];
                end
        3'b111: begin
                  an = 8'b11111110;
                  LED_BCD = aluout[3:0];   
                end
      endcase
    end
       
    always @( LED_BCD )
      begin
        casex ( LED_BCD )
          4'b0000:   a_to_g = 8'b1_000_0001;
          4'b0001:   a_to_g = 8'b1_100_1111;
          4'b0010:   a_to_g = 8'b1_001_0010;
          4'b0011:   a_to_g = 8'b1_000_0110;
          4'b0100:   a_to_g = 8'b1_100_1100;
          4'b0101:   a_to_g = 8'b1_010_0100;
          4'b0110:   a_to_g = 8'b1_010_0000;
          4'b0111:   a_to_g = 8'b1_000_1111;
       
          4'b1000:   a_to_g = 8'b1_000_0000;
          4'b1001:   a_to_g = 8'b1_000_1100;
          4'b1010:   a_to_g = 8'b1_000_1000;
          4'b1011:   a_to_g = 8'b0_110_0000;
          4'b1100:   a_to_g = 8'b1_011_0001;
          4'b1101:   a_to_g = 8'b1_100_0010;
          4'b1110:   a_to_g = 8'b1_011_0000;
          4'b1111:   a_to_g = 8'b1_011_1000;
          
          default:   a_to_g = 8'bX0000000;
        endcase
      end

endmodule

//----------------------------------------------------------------------------
// A simple method to creating a behavioral model of a 
// any n-bit Full Adder. 
// The code below uses a simple assign statement to add together
// two n-inputs, because this is a behavioral model we must include 
// the carry out value although the carry in is not structurally specified.
// What can be done is create an output or sum that is n+1- bits greater 
// than the n-bit inputs.
// By doing so one can create a carry flag output to detect wheter
// the MSB of the output is high. If it is then the carry Flag
// can be switched high.
// The last bit of the output can always be cut to show 15:0 in the testbench.

module FA_16bit
    ( a,
      b,
      cin,
      sum,
      cFlag
    );
    
    input  [15:0] a;
    input  [15:0] b;
    input  cin;
    output [15:0] sum;
    output cFlag;
            
    assign sum = a + b + cin;
    assign cFlag = ( a&b | (a^b) & cin ); 
    
endmodule
//----------------------------------------------------------------------------
// Note: Unlike a full adder where assign statement is a simple
// addition computation, it should be remembered that in binary 
// one can't subtract using a subtraction operator. 
// To subtract one simply takes the first input added with the inverse
// of the second input and then added with 1'b1.

// 16-bit Full Subtractor. Structural Design.

module FS
    ( a,
      b,
      bin,
      diff,
      bout
    );
    
    input  a;
    input  b;
    input  bin;
    output diff;
    output bout;

    wire an;
    wire w0;
    wire w0not;
    wire w1;
    wire w2;
    
    // Design implementation of a single bit full subtractor   
    not n1( an, a     );
    not n2( w0not, w0 );
    
    xor x1( w0, a, b  );
    and a1( w1, an, b );
    xor x2( diff, w0, bin  );
    and a2( w2, w0not, bin );
    or  o1( bout, w2, w1   );

endmodule 

//
module FS_16bit
    ( a,
      b,
      bin,
      diff,
      bout
    );

    input  [15:0]a;
    input  [15:0]b;
    input  bin;
   
    output [15:0] diff;
    output bout;

    wire w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15;
    
    // Design implementation
    // Using the previous module of a single bit full subtractor
    // this 16-bit subtractor can be created by instantiating
    // the FS module and adding wires to connect each block together to 
    // form a 16-bit subtractor.
    FS F0 ( a[0], b[0], bin, diff[0], w0 );
    FS F1 ( a[1], b[1], w0, diff[1], w1  );
    FS F2 ( a[2], b[2], w1, diff[2], w2  );
    FS F3 ( a[3], b[3], w2, diff[3], w3  );
    FS F4 ( a[4], b[4], w3, diff[4], w4  );
    FS F5 ( a[5], b[5], w4, diff[5], w5  );
    FS F6 ( a[6], b[6], w5, diff[6], w6  );
    FS F7 ( a[7], b[7], w6, diff[7], w7  );
    FS F8 ( a[8], b[8], w7, diff[8], w8  );
    FS F9 ( a[9], b[9], w8, diff[9], w9  );
    FS F10( a[10], b[10], w9, diff[10], w10   );
    FS F11( a[11], b[11], w10, diff[11], w11  );
    FS F12( a[12], b[12], w11, diff[12], w12  );
    FS F13( a[13], b[13], w12, diff[13], w13  );
    FS F14( a[14], b[14], w13, diff[14], w14  );
    FS F15( a[15], b[15], w14, diff[15], bout );    
    
endmodule

//----------------------------------------------------------------------------

// 16bit multiplier
module mult_16bit
    ( a,
      b,
      mult
    );
    
    input  [15:0] a;
    input  [15:0] b;
    output [31:0] mult;
    
    assign mult = a * b;
    
    
endmodule

//----------------------------------------------------------------------------

// Rotate Circular Shift Right A
module Shift_RightA
    ( a,
      shift_a  
    );
    
    input  [15:0] a;
    output [15:0] shift_a;
    
    assign shift_a = a >> 1;
    
endmodule









