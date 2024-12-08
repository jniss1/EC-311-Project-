`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/08/2024 02:45:57 PM
// Design Name: 
// Module Name: clk_divider
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


module clk_divider(
    input wire clk_in,
    input wire reset,
    output reg clk_out
    );
    
    //Counter: 3 bits
    reg [2:0] counter = 0;
    
    //Divider Logic
    always @(posedge clk_in or posedge reset) begin
        if (reset) begin
            counter <= 0;
            clk_out <= 0;
        end else begin
            counter <= counter + 1;
            
            if (counter == 3) begin  // Change bool exp to change toggle value
                clk_out <= ~clk_out;
                counter <= 0;
            end
        end    
    end         
endmodule









