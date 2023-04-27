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
**************************************************************************************************
	.global encodeBlock		;game_physics_engine
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
	BL timer_interrupt_init_RNG
	BL DisableRNG
	BL start_printer
	;BL read_from_push_btns
	;BL makeBlocks
	BL EnableT		;start game
	MOV r7, #0
	MOV r6, #0xF
	MOV r9, #0
	B wait

wait:
	B wait

game:
	PUSH {lr}
	BL checkermanager
	BL gameprinter
	;move cordinates
	LDR r1, ptr_to_cordinatesNext
	LDRH r0, [r1]
	LDR r1, ptr_to_cordinatesNow
	STRH r0, [r1]
	POP {pc}

lifelost:
	CMP r6, #0x1	;1 life
	ITT EQ
	SUBEQ r6, #1
	BEQ game_over
	CMP r6, #0x3	;2 lives
	IT EQ
	SUBEQ r6, #2
	CMP r6, #0x7	;3 lives
	IT EQ
	SUBEQ r6, #4
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
	LDR r0, ptr_to_blocklvls
	LDRB r0, [r0]
	MOV r1, #2
	MOV r4, #1		;block is alive
	CMP r0, #1		;1st level of blocks
	ITTT LE
	LDRLE r2, ptr_to_blocksrow2
	MOVLE r5, #0
	BLE makeBlocksLoop
	CMP r0, #1		;2nd level of blocks
	ITTT LE
	LDRLE r2, ptr_to_blocksrow3
	MOVLE r5, #0
	BLE makeBlocksLoop
	CMP r0, #1		;3rd level of blocks
	ITTT LE
	LDRLE r2, ptr_to_blocksrow4
	MOVLE r5, #0
	BLE makeBlocksLoop
	CMP r0, #1		;4th level of blocks
	ITTT LE
	LDRLE r2, ptr_to_blocksrow5
	MOVLE r5, #0
	BLE makeBlocksLoop
	POP {pc}

makeBlocksLoop:
	BL EnableRNG		;HOW FAST DOES THE TIMMER RUN
	CMP r5, #7
	IT GE
	MOVGE pc, lr
	MOV r3, r9			;store color
	ADD r3, #1
	MUL r3, r1
	BL encodeBlock
	ADD r5, #1
	B makeBlocksLoop

game_over:

.end
