`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/08/2024 02:45:57 PM
// Design Name: 
// Module Name: vga_controller
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


module vga_controller(
    input wire clk_25MHz,
    input wire reset,
    output wire hsync,
    output wire vsync,
    output wire active_video,
    output wire [9:0] x,
    output wire [9:0] y
    );
    
    //Horizontal Parameters
    localparam H_DISPLAY = 640;   // Visible pixels
    localparam H_FRONT = 16;      // Front porch
    localparam H_SYNC = 96;       // Sync pulse
    localparam H_BACK = 48;       // Back porch
    localparam H_TOTAL = H_DISPLAY + H_FRONT + H_SYNC + H_BACK;
    
    //Vertical Parameters
    localparam V_DISPLAY = 480;   // Visible rows
    localparam V_FRONT = 10;      // Front porch
    localparam V_SYNC = 2;        // Sync pulse
    localparam V_BACK = 33;       // Back porch
    localparam V_TOTAL = V_DISPLAY + V_FRONT + V_SYNC + V_BACK;

    
    //Counter Declarations
    reg [9:0] h_counter = 0; // Horizontal counter (x-coordinate)
    reg [9:0] v_counter = 0; // Vertical counter (y-coordinate)
    
    //Horizontal Counter Logic
     always @(posedge clk_25MHz or posedge reset) begin
        if (reset)
            h_counter <= 0; // Reset horizontal counter
        else if (h_counter == H_TOTAL - 1)
            h_counter <= 0; // Restart at the end of the row
        else
            h_counter <= h_counter + 1; // Increment counter
    end
    
    //Vertical Counter Logic
    always @(posedge clk_25MHz or posedge reset) begin
        if (reset)
            v_counter <= 0; // Reset vertical counter
        else if (h_counter == H_TOTAL - 1) begin
            if (v_counter == V_TOTAL - 1)
                v_counter <= 0; // Restart at the end of the frame
            else
                v_counter <= v_counter + 1; // Increment counter
        end
    end
    
    //Generate sync signals + active video signal
    assign hsync = (h_counter >= H_DISPLAY + H_FRONT && h_counter < H_DISPLAY + H_FRONT + H_SYNC) ? 0 : 1;
    assign vsync = (v_counter >= V_DISPLAY + V_FRONT && v_counter < V_DISPLAY + V_FRONT + V_SYNC) ? 0 : 1;
    assign active_video = (h_counter < H_DISPLAY && v_counter < V_DISPLAY);
  
    //Output current pixel coordinates
    assign x = h_counter;
    assign y = v_counter;
    
endmodule
