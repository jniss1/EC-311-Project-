`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/02/2024 07:44:23 AM
// Design Name: 
// Module Name: vga_top
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


module vga_top(
    input clk,
    input reset,
    input mole, mole2, mole3, mole4,
    output reg [3:0] vga_r, vga_g, vga_b,
    output h_sync, v_sync
);

    
    wire newClk, ledOn;
    wire [9:0] x;
    wire [9:0] y;

    
    
    
    
   /////Instantiations///// 
    
    
    
    //Clock Divider
    clk_divider clkDiv (clk, reset, newClk);
    
    //VGA Controller
    vga_controller vga_con (newClk, h_sync, v_sync, ledOn, x, y);
    
    
    
    //////VGA Logic//////
    
//    For debugging: Hardcoded mole signals for testing
//    reg mole, mole2, mole3, mole4;
    
//    initial begin
//        mole = 1;
//        mole2 = 0;
//        mole3 = 1;
//        mole4 = 0;
//    end 
    
    // Block detection
    wire [2:0] block;
    assign block = (x >= 266 && x < 330) && (y >= 169 && y < 233) ? 3'b001 : //top left
                   (x >= 410 && x < 474) && (y >= 169 && y < 233) ? 3'b010 : //top right
                   (x >= 410 && x < 474) && (y >= 313 && y < 377) ? 3'b011 : // bottom right
                   (x >= 266 && x < 330) && (y >= 313 && y < 377) ? 3'b100 : 3'b000; //bottom left
    

    
    always @(posedge newClk)
    begin
        if (ledOn) begin
//            if (block == 3'b000) begin
//                vga_r <= 4'h0;  // Full red
//                vga_g <= 4'h0;  // No green
//                vga_b <= 4'hF;  // No blue
//            end
//            else 
            if (block == 3'b001 && mole) begin
                vga_r <= 4'h0;  // No red
                vga_g <= 4'hF;  // Full green
                vga_b <= 4'h0;  // No blue
            end
            else if (block == 3'b010 && mole2) begin
                vga_r <= 4'h0;  // No red
                vga_g <= 4'hF;  // No green
                vga_b <= 4'h0;  // Full blue
            end
            else if (block == 3'b011 && mole3) begin
                vga_r <= 4'h0;  // Full red
                vga_g <= 4'hF;  // Full green
                vga_b <= 4'h0;  // White
            end
            else if (block == 3'b100 && mole4) begin
                vga_r <= 4'h0; 
                vga_g <= 4'hF;
                vga_b <= 4'h0; 
            end
            else begin
                vga_r <= 4'h0;  // Full red
                vga_g <= 4'h0;  // No green
                vga_b <= 4'hF;  // No blue
            end 
        end
        else begin
            vga_r <= 4'h0;  // Full red
            vga_g <= 4'h0;  // No green
            vga_b <= 4'hF;
        end  
    end
    
    
endmodule