	.data
menu_prompt: 					.string "Testing Menu",0xA,0xD,0x00
output_character_prompt: 		.string "Test ouput_character: Press [1]",0xA,0xD,0x00
read_character_prompt: 			.string "Test read_chracter: Press [2]",0xA,0xD,0x00
read_string_prompt: 			.string "Test read_string: Press [3]",0xA,0xD,0x00
output_string_prompt: 			.string "Test output_string: Press [4]",0xA,0xD,0x00
read_from_push_btns_prompt: 	.string "Test read_from_push_btns: Press [5]",0xA,0xD,0x00
illuminate_LEDs_prompt: 		.string "Test illuminate_LEDs: Press [6]",0xA,0xD,0x00
illuminate_RGB_LED_prompt: 		.string "Test illuminate_RGB_LED: Press [7]",0xA,0xD,0x00
read_tiva_push_button_prompt: 	.string "Test read_tiva_push_button: Press [8]",0xA,0xD,0x00
read_keypad_prompt: 			.string "Test read_keypad: Press [9]",0xA,0xD,0x00
quit_prompt:					.string "To quit: Press [ESC]",0xA,0xD,0x00

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


lab4:
	PUSH {lr} ; Store register lr on stack
	

	 ; Your code is placed here
	POP {lr}
	MOV pc, lr
.end
