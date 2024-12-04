`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/21/2024 03:54:39 PM
// Design Name: 
// Module Name: whack_a_mole
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


module whack_a_mole(
    input clk,
    input reset,
    input button,              // Debounced button input (fed from exernal module)
    //input button2,
    //input button3,
    //input button4,
    //input randnum            // NOTE: Need to add apropriate reg size. SHould interface with RNG module which should ensure each is different
    //input randnum2
    //input randum3
    //input randnum4
    output reg mole,           // Mole visibility (1 for mole shown, 0 for hidden)
    //output reg mole2,
    //output reg mole3,
    //output reg mole4,
    output reg [3:0] score,    // Player score
    output reg [3:0] lives,    // Player lives
    output reg [2:0] state     // Game state (IDLE, GAMEPLAY, END_SCREEN)
);

// Defining States 
reg IDLE = 3'b000;
reg GAMEPLAY = 3'b001;
reg END_SCREEN = 3'b010;

// Timer definitions
reg [7:0] mole_timer;        // Random timer for mole to appear (1-3 seconds) [DOULE CHECK if that many clk cycles corresponds to the second timings]
//reg [7:0] mole_timer2;
//reg [7:0] mole_timer3;
//reg [7:0] mole_timer4;
        
reg [7:0] hammer_timer;      // Time for hammer availability
reg button_prev;             // Previous button state to detect rising edge
//reg button_prev2;
//reg button_prev3;
//reg button_prev4;
//reg mistake_flag;          // used to signal wrong button pressed for active mole
reg [7:0] blink_counter;     // Counter for blinking in the end state
reg [7:0] random_num;        // CAN DELETE Random number for mole_timer

// Note: I don't think the random number generator detailed below is working rn; As a task, turn it into extern module as input


// Reset Logic for timers, button, and RNG
always @(posedge clk or posedge reset) begin
    if (reset) begin
        mole_timer <= 0;        // Resetting the timer
        //mole_timer2 <= 0;
        //mole_timer3 <= 0;
        //mole_timer4 <= 0;
        hammer_timer <= 0;      // Resetting the hammer timer
        button_prev <= 0;       // Initialize button_prev
        //button_prev2 <= 0;
        //button_prev3 <= 0;
        //button_prev4 <= 0;
        //mistake_flag <= 0;
        random_num <= 8'd0;     // CAN DELETE Random number
        state <= 3'b000;
    end else begin
        // CLK updates for random num and button prev; timer logics will be handles in game loop for clarity.
        button_prev <= button;          // Update button_prev on every clock cycle; helps detect rising edge (button = 1, button prev = 0, every other combo is not it)
        //button_prev2 <= button2;
        //button_prev3 <= button3;
        //button_prev4 <= button4;
        random_num <= random_num + 1;   // CAN DELETE change random number
    end
end


// Game logic state machine
always @(posedge clk or posedge reset) begin
    if (reset) begin
    // Reset all variable
        state <= IDLE;
        score <= 4'b0000;    // begin with 0 score
        lives <= 4'b0000;    // Starting with 3 lives
        mole <= 0;
        //mole2 <= 0;
        //mole3 <= 0;
        //mole4 <= 0;
        mole_timer <= 0;
        //mole_timer2 <= 0;
        //mole_timer3 <= 0;
        //mole_timer4 <= 0;
        //mistake_flag <= 0;
        hammer_timer <= 0;
        blink_counter <= 0;  // Used for blinking LED in END_SCREEN
        button_prev = 0;
        //button_prev2 <= 0;
        //button_prev3 <= 0;
        //button_prev4 <= 0;
    end else begin
        case(state)
            IDLE: begin
                mole <= 0;                          // turn mole LED off
                mole_timer <= 0;                    // Reset mole timer to 0 in IDLE state
                //mole_timer2 <= 0;
                //mole_timer3 <= 0;
                //mole_timer4 <= 0;
                //mistake_flag <= 0;
                if (button && !button_prev) begin   // Detect rising edge of the button, on press goto GAMPLAY on next clk cycle
                // Multi-mole version, detects on any button press
                //if (button && !button_prev || button2 && !button_prev2 || button3 && !button_prev3 || button4 && !button_prev4) begin
                    state <= GAMEPLAY;
                    // Initilizing gameplay variables
                    score <= 4'b0000;
                    lives <= 4'b0011;
                    // NOTE: currently hardcoded for debugging, but just need to change it to equal equivilanet randnum# input
                    mole_timer <= 300_000_000;
                    //mole_timer2 <= 300_000_001;        // Note that RNG should have contraint of outputting 4 DIFFERENT rand. nums to avoid issue of 2 timers running out at the same time
                    //mole_timer3 <= 300_000_002;
                    //mole_timer4 <= 300_000_003;
                    hammer_timer <=  300_000_000;                 // 1 second for hammer timer
                end
            end
            
            GAMEPLAY: begin 
                // First, we will check if the game is over:
                if (lives == 0) begin
                        state <= 3'b010;  // GLITCH: breaks when it says end screen Go to end screen if no lives left. IDK why...
                end 
                
                // Next, we decrement the new mole timer, and check if it has hit 0:
                // MOLE 1
                else if (mole_timer > 0) begin
                // multi-mole version, checks to make sure no other mole has gone off first:
                //else if (mole_timer > 0 && mole == 0 && mole2 == 0 && mole3 == 0 && mole4 == 0) begin 
                    mole_timer = mole_timer - 1;
                    
                    // if mole timer has hit zero, we turn mole on, triggering the start of hammer logic
                    if (mole_timer == 0) begin
                        mole <= 1;  // If 0, turn on the mole 
                    end
                end

                // Same checks for the other mole timers:
                    
                // MOLE 2
                //else if (mole_timer2 > 0 && mole == 0 && mole2 == 0 && mole3 == 0 && mole4 == 0) begin
                    //mole_timer2 = mole_timer2 - 1;
                    
                    
                    //if (mole_timer2 == 0) begin
                        //mole2 <= 1;  // If 0, turn on the mole 
                    //end
                //end
                    
                // MOLE 3
                //else if (mole_timer3 > 0 && mole == 0 && mole2 == 0 && mole3 == 0 && mole4 == 0) begin
                    //mole_timer3 = mole_timer3 - 1;
                    
                    
                    //if (mole_timer3 == 0) begin
                        //mole3 <= 1;  // If 0, turn on the mole 
                    //end
                //end
                    
                // MOLE 4
                //else if (mole_timer4 > 0 && mole == 0 && mole2 == 0 && mole3 == 0 && mole4 == 0) begin
                    //mole_timer4 = mole_timer2 - 1;
                    
                    
                    //if (mole_timer4 == 0) begin
                        //mole4 <= 1;  // If 0, turn on the mole 
                    //end
                //end

                    
                // Hammer timer logic starts only when mole turns on (ie mole timer = 0 and prev case does not trigger):
                else if (hammer_timer > 0 && mole == 1) begin
                // Multi-mole version (checks is any mole is on)
                //else if (hammer_timer > 0 && (mole == 1 || mole2==1 || mole3 == 1 || mole4 == 1)) begin
                    // decreases hammer timer every clk cycle until 0:
                    hammer_timer <= hammer_timer - 1; 
                    
                    // Check if user has pressed button while hammer timer is on only for rising edge (since holding does not count as a hit):
                    if (button && !button_prev) begin   
                        // If yes, get a point & reset mole & timer variables to restart the GAMEPLAY logic loop
                        score <= score + 1;      // Increment score on button press
                        mole <= 0;               // Turn mole off
                        mole_timer <= 300_000_000;  // Reset mole timer to another randome variable (AGAIN, Change to work with external module)
                        hammer_timer <=  300_000_000;  // Reset hammer timer
                    end 
                   // Multi-mole version: 2 cases, either correct button correct mole or not
                   // Case 1: correct button
                   //if ((button && !button_prev && mole == 1) || (button2 && !button_prev2 && mole2 == 1) || (button3 && !button_prev3 && mole3 == 1) || (button4 && !button_prev4 && mole4 == 1)) begin
                        //score <= score + 1;
                        //mole <= 0;
                        //mole2 <= 0;
                        //mole3 <= 0;
                        //mole4 <= 0;
                        // NOTE: currently hardcoded for debugging, but just need to change it to equal equivilanet randnum# input
                        //mole_timer <= 300_000_000;
                        //mole_timer2 <= 300_000_001;
                        //mole_timer3 <= 300_000_002;
                        //mole_timer4 <= 300_000_003;
                        
                        //hammer_timer <= 300_000_000;
                        // DYNAMIC TIMER INCREASE
                        //if (score > 10) begin
                                //hammer_timer <= hammer_timer - reduced_speed;
                                //if (score > 20) begin
                                        //hammer_timer <= hammer_timer - reduced_speed;
                                        //if (score > 30) begin
                                                //hammer_timer <= hammer_timer - reduced_speed;
                                                //if (score > 40) begin
                                                        //hammer_timer <= hammer_timer - reduced_speed;
                                                        //if (score > 50) begin
                                                                //hammer_timer <= hammer_timer - reduced_speed;
                                                                //if (score > 60) begin
                                                                        //hammer_timer <= hammer_timer - reduced_speed;
                                                                        //if (score > 70) begin
                                                                                //hammer_timer <= hammer_timer - reduced_speed;
                                                                                //if (score > 80) begin
                                                                                        //hammer_timer <= hammer_timer - reduced_speed;
                                                                                        //if (score > 90) begin
                                                                                                //hammer_timer <= hammer_timer - reduced_speed;
                                                                                        //end
                                                                                //end                                
                                                                        //end
                                                                //end
                                                        //end
                                                //end
                                        //end
                                //end
                        //end
                   //end
                   // Case 2: Wrong button  
                   //else begin
                            //lives <= lives - 1;  
                            //mole <= 0;
                            //mole2 <= 0;
                            //mole3 <= 0;
                            //mole4 <= 0;
                            //if (lives == 0) begin
                                //state <= END_SCREEN;  // Go to end screen if no lives left
                            //end 
                        
                            //else begin
                                // NOTE: currently hardcoded for debugging, but just need to change it to equal equivilanet randnum# input
                                //mole_timer <=  300_000_000;  
                                //mole_timer2 <= 300_000_001;  
                                //mole_timer3 <= 300_000_002;  
                                //mole_timer4 <= 300_000_003;  
                                //hammer_timer <=  300_000_000;                 
                            //end
                   //end
                end 
                
                // We reach here when varaible have yet to reset and missed chance to hit button while timer was on (both timers are now 0)
                // Here, we handle the lose a life case:
                else if (hammer_timer == 0) begin
                    // Update lives and reset mole to zero
                    lives <= lives - 1;  
                    mole <= 0;
                    //mole2 <= 0;
                    //mole3 <= 0;
                    //mole4 <= 0;
                    // if this triggers, goto END SCREEN the next clk cycle (the other variable resets will happen later)
                    if (lives == 0) begin
                        state <= END_SCREEN;  // Go to end screen if no lives left
                    end 
                    
                    // If that did not trigger, then there are still lives remaining. Reset the timers to begin gameplay loop all over again
                    else begin
                        // NOTE: currently hardcoded for debugging, but just need to change it to equal equivilanet randnum# input
                        mole_timer <=  300_000_000;  
                        //mole_timer2 <= 300_000_001;  
                        //mole_timer3 <= 300_000_002;  
                        //mole_timer4 <= 300_000_003;  
                        hammer_timer <=  300_000_000;                 
                    end
                end
            end
            
            3'b010: begin
                // Mole LED will blink every second until button is pressed
                /*blink_counter <= blink_counter + 1;
                if (blink_counter == 8'd25000000) begin  // Toggle mole every second (assuming 100 MHz clock)
                    mole <= ~mole;                       // Toggle mole visibility
                    blink_counter <= 0;                  // reset counter for next time
                end*/
                
                // Waits in this state until a rising edge button press is detected, then sends to IDLE state.
                if (button && !button_prev) begin  
                    //state <= 3'b000;  // Reset to IDLE state next clk cycle
                    // Some of the assignemnts are redudent since they happen again in the idle state, just saying. However, if you later want to trim it down, trim the ones in the IDLE state instead
                    score <= 4'b0000;
                    lives <= 4'b0011; // Starting with 3 lives
                    mole <= 0;
                    mole_timer <= 0;
                    hammer_timer <= 0;
                    blink_counter <= 0;
                    state <= 3'b000;  // Reset to IDLE state next clk cycle
                end
            end
        endcase
    end
end

endmodule

