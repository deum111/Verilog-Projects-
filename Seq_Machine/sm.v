`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/25/2019 06:26:38 PM
// Design Name: 
// Module Name: sm
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

// This module is a very simple sequential machine that behaves based off 
// a vending machine that only accepts nickels 'n' and dimes 'd' one input at a time.
// ALthough there is nothing preventing multiple inputs at the same time, there should
// only be ONE input per clock cycle.
// The output is achieved when 15 cents has been deposited (the fourth state is reached).
// This machine DOES NOT consider more than one output for the deposit.
module sm
    ( n,
      d,
      clk,
      rst,
      op,
      state,
      nstate
    );
    
    input  n;
    input  d;
    input  clk;
    input  rst;
    output op; 
    output [1:0] state;
    output [1:0] nstate;
    
    // 2 bit register allows for 4 states to be created in this state machine
    reg [1:0] state;
    reg [1:0] nstate;
    reg op;
    
    // Design implementation
    
    //reset and update state
    always @( posedge rst or posedge clk )
      begin                    //if this were (*) it would be updating every 1ps (timescale). This would not work. So what we do it  
        if ( rst )             //update it at every positive edge of the rst or clk. When it goes from 0 to 1. 
          begin 
            state  <= 2'b00;
            nstate <= 2'b00;
          end
        else
          state <= nstate;
      end
     
    //calculating the next state
    always @( state or d or n )
      begin
        case ( state )
          2'b00: if ( n ) 
                   nstate <= 2'b01;
                 else if ( d ) 
                   nstate <= 2'b10;
          
          2'b01: if ( n )
                   nstate <= 2'b10;
                 else if ( d )
                   nstate <= 2'b11;
          
          2'b10: if ( n )
                   nstate <= 2'b11;
                 else if ( d )
                   nstate <= 2'b11;
          
          2'b11: if ( n )
                   nstate <= 2'b01;
                 else if ( d )
                   nstate <= 2'b10;
                 else
                   nstate <= 2'b00;
          
          default: nstate <= 2'b00;                                         
        endcase                 
      end        
     
    //output
    always @( state )
      begin
        case ( state )
          2'b11:   op <= 1'b1;  
          default: op <= 1'b0;
        endcase
      end         
                         
endmodule





















