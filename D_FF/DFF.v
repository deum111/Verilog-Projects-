`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/14/2019 06:19:29 PM
// Design Name: 
// Module Name: DFF
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

// THIS IS THE STRUCTURAL DESIGN USING PRIMITIVES.
/*
module DFF(
    
    input d, en, 
    output q, qbar
   
    );
    
    wire r, w1, w2;
    not (r, d);
    and (w1, r, en);
    and (w2, d, en);
    nor (q, w1, qbar);
    nor (qbar, w2, q);
    
endmodule

*/
//-------------------------------------
// STRUCTURAL DESIGN USING GATES
/*
module DFF(input d, en, output q, qbar);
    
    wire r, w1, w2;
    INV I1(r, d);
    AND2 A1(w1, r, en);  //I am guessing that the total # of gates must be a part of the gate name.
    AND2 A2(w2, d, en);
    NOR2 N1(q, w1, qbar);
    NOR2 N2(qbar, w2, q);

endmodule
*/
//-------------------------------------

// THIS IS THE BEHAVIORAL DESIGN
// The reason why the above design does not work
// is because a flip flop requries sequential logic.
// Using combinational logic to drive the output of a flip flop
// will create problems in Verilog because it acts as a latch or
// some other issues arise.

module DFF
    ( d,
      clk,
      q,
      qbar
    );
    
    input  d;
    input  clk;
    output q;
    output qbar;    
    
    reg q;
    reg qbar;
    
    always @( posedge clk )
      begin
        if ( d || ~d )
          begin
            q    <=  d;
            qbar <= ~d;
          end  
      end
        
endmodule






    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    













