`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/08/2020 03:18:10 PM
// Design Name: 
// Module Name: RISC_16bit_Datapath
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
    
    // INITIALIZE/CREATE VALUES TO PUT IN DMEM[addr] 
    
    integer i;
    
    initial 
    begin
      R_data = 0;
      for ( i = 0; i < 256; i = i+1 )    
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
//-----------------------------------------------------------------
//-----------------------------------------------------------------
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
      for ( i = 0; i < 16; i = i+1 )
        begin
          RFMEM[i] = 0;
        end
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
            RFMEM[Rp_addr] <= Rp_addr; // instead of manually setting values.
            Rp_data        <= RFMEM[Rp_addr];  
          end
        if ( Rq_rd == 1'b1 )
          begin
            RFMEM[Rq_addr] <= Rq_addr; // instead of manually setting values.
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
//-----------------------------------------------------------------
//-----------------------------------------------------------------
module RISC_16bit_Datapath#( parameter W = 16 )
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
      Rp_data_wire,
      Rq_data_wire
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
    
    output [W-1:0] alu_out_wire;  
    output         RF_Rp_zero;
    output [W-1:0] Rp_data_wire; // W_data
    output [W-1:0] Rq_data_wire;
    
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














