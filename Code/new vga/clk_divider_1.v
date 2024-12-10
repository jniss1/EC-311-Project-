`timescale 1ns / 1ps


// CLK DIVIDER FROM 100MHz -> 25 MHz

module clk_divider(clk, reset, newClk);
    
    input clk, reset;
    output newClk;
    
    reg [1:0] cnt = 0;
    reg toggleVal = 1;
    reg tempClk = 0;
    
    assign newClk = tempClk;
    
    always@(posedge clk)
    begin        
        if(reset)
        begin
            cnt <=0;
            tempClk <= 0;
        end
        else
        begin
            if(cnt < toggleVal)
                cnt = cnt + 1;
            else
            begin
                cnt <= 0;
                tempClk = ~tempClk;
            end
            
       end
             
    
    end
    

endmodule
