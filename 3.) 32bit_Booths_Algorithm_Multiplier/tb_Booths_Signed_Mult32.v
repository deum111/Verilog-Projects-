`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/03/2020 02:48:41 PM
// Design Name: 
// Module Name: tb_Booths_Signed_Mult32
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


module tb_Booths_Signed_Mult32#( parameter W = 32 )();

    reg  [W-1:0] A;
    reg  [W-1:0] B;
    reg          Start;
    reg          clk;
    
    wire [63:0] Result;
    
    wire accRst;
    wire accLd;
    wire Bld;
    wire Ald;
    wire bi_1_Rst;
    wire Ready;
    wire Shift;
    wire CountRst;
    wire SubCount;
    
    wire state0;
    wire state1;
    wire nstate0;
    wire nstate1;
    wire Done;
          
    wire [W-1:0] B_Result;
    wire [W-1:0] Acc_out_AS_in;
    
    wire [5:0] CountReg;

    Booths_Signed_Mult32 UUT 
        ( 
         .A        ( A        ),
         .B        ( B        ),
         .Start    ( Start    ),
         .clk      ( clk      ),
         .Result   ( Result   ),
         .accRst   ( accRst   ),
         .accLd    ( accLd    ),
         .Bld      ( Bld      ),
         .Ald      ( Ald      ),
         .bi_1_Rst ( bi_1_Rst ),
         .Ready    ( Ready    ),
         .Shift    ( Shift    ),
         .CountRst ( CountRst ),
         .SubCount ( SubCount ),
         .state0   ( state0   ),
         .state1   ( state1   ),
         .nstate0  ( nstate0  ),
         .nstate1  ( nstate1  ),
         .Done     ( Done     ),
         .B_Result ( B_Result ),
         .Acc_out_AS_in ( Acc_out_AS_in ),
         .CountReg ( CountReg )
        );
        
    initial 
    begin
      clk = 0;
      Start = 0;
      forever #5 clk = ~clk;
    end     
     
    // WAVEFORM SHOULD BE VIEWED IN SIGNED DECIMAL     
    initial
    begin
      A = 32'hffff_fff5; //  ( -11 ) == 32'b1111...1111_0101;
      B = 32'hffff_fff5; // x( -11 ) == 32'b1111...1111_0101;
                         // -----------------------------------
      Start = 1;         //    121   == 64'b0000...0111_1001;
      
      #10 Start = 0; 
    end
    

endmodule








