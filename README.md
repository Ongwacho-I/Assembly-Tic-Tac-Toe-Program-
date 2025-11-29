# Assembly-Tic-Tac-Toe-Program-
This program animates a logo on the LC‑3 display. The user can move the logo up, down, left, and right using keyboard inputs. The program draws the graphic pixel‑by‑pixel and updates the screen in real time based on user commands.


Project Overview

This program animates a logo on the LC‑3 display. The user can move the logo up, down, left, and right using keyboard inputs. The program draws the graphic pixel‑by‑pixel and updates the screen in real time based on user commands.

Display & Coordinate System

The LC‑3 display memory starts at xC000.

The screen contains 128 columns × 124 rows of pixels.

Each pixel is a 16‑bit color value stored in a memory‑mapped video buffer.

A pixel at (row, col) is stored at:

xC000 + row*128 + col
User Controls

The program reads keyboard input using memory‑mapped keyboard registers.

Key	Action
w	Move logo UP
s	Move logo DOWN
a	Move logo LEFT
d	Move logo RIGHT
Other	Ignore

Invalid input is ignored until a valid move key is pressed.

Program Structure

The project is implemented using clean modular subroutines:

1. MAIN

The main program loop:

Clears the display

Draws the logo

Reads user input

Calls the appropriate movement routine

Redraws the logo at the new location

2. CLEAR_SCREEN

Clears all pixels on the LC‑3 display.

Writes x0000 (black) to every video memory location.

3. DRAW_LOGO

Draws the logo at a specified row & column.

Uses the bounding box starting at global variables LOGO_ROW and LOGO_COL.

Loops through the logo bitmap and writes each pixel.

4. ERASE_LOGO

Same structure as DRAW_LOGO but writes black pixels.

5. Movement Routines

Each movement routine:

Erases the current logo

Updates the row/col coordinate

Redraws the logo

Ensures boundary limits are not exceeded

Includes:

MOVE_UP

MOVE_DOWN

MOVE_LEFT

MOVE_RIGHT

Data Structures
Logo Position Variables
LOGO_ROW .FILL <initial row>
LOGO_COL .FILL <initial col>

These update after every movement.

Logo Bitmap

A 2D grid of values such as:

.COLOR1
.COLOR2
.COLOR1

Each row represents one horizontal row of the logo.

▶️ How to Run the Program

Open LC3Edit or xLC3.

Load the .asm file.

Assemble and load into memory.

Ensure the display window is visible.

Run (F5) and use WASD to move the logo.

Debugging Notes

An "Undefined Instruction" error usually means a register used as an address contained x0000 or another invalid memory location.

Always ensure the screen address base (xC000) is loaded correctly.

Avoid clearing registers that still need their values later.
