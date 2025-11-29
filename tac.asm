; 		IAN ONGWACHO 
; 		
;		PROGRAM 3: ASSUMING A SEMI SMART USER, WE WILL CREATE A TIC-TAC-TOE BOARD
; 		THAT LETS THE 2 USERS PLAY TIC-TAC-TOE AGANIST EACH OTHER
;		
;----------------------------------------------------------------------------------------
		
		
		
		.ORIG	x3000
		
		
				JSR CLEAR_SCREEN
				JSR DRAWH
				JSR DRAWV
MAIN_LOOP		JSR	GETMOV
				JSR DRAWB
				BRnzp MAIN_LOOP
DONE	HALT

		
; ----CONSTANTS-------
SCREEN  		.FILL 	xC000             	;start address of the graphics display
CURR_X  		.FILL 	#10               	;holds current x position of logo
CURR_Y  		.FILL 	#45              	;holds current y position of logo
SCREEN_END 		.FILL 	xFDFF          		;end address of graphics display
BLOCK_X			.FILL 	xA000				; starting address for blockx 
BLOCK_O			.FILL 	xA200				; starting address for blocko 
L_LENGTH		.FILL 	#90					; LENGTH ON OUR LINES
HOR_1			.FILL 	xCF00				; ADDRESS OF HORIZONTAL LINE 1 
HOR_2			.FILL	xDE00				; ADDRESS OF HORIZONTAL LINE 2 
WHITE			.FILL	x7FFF				; COLOR PURPLE 
VER_1			.FILL	xC01E				; ADDRESS FOR VERTICAL POSITION 1
VER_2			.FILL	xC03C				; ADDRESS FOR VERTICAL POSITION 2 
NEXT			.FILL	#128				; PRETTY SELF EXPLINANITORY 
NEG_0    		.FILL 	#-48				; NEGATIVE VALUE OF ZERO 
NEG_1			.FILL	#-49
NEG_2			.FILL	#-50
NEG_3			.FILL	#-51
NEG_4			.FILL	#-52
NEG_5			.FILL	#-53
NEG_6			.FILL	#-54
NEG_7			.FILL	#-55
NEG_8			.FILL	#-56
NEG_ENTER  		.FILL 	#-10     
NEGQ			.FILL 	#-113		; NEGATIVE VALUE FOR 'q'
MOVECHECKER
				.FILL	#0			;TOP_LEFT
				.FILL	#0			;TOP_MIDDLE	
				.FILL	#0			;TOP_RIGHT	
				.FILL	#0			;MIDDLE_LEFT	
				.FILL	#0			;MIDDLE_MIDDLE
				.FILL	#0			;MIDDLE_RIGHT
				.FILL	#0			;BOTTOM_LEFT
				.FILL	#0			;BOTTOM_MIDDLE
				.FILL	#0			;BOTTOM_RIGHT


BLOCK_ADDR		
				.FILL	xC285 		;BLOCK_0			
				.FILL	xC2A3 		;BLOCK_1	
				.FILL	xC2C1 		;BLOCK_2	
				.FILL	xD185 		;BLOCK_3		
				.FILL	xD1A3 		;BLOCK_4	
				.FILL	xD1C1		;BLOCK_5			
				.FILL	xE085 		;BLOCK_6	
				.FILL	xE0A3 		;BLOCK_7	
				.FILL	xE0C1 		;BLOCK_8	
				
BLUE			.FILL	x05FF
GREEN			.FILL	x0F00
WIDTH_20		.FILL	#20
HEIGHT_20		.FILL	#20
LAST_MOVE		.FILL	#0
PLAY_BOX		.FILL	#0
OFF_SET			.FILL	#108
PROMPT1			.STRINGZ "\n PLAYER X ENTER A MOVE:\n" 
PROMPT2			.STRINGZ "\n PLAYER O ENTER A MOVE:\n" 
PLAYER_MOVE		.FILL 	#0
IF_Q			.FILL	#9
SAVED_RET		.FILL	#0
;------SUBROUTINES---------		
		
CLEAR_SCREEN	
				LD R1, SCREEN           ;R1 = xC000    
				LD R2, SCREEN_END       ;R2 = xFDFF
				NOT R2, R2              ;R2 = NOT(xFDFF)
				ADD R2, R2, #1          ;R2 = -xFDFF
				AND R0, R0, #0          ;R0 = x0000		
CLEAR_LOOP
				STR R0, R1, #0          ;write a black pixel to screen
				ADD R1, R1, #1          ;increment the screen address
				ADD R3, R1, R2          ;R3 = current address - screen end
				BRnz CLEAR_LOOP         ;as long as the screen end is greater than or equal to current address, keep looping
    
				RET                     ;return to caller
				
;----DRAWING OUR WHITE HORIZONTAL LINES 
DRAWH
				LEA R0, HOR_1			; R0 = POINTER TO HORIZONTAL LINE MEM address
				LDR R0, R0, #0 			; R0 = DATA THAT OUR POINTER POINTED TO 
				
				LD R1, WHITE 			; R1 = VALUE PURPLE
				LD R2, L_LENGTH			; R2 = #90

W_PAINT			STR R1, R0, #0			; STORE PURPLE FROM R1, INTO ADDRESS IN R0 
				ADD R0, R0, #1 			; INCREMENT OUR SCREEN ADDRESS POINTER 
				ADD R2, R2, #-1			; DECREMENT OUR COUNTER OF LINE LENGTH 
				BRnp	W_PAINT			; KEEP REPEATING UNTIL LINE IS DRAWNOUT
				
				LEA R0, HOR_2			; R0 = POINTER TO HORIZONTAL LINE MEM address
				LDR R0, R0, #0 			; R0 = DATA THAT OUR POINTER POINTED TO 
				
				LD R1, WHITE	 		; R1 = VALUE PURPLE
				LD R2, L_LENGTH			; R2 = #90

BROTHER			STR R1, R0, #0			; STORE PURPLE FROM R1, INTO ADDRESS IN R0 
				ADD R0, R0, #1 			; INCREMENT OUR SCREEN ADDRESS POINTER 
				ADD R2, R2, #-1			; DECREMENT OUR COUNTER OF LINE LENGTH 
				BRnp	BROTHER			; KEEP REPEATING UNTIL LINE IS DRAWNOUT				

 				RET
				
DRAWV		
				LEA R0, VER_1			; R0 = POINTER TO VERTICAL LINE MEM address
				LDR R0, R0, #0 			; R0 = DATA THAT OUR POINTER POINTED TO 
				
				LD R1, WHITE 			; R1 = VALUE PURPLE
				LD R2, L_LENGTH			; R2 = #90
				LD R3, NEXT				; R3 = 128 

PAINTING		STR R1, R0, #0			; STORE PURPLE FROM R1, INTO ADDRESS IN R0 
				ADD R0, R0, R3 			; INCREMENT OUR SCREEN ADDRESS POINTER 
				ADD R2, R2, #-1			; DECREMENT OUR COUNTER OF LINE LENGTH 
				BRnp PAINTING
;--SECOIND LINE							
				LEA R0, VER_2			; R0 = POINTER TO VERTICAL LINE MEM address
				LDR R0, R0, #0 			; R0 = DATA THAT OUR POINTER POINTED TO 
				
				LD R1, WHITE 			; R1 = VALUE PURPLE
				LD R2, L_LENGTH			; R2 = #90
				LD R3, NEXT				; R3 = 128 
				
MOTHER			STR R1, R0, #0			; STORE PURPLE FROM R1, INTO ADDRESS IN R0 
				ADD R0, R0, R3 			; INCREMENT OUR SCREEN ADDRESS POINTER 
				ADD R2, R2, #-1			; DECREMENT OUR COUNTER OF LINE LENGTH 
				BRnp MOTHER
				
				RET
				;----- GET MOVE SUBROUTINE----------------------------------------
GETMOV			ST R7, SAVED_RET
				LD R0, LAST_MOVE			; LOAD INTO R0 THE LAST MOVE OF PLAYER, MEMORY ADDRESS CONTAINS EITHER 0 OR 1
				BRz		SWITCH1			; IF IT IS ZERO, THAT MEANS PLAYER O PREVISOULY JUST AHD THEIR TURN, SO WE SWITCH TO PLAYER X
				BRnp	SWITCH2			; IF IT IS ONE, THAT MEANS PLAYER X PREVISOULY HAD THEIR TUNR, SO WE WITCH TO PLAYER O 

SWITCH1			LEA R0, PROMPT1			; R0 = STRINGS THAT SAYS PLAYER X TO PLAY THEIR MOVE 
				PUTS
				BRnzp	CONTINUE

SWITCH2			LEA R0, PROMPT2 		; R0 = STRING THAT SAYS PLAYER O TO PLAY THEIR MOVE
				PUTS
				
CONTINUE		BRnzp GETTING_CHAR1		; CONTINUE ONTO THE PROGRAM AS IS	
				
GETTING_CHAR1	GETC
				OUT
				
				LD R1,NEG_0				; R1 = -0
				ADD R1, R0, R1			; R1 = USER INPUT + NEG0
				BRz	CHAR_RECIVED 
				
				LD R1,NEG_1				; R1 = -1
				ADD R1, R0, R1			; R1 = USER INPUT + NEG1
				BRz	CHAR_RECIVED
				
				LD R1,NEG_2				; R1 = -2
				ADD R1, R0, R1			; R1 = USER INPUT + NEG2
				BRz	CHAR_RECIVED
				
				LD R1,NEG_3				; R1 = -3
				ADD R1, R0, R1			; R1 = USER INPUT + NEG3
				BRz	CHAR_RECIVED
				
				LD R1,NEG_4				; R1 = -4
				ADD R1, R0, R1			; R1 = USER INPUT + NEG4
				BRz	CHAR_RECIVED
				
				LD R1,NEG_5				; R1 = -5
				ADD R1, R0, R1			; R1 = USER INPUT + NEG5
				BRz	CHAR_RECIVED
				
				LD R1,NEG_6				; R1 = -6
				ADD R1, R0, R1			; R1 = USER INPUT + NEG6
				BRz	CHAR_RECIVED
				
				LD R1,NEG_7				; R1 = -7
				ADD R1, R0, R1			; R1 = USER INPUT + NEG7
				BRz	CHAR_RECIVED
				
				LD R1,NEG_8				; R1 = -8
				ADD R1, R0, R1			; R1 = USER INPUT + NEG8
				BRz	CHAR_RECIVED
				
				LD R1,NEGQ				; R1 = -q
				ADD R1, R0, R1			; R1 = USER INPUT + NEGQ
				BRz	Q_RECIVED
;---- IF USER DID NOT PRESS 0-8 OR Q				
				AND R0, R0, #0			; CLEAR R0
				ADD R0, R0, #-1			; R0 = -1
				ST R0, PLAYER_MOVE
				
				BRnzp GETTING_CHAR2			
				
CHAR_RECIVED	LD R1, NEG_0			; r1 = -48
				ADD R0, R0, R1
				ST R0, PLAYER_MOVE		; STORE THE VALUE OF R0, OUR PLAYER MOVE INTO MEMORY BEFORE WE CALL GETC AGAIN 
				
				BRnzp GETTING_CHAR2		
				
Q_RECIVED		LD R0, IF_Q				; R0 = 9
				ST R0, PLAYER_MOVE
				
				BRnzp GETTING_CHAR2	
				
;-----GET THE ENTER KEY-------------------------------
GETTING_CHAR2	
				GETC
				AND R2, R2, #0
				ADD R2, R0, R2			;R2 = VALUE IN R0 
				OUT
				ADD R0, R2, #0			; RESTORE INTO R0 ITS VALUE 
				LD R1, NEG_ENTER		; R1 = NEGATIVE ENTER
				ADD R1, R0, R1			; R1 = NEG_ENTER + USERINPUT
				BRz	 RETURN_RECIVED 
				BRnp GETTING_CHAR2

RETURN_RECIVED	AND R0, R0, #0			; CLEAR R0
				ADD R0, R0, #-2	
				LD R7, SAVED_RET
				RET

;-------------DRAWB SUBROUTINE---------------------------------------------
DRAWB			LD R2, PLAYER_MOVE
				BRn	MAIN_LOOP
				ADD R3, R2, #-9
				BRz	DONE
				
				LD R2, 	PLAYER_MOVE		; USER INPUT 0-8
				LEA R0, MOVECHECKER		; R0 = ADDRESS TO FIND MOVE IF VAIABLE 
				
				ADD R2, R2, #0			; USING R2
				BRz	CHECKER_COMPL
				
REPEATS			ADD R0, R0, #1			; INCREMENT ADDRESS
				ADD R2, R2, #-1
				BRp REPEATS
				

				
CHECKER_COMPL	LDR R1, R0, #0
				ADD R1, R1, #0
				BRnp	MAIN_LOOP
				
				AND R6, R6, #0			; CLEAR R6
				ADD R6, R6, #1			; R6 = 1
				STR R6, R0, #0			
				

LOAD_ADDR		LEA R6, ADDR_PLAYER_MOVE
				LDR R2, R6, #0
				LDR R2, R2, #0			; R2 = PLAYER MOVE, 0-8

				LEA R0, BLOCK_ADDR		; THIS CONTAINS OUR ADRESS
				ADD R2, R2, #0
				BRz	DONE_INDEXING
				
ALLY			ADD R0, R0, #1
				ADD R2, R2, #-1
				BRp ALLY
				
DONE_INDEXING	LDR R1, R0, #0
				BRnzp	DRAW_IMAGE
								 
				
DRAW_IMAGE		AND R0, R0, #0
				ADD R0, R1, #0			; PUT THE ADRESS FROM R1 INTO R0
				
				LEA R2, ADDR_LAST_MOVE
				LDR R3, R2,#0			
				LDR R3, R3, #0 			; R3 = CONTENTS OF LAST MOVE BY PLAYER
				
				BRz CALLY				; IF R3 IS 0, DRAW_X
				BRnp CALLER 				; IF R3 IS 1, DRAW_O
				
				
CALLER			LEA R5, ADDR_SAVED_RET
				LDR R4, R5, #0			; R4 = ADDRESS OF SAVNG return
				STR R7, R4, #0			; SAVE R7 INTO 
				
				JSR DRAW_O
				LEA R6, ADDR_MAIN_LOOP
				LDR R0,R6, #0
				LDR R0, R0, #0
				JMP R0
				
				
DRAW_O          LEA R2, ADDR_LAST_MOVE
				LDR R3, R2,#0
				
				AND R2, R2, #0
				
				STR R2, R3, #0


				LEA R6, ADDR_BLOCK_O
                LDR R1, R6, #0
                LDR R1, R1, #0          ; R1 = BLOCK O address
                
                LEA R6, ADDR_BLUE
                LDR R2, R6, #0
                LDR R2, R2, #0          ; R2 = DATA OF COLOR BLUE 
                
                LEA R6, ADDR_HEIGHT_20
                LDR R3, R6, #0
                LDR R3, R3, #0          ; R3 = HEIGHT OF 20
                                
LOOP2           LEA R6, ADDR_WIDTH_20
                LDR R4, R6, #0
                LDR R4, R4, #0          ; R4 = WIDTH OF 20
        
LOOP1           LDR R5, R1, #0
                BRz ZERO
                BRnp PUTTING

ZERO            ADD R1, R1, #1          ; Move to next template pixel
                ADD R0, R0, #1          ; Move to next screen pixel
                ADD R4, R4, #-1         ; Decrement width
                BRp LOOP1               ; Continue if more pixels in row
                BRnz END_ROW            ; Row done, go to next row
                
PUTTING         STR R2, R0, #0          ; Draw blue pixel
                ADD R0, R0, #1          ; Next screen pixel
                ADD R1, R1, #1          ; Next template pixel
                ADD R4, R4, #-1         ; Decrement width
                BRp LOOP1               ; Continue if more pixels in row
                
END_ROW         LEA R6, ADDR_OFF_SET
                LDR R5, R6, #0
                LDR R5, R5, #0          ; R5 = 108
                
                ADD R0, R0, R5          ; Move to next screen row
                ADD R3, R3, #-1         ; Decrement height
                BRp LOOP2               ; Continue if more rows
                
                LEA R6, ADDR_SAVED_RET
                LDR R7, R6, #0
                LDR R7, R7, #0
                RET
				
				
;---------DRAW X SUBSCRIBERS 
CALLY			LEA R5, ADDR_SAVED_RET
				LDR R4, R5, #0			; R4 = ADDRESS OF SAVNG return
				STR R7, R4, #0			; SAVE R7 INTO 
				
				JSR DRAW_X
				LEA R6, ADDR_MAIN_LOOP
				LDR R0,R6, #0
				LDR R0, R0, #0
				JMP R0


DRAW_X          LEA R2, ADDR_LAST_MOVE
				LDR R3, R2,#0
				
				AND R2, R2, #0
				ADD R2, R2, #1
				STR R2, R3, #0



				LEA R6, ADDR_BLOCK_X
                LDR R1, R6, #0
                LDR R1, R1, #0          ; R1 = BLOCK O address
                
                LEA R6, ADDR_GREEN
                LDR R2, R6, #0
                LDR R2, R2, #0          ; R2 = DATA OF COLOR BLUE 
                
                LEA R6, ADDR_HEIGHT_20
                LDR R3, R6, #0
                LDR R3, R3, #0          ; R3 = HEIGHT OF 20
                                
LOOP3           LEA R6, ADDR_WIDTH_20
                LDR R4, R6, #0
                LDR R4, R4, #0          ; R4 = WIDTH OF 20
        
LOOP4           LDR R5, R1, #0
                BRz DRC
                BRnp ALEJANDRA

DRC             ADD R1, R1, #1          ; Move to next template pixel
                ADD R0, R0, #1          ; Move to next screen pixel
                ADD R4, R4, #-1         ; Decrement width
                BRp LOOP1               ; Continue if more pixels in row
                BRnz BYE_ROW            ; Row done, go to next row
                
ALEJANDRA       STR R2, R0, #0          ; Draw blue pixel
                ADD R0, R0, #1          ; Next screen pixel
                ADD R1, R1, #1          ; Next template pixel
                ADD R4, R4, #-1         ; Decrement width
                BRp LOOP4               ; Continue if more pixels in row
                
BYE_ROW         LEA R6, ADDR_OFF_SET
                LDR R5, R6, #0
                LDR R5, R5, #0          ; R5 = 108
                
                ADD R0, R0, R5          ; Move to next screen row
                ADD R3, R3, #-1         ; Decrement height
                BRp LOOP3               ; Continue if more rows
                
                LEA R6, ADDR_SAVED_RET
                LDR R7, R6, #0
                LDR R7, R7, #0
                RET


; --------POINTERS TO ADRESS LOCATION
ADDR_PLAYER_MOVE	.FILL	PLAYER_MOVE
ADDR_LAST_MOVE		.FILL	LAST_MOVE
ADDR_SAVED_RET		.FILL	SAVED_RET
ADDR_BLOCK_O		.FILL	BLOCK_O
ADDR_BLUE			.FILL	BLUE
ADDR_HEIGHT_20		.FILL	HEIGHT_20
ADDR_WIDTH_20		.FILL	WIDTH_20
ADDR_OFF_SET		.FILL	OFF_SET
ADDR_MAIN_LOOP		.FILL	MAIN_LOOP
ADDR_BLOCK_X		.FILL	BLOCK_X
ADDR_GREEN			.FILL	GREEN

