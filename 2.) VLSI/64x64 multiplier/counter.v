`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/27/2019 08:03:43 PM
// Design Name: 
// Module Name: counter
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


module counter(
    clk,
    reset,
    UpOrDown,  //high for UP counter and low for Down counter
    Count
    );

    
    //input ports and their sizes
    input clk, reset, UpOrDown;
    //output ports and their size
    output [15:0] Count;
    //Internal variables
    reg [15:0] Count = 0;  //2^16 65,536
    
     always @(posedge clk or posedge reset )
     begin
        if(reset == 1) 
            Count <= 0;
        else    
            if(UpOrDown == 1)   //Up mode selected
                if(Count == 65536)
                    Count <= 0;
                else
                    Count <= Count + 1; //Increment Counter
            else  //Down mode selected
                if(Count == 0)
                    Count <= 65536;
                else
                    Count <= Count - 1; //Decrement counter
     end    
endmodule
