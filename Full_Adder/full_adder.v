`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/05/2019 10:19:28 PM
// Design Name: 
// Module Name: full_adder
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


module half_adder
    ( a,
      b,
      sum,
      c
    );
    
    input  a;
    input  b;
    output sum;
    output c;
        
    // Design implementation    
    xor U1( sum, a, b );
    and U2( c, a, b );
    
endmodule


module full_adder
    ( a,
      b,
      cin,
      sum,
      cout
    );
    
    input  a;
    input  b;
    input  cin;
    output sum;
    output cout;
    
    wire w1;
    wire w2;
    wire w3;
   
   // Design implementation
   // By instantiaing the previous creation of the half_adder module
   // one can simplify the construction of more complex circuits. 
   // In this case the half_adder module is called twice to create a full_adder.
    
    half_adder HF1 ( a, b, w1, w2     );
    half_adder HF2 ( cin, w1, sum, w3 );
    
    or U1 ( cout, w2, w3     );
    
endmodule









