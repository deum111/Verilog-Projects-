`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/27/2019 03:01:56 PM
// Design Name: 
// Module Name: arbiter
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

// This module is a an arbiter designed as a sequential machine.

module arbiter(
    req_0,
    req_1,
    req_2, 
    clk, 
    rst, 
    gnt_0, 
    gnt_1, 
    gnt_2,
    state,
    nstate
    );
    
    input  req_0; 
    input  req_1;
    input  req_2;
    input  clk; 
    input  rst; 
    output gnt_0; 
    output gnt_1; 
    output gnt_2;
    output [1:0] state;
    output [1:0] nstate;
  
    reg [1:0] state;    // current state, output is shown at this state
    reg [1:0] nstate;   // next state, input is computed at this state
    reg gnt_0;          // outputs
    reg gnt_1;
    reg gnt_2;
    
    wire gnt_0_out;     // To demonstrate the functionality of this circuit
    wire gnt_1_out;     // an equation was created from a truth table. 
    wire gnt_2_out;     // Wires are created for assign statements to be used as net data types 
                        // seen in the state machine below. 
    
    // Based on the specifications of the design. A truth table was input into
    // a program called Logic Friday which can generate a boolean equation 
    // from the truthtable and minimize the equation. The result is seen below. 
    // These equations fulfill the described conditions. 
    // When only req_0 is asserted, gnt_0 is asserted.
    // "" req_1 "", gnt_1 "".
    // "" req_2 "", gnt_2 "".
    // When both req_0 and req_1 are asserted, then gnt_0 is asserted.
    // "" req_1 and req_2 "", then gnt_1 "".
    // For all other combinations, gnt_2 is asserted.
                        
    assign gnt_0_out = ~req_2 & req_0;
    assign gnt_1_out = req_1 & ~req_0;
    assign gnt_2_out = req_2 & req_0 + ~req_1 & ~req_0;
    
    // reset and update state
    always @( posedge rst or posedge clk )
      begin
        if ( rst )
          begin
            state  <= 2'b00;      // For the reset, I left state 0 as an empty
            nstate <= 2'b00;      // reset state. This is because if you assign 
          end                     // gnt_0 to be associated with state 0, or any output for that matter,
        else                      // then one may run into an issue where gnt_0 is high in instances where it         
          state <= nstate;        // is not wanted to be.
      end
    
    // calculating the next state
    always @( state or req_0 or req_1 or req_2 )
      begin
        case ( state )
          2'b01: if ( gnt_0_out )        // The assign statements created using the 
                   nstate <= 2'b01;      // net data type outputs are used as the conditionals
                 else if ( gnt_1_out )   // in this sequential function.
                   nstate <= 2'b10;      
                 else if ( gnt_2_out )   
                   nstate <= 2'b11;
                 else 
                   nstate <= 2'b11;
          
          2'b10: if ( gnt_0_out )
                   nstate <= 2'b01;
                 else if ( gnt_1_out )
                   nstate <= 2'b10;
                 else if ( gnt_2_out )
                   nstate <= 2'b11;
                 else 
                   nstate <= 2'b11;                  
          
          2'b11: if ( gnt_0_out )
                   nstate <= 2'b01;
                 else if ( gnt_1_out )
                   nstate <= 2'b10;
                 else if ( gnt_2_out )
                   nstate <= 2'b11;
                 else 
                   nstate <= 2'b11;
          
          default: nstate <= 2'b11;                     
        endcase
      end 
    
    // output of the design  
    always @( state )             // Because this is a sequential design
      begin                       // the output will not be realized until one
        case ( state )            // clock cycle after the input is realized.
          2'b01:   begin          // Mentioned above gnt_0 is associated
                     gnt_0 <= 1;  // with state 1 and so on to allow for a reset state 0...     
                     gnt_1 <= 0;
                     gnt_2 <= 0;
                   end   
          2'b10:   begin
                     gnt_0 <= 0;
                     gnt_1 <= 1;
                     gnt_2 <= 0;
                   end                 
          2'b11:   begin
                     gnt_0 <= 0;
                     gnt_1 <= 0;
                     gnt_2 <= 1;
                   end  
          default: begin 
                     gnt_0 <= 0;
                     gnt_1 <= 0;
                     gnt_2 <= 0;
                   end  
        endcase
      end
      
endmodule


