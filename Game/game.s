	.data

	.global score
	.global gamelevel

score:		.half 0x0000
gamelevel:	.byte 0x01
**********************************from exterior file**********************************************
	.global cordinatesNow		;game_physics_engine
	.global cordinatesNext		;game_physics_engine

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
	.global Four_LED_subroutine	;game_handler_library
	.global DisableT			;game_handler_library
	.global EnableT				;game_handler_library
	.global start_printer	;game_printer_and_sub
	.global gameprinter		;game_printer_and_sub
	.global checkermanager	;game_physics_engine
**************************************************************************************************

**********************************from exterior file**********************************************
ptr_to_cordinatesNow:	.word cordinatesNow
ptr_to_cordinatesNext:	.word cordinatesNext
**************************************************************************************************

start:
	BL uart_init
	BL uart_interrupt_init
	BL gpio_interrupt_init
	BL Four_LED_init
	BL Four_BUTTON_init
	BL RGB_LIGHT_init
	BL timer_interrupt_init
	;BL timer_interrupt_init_RNG
	BL DisableT			;pause timer until game actually starts
	BL start_printer
	;BL subroutine for alice board press
	BL EnableT
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
	MOV r0, #0x0B06
	LDR r1, ptr_to_cordinatesNow
	STRB r0, [r1]
	LDR r1, ptr_to_cordinatesNext
	STRB r0, [r1]

	POP {pc}

game_over:

.end
