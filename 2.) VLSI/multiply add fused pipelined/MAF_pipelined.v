`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/17/2020 02:17:36 PM
// Design Name: 
// Module Name: MAF_pipelined
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

// Pipe Stage 1
//========================================================
module mux2inB#( parameter W = 32 ) 
    ( B,
      in1,
      Sel,
      Out
    );
    
    input  [W-1:0] B;
    input  [W-1:0] in1;
    input    [1:0] Sel;
    output [W-1:0] Out;
    
    reg [W-1:0] Out;
    
    always @(*) 
      begin
        casex ( Sel )
          2'b00  : Out = B;
          2'b01  : Out = in1;
          2'b10  : Out = B;
          2'b11  : Out = 32'hXXXX_XXXX;
          default: Out = 32'hXXXX_XXXX;
        endcase
      end
    
endmodule 


module Multiplier#( parameter W = 32 ) 
    ( A,
      B,
      Out
    );
    
    input    [W-1:0] A;
    input    [W-1:0] B;
    output [W*2-1:0] Out;
    
    assign Out = A * B; 
    
endmodule
//========================================================

//Pipe Stage 2
//========================================================
module mux2inC#( parameter W = 32 ) 
    ( C,
      in1,
      Sel,
      Out
    );
    
    input    [W-1:0] C;  // C
    input    [W-1:0] in1; // 1'b0
    input      [1:0] Sel;
    output [W*2-1:0] Out;
    
    reg [W*2-1:0] Out;
    
    always @(*) 
      begin
        casex ( Sel )
          2'b00  : Out = in1;
          2'b01  : Out = C;
          2'b10  : Out = C;
          2'b11  : Out = 32'hXXXX_XXXX;
          default: Out = 32'hXXXX_XXXX;
        endcase
      end
    
endmodule


module Adder#( parameter W = 64 )
    ( in0,
      in1,
      Out
    );
    
    input  [W-1:0] in0;
    input  [W-1:0] in1;
    output [W-1:0] Out;
    
    assign Out = in0 + in1;
    
endmodule
//========================================================

//Top Module
//========================================================
module MAF_pipelined#( parameter W = 64 )
    ( clk,
      A,
      B,
      C,
      func,
      Result
    );
    
    input  clk;
    
    input [W-33:0] A;
    input [W-33:0] B;
    input [W-33:0] C;
    input    [1:0] func;
    
    output [W-1:0] Result;
    
    wire [W-33:0] M1_wire;
    
    mux2inB M1
        ( .B   ( B       ), 
          .in1 ( 32'd1   ),
          .Sel ( func    ),
          .Out ( M1_wire )
        );
    
    wire [W-1:0] mult_out;
    
    Multiplier mult
        ( .A   ( A        ),
          .B   ( M1_wire  ),
          .Out ( mult_out )
        );
        
    //pipeline stage registers
    reg [W-1:0] mult_out_reg;
    reg   [1:0] func_reg;
    reg [W-33:0] c_reg;
    
    always @( posedge clk )
      begin
        mult_out_reg <= mult_out;
        func_reg <= func;
        c_reg <= C;                  
      end    
    
    wire [W-1:0] M2_wire;
    
    mux2inC M2    
        ( .C   ( c_reg    ),
          .in1 ( 32'd0    ),
          .Sel ( func_reg ),
          .Out ( M2_wire  )
        );
    
    // pipe stage 2
    wire [W-1:0] Out;
    reg  [W-1:0] Result;
    
    Adder Add
        ( .in0 ( mult_out_reg ),
          .in1 ( M2_wire      ),
          .Out ( Out          )
        );
    
    always @( posedge clk )
      begin
        Result <= Out;
      end 
   
    
endmodule








