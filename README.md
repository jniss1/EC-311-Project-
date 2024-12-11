# EC-311-Project: FPGA Whack-a-Mole

![alt text](https://github.com/jniss1/EC-311-Project-/blob/a3ef40bc5f97d0d1c561caa06e85e6b59d46cd90/Idea.GIF)
_____________________________________________________
Team Members: Arielle, Mirclea, Jacob, Mingshan, Kofi

Link to demo video: https://drive.google.com/file/d/1cnEWsAt0QOOGxtiyAdJfWRkzOz60V5_h/view?usp=sharing

## Project Overview: 
In this project, we implemented whack-a-mole on the Nexys A7 FPGA. The final project uses the VGA cable to display the game logic on the monitor and uses both buttons and tilt controls as input. Upon a button click or tilt input, the game launches into the game loop where you have 3 lives and score points by giving the correct input to the given mole on the screen. If you are too slow, or give the wrong input, you loosea a life. The goal is to beat the game by getting 64 points, where every 8 points added to the score speeds up the game. The game saves the current highest score and displays it in the end state. Pressing the reset button resets the game and high score. 

## How to run it:
To run the game, download the bitstream onto the FPGA (PLS UPLOAD!!!!)
If bitstream is still not yet up, go into the working code folder, and the final version uses the "with_acc.xdc" as the constraint, and "with_accelerometer_final.v" as the design source.

## Code Overview:
The "Code" folder contains all of the code we wrote prior to the final version. THis includeds multiple versions of the game logic at various working complexities, and the same for the VGA and accelorometer code. The Test Bench and Contraints folders hold the corresponding files for the modules in the code folder. Generally, the code can be split into those for the simple version of the game and the advanced version, where those for the latter have the word "advanced" included in their titles. 

There is also the Working Code folder which houses all of the code needed to run the final working version of our game as shown in the demo. This includes the follwing modules:
- with_acc.xdc:             Constrain file for running the demo
- with_acc_final:           Top module for running the demo
- spi_master:               Spi controller for sensing the tilt controls
- button_control:           Converts tilts into button inputs
- iclk_gen:                 Generates clk
- vga_controller:           controls the vga signals
- vga_top:                  instatiates the vga code for actual use
- debouncer:                Debounces the button input for reset
- whack_a_mole_Advanced:    Handles the game logic

Outside the folders is the code for the sprite jpeg to memory converter that we would have used to display our sprites (as seen in Idea.gif) as the green boxes for the vga signals. 

## Additional Notes:
Mirclea wrote the accelerometer modules, Arielle wrote the the VGA modules, Jacob wrote the game logic modules, Mingshan wrote the RNG module and matlab image converter, and Kofi connected the RNG and gameplay modules together.


## Some sources
- accelerometer tutorial: https://github.com/FPGADude/Digital-Design/tree/main/FPGA%20Projects/Nexys%20A7%203-Axis%20Accelerometer%20SPI


