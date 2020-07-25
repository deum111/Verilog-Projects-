`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/19/2019 06:26:08 PM
// Design Name: 
// Module Name: FS
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



