`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/09/2024 02:14:07 PM
// Design Name: 
// Module Name: fourblock_test_module
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


module fourblock_test_module(
    input wire [9:0] x,
    input wire [9:0] y,
    output reg [3:0] red,
    output reg [3:0] green,
    output reg [3:0] blue
    );
    
    // Block detection
    wire [1:0] block;
    assign block = (x >= 100 && x < 164) && (y >= 50 && y < 114) ? 2'b00 : // Block 1
                   (x >= 164 && x < 228) && (y >= 50 && y < 114) ? 2'b01 : // Block 2
                   (x >= 100 && x < 164) && (y >= 114 && y < 178) ? 2'b10 : // Block 3
                   (x >= 164 && x < 228) && (y >= 114 && y < 178) ? 2'b11 : 2'bxx; // Block 4 or none

    // Assign colors based on block
    always @(*) begin
        case (block)
            2'b00: begin
                red   = 4'hF; // Full red
                green = 4'h0; // No green
                blue  = 4'h0; // No blue
            end
            2'b01: begin
                red   = 4'h0; // No red
                green = 4'hF; // Full green
                blue  = 4'h0; // No blue
            end
            2'b10: begin
                red   = 4'h0; // No red
                green = 4'h0; // No green
                blue  = 4'hF; // Full blue
            end
            2'b11: begin
                red   = 4'hF; // Full red
                green = 4'hF; // Full green
                blue  = 4'h0; // Yellow
            end
            default: begin
                red   = 4'hF; 
                green = 4'hF;
                blue  = 4'hF;
            end
        endcase
    end
    

endmodule
