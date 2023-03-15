	.data
menu_prompt: 					.string "Testing Menu",0xA,0xD,0x00
read_from_push_btns_prompt: 	.string "Test read_from_push_btns: Press [1]",0xA,0xD,0x00
illuminate_LEDs_prompt: 		.string "Test illuminate_LEDs: Press [2]",0xA,0xD,0x00
illuminate_RGB_LED_prompt: 		.string "Test illuminate_RGB_LED: Press [3]",0xA,0xD,0x00
read_tiva_push_button_prompt: 	.string "Test read_tiva_push_button: Press [4]",0xA,0xD,0x00
read_keypad_prompt: 			.string "Test read_keypad: Press [5]",0xA,0xD,0x00
quit_prompt:					.string "To quit: Press [ESC]",0xA,0xD,0x00
rerun_prompt:					.string "To rerun test: Press [TAB]",0xA,0xD,0x00

read_from_push_btns_name:		.string "read_from_push_btns ",0x00
illuminate_LEDs_name:			.string "illuminate_LEDs ",0x00
illuminate_RGB_LED_name:		.string "illuminate_RGB_LED ",0x00
read_tiva_push_button_name:		.string "read_tiva_push_button ",0x00
read_keypad_name:				.string "read_keypad ",0x00

read_from_push_btns_inst:		.string "",0xA,0xD,0x00
illuminate_LEDs_inst:	 		.string "",0xA,0xD,0x00
illuminate_RGB_LED_inst: 		.string "Refer to the light on the tiva board",0xA,0xD
;illuminate_RGB_LED_inst2:		.string "Red: Press [1]",OxA,OxD,"Geen: Press [2]",0xA,0xD
illuminate_RGB_LED_inst3:		.string "Geen: Press [2]",0xA,0xD,"Blue: Press [3]",0xA,0xD
illuminate_RGB_LED_inst4:		.string "Purple: Press [4]",0xA,0xD,"Yellow: Press [5]",0xA,0xD
illuminate_RGB_LED_inst5:		.string "White: Press [6]",0xA,0xD,"Off: Press [7]",0xA,0xD,0x00
read_tiva_push_button_inst: 	.string "",0xA,0xD,0x00
read_keypad_inst:	 			.string "",0xA,0xD,0x00

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
	.global lab4

ptr_to_menu_prompt: 					.word menu_prompt
ptr_to_output_character_prompt: 		.word output_character_prompt
ptr_to_read_character_prompt: 			.word read_character_prompt
ptr_to_read_string_prompt: 				.word read_string_prompt
ptr_to_output_string_prompt: 			.word output_string_prompt
ptr_to_read_from_push_btns_prompt: 		.word read_from_push_btns_prompt
ptr_to_illuminate_LEDs_prompt: 			.word illuminate_LEDs_prompt
ptr_to_illuminate_RGB_LED_prompt: 		.word illuminate_RGB_LED_prompt
ptr_to_read_tiva_push_button_prompt: 	.word read_tiva_push_button_prompt
ptr_to_read_keypad_prompt: 				.word read_keypad_prompt
ptr_to_quit_prompt:						.word quit_prompt
ptr_to_rerun_prompt:					.word rerun_prompt

ptr_to_output_character_name:			.word output_character_name
ptr_to_read_character_name:				.word read_character_name
ptr_to_read_string_name:				.word read_string_name
ptr_to_output_string_name:				.word output_string_name
ptr_to_read_from_push_btns_name:		.word read_from_push_btns_name
ptr_to_illuminate_LEDs_name:			.word illuminate_LEDs_name
ptr_to_illuminate_RGB_LED_name:			.word illuminate_RGB_LED_name
ptr_to_read_tiva_push_button_name:		.word read_tiva_push_button_name
ptr_to_read_keypad_name:				.word read_keypad_name

ptr_to_read_from_push_btns_inst:		.word read_from_push_btns_inst
ptr_to_illuminate_LEDs_inst:	 		.word illuminate_LEDs_inst
ptr_to_illuminate_RGB_LED_inst: 		.word illuminate_RGB_LED_inst
ptr_to_read_tiva_push_button_inst: 		.word read_tiva_push_button_inst
ptr_to_read_keypad_inst:	 			.word read_keypad_inst

;ptr_to_:								.word


lab4s:
	PUSH {lr} ; Store register lr on stack

	BL uart_init
	BL gpio_btn_and_LED_init
	BL clr_page
	BL main_menu
lab4_loop:
	BL read_character
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
	CMP r0, #0x1B
	BEQ QUIT
	B lab4_loop


	 ; Your code is placed here
	POP {lr}
	MOV pc, lr
	;##################

clr_page:
	PUSH {lr}

	MOV r0, #0xC
	BL output_character

	POP {lr}
	MOV pc, lr
	;##################

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
	;##################

read_from_push_btns_menu:
	PUSH {lr}

	BL clr_page
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

	POP {lr}
	MOV pc, lr

illuminate_LEDs_menu:
	PUSH {lr}

	BL clr_page
	LDR r0, ptr_to_illuminate_LEDs_name
	BL output_string
	LDR r0, ptr_to_menu_prompt
	BL output_string
	LDR r0, ptr_to_illuminate_LEDs_inst
	BL output_string
	LDR r0, ptr_to_rerun_prompt
	BL output_string
	LDR r0, ptr_to_quit_prompt
	BL output_string

	POP {lr}
	MOV pc, lr

illuminate_RGB_LED_menu:
	PUSH {lr}

	BL clr_page
	LDR r0, ptr_to_illuminate_RGB_LED_name
	BL output_string
	LDR r0, ptr_to_menu_prompt
	BL output_string
	LDR r0, ptr_to_illuminate_RGB_LED_inst
	BL output_string
	LDR r0, ptr_to_rerun_prompt
	BL output_string
	LDR r0, ptr_to_quit_prompt
	BL output_string
illuminate_RGB_LED_handler:
	BL read_character
	SUB r0, r0, #48
	CMP r0, #1
	MOV r0, #0b

	POP {lr}
	MOV pc, lr

read_tiva_push_button_menu:
	PUSH {lr}

	BL clr_page
	LDR r0, ptr_to_illuminate_RGB_LED_name
	BL output_string
	LDR r0, ptr_to_menu_prompt
	BL output_string
	LDR r0, ptr_to_read_tiva_push_button_inst
	BL output_string
	LDR r0, ptr_to_rerun_prompt
	BL output_string
	LDR r0, ptr_to_quit_prompt
	BL output_string

	POP {lr}
	MOV pc, lr

read_keypad_menu:
	PUSH {lr}

	BL clr_page
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

	POP {lr}
	MOV pc, lr

QUIT:

.end
