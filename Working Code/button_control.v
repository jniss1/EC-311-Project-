`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/09/2024 09:44:29 PM
// Design Name: 
// Module Name: button_control
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


module button_control(
    input [14:0] acl_data, 
    output reg right_button,
    output reg left_button,
    output reg up_button,
    output reg bottom_button
);

always @(*) begin
    // Initialize buttons to 0
    right_button = 0;
    left_button = 0;
    up_button = 0;
    bottom_button = 0;

    // Check conditions for right button
    if (acl_data[9] && (acl_data[8:5] >= 8 && acl_data[8:5] <= 11)) begin
        right_button = 1;
    end

    // Check conditions for left button
    if (!acl_data[9] && (acl_data[8:5] >= 5 && acl_data[8:5] <= 8)) begin
        left_button = 1;
    end

    // Check conditions for up button
    if (acl_data[14] && (acl_data[13:10] >= 8 && acl_data[13:10] <= 11)) begin
        up_button = 1;
    end

    // Check conditions for bottom button
    if (!acl_data[14] && (acl_data[13:10] >= 3 && acl_data[13:10] <= 7)) begin
        bottom_button = 1;
    end
end 
    
endmodule
