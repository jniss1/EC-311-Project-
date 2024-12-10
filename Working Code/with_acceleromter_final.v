module with_acceleromter_final(
    input clk,                      // 100 MHz clk
    input reset,            
    
    // Mole visibility (1 for mole shown, 0 for hidden)
    output wire mole, 
    output wire mole2, 
    output wire mole3, 
    output wire mole4,              
    
    // In-Game Stats
    output wire [6:0] score,        // Player score
    output wire [1:0] lives,        // Player lives
    output wire [2:0] state,        // Game state (IDLE, GAMEPLAY, END_SCREEN)
    
    // Accelerometer SPI Signals
    input ACL_MISO,                 // master in
    output ACL_MOSI,                // master out
    output ACL_SCLK,                // spi sclk
    output ACL_CSN,                 // spi ~chip select
    
    //VGA Outputs
    output [3:0] vga_r,         
    output [3:0] vga_g,         
    output [3:0] vga_b,         
    output h_sync,             
    output v_sync
    );
    
    // Slowed Clocks
    wire clk_4MHz;      //For Accelerometer
    wire clk_25MHz;     //For VGA Output
    
    
    // Button Signals
    wire button4;
    wire button2;
    wire button3;
    wire button;
    wire clean;
    wire clean2;
    wire clean3;
    wire clean4;
    
    
    // Wires for accelerometer data
    wire [14:0] acl_data;
    
    
    
    
    
    ///// Clock Generators /////
    
        
    // 4 MHz clock for accelerometer
    iclk_gen clock_generation(
        .CLK100MHZ(clk),
        .clk_4MHz(clk_4MHz)
    );
    
//    // 25 MHz clock for VGA
//    clk_divider clk_div_25MHz(
//        .clk(clk),
//        .reset(reset),
//        .newClk(clk_25MHz)
//    );
    
    
    
    
    
    ///// Accelerometer Interface /////
    spi_master master(
        .iclk(clk_4MHz),
        .miso(ACL_MISO),
        .sclk(ACL_SCLK),
        .mosi(ACL_MOSI),
        .cs(ACL_CSN),
        .acl_data(acl_data)
    );
    
   
   ///// Button Control ///// 
    button_control button_control(
        .acl_data(acl_data), 
        .right_button(button4),
        .left_button(button2),
        .up_button(button3),
        .bottom_button(button)
    );
    
    
    ///// Debouncer Instaces /////
    
       
    debouncer DEB(clk, button, clean);
    debouncer DEB2(clk, button2, clean2);
    debouncer DEB3(clk, button3, clean3);
    debouncer DEB4(clk, button4, clean4);


    ////// Main Game Logic /////
    
    whack_a_mole_advanced game_logic(
        .clk(clk),
        .reset(reset),
        .button(clean),
        .button2(clean2),
        .button3(clean3),
        .button4(clean4),
        .mole(mole),
        .mole2(mole2),
        .mole3(mole3),
        .mole4(mole4),
        .score(score),
        .lives(lives),
        .state(state)
    );

    
    ///// VGA Output /////    
    vga_top VGA(
        .clk(clk),       // 25 MHz clock for VGA
        .reset(reset),
        .mole(mole),
        .mole2(mole2),
        .mole3(mole3),
        .mole4(mole4),
        .vga_r(vga_r),
        .vga_g(vga_g),
        .vga_b(vga_b),
        .h_sync(h_sync),
        .v_sync(v_sync)
    );
endmodule
