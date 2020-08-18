`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/26/2020 08:08:34 PM
// Design Name: 
// Module Name: Euclid_GCD
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

// Adapted from http://cseweb.ucsd.edu/classes/sp10/cse141L/pdf/02/02-Verilog2.pdf
// The following code is based on the design found in the link above. 
// Initially, an attempt was made to follow the Eulclidean Algorithm as stated 
// in https://www.khanacademy.org/computing/computer-science/cryptography/modarithmetic/a/the-euclidean-algorithm,
// however, with the idea of maintaining a synthesizable design, the implementation of using division '/' and 
// remainder '%' functions would be more complex than the design in the first link stated. Furthermore, 
// reading into synthesizable design guides, it is said that the modulus and division operators should not be used
// in synthesizable design because it may have trouble/cause issues with synthesis. 

// Euclid's Algorithm to find Greatest Common Divisor between two integers.
// Leaf modules with logic that will be instantiated 
// through the Datapath_Unit 

// 2-input Multiplexer to be used for B input reg.
module Mux2in#( parameter W = 16 )  
    ( in0,
      in1,
      sel,
      out
    );
    
    input  [W-1:0] in0;
    input  [W-1:0] in1;
    input  sel;
    output [W-1:0] out;
    
    reg [W-1:0] out;
    
    always @( * )
      begin
        case ( sel )
          0: out = in0;
          1: out = in1;
        endcase
      end
    
endmodule

// 3 input Multiplexer to be used for A input reg
module Mux3in#( parameter W = 16 )
    ( in0,
      in1,
      in2,
      sel,
      out    
    );
    
    input  [W-1:0] in0;
    input  [W-1:0] in1;
    input  [W-1:0] in2;
    input  [1:0]   sel;
    output [W-1:0] out;
    
    reg [W-1:0] out;
    
    always @( * )
     begin
       casex ( sel )
         2'b00:  out = in0;
         2'b01:  out = in1;
         2'b10:  out = in2;
         default: out = 2'bXX;
       endcase
     end
       
endmodule

// Flip Flop with enable pin to be instantiated 
// for A and B inputs.
module ED_FF#( parameter W = 16 )
    ( clk,
      en,
      d,
      q
    );
    
    input  clk;
    input  en;
    input  [W-1:0] d;
    output [W-1:0] q;
    
    reg [W-1:0] q;
    
    always @( posedge clk )
      begin
        if ( en )
          q <= d;
      end

endmodule

// Comparator to check if B input is equal to zero.
module EQ_zero#( parameter W = 16 )
    ( in0,
      in1,
      out
    );
    
    input  [W-1:0] in0;
    input  [W-1:0] in1;
    output out;

    assign out = ( in0==in1 );
    
endmodule

// If input A is less than B, output high
// to enable logic in non-leaf modules.
module Less_than#( parameter W = 16 )
    ( in0,
      in1,
      out
    );
    
    input  [W-1:0] in0;
    input  [W-1:0] in1;
    output out;
    
    assign out = ( in0 < in1 );
    
endmodule

// Subtractin input A - input B
module Subtractor#( parameter W =16 )
    (
      in0,
      in1,
      out
    );
     
    input  [W-1:0] in0;
    input  [W-1:0] in1;
    output [W-1:0] out; 
    
    assign out = in0 - in1;
     
endmodule    

// Non-leaf modules
// Datapath Unit to instantiate together submodules. 
module Datapath_Unit#( parameter W = 16 )
    ( clk,
      operand_A,
      operand_B,
      result_data,
      A_en,
      B_en,
      A_mux_sel,
      B_mux_sel,
      B_zero,
      A_lt_B
    );
            
    input clk;
    
    // Data signals
    input   [W-1:0] operand_A;
    input   [W-1:0] operand_B;
    output  [W-1:0] result_data;
    
    // Control signals (ctrl -> dpath)
    input        A_en;
    input        B_en;
    input  [1:0] A_mux_sel;
    input        B_mux_sel;
    
    // Control signals (dpath -> ctrl)
    output B_zero;
    output A_lt_B;
    
    wire [W-1:0] B;
    wire [W-1:0] A_mux_out; 
    wire [W-1:0] sub_out;
    
    Mux3in#(W) A_mux ( .in0 ( operand_A ),
                       .in1 ( sub_out   ),
                       .in2 ( B         ),
                       .sel ( A_mux_sel ),
                       .out ( A_mux_out ) 
                     ); 
    
    wire [W-1:0] A;
    
    ED_FF#(W) A_ff   ( .clk ( clk       ),
                       .en  ( A_en      ),
                       .d   ( A_mux_out ), 
                       .q   ( A         ) 
                     );
    
    wire [W-1:0] B_mux_out;
    
    Mux2in#(W) B_mux ( .in0 ( operand_B ), 
                       .in1 ( A         ), 
                       .sel ( B_mux_sel ),
                       .out ( B_mux_out ) 
                     );
                        
    ED_FF#(W) B_ff   ( .clk ( clk       ),
                       .en  ( B_en      ),
                       .d   ( B_mux_out ),
                       .q   ( B         )
                     );
    
    EQ_zero#(W) B_EQ_0 ( .in0( B ), .in1( 16'd0 ), .out( B_zero ) );
    Less_than#(W) lt   ( .in0( A ), .in1( B ), .out( A_lt_B )  );
    Subtractor#(W) sub ( .in0( A ), .in1( B ), .out( sub_out ) );    
    
    assign result_data = A; 
    
endmodule


module Control_Unit#( parameter W = 16 )
    ( clk,
      reset,
      A_en,
      B_en,
      A_mux_sel,
      B_mux_sel,
      B_zero,
      A_lt_B,
      input_available,
      result_rdy,
      result_taken,
      state,
      nstate
    );
        
    input  clk;
    input  reset;
    
    // Data signals
    output input_available;
    output result_taken;
    output result_rdy;
    
    // Control signals (dpath -> ctrl)
    input  B_zero;
    input  A_lt_B;
    
    // Control signals (ctrl -> dpath)
    output       A_en;
    output       B_en;
    output [1:0] A_mux_sel;
    output       B_mux_sel;
    
    // state and next state registers
    // state and nstate outputs specified 
    // purely for display purposes in the simulation 
    output [1:0] state;      
    output [1:0] nstate;
    
    reg [1:0] state;
    reg [1:0] nstate;
   
    // reset and update state
    always @( posedge clk or posedge reset )
      begin
        if ( reset )
          begin
            state  <= 2'b00;
            nstate <= 2'b00;
          end
        else 
          state <= nstate; 
      end
      
    // calculating the next state 
    always @(*)
      begin   
        nstate = state;     // Default state stays the same. This allows calculation to continue unitl completion. 
        case ( state ) 
          2'b00: if ( !reset )         // Reset state created for a cleaner design
                   nstate = 2'b01;     // and to prevent next states from occuring too
                                       // quickly.
          2'b01: if ( input_available )// State1 acts as an idle state when operation 
                   nstate = 2'b10;     // begins when input_available == 1.
          
          2'b10: if ( B_zero )         // State2 begins the calculation of the GCD. 
                   nstate = 2'b11;
                             
          2'b11: if ( result_taken )   // State3 notifies of completion of calculation.
                   nstate = 2'b01;
         
          default: nstate = state;
        endcase 
      end  
        
    //output is sent to next state logic
    assign result_taken = result_rdy;    
    
    wire result_taken;
    
    reg [1:0] A_mux_sel;
    reg A_en;
    reg B_mux_sel;
    reg B_en;
    reg result_rdy;
    reg input_available;
    
    // output 
    always @(*)
      begin
        // Default values.
        A_mux_sel       = 2'bXX; 
        A_en            = 1'b0;  
        B_mux_sel       = 1'bX;  
        B_en            = 1'b0;
        input_available = 1'b0;  
        result_rdy      = 1'b0;  
       
        casex ( state ) 
          2'b01: begin
                   A_mux_sel       = 2'b00; // Take in operand_A
                   A_en            = 1'b1;  
                   B_mux_sel       = 1'b0;  // Take in operand_B
                   B_en            = 1'b1;  
                   input_available = 1'b1;  // Trigger next state
                 end
          
          2'b10: begin
                   if ( A_lt_B )
                     begin
                       A_mux_sel = 2'b10; // Swap function. Select B as Mux_A input
                       A_en      = 1'b1;  // Enable A register
                       B_mux_sel = 1'b1;  // Select A as Mux_B input
                       B_en      = 1'b1;  // Enable B register
                     end
                   else if ( !B_zero )
                     begin 
                       A_mux_sel = 2'b01; //sub_out into Mux_A input
                       A_en      = 1'b1; 
                     end
                 end 
          
          2'b11: begin
                   result_rdy = 1'b1;     // assign result_taken = result_rdy;
                 end                      // restarts back at State1.
                 
          default: begin
                     A_mux_sel       = 2'bXX; 
                     A_en            = 1'b0;  
                     B_mux_sel       = 1'bX;  
                     B_en            = 1'b0;  
                     input_available = 1'b0;  
                     result_rdy      = 1'b0;  
                   end
        endcase 
      end  
         
endmodule


module Euclid_GCD#( parameter W = 16 )
    ( clk,
      reset,
      operand_A,
      operand_B,
      result_data,
      input_available,
      result_rdy,
      result_taken,
      state,
      nstate
    );  
    
    input clk;
    
    // Data signals
    input  [W-1:0] operand_A;
    input  [W-1:0] operand_B;
    output [W-1:0] result_data;
    
    // Control signals
    input  reset;
    
    output input_available;
    output result_taken;
    output result_rdy;
    
    output [1:0] state;
    output [1:0] nstate;
    
    wire       A_en;
    wire       B_en;
    wire [1:0] A_mux_sel;
    wire       B_mux_sel;
    wire       B_zero;
    wire       A_lt_B;
    
    Datapath_Unit#(W) datapath ( .clk         ( clk ),
                                 .operand_A   ( operand_A ),
                                 .operand_B   ( operand_B ),
                                 .result_data ( result_data ),
                                 .A_en        ( A_en ),
                                 .B_en        ( B_en ),
                                 .A_mux_sel   ( A_mux_sel ),
                                 .B_mux_sel   ( B_mux_sel ),
                                 .B_zero      ( B_zero ),
                                 .A_lt_B      ( A_lt_B )
                               );  
   
    Control_Unit#(W) control ( .clk             ( clk   ),
                               .reset           ( reset ),
                               .A_en            ( A_en  ),
                               .B_en            ( B_en  ),
                               .A_mux_sel       ( A_mux_sel ),
                               .B_mux_sel       ( B_mux_sel ),
                               .B_zero          ( B_zero ),
                               .A_lt_B          ( A_lt_B ),
                               .input_available ( input_available ),
                               .result_rdy      ( result_rdy   ),
                               .result_taken    ( result_taken ),
                               .state           ( state  ),
                               .nstate          ( nstate )
                             );                      
    
endmodule


