`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/08/2024 02:45:57 PM
// Design Name: 
// Module Name: memory_module
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


module memory_module (
    input wire [9:0] x,         // Current x-coordinate from VGA
    input wire [9:0] y,         // Current y-coordinate from VGA
    output wire [4:0] red,      // 5-bit red color output
    output wire [5:0] green,    // 6-bit green color output
    output wire [4:0] blue      // 5-bit blue color output
);

    // Sprite size
    localparam SPRITE_WIDTH = 64;  // Sprite width (64 pixels)
    localparam SPRITE_HEIGHT = 64; // Sprite height (64 pixels)

    // Sprite position on the screen
    localparam SPRITE_X_OFFSET = 100; // Horizontal starting position of sprite
    localparam SPRITE_Y_OFFSET = 50;  // Vertical starting position of sprite

    // Memory array for the sprite data
    reg [15:0] pixel_data [0:SPRITE_WIDTH * SPRITE_HEIGHT - 1];

    // Initialize the memory with data from the .mem file
    initial begin
        $readmemh("mole_sprite.mem", pixel_data);
    end

    // Determine if the current VGA coordinates are within the sprite's bounds
    wire sprite_active = (x >= SPRITE_X_OFFSET && x < SPRITE_X_OFFSET + SPRITE_WIDTH) &&
                         (y >= SPRITE_Y_OFFSET && y < SPRITE_Y_OFFSET + SPRITE_HEIGHT);

    // Calculate pixel index relative to the sprite's top-left corner
    wire [5:0] sprite_x = x - SPRITE_X_OFFSET; // Sprite-relative X coordinate
    wire [5:0] sprite_y = y - SPRITE_Y_OFFSET; // Sprite-relative Y coordinate
    wire [11:0] pixel_index = sprite_y * SPRITE_WIDTH + sprite_x;

    // Output pixel data
    wire [15:0] pixel_value = sprite_active ? pixel_data[pixel_index] : 16'b0;

    // Extract RGB565 components
    assign red   = pixel_value[15:11]; // Upper 5 bits for red
    assign green = pixel_value[10:5];  // Middle 6 bits for green
    assign blue  = pixel_value[4:0];   // Lower 5 bits for blue

endmodule
