`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/10/2020 04:18:06 PM
// Design Name: 
// Module Name: RISC_16bit_ControlUnit
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


module mux2in#( parameter W = 8 )
    ( in0,
      in1,
      sel,
      out
    );
    
    input  [W-1:0] in0;
    input  [W-1:0] in1;
    input          sel;
    
    output [W-1:0] out;
    
    assign out = sel ? in1 : in0;
    
endmodule
//-----------------------------------------------------------------
//-----------------------------------------------------------------
module DataReg#( parameter W = 16 )
    ( clk,
      addr,
      rd,
      wr,
      W_data,
      R_data
    );
    
    input          clk;
    input  [W-9:0] addr;   // 8-bit address to allow 256 selections for DREG
    input          rd;
    input          wr;
    input  [W-1:0] W_data;
    
    output reg [W-1:0] R_data;
 
    reg [15:0] DMEM [0:255]; //256 addresses 16-bits long.   
        
    integer i;
    
    initial 
    begin
      R_data = 16'hZZZZ;
      DMEM[0]  = 16'b0000_0000_0001_0010;
      DMEM[1]  = 16'b0001_0011_0100_0101;
      
      DMEM[2]  = 16'b0010_0110_0111_1000;
      DMEM[3]  = 16'b0011_1001_1010_1011;
      DMEM[4]  = 16'b0100_1100_1101_1110;
      DMEM[5]  = 16'b0101_0000_0001_0010;
      DMEM[6]  = 16'b0110_0011_0100_0101;
      DMEM[7]  = 16'b0111_0110_0111_1000;
      
      DMEM[8]  = 16'b1000_1001_1010_1011;
      DMEM[9]  = 16'b1001_1100_1101_1110;
      DMEM[10] = 16'b1010_0000_0001_0010;
      
      DMEM[11] = 16'b1011_0011_0100_0101;
      DMEM[12] = 16'b1100_0110_0111_1000;
      
      DMEM[13] = 16'b1101_1001_1010_1011;
      DMEM[14] = 16'b1110_1100_1101_1110;
      DMEM[15] = 16'b1111_0000_0001_0010;
      
      for ( i = 16; i < 256; i = i+1 )    
        begin
          DMEM[i] = 0;  
        end
        
    end  
    
    always @( posedge clk )
      begin
        if ( wr == 1'b1 )
          DMEM[addr] <= W_data[W-1:0]; // In the specified address of DREG[], store Write data.
      end
          
    always @( posedge clk )
      begin
        if ( rd == 1'b1 )
          R_data <= DMEM[addr];
        else
          R_data <= R_data;
      end  
    
endmodule
//--------------------------------------------------------------------------------
//--------------------------------------------------------------------------------
module ProgramCounter#( parameter W = 8 ) 
    ( clk,
      ld,
      data_in,
      clr,
      up,
      pc
    );
    
    input          clk;
    input          ld;
    input  [W-1:0] data_in;
    input          clr;
    input          up;
    
    output reg [W-1:0] pc;    
    
    initial 
    begin
      pc = 8'd0;
    end
    
    always @( posedge clk )
      begin
        casex ( {clr, up, ld} )
          
          3'b0X1: pc <= data_in;
          
          3'b01X: pc <= pc + 1;
         
          3'b1XX: pc <= 8'd0;
         
          default: pc = pc;
        endcase
      end
      
endmodule
//--------------------------------------------------------------------------------
//--------------------------------------------------------------------------------
module Offset#( parameter W = 8 )
    ( in0,
      in1,
      out  
    );
    
    input  [W-1:0] in0;
    input  [W-1:0] in1;
    
    output [W-1:0] out;
      
    
endmodule
//--------------------------------------------------------------------------------
//--------------------------------------------------------------------------------
module InstructionRegister#( parameter W = 16 )
    ( clk,
      ld,
      in,
      out
    );
    
    input          clk;
    input          ld;
    input  [W-1:0] in;
    
    output reg [W-1:0] out;

    always @( posedge clk )
      begin
        if ( ld == 1'b1 )
          out <= in;
      end
    
endmodule
//--------------------------------------------------------------------------------
//--------------------------------------------------------------------------------
module controller#( parameter W = 16 ) 
    ( clk,
      reset,
      instruction,
      RF_Rp_zero,
      PC_ld,
      PC_clr,
      PC_inc,
      IR_ld,
      D_addr,
      D_addr_sel,
      D_rd,
      D_wr,
      RF_W_data,
      RF_s1,
      RF_s0,
      RF_W_addr,
      RF_W_wr,
      RF_Rp_addr,
      RF_Rp_rd,
      RF_Rq_addr,
      RF_Rq_rd,
      alu_s,
      state,
      nstate
    );
    
    input          clk;
    input          reset;
    input  [W-1:0] instruction; //IR Wire   
    input          RF_Rp_zero;
    
    output         PC_ld;
    output         PC_clr;
    output         PC_inc;
    output         IR_ld;
    output [W-9:0] D_addr;
    output         D_addr_sel;
    output         D_rd;
    output         D_wr;
    output [W-9:0] RF_W_data;
    output         RF_s1;
    output         RF_s0;
    output [3:0]   RF_W_addr;
    output         RF_W_wr;
    output [3:0]   RF_Rp_addr;
    output         RF_Rp_rd;
    output [3:0]   RF_Rq_addr;
    output         RF_Rq_rd;
    output [2:0]   alu_s;
    output [2:0]   state;
    output [2:0]   nstate;
    
    reg          PC_ld;
    reg          PC_clr;
    reg          PC_inc;
    reg          IR_ld;
    reg  [W-9:0] D_addr;
    reg          D_addr_sel;
    reg          D_rd;
    reg          D_wr;
    reg  [W-9:0] RF_W_data;
    reg          RF_s1;
    reg          RF_s0;
    reg  [3:0]   RF_W_addr;
    reg          RF_W_wr;
    reg  [3:0]   RF_Rp_addr;
    reg          RF_Rp_rd;
    reg  [3:0]   RF_Rq_addr;
    reg          RF_Rq_rd;
    reg  [2:0]   alu_s;
                 
    reg [2:0] state;
    reg [2:0] nstate;
  
    //
    // 1.) IF
    // 2.) ID  IF
    // 3.) EX  ID  IF
    // 4.) MEM EX  ID
    // 5.) WB  MEM EX
    //         WB  MEM
    //             WB
    
    localparam IDLE = 3'b000;
    localparam IF   = 3'b001;
    localparam ID   = 3'b010;
    localparam EX   = 3'b011;
    localparam MEM  = 3'b100;
    localparam WB   = 3'b101;
    
    wire [3:0] opcode;  
    wire [3:0] Rc;
    wire [3:0] Ra;
    wire [3:0] Rb;
    
    assign opcode = instruction[W-1:12];
    assign Rc     = instruction[11:8];
    assign Ra     = instruction[7:4];
    assign Rb     = instruction[3:0]; 
            
    always @( posedge clk or posedge reset )
      begin
        if ( reset )
          begin
            state  <= 3'b000;
            nstate <= 3'b000;
            //PC_clr <= 1'b1;
          end
        else 
          state  <= nstate;
          //PC_clr <= 1'b0; 
      end
      
    //state or opcode or Rc or Ra or Rb or reset
    always @( state or opcode or Rc or Ra or Rb or reset )
      begin
        nstate     = state;    
        PC_ld      = 1'b0;
        PC_clr     = 1'b0; //
        PC_inc     = 1'b0;
        IR_ld      = 1'b0;
        //D_addr     = 8'b0; used in an always block below
        D_addr_sel = 1'b0;
        D_rd       = 1'b0;
        D_wr       = 1'b0;
        RF_W_data  = 8'b0; 
        RF_s1      = 1'b0;
        RF_s0      = 1'b0;
        //RF_W_addr  = 4'b0; if not commented out, will be 0 in between sequences
        RF_W_wr    = 1'b0;   //doesn't really matter if they're commented out or not.
        //RF_Rp_addr = 4'b0; if not commented out, will be 0 in between sequences
        RF_Rp_rd   = 1'b0;
        //RF_Rq_addr = 4'b0; if not commented out, will be 0 in between sequences
        RF_Rq_rd   = 1'b0;
        //alu_s      = 3'b0;
        
        casex ( state )
          IDLE: begin
                  if ( !reset )
                    nstate = IF;
                  else
                    begin
                      nstate = state;
                      PC_clr = 1'b1;
                    end
                end
          
          IF : begin  
                 PC_clr     = 1'b0;
                 PC_inc     = 1'b1;
                 D_addr_sel = 1'b0;
                 D_rd       = 1'b1;
                 IR_ld      = 1'b1;
                 nstate     = ID;
               end
               
          ID : begin
                 casex ( opcode )
                   4'b0XXX: begin
                              RF_Rp_addr = Ra;
                              RF_Rp_rd   = 1'b1;
                              RF_Rq_addr = Rb;
                              RF_Rq_rd   = 1'b1; 
                              nstate     = EX;
                            end
                             
                   4'b1000: begin
                              RF_W_data = {Ra, Rb}; // concatenating lower 8 bits
                              nstate    = EX;       // sign-extension calculation
                                                    // occurs in mux3in module
                            end
                   
                   4'b1001: begin
                              nstate = EX;
                            end
                   
                   4'b1010: begin
                              RF_Rp_addr = Ra;
                              RF_Rp_rd   = 1'b1;
                              nstate     = EX;
                            end
                  
                   default: nstate = EX;
                 endcase    
               end
          
          EX : begin
                 casex ( opcode )
                   4'b0XXX: begin
                              alu_s  = opcode[2:0];
                              nstate = MEM; 
                            end
                             
                   4'b1000: begin
                              nstate = MEM;
                            end
                   
                   4'b1001: begin
                              nstate = MEM;
                            end
                   
                   4'b1010: begin
                              nstate = MEM;
                            end
            
                   default: nstate = MEM;
                 endcase                 
               end
          
          MEM: begin
                 casex ( opcode )
                   4'b0XXX: begin
                              nstate = WB;
                            end
                            
                   4'b1000: begin
                              nstate = WB;
                            end         
                                 
                   4'b1001: begin
                              D_addr_sel = 1'b1;
                              D_rd       = 1'b1;
                              nstate     = WB;
                            end
                                      
                   4'b1010: begin
                              D_addr_sel = 1'b1;
                              D_wr       = 1'b1;
                              nstate     = WB;
                            end
                  
                   default: nstate = WB;   
                 endcase              
               end
          
          WB : begin
                 casex ( opcode )
                   4'b0XXX: begin
                              RF_s1     = 1'b0;
                              RF_s0     = 1'b0;                   
                              RF_W_addr = Rc;
                              RF_W_wr   = 1'b1;
                              nstate    = IF; 
                            end
                             
                   4'b1000: begin
                              RF_s1     = 1'b1;
                              RF_s0     = 1'b0;
                              RF_W_addr = Rc;
                              RF_W_wr   = 1'b1;
                              nstate    = IF;
                            end
                   
                   4'b1001: begin
                              RF_s1     = 1'b0;
                              RF_s0     = 1'b1;
                              RF_W_addr = Rc;
                              RF_W_wr   = 1'b1;
                              nstate    = IF;
                            end
                   
                   4'b1010: begin
                              nstate = IF;
                            end

                   default: nstate = IF;
                 endcase          
               end
               
          default: begin
                     nstate = IDLE;
                   end
           
        endcase
      end
   
   always @(*)
     begin
       if ( D_addr_sel && D_rd )
         D_addr = 8'h9;
       else if ( D_addr_sel && D_wr )
         D_addr = 8'ha;
       else 
         D_addr = 8'd0;             
     end
   
endmodule
//--------------------------------------------------------------------------------
//--------------------------------------------------------------------------------
module RISC_16bit_ControlUnit#( parameter W = 16 )
    ( clk,
      reset,
      RF_Rp_zero,
      PC_addr,
      PC_clr,   //
      D_addr_sel,
      D_addr,
      D_rd,
      D_wr,
      RF_W_data,
      RF_s1,
      RF_s0,
      RF_W_addr,
      RF_W_wr,
      RF_Rp_addr,
      RF_Rp_rd,
      RF_Rq_addr,
      RF_Rq_rd,
      alu_s,
      R_data,
      instruction,
      state,
      nstate   
    );
    
    input          clk;
    input          reset;
    input          RF_Rp_zero; 
    
    output [W-9:0] PC_addr;
    output         PC_clr;
    output         D_addr_sel;
    output [W-9:0] D_addr;
    output         D_rd;
    output         D_wr;
    output [W-9:0] RF_W_data;
    output         RF_s1;
    output         RF_s0;
    output [3:0]   RF_W_addr;
    output         RF_W_wr;
    output [3:0]   RF_Rp_addr;
    output         RF_Rp_rd;
    output [3:0]   RF_Rq_addr;
    output         RF_Rq_rd;
    output [2:0]   alu_s;
    output [W-1:0] R_data;
    output [W-1:0] instruction;
    output [2:0]   state;
    output [2:0]   nstate;
    
    wire         D_addr_sel;
    wire [W-9:0] PC_addr;
    wire [W-9:0] D_addr;
    wire [W-9:0] mux_out_D_in;        
    
    mux2in mux2 ( .in0( PC_addr ), .in1( D_addr ), .sel( D_addr_sel ), .out( mux_out_D_in ) );
    
    wire         D_rd;
    wire         D_wr;
    wire [W-1:0] R_data;
    
    DataReg DR ( .clk( clk ), .addr( mux_out_D_in ), .rd( D_rd ), .wr( D_wr ), .W_data( 16'd0 ), .R_data( R_data ) );
    
    wire PC_clr;
    wire PC_ld;
    wire PC_inc;

    wire [7:0] offset_wire;
        
    ProgramCounter PC ( .clk( clk ), .ld( PC_ld ), .data_in( offset_wire ), .clr( PC_clr ), .up( PC_inc ), .pc( PC_addr ) );
    
    Offset Off ( .in0( 8'd0 ), .in1 ( 8'd0 ), .out ( offset_wire ) );
    
    wire         IR_ld;
    wire [W-1:0] instruction;
    
    InstructionRegister IR ( .clk( clk ), .ld( IR_ld ), .in( R_data ), .out( instruction ) );
    
    controller contr ( .clk( clk ), .reset( reset ), .instruction ( instruction ), .RF_Rp_zero ( 1'b0 ), .PC_ld( PC_ld ), .PC_clr( PC_clr ), 
                       .PC_inc( PC_inc ), .IR_ld( IR_ld ), .D_addr( D_addr ), .D_addr_sel( D_addr_sel ), .D_rd( D_rd ), .D_wr( D_wr ), 
                       .RF_W_data( RF_W_data ), .RF_s1 ( RF_s1 ), .RF_s0( RF_s0 ), .RF_W_addr( RF_W_addr ), .RF_W_wr( RF_W_wr ), 
                       .RF_Rp_addr( RF_Rp_addr ), .RF_Rp_rd( RF_Rp_rd ), .RF_Rq_addr( RF_Rq_addr ), .RF_Rq_rd( RF_Rq_rd ), .alu_s( alu_s ),
                       .state( state ), .nstate( nstate ) );
    
    
endmodule















