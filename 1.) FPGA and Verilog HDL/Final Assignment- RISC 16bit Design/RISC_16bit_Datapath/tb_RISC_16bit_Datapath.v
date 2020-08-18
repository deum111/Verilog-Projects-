`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/08/2020 03:18:30 PM
// Design Name: 
// Module Name: tb_RISC_16bit_Datapath
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


module tb_RISC_16bit_Datapath#( parameter W = 16 )();

    reg          clk;
      
    reg  [W-1:0] R_data;
    reg  [W-9:0] RF_W_data; // A, B input;
    reg          RF_s1;
    reg          RF_s0;
    reg  [3:0]   RF_W_addr;
    reg          W_wr;
    reg  [3:0]   RF_Rp_addr;
    reg          Rp_rd;
    reg  [3:0]   RF_Rq_addr;
    reg          Rq_rd;
    reg  [2:0]   alu_s;
      
    wire [W-1:0] alu_out_wire;  
    wire         RF_Rp_zero;
    wire [W-1:0] Rp_data_wire;
    wire [W-1:0] Rq_data_wire;

    RISC_16bit_Datapath UUT 
        ( 
         .clk (clk),    
         .R_data (R_data),
         .RF_W_data (RF_W_data),
         .RF_s1 (RF_s1),
         .RF_s0 (RF_s0),
         .RF_W_addr (RF_W_addr),
         .W_wr (W_wr),
         .RF_Rp_addr (RF_Rp_addr),
         .Rp_rd (Rp_rd),
         .RF_Rq_addr (RF_Rq_addr),
         .Rq_rd (Rq_rd),
         .alu_s (alu_s),
         .alu_out_wire (alu_out_wire),
         .RF_Rp_zero (RF_Rp_zero),
         .Rp_data_wire (Rp_data_wire),
         .Rq_data_wire (Rq_data_wire)
        );
        
    initial 
    begin
      clk = 0;
      forever #5 clk = ~clk; 
    end    
    
    initial 
    begin
      #10 
      Rp_rd = 1'b1;
      Rq_rd = 1'b1;
      RF_Rp_addr = 4'b0101;
      RF_Rq_addr = 4'b0110;
      alu_s = 3'b000;
      
      RF_s0 = 1'b0;
      RF_s1 = 1'b0;
      
      #15
      W_wr = 1;
      RF_W_addr = 4'b1111;
      
      
      
        
    end
        

endmodule












