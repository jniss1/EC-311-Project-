`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/08/2024 03:01:03 PM
// Design Name: 
// Module Name: clk_divider_tb
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


module clk_divider_tb(
    
    );
    
    reg clk_in;
    reg reset;
    wire clk_out;
    
    clk_divider DUT (
        .clk_in(clk_in),
        .reset(reset),
        .clk_out(clk_out)
    );
    
    always #2 clk_in = ~clk_in;
    
    initial begin
        clk_in = 0;
        reset = 0;
        #1 reset = 1;
        #1 reset = 0;
        
        #100 reset = 1;
        #100 reset = 0;
        #500 $finish;
    end 
    
endmodule
