`timescale 1ns / 1ps



module vga_controller(clk, h_sync, v_sync, led_on, x, y);
    
    input clk;
    output reg h_sync, v_sync, led_on;
    output wire [9:0] x;
    output wire [9:0] y;
    
    
    localparam TOTAL_WIDTH = 800;
    localparam TOTAL_HEIGHT = 525;
    localparam ACTIVE_WIDTH = 640;
    localparam ACTIVE_HEIGHT = 480;
    localparam H_SYNC_COLUMN = 704;
    localparam V_SYNC_LINE = 523;
    
    reg [11:0] widthPos = 0;
    reg [11:0] heightPos = 0;
    
    
    wire enable = ((widthPos >=50 & widthPos < 690) & (heightPos >=33 & heightPos < 513)) ? 1'b1: 1'b0;
    
    
    // Following always block ensures that 
    // you go through all pixel coordinates
    always@(posedge clk)
    begin
        // check if end of the width 
        if(widthPos < TOTAL_WIDTH -1)
            begin 
                widthPos <= widthPos + 1;
            end
        else
        begin
            // move back to the first column
            widthPos <=0;
            // check if end of the height
            if(heightPos < TOTAL_HEIGHT -1)
            begin
                heightPos <= heightPos + 1;
            end
            else
            begin
                 heightPos <= 0;
            end       
        end
    end
    
    always@(posedge clk)
    begin
        if (widthPos < H_SYNC_COLUMN)
        begin
            h_sync <= 1'b1;
        end
        else
        begin
            h_sync <= 1'b0;
        end
   end


    always@(posedge clk)
    begin
        if (heightPos < V_SYNC_LINE)
        begin
            v_sync <= 1'b1;
        end
        else
        begin
            v_sync <= 1'b0;
        end
   end
    
    // this is you main logic based on 
    // your project
    always@(posedge clk)
    begin
        if(enable)
        begin
            led_on <= 1'b1;
        end
        else
        begin
            led_on <= 1'b0;
        end 
   end   
        
    
   assign x = widthPos;
   assign y = heightPos; 

endmodule
