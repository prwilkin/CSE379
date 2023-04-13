.data

	.global score
	.global gamelevel

score:		.half 0x0000
gamelevel:	.byte 0x01

.text
	.global start
	.global game
	.global lifelost
**********************************from exterior file**********************************************
	.global uart_init				;game_init_library
	.global uart_interrupt_init		;game_init_library
	.global gpio_interrupt_init		;game_init_library
	.global Four_LED_init			;game_init_library
	.global Four_BUTTON_init		;game_init_library
	.global RGB_LIGHT_init			;game_init_library
	.global timer_interrupt_init	;game_init_library
	.global DisableT		;game_handler_library
	.global EnableT			;game_handler_library
	.global start_printer		;game_printer_and_sub
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
	BL start_printer
	;BL subroutine for alice board press
	B wait

wait:
	B wait

game:

lifelost:

.end
