# FPGA BASED GAME (DINO GAME)

This project is based on the offline game created by the developers working on Google Chrome. They found that users often get frustated when the internet isn't working. They decided to make a small time killing game for users to keep them occupied before the internet connection resume. The idea of the game is that a dinosaur is made to run on the given surface on screen and we have to clear the hurdles either by passing them through jumping or ducking. The game continues till there is establishment of the internet connection. Also there is a score board provided at the top right corner of the screen which shows the score of the individual playing game. Hence from there a thought arises to implement this type of game using the Field Programmable Gate Array(FPGA).


   ## Working Principle
In this project we have generated a block of defined pixel, which is made to jump over the obstacles which is also of defined pixels and are placed on the way of the block. The block is made to run continuously on the screen and made to jump over the obstacles. If the block passes the hurdle the block continues to run and further continue to increase the points on the digits display placed on the top right corner of the screen, if the block collides with the hurdle then the block stops to run which results to stop in the points display and hence the game stops and made to reset again in order to play further.

## Concept of VGA Monitor
The VGA Monitor display is defined into 800x525 pixels. The display areea id defined into 640x480 pixels. In this display area of given pixels the whole game is to be displayed on the VGA monitor. These pixels are generated with the help of H-Sync & V-Sync. H-Sync is the horizontal representation of pixels whereas V-Sync is the vertical representation of pixels followed by the completion of one row of H-Sync pulse. Since the pixels move on the display in Left-Right direction row by row , when the first row completes thw given pixels (i.e.640 pixels) the value of V-Sync increases. These H-Sync & V-Sync pulses are generated in the order of the pixels.

The representation of H-Sync and V-Sync is given below:
![](http://www.johnloomis.org/altera/DE2/vga_timing.jpg)



The Actual use of Pixels:
![](https://www.digikey.com/eewiki/download/attachments/15925278/signal_timing_diagram.jpg?version=1&modificationDate=1368216804290&api=v2)

**NOTE** : 
*1. Screen Refresh Rate is 60Hz.

  2. Pixel frequency is 25Mhz.*

**NOTE :** These values are for Horizontal frame.

* The H-Sync is created upto 640 count. 
* The value for which Sync Pulse is low is 3.8Us(micro seconds) or 96 pixels.
* The value for which Back Porch is high is 1.9Us(micro seconds) or 48 pixels.
* The value for which Visible Area is high is 25.4Us(micro seconds) or 640 pixels.
* The value for which Front Porch is high is 0.63Us(micro seconds) or 16 pixels.

**NOTE :** These va;ues are for Vertical frame.
* The V-Sync Counter is created upto 480 count. 
* The value for which Sync Pulse is low is 0.06Us(micro seconds) or 2 lines.
* The value for which Back Porch is high is 1.04Us(micro seconds) or 33 lines.
* The value for which Visible Area is high is 15.25Us(micro seconds) or 480 lines.
* The value for which Front Porch is high is 0.31Us(micro seconds) or 10 lines.

## Keywords Used in the Code
* clk =  Internal Clock (50Mhz)
* clk_25 = 25MHz Clock
* clk_60 = 60Hz Clock
* clk_div = Clock Divisions
* clk_div_1s = Clock Divisions for 1 second 
* CounterX = Horizontal Counter
* CounterY = Vertical Counter
* CounterXmaxed = Maximum Value of Counter
* CounterYmaxed = Maximum Value of Counter
* rst = reset (active low)
* kb_clk = keyboard clock 
* kb_data = keyboard data
* inDisplayArea = Display area (640x480 pixels)
* obstacle_x1 = Obstacle's x1 co-ordinate
* obstacle_x2 = Obstacle's x2 co-ordinate
* obstacle_y1 = Obstacle's y1 co-ordinate
* obstacle_y2 = Obstacle's y2 co-ordinate
* x1 = Block's x1 co-ordinate
* x2 = Block's x2 co-ordinate
* y1 = Block's y1 co-ordinate
* y2 = Block's y2 co-ordinate
* int_count = Initial Count
* addr =  first address of the character to be displayed
* addr_count = Address Count
* location1 = Location of First digit for score
* pos_X = X co-ordinate of first digit for score
* pos_Y = Y co-ordinate of first digit for score
* RED_GREEN_BLUE = Value for Colour to be displayed
* shift_X = Value by which obstacle is moving in X direction
* shift_Y = Value by which obstacle is moving in Y direction


The game can be designed on any Monitor but I would suggest you to use the old Monitor to protect it from any damage. 
Hey guys thanks for giving time to watch my creation. I hereby attach links of all the files related to this project.

////////////////////////////////////////////////////////////////////////////////////////////////

MAIN PROGRAM  [https://github.com/akshayd2998/DINO-GAME/blob/master/Verilog2.v]

Counter for Score [https://github.com/akshayd2998/DINO-GAME/blob/master/NUM_COUNT.v]

KEYBOARD files Instantiation [https://github.com/akshayd2998/DINO-GAME/blob/master/KEYBOARD_GAME.v]

PS2 KEYBOARD MODULE [https://github.com/akshayd2998/DINO-GAME/blob/master/PS2_KEYBOARD.v]

ASCII values for characters  [https://github.com/akshayd2998/DINO-GAME/blob/master/ascii_values.v]
