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
    output reg hsync,
    output reg vsync,
    output reg active_video,
    output wire [9:0] x,
    output wire [9:0] y
    );
    
    //Horizontal Parameters
    localparam H_DISPLAY = 640;   // Visible pixels
    localparam H_SYNC_COLUMN = 704;
    localparam H_TOTAL = 800;
    
    //Vertical Parameters
    localparam V_DISPLAY = 480;   // Visible rows
    localparam V_SYNC_LINE = 523;
    localparam V_TOTAL = 525;

    
    //Counter Declarations
    reg [11:0] h_counter = 0; // Horizontal counter (x-coordinate)
    reg [11:0] v_counter = 0; // Vertical counter (y-coordinate)
    
    wire enable = ((h_counter >=50 & h_counter < 690) & (v_counter >=33 & v_counter < 513)) ? 1'b1: 1'b0;
    
     // Following always block ensures that 
    // you go through all pixel coordinates
    always@(posedge clk_25MHz)
    begin
        // check if end of the width 
        if(h_counter < H_TOTAL - 1)
            begin 
                h_counter <= h_counter + 1;
            end
        else
        begin
            // move back to the first column
            h_counter <=0;
            // check if end of the height
            if(v_counter < V_TOTAL - 1)
            begin
                v_counter <= v_counter + 1;
            end
            else
            begin
                 v_counter <= 0;
            end       
        end
    end
    
    always@(posedge clk_25MHz)
    begin
        if (h_counter < H_SYNC_COLUMN)
        begin
            hsync <= 1'b1;
        end
        else
        begin
            hsync <= 1'b0;
        end
   end


    always@(posedge clk_25MHz)
    begin
        if (v_counter < V_SYNC_LINE)
        begin
            vsync <= 1'b1;
        end
        else
        begin
            vsync <= 1'b0;
        end
   end
    
    // this is you main logic based on 
    // your project
    always@(posedge clk_25MHz)
    begin
        if(enable)
        begin
            active_video <= 1'b1;
        end
        else
        begin
            active_video <= 1'b0;
        end 
   end   
   
   assign x = h_counter;
   assign y = v_counter; 
endmodule
