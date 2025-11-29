# Assembly-Tic-Tac-Toe-Program-
This LC-3 program allows two human players to play Tic-Tac-Toe. The grid is drawn on the graphics display, and players enter moves via the keyboard.

# Tic-Tac-Toe Program (LC-3 Assembly)
This program implements a simple two-player Tic-Tac-Toe game using LC-3 assembly and the PennSim graphics display. The game draws a 3x3 board, accepts user moves, and displays X and O markers until a player quits.

## How to Assemble and Run
Before running your main program, assemble the files that contain the block data for X and O, then load everything into PennSim:

reset
ld p3os.obj
as blockx.asm
ld blockx.obj
as blocko.asm
ld blocko.obj
as tac.asm
ld tac.obj
set pc x3000

## Program Overview
The program begins execution at address x3000.

### 1. Clear the Graphics Display
All pixels are set to black by writing zeros across the entire display.  
A dedicated subroutine should be used to perform the clearing.

### 2. Draw the Board
The program draws two vertical and two horizontal white lines:

- Vertical lines at (30,0) and (60,0)
- Horizontal lines at (0,30) and (0,60)

This forms nine blocks, numbered left-to-right and top-to-bottom:

0 1 2  
3 4 5  
6 7 8

### 3. Game Loop
Players alternate starting with X.

For each turn:
1. Display prompt (“X move: ” or “O move: ”)
2. Call GETMOV to read user input
3. Validate and process the move
4. Draw the X or O block if the square is free
5. Repeat until user enters 'q'

### Quitting the Game
Typing “q” followed by Return causes GETMOV to return 9, and the program halts.

---

## Required Subroutines

### GETMOV
Reads an entire user command terminated with Return (ASCII 0xA).  
Rules:
- Valid inputs: characters '0'–'8' or 'q'
- Return values:
  - 0–8: valid move number
  - 9: user entered 'q'
  - −1: illegal command  
- Must echo all typed characters (including Return)
- Must ignore extra characters until Return is seen

### DRAWH
Draws a horizontal white line of length 90 pixels.  
Input:
- R0 = y-coordinate (row)

### DRAWV
Draws a vertical white line of length 90 pixels.  
Input:
- R0 = x-coordinate (column)

### DRAWB
Draws a 20x20 block using block data stored in memory.  
Inputs:
- R0 = starting pixel address
- R1 = starting address of 400-element block data
- R2 = color  
Block rules:
- Zero in block data means draw a black pixel
- Non-zero means draw pixel color stored in R2

Block data addresses:
- X block at xA000
- O block at xA200

---

## Block Start Addresses
You may store these in an array for easy indexing by move number:

Block | Coordinates | Start Address | Description
0 | (5, 5) | xC285 | Top left  
1 | (35, 5) | xC2A3 | Top middle  
2 | (65, 5) | xC2C1 | Top right  
3 | (5, 35) | xD185 | Middle left  
4 | (35, 35) | xD1A3 | Middle  
5 | (65, 35) | xD1C1 | Middle right  
6 | (5, 65) | xE085 | Bottom left  
7 | (35, 65) | xE0A3 | Bottom middle  
8 | (65, 65) | xE0C1 | Bottom right  

X color: x7FED  
O color: x03E0

---

## Occupancy Tracking
You must prevent drawing on already occupied squares.  
Recommended methods:
- Maintain an array of 9 integers (0 = free, 1 = taken), or
- Use a single word with bit-mask operations.
