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
	.global blocklvls			;game_physics_engine

	.text
	.global start
	.global game
	.global lifelost
	.global BlockCreate
	.global BeginBlockLoop
	.global game_over
**********************************from exterior file**********************************************
	.global uart_init					;game_init_library
	.global uart_interrupt_init			;game_init_library
	.global gpio_interrupt_init			;game_init_library
	.global Four_LED_init				;game_init_library
	.global Four_BUTTON_init			;game_init_library
	.global RGB_LIGHT_init				;game_init_library
	.global timer_interrupt_init		;game_init_library
	.global timer_interrupt_init_RNG	;game_init_library
	.global read_from_push_btns	;game_handler_library
	.global Four_LED_subroutine	;game_handler_library
	.global EnableRNG
	.global DisableRNG
	.global DisableT			;game_handler_library
	.global EnableT				;game_handler_library
	.global start_printer	;game_printer_and_sub
	.global gameprinter		;game_printer_and_sub
	.global checkermanager	;game_physics_engine
	.global encodeBlock		;game_physics_engine
**************************************************************************************************
ptr_to_gamelevel:		.word gamelevel
**********************************from exterior file**********************************************
ptr_to_blocksrow2:		.word blocksrow2
ptr_to_blocksrow3:		.word blocksrow3
ptr_to_blocksrow4:		.word blocksrow4
ptr_to_blocksrow5:		.word blocksrow5
ptr_to_cordinatesNow:	.word cordinatesNow
ptr_to_cordinatesNext:	.word cordinatesNext
ptr_to_blocklvls:		.word blocklvls
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
	BL DisableRNG	;disable rng
	BL EnableT		;start game
	MOV r7, #0		;pause reg 1 is pause 0 is running
	MOV r6, #0xF	;lives reg also used as direct output for lives
	BL Four_LED_subroutine
	B wait

wait:
	B wait

game:
	PUSH {lr}
	BL checkermanager
	CMP r11, #0
	IT EQ
	BLEQ newLevel
	BL gameprinter
	;move cordinates
	LDR r1, ptr_to_cordinatesNext
	LDRH r0, [r1]
	LDR r1, ptr_to_cordinatesNow
	STRH r0, [r1]
	POP {pc}

newLevel:
	PUSH {lr}
	LDR r0, ptr_to_gamelevel
	LDRB r1, [r0]
	ADD r1, #1		;increase game level by 1
	STRB r1, [r0]
	;do timer increase
	BL makeBlocks
	MOV r7, #0	;fix pause reg
	MOV r0, #0x0A06			;reset ball
	LDR r1, ptr_to_cordinatesNow
	STRH r0, [r1]
	LDR r1, ptr_to_cordinatesNext
	STRH r0, [r1]
	POP {pc}

lifelost:
	CMP r6, #0x00	;0 lifes
	IT EQ
	BEQ game_over
	;CMP r6, #0x3	;2 lives
	;IT EQ
	;SUBEQ r6, #2
	;CMP r6, #0x7	;3 lives
	;IT EQ
	;SUBEQ r6, #4
	;CMP r6, #0xF	;4 lives
	;IT EQ
	;SUBEQ r6, #0x8
	BL Four_LED_subroutine
	MOV r0, #0x0A06
	LDR r1, ptr_to_cordinatesNow
	STRH r0, [r1]
	LDR r1, ptr_to_cordinatesNext
	STRH r0, [r1]
	POP {pc}

nextLevel:
	BL DisableT			;pause timer
	MOV r0, #0x0A06
	LDR r1, ptr_to_cordinatesNow
	STRH r0, [r1]
	LDR r1, ptr_to_cordinatesNext
	STRH r0, [r1]
	BL makeBlocks
	BL EnableT		;start game
	B wait

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
	MOV r10, #5					;r10 = 5 to be use to mod 5
ADDValue:
	ADD r8, #0x0043				;add some value to r6 to change up the delay
DELAY:
    SUBS r8, r8, #1				;do a loop subracting r6 by 1 and setting r6 with the new value when it done subtracting
    BNE DELAY					;if r6 does not equal zero go back to loop to keep subtracting

	LDR r1, [r0, #0x050]		;load Timer A Value to r1
	MOV r1, r1, LSR #10
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
	;BLT BlockCreate
	B BlockCreate
	CMP r5, #7
	BLT	BlockLoop
	POP {r0, pc}

game_over:
	NOP
.end
