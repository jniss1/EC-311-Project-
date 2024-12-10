`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/08/2024 04:01:35 PM
// Design Name: 
// Module Name: top_module_vga
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


module top_module_vga (
    input wire clk_in,        // Input clock (e.g., 100 MHz)
    input wire reset,         // Reset signal
    output wire hsync,        // Horizontal sync for VGA
    output wire vsync,        // Vertical sync for VGA
    output wire [3:0] red,    // 5-bit red VGA signal
    output wire [3:0] green,  // 6-bit green VGA signal
    output wire [3:0] blue    // 5-bit blue VGA signal
);

    // Clock signal for the VGA controller
    wire clk_25MHz;

    // VGA coordinates and active video signal
    wire [9:0] x;
    wire [9:0] y;
    wire active_video;


    // Instantiate Clock Divider
    clk_divider clk_divider_inst (
        .clk_in(clk_in),       // Input clock (e.g., 100 MHz)
        .reset(reset),         // Reset signal
        .clk_out(clk_25MHz)    // Output clock (25 MHz for VGA)
    );

    // Instantiate VGA Controller
    vga_controller vga_controller_inst (
        .clk_25MHz(clk_25MHz), // 25 MHz clock
        .reset(reset),         // Reset signal
        .hsync(hsync),         // Horizontal sync signal
        .vsync(vsync),         // Vertical sync signal
        .active_video(active_video), // Active video region
        .x(x),                 // X coordinate
        .y(y)                  // Y coordinate
    );

    // Instantiate Memory Module
    fourblock_test_module disp_inst (
        .x(x),                 // Current X coordinate from VGA
        .y(y),                 // Current Y coordinate from VGA
        .red(red),             // Red color output
        .green(green),         // Green color output
        .blue(blue)            // Blue color output
    );
    
  
endmodule
