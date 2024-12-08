# EC-311-Project: FPGA Whack-a-Mole

To group memebers: Here is a link to my (Jacob's) video explaining code (6:30 min): https://drive.google.com/file/d/1JrSTHwWFClQChDPSzISPSwKdR4D43Did/view?usp=sharing

_____________________________________________________
Team Members: Arielle, Mirclea, Jacob, Mingshan, Kofi

Link to demo video: (TODO)

#Project Overview: 
In this project, we implemented whack-a-mole on the Nexys A7 FPGA. The final project uses the VGA cable to display the game logic on the monitor and uses both buttons and tilt controls as input. Upon a button click or tilt input, the game launches into the game loop where you have 3 lives and score points by giving the correct input to the given mole on the screen. If you are too slow, or give the wrong input, you loosea a life. The goal is to beat the game by getting 64 points, where every 4 points added to the score speeds up the game. The game saves the current highest score and displays it in the end state. Pressing the reset button resets the game and high score. (Clarify if this is outdated!!)

##How to run it:
To run the game, download the bitstream onto the FPGA (TODO!!!!)

##Code Overview:
Generally, the code can be split into those for the simple version of the game and the advanced version, where those for the latter have the word "advanced" included in their titles...(add more descriptions)


##Additional Notes:
Mirclea wrote the accelerometer modules, Arielle wrote the the VGA modules, Jacob wrote the game logic modules, Mingshan wrote the RNG module and matlab image converter, and Kofi wrote... (please update this so it is accurate to your work!!)
