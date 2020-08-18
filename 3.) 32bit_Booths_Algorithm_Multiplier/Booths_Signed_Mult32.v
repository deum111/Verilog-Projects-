`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/03/2020 02:48:21 PM
// Design Name: 
// Module Name: Booths_Signed_Mult32
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
//  This is a 32-bit Booth's Algorithm Multiplier for Signed and Unsigned multiplication.
//  The design consists of submodules instantiated within the controller and datapath units,  
//  and the top module that instantiates the controller and datapath and wires together the necessary
//  ports together. 
//////////////////////////////////////////////////////////////////////////////////

// Accumulator register for the datapath circuit
// this is a 32-bit register that shift arithmetically to the right. 
// The register has a single input that is 32-bits and is the output 
// of a 2's complement adder/subtractor. 
// There are two outputs, one sends the least significant bit '[0]' of the register 
// to the B register everytime the Shift signal is high.
// The other output is the 32-bit value of the register itself which serves as the 
// input to the 2's complement adder/subtractor.   
module Acc_Reg#( parameter W = 32 )
    ( in,
      clk,
      reset,
      load,
      shift,
      Acc_out_B,
      Acc_out_AS 
    );
    
    input  [W-1:0] in;
    input          clk;
    input          reset;
    input          load;
    input          shift;
    
    output         Acc_out_B;
    output [W-1:0] Acc_out_AS;
    
    reg    [W-1:0] Acc_Reg; 
    
    initial
    begin
      Acc_Reg = 32'b0;
    end
    
    always @( posedge clk or posedge reset )
      begin
        if ( reset )
            Acc_Reg <= 32'b0;
        else
          begin 
            case ({ shift, load })
              2'b00:   Acc_Reg <= Acc_Reg;
          
              2'b01:   Acc_Reg <= in;
              // concatenates the MSB of the reg and the removes the LSB.
              2'b10:   Acc_Reg <= { Acc_Reg[W-1], Acc_Reg[W-1:1] };
                     
              default: Acc_Reg <= Acc_Reg;
            endcase   
          end
      end 
    // LSB of the register is sent as the input of the B register.    
    assign Acc_out_B  = Acc_Reg[0];
    assign Acc_out_AS = Acc_Reg;
    
endmodule
//-----------------------------------------------------------------------------

// The B Reg is a 32-bit registers that shifts to the right.
// B register that loads in the value of the B input 
// when the Load signal is high.
// A second 1-bit input takes in the output of the acc Register
// when the Shift signal is high.
// There are two outputs of the BReg. 
// There is one output that branches out to three different modules,
// the LSB of the B register is sent into the bi Register, this serves
// as the previous bit of the B register, while at the same time 
// the LSB is also sent into the input of an XOR gate and the cin of 
// 2's complement adder/subtractor. 
// The LSB serves three functions. The previous bit of the B reg (bi-1),
// the current bit of the B reg (bi, gets sent to XOR gate), and the 
// input that controls the adder/subtractor. 

// This is ESSENTIAL to create the functionality of BOOTH'S ALGORITHM. 
module B_Reg#( parameter W = 32 )
    ( in,
      shiftIn,
      clk,
      load,
      shift,
      B_out_biReg,
      B_out_XOR,
      B_Result
    );
    
    input          shiftIn;
    input  [W-1:0] in;
    input          clk;
    input          load;
    input          shift;
    
    output         B_out_XOR;
    output         B_out_biReg;
    output [W-1:0] B_Result; 
    
    reg    [W-1:0] B_Reg;

    initial 
    begin
      B_Reg = 32'b0;
    end
    
    always @( posedge clk )
      begin 
        case ({ shift, load })
          2'b00: B_Reg <= B_Reg;
          
          2'b01: B_Reg <= in;
          //concatenates the single-bit input from the acc Reg 
          //and the upper 31 bits of the B Reg/
          2'b10: B_Reg <= {shiftIn, B_Reg[W-1:1]};
          
          default: B_Reg <= B_Reg;
        endcase
      end
    
    assign B_out_biReg  = B_Reg[0];
    assign B_out_XOR    = B_Reg[0];
    assign B_Result     = B_Reg;
    
endmodule
//-----------------------------------------------------------------------------

// This register is a 1-bit D Flip Flop.
// It serves as the register to hold the previous
// bit of the B register.
// Initially, the B register should always be equal to 1'b0;
// This is because in Booth's Algorithm before any algorithmic shift of the 
// multiplier itself, the shift must start off with a zero value compared to 
// the LSB of the multiplier.
module bi_Reg 
    ( in,
      clk,
      reset,
      out
    );
    
    input  in;
    input  clk;
    input  reset;
    output out;
    
    reg out;
    
    initial
    begin
      out = 1'b0;
    end
    
    always @( posedge clk or posedge reset )
      begin
        if ( reset )
          out <= 1'b0;
        else
          out <= in;  
      end
   
endmodule
//-----------------------------------------------------------------------------

// xor gate that serves a purpose like an excitation table of
// a state transistion table. 
// Takes in the sequence of the current and previous B reg bits to determine
// the action for the multiplicand with the multiplier.
module xor_gate
    ( in0,
      in1,
      out
    );
    input  in0;
    input  in1;
    output out;
    
    assign out = in1 ^ in0;

endmodule    
//-----------------------------------------------------------------------------    

// 2-input multiplexer that selects either a zero or 
// the A register containing the input A.
module mux_2in#( parameter W = 32 )
    ( in0,
      in1,
      sel,
      out
    );
    
    input  [W-1:0] in0;// value is instantiated in datapath unit.
    input  [W-1:0] in1; 
    input          sel;  
    output [W-1:0] out;
    
    assign out = sel ? in1 : in0; 
    
endmodule
//-----------------------------------------------------------------------------

// The A register contains the input A value when the 
// Load signal is high.
module A_Reg#( parameter W = 32 )
    ( in,
      clk,
      load,
      out
    );
    
    input  [W-1:0] in;
    input          clk;
    input          load;
    
    output [W-1:0] out;
    
    reg [W-1:0] A_Reg;
    
    initial
    begin
      A_Reg = 32'b0;
    end
    
    always @( posedge clk )
      begin
        if ( load )
          A_Reg <= in;
      end
      
    assign out = A_Reg;  
    
endmodule
//-----------------------------------------------------------------------------

// 2's Complement Adder/Subtractor
module AS_2comp#( parameter W = 32 )
    ( a,
      b,
      cin,
      out
    );
    
    input  [W-1:0] a;
    input  [W-1:0] b;
    input          cin;
    output [W-1:0] out;
     
    assign out = cin ? ( b + ~a + cin ) : ( b + a );

endmodule
////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////
// The following submodules are part os the control circuit.

// The DFF is used as part of the state, next-state controller logic.
// The DFF is a clocked register that can be used to allow for 
// a single clock cycle to occur before the states are sent to the controller 
// after the next state inputs are sent into this DFF.
module DFF
    ( d,
      clk,
      q
    );
    
    input  d;
    input  clk;
    output q;
    
    reg q;
    
    initial 
    begin
      q = 1'b0;
    end
    
    always @( posedge clk )
      begin
        q <= d;
      end  
    
endmodule
//-----------------------------------------------------------------------------

// This Countdown counter is used to set the Done output flag signal
// to high after 32 counts, because that is how long it takes to
// perform a 32-bit Booth's Algorithm signed multiply operation.
module Countdown_Counter
    ( SubCount,
      CountRst,
      clk,
      Done,
      CountReg
    );
    
    input  SubCount;
    input  CountRst;
    input  clk;
    output Done;
    output [5:0] CountReg;
    
    reg [5:0] CountReg;
      
    initial
    begin
      CountReg = 6'd32;
    end  
      
    // only posedge clk in sensitivity list and not 
    // also posedge reset, because if it is included
    // the combinational logic of the Done flag 
    // never has time to occur ( be set high ) before the register
    // is reset again to 6'd32 so it never "sees" the zero.
    always @( posedge clk )
      begin
        if ( CountRst )
          CountReg <= 6'd32;
        else if ( SubCount )
          CountReg <= CountReg - 1;
        else 
          CountReg <= CountReg;    
      end  
      
    assign Done = (CountReg == 0);  
    
endmodule
//-----------------------------------------------------------------------------

// Controller logic that sets the values
// of the operands and controls the next state
// values of the circuit.

// The operand signals are already given in
// the state-transistion table in the assignment.
// I used Logic Friday (truth-table/boolean software) to
// derive the minimized boolean equations of the operands.
module Controller_Logic
    ( Start,
      Done,
      state0,
      state1,
      nstate0,
      nstate1,
      SubCount,
      CountRst,
      accRst,
      accLd,
      Bld,
      Ald,
      biRst,
      Ready,
      Shift      
    );
    
    input  Start;
    input  Done;

    input  state0;
    input  state1;
    output nstate0;
    output nstate1;
    
    //reg nstate0;
    //reg nstate1;
        
    output accRst;
    output accLd;
    output Bld;
    output Ald;
    output biRst;
    output Ready;
    output Shift;
    output CountRst;
    output SubCount;
    
    // calculating the next state
    /*
    always @(*)
      begin
        nstate1 = 1'b0;
        nstate0 = 1'b0;     
        case ({ state1, state0 })
          2'b00: begin 
                   if ( Start )
                     begin
                       nstate1 = 1'b0;
                       nstate0 = 1'b1;
                     end
                 end
                 
          2'b01: begin
                   if ( !Done )
                     begin
                       nstate1 = 1'b1;
                       nstate0 = 1'b0;
                     end
                   else
                     begin
                       nstate1 = 1'b0;
                       nstate0 = 1'b0;   
                     end
                 end
                 
          2'b10: begin
                   if ( !Done )
                     begin
                       nstate1 = 1'b0;
                       nstate0 = 1'b1;
                     end
                   else
                     begin
                       nstate1 = 1'b0;
                       nstate0 = 1'b0;
                     end
                 end
                  
          default: begin
                     nstate1 = state1;
                     nstate0 = state0;             
                   end
        endcase   
      end
    */
    
    assign nstate1  = ( state0 & ~Done );
    assign nstate0  = (( state1 & ~Done ) | ( ~state1 & ~state0 & Start ));   
    
    // output 
    assign accRst   = ( ~state1 & ~state0 & Start );
    assign accLd    = (  state0 & ~Done           );
    assign Bld      = ( ~state1 & ~state0 & Start );
    assign Ald      = ( ~state1 & ~state0 & Start );
    assign biRst    = ( ~state1 & ~state0 & Start );
    assign Ready    = (( state1 & Done ) | ( state0 & Done ) | ( ~state1 & ~state0 & ~Start ));
    assign Shift    = (  state1 & ~Done );
    assign CountRst = (  Done           );
    assign SubCount = (  state1 & ~Done );                
                 
          
endmodule
////////////////////////////////////////////////////////////////

    
////////////////////////////////////////////////////////////////

// Datapath unit instantiates the submodules together
// to create the datapath circuit.
module Datapath_unit#( parameter W = 32 )
    ( A,
      B,
      clk,
      Result,
      accLd,
      Bld,
      Ald,
      accRst,
      bi_1_Rst,
      Shift,
      B_Result,
      Acc_out_AS_in  
    );
    
    input  [W-1:0] A;  //
    input  [W-1:0] B;  //
    input  clk;
    input  accLd;
    input  Bld;
    input  Ald;
    input  accRst;
    input  bi_1_Rst;
    input  Shift;
    
    output [63:0] Result;
    
    output [W-1:0] B_Result;
    output [W-1:0] Acc_out_AS_in;
       
    wire         Acc_out_B_in;
    wire [W-1:0] Acc_out_AS_in;
    wire [W-1:0] AS_out_Acc_in;
    
    Acc_Reg#(W) Acc ( .in         ( AS_out_Acc_in ),
                      .clk        ( clk    ),
                      .reset      ( accRst ),
                      .load       ( accLd  ),
                      .shift      ( Shift  ),
                      .Acc_out_B  ( Acc_out_B_in  ),
                      .Acc_out_AS ( Acc_out_AS_in )
                    );
    
    wire         B_out_biReg_in;
    wire         B_out_XOR_in;
    wire [W-1:0] B_Result;            
                
    B_Reg#(W) B_R   ( .in          ( B ),
                      .shiftIn     ( Acc_out_B_in ),
                      .clk         ( clk   ),   
                      .load        ( Bld   ),
                      .shift       ( Shift ),
                      .B_out_biReg ( B_out_biReg_in ),
                      .B_out_XOR   ( B_out_XOR_in  ),
                      .B_Result    ( B_Result    )
                    );
    
    wire bi_out_xor_in;            
                
    bi_Reg bi1   ( .in    ( B_out_biReg_in ),
                   .clk   ( clk      ),
                   .reset ( bi_1_Rst ),
                   .out   ( bi_out_xor_in )
                 );
    
    wire xor_out_sel_in;
    
    xor_gate xg  ( .in0 ( B_out_XOR_in   ),
                   .in1 ( bi_out_xor_in  ),
                   .out ( xor_out_sel_in )
                 );
    
    wire [W-1:0] A_out_mux_in;
    wire [W-1:0] mux_out_AS_in;                
    
    // mux in0 is always set equal to 0.
    mux_2in#(W) mux ( .in0 ( 32'b0 ),
                      .in1 ( A_out_mux_in ),
                      .sel ( xor_out_sel_in ),
                      .out ( mux_out_AS_in ) 
                    );
                
    A_Reg#(W) A_R   ( .in   ( A    ),
                      .clk  ( clk  ),
                      .load ( Ald  ),
                      .out  ( A_out_mux_in ) 
                    );
    
    // assign out = cin ? ( b + ~a + cin ) : ( b + a );            
    AS_2comp#(W) AS ( .a   ( mux_out_AS_in  ),
                      .b   ( Acc_out_AS_in ),
                      .cin ( B_out_XOR_in  ),  
                      .out ( AS_out_Acc_in )
                    );
    
    // RESULTING 64-bit OUTPUT
    // Concatenation of Acc_Reg and B_Reg
    assign Result = {Acc_out_AS_in, B_Result};
  
    
endmodule
//////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////
module Control_unit
    ( clk,
      Start,
      accRst,
      accLd,
      Bld,
      Ald,
      bi_1_Rst,
      Ready,
      Shift,
      CountRst,
      SubCount,
      state0,
      state1,
      nstate0,
      nstate1,
      Done,
      CountReg
    );
    
    input  clk;
    input  Start;
      
    output accRst;
    output accLd;
    output Bld;
    output Ald;
    output bi_1_Rst;
    output Ready;
    output Shift;
    output CountRst;
    output SubCount;
    
    output state0;
    output state1;
    output nstate0;
    output nstate1;
    output Done;
    
    output [5:0] CountReg;
    
    wire state0;
    wire state1;
    wire nstate0;
    wire nstate1;
    
    wire Done;
    wire SubCount;
    wire CountRst;
    
    DFF D0 ( .d   ( nstate0 ),
             .clk ( clk     ),
             .q   ( state0  )
           ); 
           
    DFF D1 ( .d   ( nstate1 ),
             .clk ( clk     ),
             .q   ( state1  )
           );        
    
    Countdown_Counter CC ( .SubCount ( SubCount ),
                           .CountRst ( CountRst ),
                           .clk      ( clk  ),
                           .Done     ( Done ),
                           .CountReg ( CountReg ) 
                         );
    
    Controller_Logic Clogic ( .Start    ( Start  ),
                              .Done     ( Done   ),
                              .state0   ( state0  ),
                              .state1   ( state1  ),
                              .nstate0  ( nstate0 ),
                              .nstate1  ( nstate1 ),
                              .SubCount ( SubCount ),
                              .CountRst ( CountRst ),
                              .accRst   ( accRst   ),
                              .accLd    ( accLd    ),
                              .Bld      ( Bld      ),
                              .Ald      ( Ald      ),
                              .biRst    ( bi_1_Rst ),
                              .Ready    ( Ready    ),
                              .Shift    ( Shift    )      
                            );
    
endmodule
////////////////////////////////////////////////////////


////////////////////////////////////////////////////////

// TOP MODULE INSTANTIATING CONTROLLER AND DATAPATH
// More signals than necessary were included in the top module
// for initial debugging and to view the signal occurences of 
// each operand and other key outputs within the circuit. 
module Booths_Signed_Mult32#( parameter W = 32 )
    ( A,
      B,
      Start,
      clk,
      Result,
      accRst,
      accLd,
      Bld,
      Ald,
      bi_1_Rst,
      Ready,
      Shift,
      CountRst,
      SubCount,
      state0,
      state1,
      nstate0,
      nstate1,
      Done,
      B_Result,
      Acc_out_AS_in,
      CountReg
    );
    
    input  [W-1:0] A;
    input  [W-1:0] B;
    input          Start;
    input          clk;
    
    output [63:0] Result;
    
    output accRst;
    output accLd;
    output Bld;
    output Ald;
    output bi_1_Rst;
    output Ready;
    output Shift;
    output CountRst;
    output SubCount;
    
    output state0;
    output state1;
    output nstate0;
    output nstate1;
    output Done;
    
    output [W-1:0] B_Result;
    output [W-1:0] Acc_out_AS_in;
    
    output [5:0] CountReg;
            
    wire accRst;
    wire accLd;
    wire Bld;
    wire Ald;
    wire bi_1_Rst;
    wire Shift;
    
    Datapath_unit#(W) datapath ( .A        ( A   ),
                                 .B        ( B   ),
                                 .clk      ( clk ),
                                 .Result   ( Result ),
                                 .accLd    ( accLd  ),
                                 .Bld      ( Bld    ),
                                 .Ald      ( Ald    ),
                                 .accRst   ( accRst ),
                                 .bi_1_Rst ( bi_1_Rst ),
                                 .Shift    ( Shift    ),
                                 .B_Result ( B_Result ),
                                 .Acc_out_AS_in ( Acc_out_AS_in )
                               );                          
                               
    Control_unit controller     ( .clk      ( clk    ),
                                  .Start    ( Start  ),
                                  .accRst   ( accRst ),
                                  .accLd    ( accLd  ),
                                  .Bld      ( Bld    ),
                                  .Ald      ( Ald    ),
                                  .bi_1_Rst ( bi_1_Rst ),
                                  .Ready    ( Ready    ),
                                  .Shift    ( Shift    ),
                                  .CountRst ( CountRst ),
                                  .SubCount ( SubCount),
                                  .state0   ( state0  ),
                                  .state1   ( state1  ),
                                  .nstate0  ( nstate0 ),
                                  .nstate1  ( nstate1 ),
                                  .Done     ( Done    ),
                                  .CountReg ( CountReg )
                                );
                                
endmodule

