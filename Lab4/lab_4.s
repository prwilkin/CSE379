	.data

menu_prompt: 				.string "Testing Menu",0xA,0xD,0x00
read_from_push_btns_prompt: 		.string "Test read_from_push_btns: Press [1]",0xA,0xD,0x00
illuminate_LEDs_prompt: 		.string "Test illuminate_LEDs: Press [2]",0xA,0xD,0x00
illuminate_RGB_LED_prompt: 		.string "Test illuminate_RGB_LED: Press [3]",0xA,0xD,0x00
read_tiva_push_button_prompt: 		.string "Test read_tiva_push_button: Press [4]",0xA,0xD,0x00
read_keypad_prompt: 			.string "Test read_keypad: Press [5]",0xA,0xD,0x00
quit_prompt:				.string "To quit: Press [ESC]",0xA,0xD,0x00
rerun_prompt:				.string "To rerun test: Press [TAB]",0xA,0xD,0x00

read_from_push_btns_name:		.string "read_from_push_btns ",0x00
illuminate_LEDs_name:			.string "illuminate_LEDs ",0x00
illuminate_RGB_LED_name:		.string "illuminate_RGB_LED ",0x00
read_tiva_push_button_name:		.string "read_tiva_push_button ",0x00
read_keypad_name:				.string "read_keypad ",0x00

read_from_push_btns_inst:		.string "To test, press button and the number of the button pressed, as numbered on the Alice Board, will be displayed. To rerun, follow the rerun prompt.",0xA,0xD,0xA,0xD,0x00
illuminate_LEDs_inst:	 		.string "To turn on a light press [+] and then the number correpsonding to the light numbering on the board.",0xA,0xD,"To turn off a light press [-] and then the number correpsonding to the light on the board.",0xA,0xD,0xA,0xD,0x00
illuminate_RGB_LED_inst: 		.string "Refer to the light on the tiva board",0xA,0xD,"Red: Press [1]",0xA,0xD,"Blue: Press [2]",0xA,0xD,"Green: Press [3]",0xA,0xD,"Purple: Press [4]",0xA,0xD,"Yellow: Press [5]",0xA,0xD,"White: Press [6]",0xA,0xD,"Off: Press [7]",0xA,0xD,0xA,0xD,0x00
read_tiva_push_button_inst: 		.string "To test, press SW1 on the Tiva board. A message will return verifying the press occured. To test again follow the rerun prompt below.",0xA,0xD,0xA,0xD,0x00
read_keypad_inst:	 		.string "To test, press the keypad. The number you pressed on the keypad will be displayed. To test again follow the rerun prompt below.",0xA,0xD,0xA,0xD,0x00

read_from_push_btns_rtn:		.string "Button #",0x00
read_tiva_pushbutton_rtn:		.string "Pressed",0xA,0xD,0x00

	.text

	.global uart_init
	.global gpio_btn_and_LED_init
	.global output_character
	.global read_character
	.global read_string
	.global output_string
	.global read_from_push_btns
	.global illuminate_LEDs
	.global illuminate_RGB_LED
	.global read_tiva_push_button
	.global read_keypad
	.global keypad_init
	.global lab4

ptr_to_menu_prompt: 				.word menu_prompt
ptr_to_read_from_push_btns_prompt: 		.word read_from_push_btns_prompt
ptr_to_illuminate_LEDs_prompt: 			.word illuminate_LEDs_prompt
ptr_to_illuminate_RGB_LED_prompt: 		.word illuminate_RGB_LED_prompt
ptr_to_read_tiva_push_button_prompt: 		.word read_tiva_push_button_prompt
ptr_to_read_keypad_prompt: 			.word read_keypad_prompt
ptr_to_quit_prompt:				.word quit_prompt
ptr_to_rerun_prompt:				.word rerun_prompt

ptr_to_read_from_push_btns_name:		.word read_from_push_btns_name
ptr_to_illuminate_LEDs_name:			.word illuminate_LEDs_name
ptr_to_illuminate_RGB_LED_name:			.word illuminate_RGB_LED_name
ptr_to_read_tiva_push_button_name:		.word read_tiva_push_button_name
ptr_to_read_keypad_name:			.word read_keypad_name

ptr_to_read_from_push_btns_inst:		.word read_from_push_btns_inst
ptr_to_illuminate_LEDs_inst:	 		.word illuminate_LEDs_inst
ptr_to_illuminate_RGB_LED_inst: 		.word illuminate_RGB_LED_inst
ptr_to_read_tiva_push_button_inst: 		.word read_tiva_push_button_inst
ptr_to_read_keypad_inst:	 		.word read_keypad_inst

ptr_to_read_from_push_btns_rtn:			.word read_from_push_btns_rtn
ptr_to_read_tiva_pushbutton_rtn:		.word read_tiva_pushbutton_rtn


lab4:
	PUSH {lr} ; Store register lr on stack

	BL uart_init
	BL gpio_btn_and_LED_init
	BL keypad_init
lab4_non_init:
	BL clr_page
	BL main_menu
lab4_loop:
	BL read_character
	CMP r0, #0x1B
	BEQ QUIT
	SUB r0, r0, #48
	CMP r0, #1
	BEQ read_from_push_btns_menu
	CMP r0, #2
	BEQ illuminate_LEDs_menu
	CMP r0, #3
	BEQ illuminate_RGB_LED_menu
	CMP r0, #4
	BEQ read_tiva_push_button_menu
	CMP r0, #5
	BEQ read_keypad_menu
	B lab4_loop

	POP {lr}
	MOV pc, lr
	;############################################# lab4 END #############################################

clr_page:
	PUSH {lr}

	MOV r0, #0xC
	BL output_character

	POP {lr}
	MOV pc, lr
	;############################################# clr_page END #############################################

main_menu:
	PUSH {lr}

	ldr r0, ptr_to_menu_prompt
	BL output_string
	ldr r0, ptr_to_read_from_push_btns_prompt
	BL output_string
	ldr r0, ptr_to_illuminate_LEDs_prompt
	BL output_string
	ldr r0, ptr_to_illuminate_RGB_LED_prompt
	BL output_string
	ldr r0, ptr_to_read_tiva_push_button_prompt
	BL output_string
	ldr r0, ptr_to_read_keypad_prompt
	BL output_string
	ldr r0, ptr_to_quit_prompt
	BL output_string

	POP {lr}
	MOV pc, lr
	;############################################# main_menu END #############################################

read_from_push_btns_menu:

	BL gpio_btn_and_LED_init
	BL clr_page								;print instructions and prompts
	LDR r0, ptr_to_read_from_push_btns_name
	BL output_string
	LDR r0, ptr_to_menu_prompt
	BL output_string
	LDR r0, ptr_to_read_from_push_btns_inst
	BL output_string
	LDR r0, ptr_to_rerun_prompt
	BL output_string
	LDR r0, ptr_to_quit_prompt
	BL output_string

read_from_push_btns_handler:
	BL read_from_push_btns					;get btn press
read_from_push_btns_handler_btn2:
	CMP r0, #0x8							;check for btn #2
	BNE read_from_push_btns_handler_btn3
	MOV r0, #0x32
	B read_from_push_btns_handler_printer
read_from_push_btns_handler_btn3:
	CMP r0, #0x4							;check for btn #3
	BNE read_from_push_btns_handler_btn4
	MOV r0, #0x33
	B read_from_push_btns_handler_printer
read_from_push_btns_handler_btn4:
	CMP r0,	#0x2							;check for btn #4
	BNE read_from_push_btns_handler_btn5
	MOV r0, #0x34
	B read_from_push_btns_handler_printer
read_from_push_btns_handler_btn5:
	CMP r0,	#0x1							;check for btn #5
	BNE read_from_push_btns_handler
	MOV r0, #0x35
	B read_from_push_btns_handler_printer
read_from_push_btns_handler_printer:
	PUSH {r0}
	LDR r0, ptr_to_read_from_push_btns_rtn
	BL output_string						;print button and number
	POP {r0}
	BL output_character
	MOV r0, #0xA
	BL output_character
	MOV r0, #0xD
	BL output_character
read_from_push_btns_handler_closer:
	BL read_character						;get TAB or ESC to rerun or quit
	CMP r0, #0x9
	BEQ read_from_push_btns_handler
	CMP r0, #0x1B
	BEQ lab4_non_init
	B read_from_push_btns_handler_closer
	;############################################# read_from_push_btns_menu END #############################################

illuminate_LEDs_menu:

	BL gpio_btn_and_LED_init
	BL clr_page							;print instructions and prompts
	LDR r0, ptr_to_illuminate_LEDs_name
	BL output_string
	LDR r0, ptr_to_menu_prompt
	BL output_string
	LDR r0, ptr_to_illuminate_LEDs_inst
	BL output_string
	LDR r0, ptr_to_quit_prompt
	BL output_string

illuminate_LEDs_handler:
	BL read_character				;get and print + or - sign
	CMP r0, #0x1B
	BEQ lab4_non_init				;if ESC go to menu
	BL output_character
	CMP r0, #0x2B					;Check for + to add light
	BNE illuminate_LEDs_handler_sub			;Or with data
	BL read_character				;ex. L3 on will be DATA | 1000
	BL output_character				;get and print light number
	BL light_hex					;get binary bit mask
	MOV r1, #0x5000					;move address for data port B
	MOVT r1, #0x4000
	LDR r2, [r1, #0x3FC]				;get data from offset of data port B
	ORR r0, r2					;bit mask to turn on and leave on other lights
	BL illuminate_LEDs				;store to data offset of data port B
	B illuminate_LEDs_handler

illuminate_LEDs_handler_sub:
	CMP r0, #0x2D					;Check for - to sub light
	BNE illuminate_LEDs_handler			;XOR with data excluding light to turn off
	BL read_character				;ex. L3 off will be DATA ^ 0111
	BL output_character				;get and print light number
	BL light_hex					;get binary bit mask
	MOV r1, #0x5000					;move address for data port B
	MOVT r1, #0x4000
	LDR r2, [r1, #0x3FC]				;get data from offset of data port B
	EOR r0, r2					;bit mask to turn off and leave on other lights
	BL illuminate_LEDs				;store to data offset of data port B
	B illuminate_LEDs_handler

	;############################################# illuminate_LEDs_menu END #############################################

illuminate_RGB_LED_menu:

	BL clr_page								;print instructions and prompts
	LDR r0, ptr_to_illuminate_RGB_LED_name
	BL output_string
	LDR r0, ptr_to_menu_prompt
	BL output_string
	LDR r0, ptr_to_illuminate_RGB_LED_inst
	BL output_string
	LDR r0, ptr_to_quit_prompt
	BL output_string
illuminate_RGB_LED_handler:
	BL read_character
	CMP r0, #0x1B							;if ESC go to menu
	BEQ lab4_non_init
	SUB r0, r0, #48
illuminate_RGB_LED_handler_red:
	CMP r0, #1								;test Red
	BNE illuminate_RGB_LED_handler_blue
	MOV r0, #0x2
	BEQ illuminate_RGB_LED_handler_end
illuminate_RGB_LED_handler_blue:
	CMP r0, #2								;test Blue
	BNE illuminate_RGB_LED_handler_green
	MOV r0, #0x4
	BEQ illuminate_RGB_LED_handler_end
illuminate_RGB_LED_handler_green:
	CMP r0, #3								;test Green
	BNE illuminate_RGB_LED_handler_purple
	MOV r0, #0x8
	BEQ illuminate_RGB_LED_handler_end
illuminate_RGB_LED_handler_purple:
	CMP r0, #4								;test Purple
	BNE illuminate_RGB_LED_handler_yellow
	MOV r0, #0x6
	BEQ illuminate_RGB_LED_handler_end
illuminate_RGB_LED_handler_yellow:
	CMP r0, #5								;test Yellow
	BNE illuminate_RGB_LED_handler_white
	MOV r0, #0xA
	BEQ illuminate_RGB_LED_handler_end
illuminate_RGB_LED_handler_white:
	CMP r0, #6								;test White
	BNE illuminate_RGB_LED_handler_off
	MOV r0, #0xE
	BEQ illuminate_RGB_LED_handler_end
illuminate_RGB_LED_handler_off:
	CMP r0, #7
	BNE illuminate_RGB_LED_handler_end
	MOV r0, #0x0
illuminate_RGB_LED_handler_end:
	BLEQ illuminate_RGB_LED
	B illuminate_RGB_LED_handler

	;############################################# illuminate_RGB_LED_menu END #############################################

read_tiva_push_button_menu:

	BL clr_page								;print instructions and prompts
	LDR r0, ptr_to_read_tiva_push_button_name
	BL output_string
	LDR r0, ptr_to_menu_prompt
	BL output_string
	LDR r0, ptr_to_read_tiva_push_button_inst
	BL output_string
	LDR r0, ptr_to_rerun_prompt
	BL output_string
	LDR r0, ptr_to_quit_prompt
	BL output_string
read_tiva_push_button_handler:
	BL read_tiva_push_button
	CMP r0, #1
	BNE read_tiva_push_button_handler
	LDR r0, ptr_to_read_tiva_pushbutton_rtn
	BL output_string
read_tiva_push_button_handler_closer:
	BL read_character						;get TAB or ESC to rerun or quit
	CMP r0, #0x9
	BEQ read_tiva_push_button_handler
	CMP r0, #0x1B
	BEQ lab4_non_init
	B read_tiva_push_button_handler_closer

	;############################################# read_tiva_push_button_menu END #############################################

read_keypad_menu:

	BL keypad_init
	BL clr_page								;print instructions and prompts
	LDR r0, ptr_to_read_keypad_name
	BL output_string
	LDR r0, ptr_to_menu_prompt
	BL output_string
	LDR r0, ptr_to_read_keypad_inst
	BL output_string
	LDR r0, ptr_to_rerun_prompt
	BL output_string
	LDR r0, ptr_to_quit_prompt
	BL output_string

read_keypad_handler:
	BL read_keypad							;get keypad
	PUSH {r0}
	LDR r0, ptr_to_read_from_push_btns_rtn
	BL output_string
	POP {r0}
	ADD r0, r0, #48
	BL output_character						;print line and keypad number
	MOV r0, #0xA
	BL output_character
	MOV r0, #0xD
	BL output_character
read_keypad_handler_closer:
	BL read_character						;get TAB or ESC to rerun or quit
	CMP r0, #0x9
	BEQ read_keypad_handler
	CMP r0, #0x1B
	BEQ lab4_non_init
	B read_keypad_handler_closer

	;############################################# read_keypad_menu END #############################################


light_hex:
	PUSH {lr}

	SUB r0, r0, #48		;convert ascii to int
light_3:
	CMP r0, #3
	BNE light_2
	MOV r0, #0x8		;bit #3
	B light_hex_end
light_2:
	CMP r0, #2
	BNE light_1
	MOV r0, #0x4		;bit #2
	B light_hex_end
light_1:
	CMP r0, #1
	BNE light_0
	MOV r0, #0x2		;bit #1
	B light_hex_end
light_0:
	CMP r0, #0
	MOV r0, #0x1		;bit #0
light_hex_end:
	POP {lr}
	MOV pc, lr

QUIT:

.end
