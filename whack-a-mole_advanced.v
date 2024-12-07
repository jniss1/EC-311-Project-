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


module whack_a_mole_advanced(
    input clk,
    input reset,
    input button,              // Debounced button input (fed from exernal module)
    input button2,
    input button3,
    input button4,
    //input randnum            // NOTE: Need to add apropriate reg size. Should interface with RNG module which should ensure each is different
    //input randnum2
    //input randum3
    //input randnum4
    output reg mole,           // Mole visibility (1 for mole shown, 0 for hidden)
    output reg mole2,
    output reg mole3,
    output reg mole4,
    output reg [6:0] score,    // Player score
    output reg [1:0] lives,    // Player lives (3 max) -- binary
    output reg [2:0] state     // Game state (IDLE, GAMEPLAY, END_SCREEN)
    
);

// Defining States 
reg IDLE = 3'b000;
reg GAMEPLAY = 3'b001;
reg WIN_SCREEN = 3'b100;
//reg END_SCREEN = 3'b111;

// Timer definitions
reg [28:0] mole_timer;        // Random timer for mole to appear (1-3 seconds) [DOULE CHECK if that many clk cycles corresponds to the second timings]
reg [28:0] mole_timer2;
reg [28:0] mole_timer3;
reg [28:0] mole_timer4;

reg [28:0] randnum;
reg [28:0] randnum2;
reg [28:0] randnum3;
reg [28:0] randnum4;


reg [28:0] hammer_timer;     // Time for hammer availability
reg button_prev;             // Previous button state to detect rising edge
reg button_prev2;
reg button_prev3;
reg button_prev4;

reg [28:0] blink_counter;   // Counter for blinking mole in the end state
reg [28:0] blink_counter2;
reg [28:0] blink_counter3;
reg [28:0] blink_counter4;

reg [28:0] reduced_speed;   
reg [7:0] high_score;       


//Button Tracking
always @(posedge clk or posedge reset) begin
    if (reset) begin
        button_prev <= 0;  // Initialize button_prev on reset
        button_prev2 <= 0;
        button_prev3 <= 0;
        button_prev4 <= 0;
        
//        randnum <= $urandom_range(100000000, 300000000);
//        randnum2 <= $urandom_range(100000000, 300000000);
//        randnum3 <= $urandom_range(100000000, 300000000);
//        randnum4 <= $urandom_range(100000000, 300000000);
        
//        randnum <= $urandom_range(10, 30);
//        randnum2 <= $urandom_range(10, 30);
//        randnum3 <= $urandom_range(10, 30);
//        randnum4 <= $urandom_range(10, 30);

        randnum <= 100_000_001;
        randnum2 <= 100_000_002;
        randnum3 <= 100_000_003;
        randnum4 <= 100_000_000;
        
    end else begin
        button_prev <= button;  // Update button_prev on every clock cycle
        button_prev2 <= button2;
        button_prev3 <= button3;
        button_prev4 <= button4;
        
//        randnum <= $urandom_range(100000000, 300000000);
//        randnum2 <= $urandom_range(100000000, 300000000);
//        randnum3 <= $urandom_range(100000000, 300000000);
//        randnum4 <= $urandom_range(100000000, 300000000);
        
//        randnum <= $urandom_range(10, 30);
//        randnum2 <= $urandom_range(10, 30);
//        randnum3 <= $urandom_range(10, 30);
//        randnum4 <= $urandom_range(10, 30);

        randnum <= 100_000_001;
        randnum2 <= 100_000_002;
        randnum3 <= 100_000_003;
        randnum4 <= 100_000_000;
    end
end



// Game logic state machine
always @(negedge clk or posedge reset) begin
    if (reset) begin
    // Reset all variable
        state <= IDLE;
        score <= 7'b0000000;    // begin with 0 score
        lives <= 2'b00;    // Starting with 3 lives
        
        mole <= 0;
        mole2 <= 0;
        mole3 <= 0;
        mole4 <= 0;
        
        mole_timer <= 0;
        mole_timer2 <= 0;
        mole_timer3 <= 0;
        mole_timer4 <= 0;
        
        hammer_timer <= 0;
        
        blink_counter <= 0;  // Used for blinking LED in END_SCREEN
        blink_counter2 <= 0;
        blink_counter3 <= 0;
        blink_counter4 <= 0;
        
        button_prev <= 0;
        button_prev2 <= 0;
        button_prev3 <= 0;
        button_prev4 <= 0;
        high_score <= 0;
    end else begin
        case(state)
            IDLE: begin
                reduced_speed <= 24_900_000; // Mote: this value corresponds to about 0.084 seconds, so after getting to level 90 reducing by this amount every time, reation timer is ~0.25 sec, or the average human reaction time
                mole <= 0;
                mole2 <= 0;
                mole3 <= 0;
                mole4 <= 0;                         // turn mole LED off
                
                mole_timer <= 0;                    // Reset mole timer to 0 in IDLE state
                mole_timer2 <= 0;
                mole_timer3 <= 0;
                mole_timer4 <= 0;
                
                blink_counter <= 0;  // Used for blinking LED in END_SCREEN
                blink_counter2 <= 0;
                blink_counter3 <= 0;
                blink_counter4 <= 0;
        
                // Detect rising edge of the button, for any button, on press goto GAMPLAY on next clk cycle
                if ((button && !button_prev) || (button2 && !button_prev2) || (button3 && !button_prev3) || (button4 && !button_prev4)) begin   
                    // Initilizing gameplay variables
                    score <= 7'b0000000;
                    lives <= 2'b11;
                    mole_timer <= randnum;
                    mole_timer2 <= randnum2;        
                    mole_timer3 <= randnum3;
                    mole_timer4 <= randnum4;
                    hammer_timer <=  300_000_000;                 // 1 second for hammer timer
                    state <= GAMEPLAY;
                end
            end
            
            GAMEPLAY: begin 
                // First, we will check if the game is over:
                if (lives == 0) begin
                        //state <= END_SCREEN;  
                        //state <= IDLE;
                        state <= 3'b111; // It seems that this is the only transition condition that triggers
                end 
                // Then, we will check if the game is won:
                if (score == 64) begin
                        state <= 3'b100;
                end
                
                // Next, we decrement the new mole timer, and check if it has hit 0:
                
                //else if (mole_timer > 0 || mole_timer2 > 0 || mole_timer3 > 0 || mole_timer4 > 0) begin
                else if (mole_timer > 0) begin
                    mole_timer = mole_timer - 1;
                    mole_timer2 = mole_timer2 - 1;
                    mole_timer3 = mole_timer3 - 1;
                    mole_timer4 = mole_timer4 - 1;
                    
                    // if mole timer has hit zero, we turn mole on, turn off other timers, and trigger the start of hammer logic
                    // MOLE 1
                    if (mole_timer == 0) begin
                        mole <= 1;          // If 0, turn on the mole 
                        mole_timer2 <= 0;   // reset other timers
                        mole_timer3 <= 0;
                        mole_timer4 <= 0;
                    end
                    // We do the same check for the rest of the timers:
                    // We use else if's since we only want this triggering for the first, then to skip this code until next gameplay cycle
                    // MOLE 2
                    else if (mole_timer2 == 0) begin
                        mole2 <= 1;          // If 0, turn on the mole 
                        mole_timer <= 0;   // reset other timers
                        mole_timer3 <= 0;
                        mole_timer4 <= 0;
                    end
                    // MOLE 3
                    else if (mole_timer3 == 0) begin
                        mole3 <= 1;          // If 0, turn on the mole 
                        mole_timer2 <= 0;   // reset other timers
                        mole_timer <= 0;
                        mole_timer4 <= 0;
                    end
                    // MOLE 4
                    else if (mole_timer4 == 0) begin
                        mole4 <= 1;          // If 0, turn on the mole 
                        mole_timer2 <= 0;    // reset other timers
                        mole_timer3 <= 0;
                        mole_timer <= 0;
                    end
                    
                end
                
                // Hammer timer logic starts only when one of the mole turns on (ie mole timer == 0 and prev case does not trigger):
                else if (hammer_timer > 0 && (mole == 1 || mole2==1 || mole3 == 1 || mole4 == 1)) begin
                    // decreases hammer timer every clk cycle until 0:
                    hammer_timer <= hammer_timer - 1; 
                    
                   // Multi-mole version: 2 cases, either correct button correct mole or not
                   // Case 1: correct button
                   if ((button && !button_prev && mole == 1) || (button2 && !button_prev2 && mole2 == 1) || (button3 && !button_prev3 && mole3 == 1) || (button4 && !button_prev4 && mole4 == 1)) begin
                        score <= score + 1;
                        mole <= 0;
                        mole2 <= 0;
                        mole3 <= 0;
                        mole4 <= 0;
                        // NOTE: currently hardcoded for debugging, but just need to change it to equal equivilanet randnum# input
                        mole_timer <= randnum;
                        mole_timer2 <= randnum2;        
                        mole_timer3 <= randnum3;
                        mole_timer4 <= randnum4;
                        hammer_timer <= 300_000_000;
                        
                        // DYNAMIC TIMER INCREASE
                        if (hammer_timer > 250_000_000) begin // can mess with this value and that of reduced_speed
                            if ((score >= 8) && (score < 16)) begin
                                    hammer_timer <= hammer_timer - reduced_speed;
                            end else if ((score >= 16) && (score < 24)) begin 
                                    hammer_timer <= hammer_timer - reduced_speed;
                                    
                            end else if ((score >= 24) && (score < 32)) begin
                                    hammer_timer <= hammer_timer - reduced_speed;
                                    
                            end else if ((score >= 32) && (score < 40)) begin
                                    hammer_timer <= hammer_timer - reduced_speed;
                                    
                            end else if ((score >= 40) && (score < 48)) begin
                                    hammer_timer <= hammer_timer - reduced_speed;
                                    
                            end else if ((score >= 48) && (score < 56)) begin
                                    hammer_timer <= hammer_timer - reduced_speed;
                                    
                            end else if ((score >= 56) && (score < 58)) begin
                                    hammer_timer <= hammer_timer - reduced_speed;
                                    
                            end else if ((score >= 58) && (score < 60)) begin
                                    hammer_timer <= hammer_timer - reduced_speed;
                                    
                            end else if (score >= 60) begin
                                    hammer_timer <= hammer_timer - reduced_speed;
                            end         
                       end
                   end
                   //Case 2: Wrong button  
                   else if ((mole == 1 && (button2 || button3 || button4)) || (mole2 == 1 && (button || button3 || button4)) || (mole3 == 1 && (button || button2 || button4)) || (mole4 == 1 && (button || button2 || button3))) begin
                            //score <= score + 1;
                            lives <= lives - 1;  
                            mole <= 0;
                            mole2 <= 0;
                            mole3 <= 0;
                            mole4 <= 0;
                            if (lives == 0) begin
                                //state <= END_SCREEN;  // Go to end screen if no lives left
                                //state <= IDLE;
                                state <= 3'b111;
                            end 
                        
                            else begin
                                //NOTE: currently hardcoded for debugging, but just need to change it to equal equivilanet randnum# input
                                mole_timer <= randnum;
                                mole_timer2 <= randnum2;        
                                mole_timer3 <= randnum3;
                                mole_timer4 <= randnum4; 
                                hammer_timer <=  300_000_000;                 
                            end
                   end
                end 
                
                // We reach here when varaible have yet to reset and missed chance to hit button while timer was on (both timers are now 0)
                // Here, we handle the lose a life case:
                if (hammer_timer == 0) begin
                    // Update lives and reset mole to zero
                    lives <= lives - 1;  
                    mole <= 0;
                    mole2 <= 0;
                    mole3 <= 0;
                    mole4 <= 0;
                    
                    // if this triggers, go to END SCREEN the next clk cycle (the other variable resets will happen later)
                    if (lives == 0) begin
                        //state <= END_SCREEN;  // Go to end screen if no lives left
                        //state <= IDLE;
                        state <= 3'b111;
                    end 
                    
                    // If that did not trigger, then there are still lives remaining. Reset the timers to begin gameplay loop all over again
                    else begin
                        mole_timer <= randnum;
                        mole_timer2 <= randnum2;        
                        mole_timer3 <= randnum3;
                        mole_timer4 <= randnum4;
                        hammer_timer <=  300_000_000;                 
                    end
                end
            end
            
            3'b111: begin
                
                // Dancing Moles
                
                blink_counter <= blink_counter + 1;
                blink_counter2 <= blink_counter2 + 1;
                blink_counter3 <= blink_counter3 + 1;
                blink_counter4 <= blink_counter4 + 1;
                
                if (blink_counter == 100_000_000) begin  // Toggle mole every second (assuming 100 MHz clock)
                    mole <= ~mole;                       // You can change endscreen dance pattern of the moles by adding more blink counters or modifying the value
                    blink_counter <= 0;                  // reset counter for next time
                end
                if (blink_counter2 == 200_000_000) begin  
                    mole2 <= ~mole2;                       
                    blink_counter2 <= 0;                 
                end
                if (blink_counter3 == 300_000_000) begin  
                    mole3 <= ~mole3;                       
                    blink_counter3 <= 0;                  
                end
                if (blink_counter4 == 400_000_000) begin  
                    mole4 <= ~mole4;                       
                    blink_counter4 <= 0;                 
                end
                
                // High Score Code
                if (score > high_score) begin
                    high_score <= score;                // Displays the high score if you lost
                end else begin                          // By adding more score variables as output signals instead of reg, you can display a list in the end screen
                    score <= high_score;
                end
                
                if ((button && !button_prev) || (button2 && !button_prev2) || (button3 && !button_prev3) || (button4 && !button_prev4)) begin    
                    state <= 3'b000;  // Reset to IDLE state next clk cycle
                    
                    // Some of the assignemnts are redudent since they happen again in the idle state, just saying. However, if you later want to trim it down, trim the ones in the IDLE state instead
                    score <= 7'b0000000;
                    lives <= 2'b11; // Starting with 3 lives
                    mole <= 0;
                    mole_timer <= 0;
                    hammer_timer <= 0;
                    blink_counter <= 0;
                end
            end
            
            WIN_SCREEN: begin
                
                // This is delibritley left empty; User must use the reset since they got the highest score
                // If time permits, decorate with nice animations.             
                
            end
            
       endcase
    end
end

endmodule
