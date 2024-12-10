`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/02/2024 08:32:09 AM
// Design Name: 
// Module Name: clkDiv_tb
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


module clkDiv_tb();
    
    reg clk, reset;
    wire newClk;
    
    clk_divider test(clk, reset, newClk);
    
    initial begin
        clk =  0;
        reset = 0;
        #500 $finish;
    end
    
    always #2 clk = ~clk;
endmodule
