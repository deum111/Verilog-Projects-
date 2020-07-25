`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/19/2019 06:26:28 PM
// Design Name: 
// Module Name: tb_FS
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


module tb_FS();

    reg  [15:0] a;
    reg  [15:0] b;
    reg  bin;
    wire [15:0] diff;
    wire bout;

    FS_16bit UUT
        (
         .a    ( a    ),
         .b    ( b    ), 
         .bin  ( bin  ),
         .diff ( diff ),
         .bout ( bout )
        );
    
    initial
    begin
        bin     = 1;
    #10 a[15:0] = 0;
        b[15:0] = 0;
    
    #10 a = 16'h0001; // 0001-00f0-0001 = ff10
        b = 16'h00f0; 
        
    #10 a = 16'h0002; // 0002-1000-0001 = F001
        b = 16'h1000; 
     
    #10 a = 16'h0003; // 0003-0030-0001 = FFD2
        b = 16'h0030;
                    
    #10 a = 16'h0040; // 0040-0001-0001 = 003E
        b = 16'h0001;

    //-----------------------
    #10 bin     = 0;
    #10 a[15:0] = 0;
        b[15:0] = 0;
   
    #10 a = 16'h0001; // 0001-00f0 = FF11
        b = 16'h00f0;
        
    #10 a = 16'h0002; // 0002-1000 = F002
        b = 16'h1000;
     
    #10 a = 16'h0003; // 0003-0030 = FFD3
        b = 16'h0030;
                    
    #10 a = 16'h0040; // 0040-0001 = 003F
        b = 16'h0001;                      
    end
    
endmodule

















