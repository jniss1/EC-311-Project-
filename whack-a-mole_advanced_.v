`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/21/2024 05:26:23 PM
// Design Name: 
// Module Name: mole_tb
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


module mole_advanced_tb(
    );
    
    // Variables
    reg clk;
    reg reset;
    
    reg button; 
    reg button2;
    reg button3;
    reg button4;
    
//    wire [32:0] randnum;
//    wire [32:0] randnum2;
//    wire [32:0] randnum3;
//    wire [32:0] randnum4;
    
    wire mole;
    wire mole2;
    wire mole3;
    wire mole4;
    
    wire [6:0] score;
    wire [1:0] lives;
    wire [2:0] state;
    
//    rng RNG(clk, reset, randnum);
//    rng RNG2(clk, reset, randnum2);
//    rng RNG3(clk, reset, randnum3);
//    rng RNG4(clk, reset, randnum4);
    
//    whack_a_mole_advanced DEBWAM(clk, reset, button, button2, button3, button4, mole, mole2, mole3, mole4, randnum, randnum2, randnum3, randnum4, score, lives, state);
    
      whack_a_mole_advanced DEBWAM(clk, reset, button, button2, button3, button4, mole, mole2, mole3, mole4, score, lives, state);
    
   
    
   
    
    // Making a clk:
    always #5 clk = ~ clk;
    
    // Initial block for stimulus
    initial begin
        // Initilize variables
        clk = 0;
        reset = 0;
        button = 0;
        button2 = 0;
        button3 = 0;
        button4 = 0;
        // Apply reset
        reset = 1; #10;
        reset = 0; #10;
        // Test the IDLE state
        button = 1; #20;
        // Simulate gameplay state
        button = 0; #100; // Wait for mole to appear
        button = 1; #10;  // Hit mole
        button = 0; #50;
        // Test life decrement
        button = 1; #10; // Press to continue
        // Test ENDSCREEN state (when lives = 0)
        button = 0; #20; // Wait for end state to activate
        button = 1; #10;  // Press button to go back to IDLE state
        
        #50
        button = 0; #60;
        button2 = 1;#10;
        button2 = 0;#100;
        button3 = 1;#10;
        button3 = 0;#100;
        button4 = 1;#10;
        button4 = 0;#100;
        button = 0; #60;
        button2 = 1;#10;
        button2 = 0;#100;
        button3 = 1;#10;
        button3 = 0;#100;
        button4 = 1;#10;
        button4 = 0;#100;
        button = 0; #60;
        button2 = 1;#10;
        button2 = 0;#100;
        button3 = 1;#10;
        button3 = 0;#100;
        button4 = 1;#10;
        button4 = 0;#100;
//        button2 = 1;#10;
//        button2 = 0;#10;
        button = 1; #50;
//        button = 0; #200;
//        button = 1; #200000;
        // Finish Simulation
        $finish;
    end
endmodule













