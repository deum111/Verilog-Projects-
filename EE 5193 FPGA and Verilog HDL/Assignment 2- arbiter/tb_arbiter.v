`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/27/2019 03:50:49 PM
// Design Name: 
// Module Name: tb_arbiter
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


module tb_arbiter();

    reg  req_0;
    reg  req_1;
    reg  req_2;
    reg  clk; 
    reg  rst;
    wire gnt_0; 
    wire gnt_1; 
    wire gnt_2;
    wire [1:0] state;
    wire [1:0] nstate;

    arbiter UUT
        (
         .req_0  ( req_0  ),
         .req_1  ( req_1  ),
         .req_2  ( req_2  ),
         .clk    ( clk    ),
         .rst    ( rst    ),
         .gnt_0  ( gnt_0  ),
         .gnt_1  ( gnt_1  ),
         .gnt_2  ( gnt_2  ),
         .state  ( state  ),
         .nstate ( nstate )
        );
    
    initial 
    begin
      rst = 1;
      clk = 0;
        forever #5 clk = ~clk;
    end
    
    initial 
    begin
      #10 rst   = 0;   // state 0 
          req_0 = 0;   // next state 0 with no inputs
          req_1 = 0;   // default next state 3 with inputs. next output gnt_2
          req_2 = 0;
          
      #15 req_0 = 1;   // state 3. output gnt_2
          req_1 = 0;   // next state 1. next output gnt_0
          req_2 = 0;
     
      #10 req_0 = 0;   // state 1. output gnt_0
          req_1 = 1;   // next state 2. next output gnt_1
          req_2 = 0;
 
      #10 req_0 = 0;   // state 2. output gnt_1
          req_1 = 0;   // next state 3. next output gnt_2
          req_2 = 1;
      
      #10 req_0 = 1;   // state 3. output gnt_2
          req_1 = 1;   // next state 1. next output gnt_0
          req_2 = 0;
      
      #10 req_0 = 0;   // state 1. output gnt_0
          req_1 = 1;   // next state 2. next output gnt_1
          req_2 = 1;
          
      #10 req_0 = 1;   // state 2. output gnt_1
          req_1 = 1;   // next state 3. next output gnt_2
          req_2 = 1;
      
      #10  // buffer   // state 3. output gnt_2  
                       // next state 3. next output gnt_2.
                       
      #10 rst   = 1;   // state 0. outputs 0. Reset.                                            
    end

endmodule

























