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
lab4:
	PUSH {lr} ; Store register lr on stack

	 ; Your code is placed here
	POP {lr}
	MOV pc, lr
.end
