`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/10/2020 04:22:17 PM
// Design Name: 
// Module Name: tb_RISC_16bit_ControlUnit
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


module tb_RISC_16bit_ControlUnit#( parameter W = 16 )();

    reg          clk;
    reg          reset;
    reg          RF_Rp_zero; 
    
    wire [W-9:0] PC_addr;
    wire         PC_clr;  //
    wire         D_addr_sel;
    wire [W-9:0] D_addr;
    wire         D_rd;
    wire         D_wr;
    wire [W-9:0] RF_W_data;
    wire         RF_s1;
    wire         RF_s0;
    wire [3:0]   RF_W_addr;
    wire         RF_W_wr;
    wire [3:0]   RF_Rp_addr;
    wire         RF_Rp_rd;
    wire [3:0]   RF_Rq_addr;
    wire         RF_Rq_rd;
    wire [2:0]   alu_s;
    wire [W-1:0] R_data;
    wire [W-1:0] instruction;
    wire [2:0]   state;
    wire [2:0]   nstate;
    
    RISC_16bit_ControlUnit UUT
        ( 
         .clk(clk),
         .reset(reset),
         .RF_Rp_zero(RF_Rp_zero),
         .PC_addr(PC_addr),
         .PC_clr(PC_clr),
         .D_addr_sel(D_addr_sel),
         .D_addr(D_addr),
         .D_rd(D_rd),
         .D_wr(D_wr),
         .RF_W_data(RF_W_data),
         .RF_s1(RF_s1),
         .RF_s0(RF_s0),
         .RF_W_addr(RF_W_addr),
         .RF_W_wr(RF_W_wr),
         .RF_Rp_addr(RF_Rp_addr),
         .RF_Rp_rd(RF_Rp_rd),
         .RF_Rq_addr(RF_Rq_addr),
         .RF_Rq_rd(RF_Rq_rd),
         .alu_s(alu_s),
         .R_data(R_data),
         .instruction(instruction),
         .state(state),
         .nstate(nstate)   
       );
       
    initial 
    begin
      clk   = 0;
      reset = 1;
      RF_Rp_zero = 0;
      forever #5 clk = ~clk;
    end
    
    initial 
    begin
      #10 reset = 0; 
      #15;
      #10;
    end
    
    
endmodule











