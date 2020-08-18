`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/17/2020 08:33:36 PM
// Design Name: 
// Module Name: Single_Precision_FPA
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

// This single precision floating point adder design
// ONLY takes calculation sign bit 0 numbers.
// functionality can be modified to take into account
// negative numbers.
module Single_Precision_FPA#( parameter W = 32 )
    ( clk,
      reset,
      A,
      B,
      Result,
      Done,
      ovf_flag,
      state,
      nstate
    );
    
    input          clk;
    input          reset;
    input  [W-1:0] A;
    input  [W-1:0] B;
    output [W-1:0] Result;
    output         Done;
    output         ovf_flag;
    output   [3:0] state;
    output   [3:0] nstate;
    
    reg [W-1:0] Result;
    reg         Done;
    
    reg [3:0] state;
    reg [3:0] nstate; 
    
    reg        SignA;
    reg        SignB;
    reg  [7:0] ExpA;
    reg  [7:0] ExpB;
    reg [23:0] MantissaA;  // bit [23] is for implied leading 1 bit
    reg [23:0] MantissaB;  // 
    reg [24:0] MantissaAB; // bit [24] is for overflow. if bit [24] is high then it is overflowed. 
    reg  [7:0] ExpAB;
    reg        SignAB;
    reg        Exp_equal;
    reg        ovf_flag;
    reg        Ready;
    
    // reset and update
    always @( posedge clk or posedge reset )
      begin
        if ( reset )
          begin
            state  <= 4'b0000;
            nstate <= 4'b0000;
          end
        else
          state <= nstate;  
      end
    
    // next state logic
    always @(*) 
      begin       
        case ( state )
          4'b0000: begin
                     if ( !reset )
                       nstate = 4'b0001;
                   end
                            
          4'b0001: begin
                     if ( Exp_equal )
                       nstate = 4'b0010;
                     else if ( Ready )
                       nstate = 4'b0110; // done   
                   end
                  
          4'b0010: nstate = 4'b0011;
          
          4'b0011: begin
                     if ( !Ready )
                       nstate = 4'b0100;
                     else 
                       nstate = 4'b0110; // done
                   end
                   
          4'b0100: begin
                     if ( MantissaAB[24] == 0 )
                       nstate = 4'b0101; 
                   end
                   
          4'b0101: nstate = 4'b0110; // done
          
          4'b0110: begin
                     if ( Done )
                       nstate = 4'b0000;
                   end
          
          default: nstate = state;         
        endcase 
      end
    
    // output
    always @(*) 
      begin
        SignA      = A[W-1];
        SignB      = B[W-1];
        ExpA       = A[30:23];
        ExpB       = B[30:23];
        MantissaA  = { 1'b1, A[22:0] }; // the Mantissa is given the leading 1 bit to normalize
        MantissaB  = { 1'b1, B[22:0] }; 
        ovf_flag   = 1'b0;
        Ready      = 1'b0;
        Done       = 1'b0;
        
        case ( state )
          4'b0000: Ready = 1'b0;
           
          4'b0001: begin
                     if ( ExpA == ExpB )
                       begin
                         Exp_equal = 1'b1;
                         ExpAB     = ExpA; 
                       end
                     else if ( ExpA < ExpB )
                       begin
                         if ( ExpB - ExpA > 8'd23 )
                           begin
                             MantissaAB[23:0] = MantissaB;
                             ExpAB            = B;
                             Ready            = 1'b1;
                           end
                         else
                           begin   
                             MantissaA = MantissaA >> 1; //logical shift right
                             ExpA      = ExpA + 1'b1;  //adding 1 to exponent until equal.
                           end
                       end
                     else if ( ExpA > ExpB )
                       begin
                         if ( ExpA - ExpB > 8'd23 )
                           begin
                             MantissaAB[23:0] = MantissaA;
                             ExpAB            = A;
                             Ready            = 1'b1;
                           end
                         else
                           begin  
                             MantissaB = MantissaB >> 1; //logical shift right
                             ExpB      = ExpB + 1'b1; //adding 1 to exponent until equal.
                           end
                       end                
                   end
                   
          4'b0010: MantissaAB = MantissaA + MantissaB;
                  
          4'b0011: begin
                     if ( MantissaAB == 0 )
                       begin
                         ExpAB  = 8'b0000_0000;
                         SignAB = 1'b0;
                         Ready  = 1'b1; 
                       end
                   end
          
          4'b0100: begin
                     if ( MantissaAB[24] == 1 )
                       begin
                         MantissaAB = MantissaAB >> 1;
                         ExpAB      = ExpAB + 1'b1;
                       end  
                   end
          
          4'b0101: begin
                     if (ExpAB == 8'd255 )
                       ovf_flag = 1'b1;
                   end
           
          4'b0110: begin
                     Result[W-1]   = SignA; // Doesn't matter. This design only considers 0 sign bit numbers.
                     Result[30:23] = ExpAB;
                     Result[22:0]  = MantissaAB[22:0];
                     Done          = 1'b1; 
                   end         
          
          default: Done = 1'b0;         
        endcase
      end
    
    
endmodule









