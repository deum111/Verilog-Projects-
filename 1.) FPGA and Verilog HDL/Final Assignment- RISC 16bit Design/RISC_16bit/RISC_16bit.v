`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/14/2020 05:51:59 PM
// Design Name: 
// Module Name: RISC_16bit
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
      
      // DMEM[i] is the index sent by the input addr. Either from PC_addr or D_addr.
      // The values being set into the indexes are
      // 16'b opcode_ destination reg _ sourceA reg _ sourceB reg.
      // These are sent to the IR register and the RegisterFile
      // as instructions. In the Register File values should be preset
      // into the destination, sourceA and sourceB registers, while the opcode gets sent to the ALU.
      // or some other function.
      DMEM[0]  = 16'b0000_0000_0001_0010; // opcode: 0000 Add
      DMEM[1]  = 16'b0001_0011_0100_0101; // opcode: 0001 Sub
      
      DMEM[2]  = 16'b0010_0110_0111_1000; // opcode: 0010 AND
      DMEM[3]  = 16'b0011_1001_1010_1011; // opcode: 0011 OR
      DMEM[4]  = 16'b0100_1100_1101_1110; // opcode: 0100 XOR
      DMEM[5]  = 16'b0101_0000_0001_0010; // opcode: 0101 NOT
      DMEM[6]  = 16'b0110_0011_0100_0101; // opcode: 0110 SLA
      DMEM[7]  = 16'b0111_0110_0111_1000; // opcode: 0111 SRA
      
      DMEM[8]  = 16'b1000_1001_1010_1011; // opcode: 1000 LI
      DMEM[9]  = 16'b1001_1100_1101_1110; // opcode: 1001 LW
      DMEM[10] = 16'b1010_0000_0001_0010; // opcode: 1010 SW
      
      DMEM[11] = 16'b1011_0011_0100_0101; // opcode: 1011 BIZ
      DMEM[12] = 16'b1100_0110_0111_1000; // opcode: 1100 BNZ
      
      DMEM[13] = 16'b1101_1001_1010_1011; // opcode: 1101 JAL
      DMEM[14] = 16'b1110_1100_1101_1110; // opcode: 1110 JMP
      DMEM[15] = 16'b1111_0000_0001_0010; // opcode: 1111 JR
      
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

module mux3in#( parameter W = 16 )
    ( in0,
      in1,
      in2,
      s0,
      s1,
      out
    );
    
    input  [W-1:0] in0;
    input  [W-1:0] in1;
    input  [W-9:0] in2;
    input          s0;
    input          s1;
    
    output reg [W-1:0] out;
    
    // in2 also needs to consider 8-bit sign extended immediate ( LI operation ).
    // if s1 is high and s0 is high, then check if the MSB of in2 is high.
    // if it is, then sign-extend high to 16 bits, else sign-extend low to 16 bits.
    // if s1 is high and s0 is low, then input is in1.
    // if s1 is low then input is in0. 
        
    always @(*)
      begin
        case ( {s1, s0} )
          2'b00: out = in0;
          
          2'b01: out = in1;
          
          2'b10: begin
                   if ( in2[W-9] == 1'b1 )
                     out = {8'hFF, in2[W-9:0]};
                   else 
                     out = {8'h00, in2[W-9:0]};
                 end

          default: out = in0;
        endcase
      end
        
endmodule
//-----------------------------------------------------------------
//-----------------------------------------------------------------
module RegisterFile#( parameter W = 16 )
    ( clk,
      W_data,
      W_addr,
      W_wr,
      Rp_addr,
      Rp_rd,
      Rq_addr,
      Rq_rd,
      Rp_data,
      Rq_data
    );
    
    input  clk;
    input  [W-1:0] W_data;
    input  [3:0]   W_addr;
    input          W_wr;
    input  [3:0]   Rp_addr;
    input          Rp_rd;
    input  [3:0]   Rq_addr;
    input          Rq_rd;
    
    output reg [W-1:0] Rp_data;
    output reg [W-1:0] Rq_data;
        
    reg [15:0] RFMEM [0:15];
    
    integer i;
    
    initial 
    begin
      Rp_data = 0;
      Rq_data = 0;
      
      RFMEM[0]  = 16'b0000_0000_0000_0000; //dest
      RFMEM[1]  = 16'b0000_0000_0000_0001; //source A
      RFMEM[2]  = 16'b0000_0000_0000_0001; //source B
      
      RFMEM[3]  = 16'b0000_0000_0000_0000; //dest
      RFMEM[4]  = 16'b0000_0000_0000_0001; //source A
      RFMEM[5]  = 16'b0000_0000_0000_0001; //source B
      
      RFMEM[6]  = 16'b0000_0000_0000_0000; //dest
      RFMEM[7]  = 16'b0000_0000_0000_0001; //source A
      RFMEM[8]  = 16'b0000_0000_0000_0001; //source B
      
      RFMEM[9]  = 16'b0000_0000_0000_0000; //dest
      RFMEM[10] = 16'b0000_0000_0000_0001; //source A
      RFMEM[11] = 16'b0000_0000_0000_0001; //source B
      
      RFMEM[12] = 16'b0000_0000_0000_0000; //dest
      RFMEM[13] = 16'b0000_0000_0000_0001; //source A
      RFMEM[14] = 16'b0000_0000_0000_0001; //source B
      
      RFMEM[15] = 16'b0000_0000_0000_0000;
    end  
    
    always @( posedge clk )
      begin
        if ( W_wr == 1'b1 )
          RFMEM[W_addr] <= W_data[W-1:0]; 
      end
    
    always @( posedge clk ) 
      begin
        if ( Rp_rd == 1'b1 )
          begin
            //RFMEM[Rp_addr] <= Rp_addr; // instead of manually setting values.
            Rp_data        <= RFMEM[Rp_addr];  
          end
        if ( Rq_rd == 1'b1 )
          begin
            //RFMEM[Rq_addr] <= Rq_addr; // instead of manually setting values.
            Rq_data        <= RFMEM[Rq_addr]; 
          end
      end
    
endmodule
//-----------------------------------------------------------------
//-----------------------------------------------------------------
module EQZero#( parameter W = 16 )
    ( in0,
      out
    );
    
    input  [W-1:0] in0;
    output         out;
    
    assign out = ( in0 == 16'd0 );
    
endmodule
//-----------------------------------------------------------------
//-----------------------------------------------------------------
module ALU#( parameter W = 16 )
    ( A,
      B,
      s,
      out
    );
    
    input  [W-1:0] A;
    input  [W-1:0] B;
    input  [2:0]   s;
    
    output reg [W-1:0] out;
    
    localparam ADD = 3'b000;
    localparam SUB = 3'b001;
    localparam AND = 3'b010;
    localparam OR  = 3'b011;
    localparam XOR = 3'b100;
    localparam NOT = 3'b101;
    localparam SLA = 3'b110;
    localparam SRA = 3'b111;
    
    always @(*) 
      begin
        case ( s )
          ADD: out = A + B;
          SUB: out = A - B;
          AND: out = A & B;
          OR : out = A | B;
          XOR: out = A ^ B;
          NOT: out = ~A;
          SLA: out = A << 1;
          SRA: out = A >> 1;
                  
          default: out = A + B;
      
        endcase 
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
        RF_W_addr  = 4'b0;
        RF_W_wr    = 1'b0;
        RF_Rp_addr = 4'b0;
        RF_Rp_rd   = 1'b0;
        RF_Rq_addr = 4'b0;
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
//================================================================================
//================================================================================
module Datapath#( parameter W = 16 )
    ( clk,    
      R_data,
      RF_W_data,
      RF_s1,
      RF_s0,
      RF_W_addr,
      W_wr,
      RF_Rp_addr,
      Rp_rd,
      RF_Rq_addr,
      Rq_rd,
      alu_s,
      alu_out_wire,
      RF_Rp_zero,
      Rp_data_wire
      //Rq_data_wire
    );
    
    input          clk;
      
    input  [W-1:0] R_data;
    input  [W-9:0] RF_W_data; // A, B input;
    input          RF_s1;
    input          RF_s0;
    input  [3:0]   RF_W_addr;
    input          W_wr;
    input  [3:0]   RF_Rp_addr;
    input          Rp_rd;
    input  [3:0]   RF_Rq_addr;
    input          Rq_rd;
    input  [2:0]   alu_s;
    
    output [W-1:0] alu_out_wire; // in top module for viewing 
    output         RF_Rp_zero;
    output [W-1:0] Rp_data_wire; // W_data
    //output [W-1:0] Rq_data_wire;
    
    wire [W-1:0] alu_out_wire;
    wire [W-1:0] mux3_out_wire;
                
    mux3in mux3 ( .in0 ( alu_out_wire  ),
                  .in1 ( R_data        ),
                  .in2 ( RF_W_data     ),
                  .s0  ( RF_s0         ),
                  .s1  ( RF_s1         ),
                  .out ( mux3_out_wire )
                );       
    
    wire [W-1:0] Rp_data_wire;
    wire [W-1:0] Rq_data_wire;
    
    RegisterFile RF ( .clk     ( clk           ),
                      .W_data  ( mux3_out_wire ),
                      .W_addr  ( RF_W_addr     ),
                      .W_wr    ( W_wr          ),
                      .Rp_addr ( RF_Rp_addr    ),
                      .Rp_rd   ( Rp_rd         ),
                      .Rq_addr ( RF_Rq_addr    ),
                      .Rq_rd   ( Rq_rd         ),
                      .Rp_data ( Rp_data_wire  ),
                      .Rq_data ( Rq_data_wire  )
                    );    
    
    EQZero EQZ ( .in0 ( Rp_data_wire ),
                 .out ( RF_Rp_zero   )
               );
    
    ALU aluOp ( .A   ( Rp_data_wire ),
                .B   ( Rq_data_wire ),
                .s   ( alu_s        ),
                .out ( alu_out_wire )
              );
              
endmodule
//================================================================================
//================================================================================
module Control_Unit#( parameter W = 16 )
    ( clk,
      reset,
      RF_Rp_zero,
      R_data,
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
      //instruction,
      state,
      nstate   
    );
    
    input          clk;
    input          reset;
    input          RF_Rp_zero;
    input  [W-1:0] R_data; //
    
    output [W-9:0] PC_addr; // in top module for viewing
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
    //output [W-1:0] R_data; changed to input unless debugging.
    //output [W-1:0] instruction;
    output [2:0]   state;
    output [2:0]   nstate;
    
    //wire         D_addr_sel;
    //wire [W-9:0] PC_addr;
    //wire [W-9:0] D_addr;
    //wire [W-9:0] mux_out_D_in;        
    
    //mux2in mux2 ( .in0( PC_addr ), .in1( D_addr ), .sel( D_addr_sel ), .out( mux_out_D_in ) );
    
    //wire         D_rd;
    //wire         D_wr;
    //wire [W-1:0] R_data;
    
    //DataReg DR ( .clk( clk ), .addr( mux_out_D_in ), .rd( D_rd ), .wr( D_wr ), .W_data( 16'd0 ), .R_data( R_data ) );
    
    wire PC_clr;
    wire PC_ld;
    wire PC_inc;

    wire [7:0] offset_wire;
        
    ProgramCounter PC ( .clk     ( clk         ),
                        .ld      ( PC_ld       ),
                        .data_in ( offset_wire ),
                        .clr     ( PC_clr      ),
                        .up      ( PC_inc      ),
                        .pc      ( PC_addr     )
                      );
    
    Offset Off ( .in0( 8'd0 ), .in1 ( 8'd0 ), .out ( offset_wire ) );
    
    wire         IR_ld;
    wire [W-1:0] instruction;
    
    InstructionRegister IR ( .clk   ( clk         ),
                             .ld    ( IR_ld       ),
                             .in    ( R_data      ),
                             .out   ( instruction )
                           );
    
    controller contr ( .clk         ( clk         ), .reset      ( reset      ), 
                       .instruction ( instruction ), .RF_Rp_zero ( 1'b0       ), 
                       .PC_ld       ( PC_ld       ), .PC_clr     ( PC_clr     ), 
                       .PC_inc      ( PC_inc      ), .IR_ld      ( IR_ld      ), 
                       .D_addr      ( D_addr      ), .D_addr_sel ( D_addr_sel ), 
                       .D_rd        ( D_rd        ), .D_wr       ( D_wr       ), 
                       .RF_W_data   ( RF_W_data   ), .RF_s1      ( RF_s1      ), 
                       .RF_s0       ( RF_s0       ), .RF_W_addr  ( RF_W_addr  ), 
                       .RF_W_wr     ( RF_W_wr     ), .RF_Rp_addr ( RF_Rp_addr ), 
                       .RF_Rp_rd    ( RF_Rp_rd    ), .RF_Rq_addr ( RF_Rq_addr ), 
                       .RF_Rq_rd    ( RF_Rq_rd    ), .alu_s      ( alu_s      ),
                       .state       ( state       ), .nstate     ( nstate     )
                     );
    
endmodule
//================================================================================
//================================================================================
module RISC_16bit#( parameter W = 16 )
    ( clk,
      reset,
      PC_addr,
      alu_out,
      alu_s,
      state,
      nstate
    );
    
    input  clk;
    input  reset;
    
    output [W-9:0] PC_addr;
    output [W-1:0] alu_out;
    output [2:0]   alu_s;
    output [2:0]   state;
    output [2:0]   nstate;
    
    wire [7:0] PC_addr;
    wire [7:0] D_addr;
    wire       D_addr_sel;
    wire [7:0] mux2_out_D_in;
    
    mux2in mux2 ( .in0 ( PC_addr       ),
                  .in1 ( D_addr        ),
                  .sel ( D_addr_sel    ),
                  .out ( mux2_out_D_in )
                );
  
    wire         D_rd;
    wire         D_wr;
    wire [W-1:0] W_data;
    wire [W-1:0] R_data;
    
    DataReg DR ( .clk    ( clk           ),
                 .addr   ( mux2_out_D_in ),
                 .rd     ( D_rd          ),
                 .wr     ( D_wr          ),
                 .W_data ( W_data        ),
                 .R_data ( R_data        )
               );

    wire [7:0]   RF_W_data;
    wire         RF_s1;
    wire         RF_s0;
    wire [3:0]   RF_W_addr;
    wire         RF_W_wr;
    wire [3:0]   RF_Rp_addr;
    wire         RF_Rp_rd;
    wire [3:0]   RF_Rq_addr;
    wire         RF_Rq_rd;
    wire [2:0]   alu_s;
    wire         RF_Rp_zero;
    wire [W-1:0] Rp_data_wire;
    
    Datapath Dpath ( .clk          ( clk          ), .R_data     ( R_data     ),
                     .RF_W_data    ( RF_W_data    ), .RF_s1      ( RF_s1      ),
                     .RF_s0        ( RF_s0        ), .RF_W_addr  ( RF_W_addr  ),
                     .W_wr         ( RF_W_wr      ), .RF_Rp_addr ( RF_Rp_addr ),
                     .Rp_rd        ( RF_Rp_rd     ), .RF_Rq_addr ( RF_Rq_addr ),
                     .Rq_rd        ( RF_Rq_rd     ), .alu_s      ( alu_s      ),
                     .alu_out_wire ( alu_out      ), .RF_Rp_zero ( RF_Rp_zero ),
                     .Rp_data_wire ( Rp_data_wire )
                   );

    Control_Unit control ( .clk        ( clk        ), .reset      ( reset      ),
                           .RF_Rp_zero ( RF_Rp_zero ), .R_data     ( R_data     ),
                           .PC_addr    ( PC_addr    ), .PC_clr     ( PC_clr     ),   
                           .D_addr_sel ( D_addr_sel ), .D_addr     ( D_addr     ),
                           .D_rd       ( D_rd       ), .D_wr       ( D_wr       ),
                           .RF_W_data  ( RF_W_data  ), .RF_s1      ( RF_s1      ),
                           .RF_s0      ( RF_s0      ), .RF_W_addr  ( RF_W_addr  ),
                           .RF_W_wr    ( RF_W_wr    ), .RF_Rp_addr ( RF_Rp_addr ),
                           .RF_Rp_rd   ( RF_Rp_rd   ), .RF_Rq_addr ( RF_Rq_addr ),
                           .RF_Rq_rd   ( RF_Rq_rd   ), .alu_s      ( alu_s      ),
                           .state      ( state      ), .nstate     ( nstate     )
                         );


endmodule








