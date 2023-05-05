	.data

	.global score
	.global gamelevel

score:		.half 0x0000
gamelevel:	.byte 0x01
**********************************from exterior file**********************************************
	.global blocksrow2			;game_physics_engine
	.global blocksrow3			;game_physics_engine
	.global blocksrow4			;game_physics_engine
	.global blocksrow5			;game_physics_engine
	.global cordinatesNow		;game_physics_engine
	.global cordinatesNext		;game_physics_engine
	.global LeftRight			;game_physics_engine
	.global UpDown				;game_physics_engine
	.global angle				;game_physics_engine
	.global paddleX				;game_physics_engine
	.global blocklvls			;game_physics_engine
	.global scorestr		;game_printer_and_sub
	.global gameOver		;game_printer_and_sub
	.global ballcolor		;game_printer_and_sub

	.text
	.global start
	.global game
	.global restart_game
	.global lifelost
	.global BlockCreate
	.global BeginBlockLoop
**********************************from exterior file**********************************************
	.global uart_init					;game_init_library
	.global uart_interrupt_init			;game_init_library
	.global gpio_interrupt_init			;game_init_library
	.global Four_LED_init				;game_init_library
	.global Four_BUTTON_init			;game_init_library
	.global RGB_LIGHT_init				;game_init_library
	.global timer_interrupt_init		;game_init_library
	.global timer_interrupt_init_RNG	;game_init_library
	.global Timer_Level_2		;game_handler_library
	.global Timer_Level_3		;game_handler_library
	.global Timer_Level_4		;game_handler_library
	.global read_from_push_btns	;game_handler_library
	.global Four_LED_subroutine	;game_handler_library
	.global EnableRNG			;game_handler_library
	.global DisableRNG			;game_handler_library
	.global DisableT			;game_handler_library
	.global EnableT				;game_handler_library
	.global rgbLED				;game_handler_library
	.global start_printer	;game_printer_and_sub
	.global gameprinter		;game_printer_and_sub
	.global checkermanager		;game_physics_engine
	.global encodeBlock			;game_physics_engine
**************************************************************************************************
ptr_to_score:			.word score
ptr_to_gamelevel:		.word gamelevel
**********************************from exterior file**********************************************
ptr_to_scorestr:		.word scorestr
ptr_to_blocksrow2:		.word blocksrow2
ptr_to_blocksrow3:		.word blocksrow3
ptr_to_blocksrow4:		.word blocksrow4
ptr_to_blocksrow5:		.word blocksrow5
ptr_to_LeftRight:		.word LeftRight
ptr_to_UpDown:			.word UpDown
ptr_to_angle:			.word angle
ptr_to_cordinatesNow:	.word cordinatesNow
ptr_to_cordinatesNext:	.word cordinatesNext
ptr_to_paddleX:			.word paddleX
ptr_to_blocklvls:		.word blocklvls
ptr_to_ballcolor:		.word ballcolor
**************************************************************************************************

start:
	BL uart_init
	BL uart_interrupt_init
	BL gpio_interrupt_init
	BL Four_LED_init
	BL Four_BUTTON_init
	BL RGB_LIGHT_init
	BL timer_interrupt_init
	BL DisableT			;pause timer until game actually starts
	BL timer_interrupt_init_RNG		;disabled by default
	BL start_printer
	BL read_from_push_btns
	MOV r11, #0		;block counter
	BL makeBlocks
	BL EnableT		;start game
	MOV r7, #0		;pause reg 1 is pause 0 is running
	MOV r6, #0xFF	;lives reg also used as direct output for lives
	BL Four_LED_subroutine
	B wait

wait:
	B wait

game:
	PUSH {lr}
	BL checkermanager
	CMP r11, #0
	IT EQ
	BLEQ nextLevel
	BL gameprinter
	;move cordinates
	LDR r1, ptr_to_cordinatesNext
	LDRH r0, [r1]
	LDR r1, ptr_to_cordinatesNow
	STRH r0, [r1]
	POP {pc}

restart_game:
	PUSH {lr}
	LDR r1, ptr_to_score
	MOV r0, #0x0000
	STRH r0, [r1]		;reset score to 0
	LDR r1, ptr_to_scorestr
	MOV r0, #0x30		;reset score string to 0 null null null null null
	STRB r0, [r1], #1
	MOV r0, #0x00
	STRB r0, [r1], #1
	STRB r0, [r1], #1
	STRB r0, [r1], #1
	STRB r0, [r1], #1
	STRB r0, [r1]
	LDR r1, ptr_to_cordinatesNow
	MOV r0, #0x0A06
	STRH r0, [r1]		;rest cordinates
	LDR r1, ptr_to_cordinatesNext
	MOV r0, #0x0A07
	STRH r0, [r1]
	LDR r1, ptr_to_LeftRight
	MOV r0, #0x01
	STRB r0, [r1]		;reset directions and angle
	LDR r1, ptr_to_UpDown
	MOV r0, #0x00
	STRB r0, [r1]
	LDR r1, ptr_to_angle
	MOV r0, #0x01
	STRB r0, [r1]
	LDR r1, ptr_to_gamelevel
	MOV r0, #0x01
	STRB r0, [r1]		;reset game level
	LDR r1, ptr_to_ballcolor
	MOV r0, #0x00
	STRB r0, [r1]		;reset ball color
	LDR r1, ptr_to_paddleX
	MOV r0, #0x0810
	STRH r0, [r1]		;reset paddleX
	BL uart_init
	BL uart_interrupt_init
	BL gpio_interrupt_init
	BL Four_LED_init
	BL Four_BUTTON_init
	BL RGB_LIGHT_init
	BL timer_interrupt_init
	BL DisableT			;pause timer until game actually starts
	BL timer_interrupt_init_RNG		;disabled by default
	BL start_printer
	BL read_from_push_btns
	MOV r11, #0		;block counter
	BL makeBlocks
	MOV r7, #0		;pause reg 1 is pause 0 is running
	MOV r6, #0xFF	;lives reg also used as direct output for lives
	BL Four_LED_subroutine
	BL EnableT		;start game
	POP {PC}


lifelost:
	CMP r6, #0x00	;0 lifes
	IT EQ
	BEQ game_over
	BL Four_LED_subroutine	;adjust leds
	MOV r0, #0x0A06			;move cordiinates to center
	LDR r1, ptr_to_cordinatesNow
	STRH r0, [r1]
	LDR r1, ptr_to_cordinatesNext
	STRH r0, [r1]
	MOV r0, #0x00
	LDR r1, ptr_to_ballcolor ;update ball color
	STRB r0, [r1]
	BL rgbLED		;update rgb led
	POP {pc}

nextLevel:
	PUSH {lr}
	;BL DisableT			;pause timer
	MOV r0, #0x0A06
	LDR r1, ptr_to_cordinatesNow
	STRH r0, [r1]
	LDR r1, ptr_to_cordinatesNext
	STRH r0, [r1]
	BL makeBlocks
	LDR r1, ptr_to_gamelevel
	LDRB r0, [r1]
	ADD r0, #1
	STRB r0, [r1]
	CMP r0, #2
	IT EQ
	BLEQ  Timer_Level_2
	CMP r0, #3
	IT EQ
	BLEQ  Timer_Level_3
	CMP r0, #4
	IT EQ
	BLEQ  Timer_Level_4
	;BL EnableT		;start game
	MOV r7, #0
	POP {pc}

makeBlocks:
	PUSH {lr}
	;BL EnableRNG
	LDR r0, ptr_to_blocklvls
	LDRB r0, [r0]
	CMP r0, #1		;1st level of blocks
	ITTT GE
	LDRGE r4, ptr_to_blocksrow2
	MOVGE r5, #0
	BLGE BeginBlockLoop
	CMP r0, #2		;2nd level of blocks
	ITTT GE
	LDRGE r4, ptr_to_blocksrow3
	MOVGE r5, #0
	BLGE BeginBlockLoop
	CMP r0, #3		;3rd level of blocks
	ITTT GE
	LDRGE r4, ptr_to_blocksrow4
	MOVGE r5, #0
	BLGE BeginBlockLoop
	CMP r0, #4		;4th level of blocks
	ITTT GE
	LDRGE r4, ptr_to_blocksrow5
	MOVGE r5, #0
	BLGE BeginBlockLoop
	;BL DisableRNG
	POP {pc}

BlockCreate:
	NOP
ADDValue:
	MOV r0, #0x0000
	MOVT r0, #0x4003
	LDRB r8, [r0, #0x050]		;add some value to r6 to change up the delay
DELAY:
    SUBS r8, r8, #1				;do a loop subracting r6 by 1 and setting r6 with the new value when it done subtracting
    BNE DELAY					;if r6 does not equal zero go back to loop to keep subtracting

	MOV r10, #5
	MOV r0, #0x1000				;move memory address of Timer1 base address to r0
	MOVT r0, #0x4003
	LDR r1, [r0, #0x050]		;load Timer A Value to r1
	MOV r1, r1, LSR #5
	;MOV r5, r9					;copy r9 to r8
	SDIV r2, r1, r10			;divide Timer A Value by 5 to r2
	MUL r3, r2, r10				;multiply r2 with 5 to r3
	SUB r9, r1, r3				;subtract Timer A Value with the value of r3 to get the value of Timer A Value mod 5
	CMP r9, r7					;compare r9 and r8
	BEQ ADDValue				;branch to delay if r9 and r8 are equal to make sure pattern is randomized and no repeated number

	MOV r2, r4	;move addy to r2
	MOV r3, r9		;store color
	MOV r1, #2
	ADD r3, #1
	MUL r3, r1
	MOV r4, #1		;block is alive
	BL encodeBlock
	MOV r4, r2		;move addy back to r4
	ADD r5, #1		;add 1 to block offset
	ADD r11, #1		;add block to block counter
	MOV r7, r9
	MOV r9, #10
	;BL EnableRNG
	B BlockLoop

BeginBlockLoop:
	PUSH {r0, lr}
	;BL EnableRNG
BlockLoop:
	;CMP r9, #5
	CMP r5, #7
	BLT BlockCreate
	CMP r5, #7
	BLT	BlockLoop
	POP {r0, pc}

game_over:
	PUSH {lr}
	BL DisableT
	BL Four_LED_subroutine
	MOV r0, #0xFFFF
	LDR r1, ptr_to_cordinatesNow
	STRH r0, [r1]
	LDR r1, ptr_to_cordinatesNext
	STRH r0, [r1]
	BL DisableT
	BL gameprinter
	POP {pc}

.end
