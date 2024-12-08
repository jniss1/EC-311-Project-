module Debounced_WAM_advanced(
    input clk,
    input reset,
    input button,              // Debounced button input (fed from exernal module)
    input button2,              
    input button3,              
    input button4,              
    
    output wire mole, 
    output wire mole2, 
    output wire mole3, 
    output wire mole4,           // Mole visibility (1 for mole shown, 0 for hidden)
    
    output wire [6:0] score,    // Player score
    output wire [1:0] lives,    // Player lives
    output wire [2:0] state     // Game state (IDLE, GAMEPLAY, END_SCREEN)
    );
    
    wire clean;
    wire clean2;
    wire clean3;
    wire clean4;
    
    debouncer DEB(clk, button, clean);
    debouncer DEB2(clk, button2, clean2);
    debouncer DEB3(clk, button3, clean3);
    debouncer DEB4(clk, button4, clean4);
    
    whack_a_mole_advanced DEBWAM(clk, reset, clean, clean2, clean3, clean4, mole, mole2, mole3, mole4, score, lives, state);
endmodule
