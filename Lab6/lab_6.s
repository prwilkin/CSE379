	.data

	 .global topNbottom
	 .global row1
	 .global row2
	 .global row3
	 .global row4
	 .global row5
	 .global row6
	 .global row7
	 .global row8
	 .global row9
	 .global row10
	 .global row11
	 .global row12
	 .global row13
	 .global row14
	 .global row15
	 .global row16
	 .global row17
	 .global row18
	 .global row19
	 .global row20
	 .global cordinatesNow
	 .global cordinatesNext
	 .global direction
	 .global hit
	 .global moves

	.text

	.global lab6
	.global game

	.global uart_init
	.global uart_interrupt_init
	.global gpio_interrupt_init
	.global UART0_Handler
	.global Switch_Handler
	.global Timer_Handler
	.global simple_read_character
	.global output_character
	.global output_string
	.global clr_page
	.global new_line
	.global int2string
	.global decode
	.global encode
	.global checker
	.global mover
	.global printer

ptr_to_cordinatesNow:	.word cordinatesNow
ptr_to_cordinatesNext:	.word cordinatesNext


lab6:
	PUSH {lr}

	BL uart_init
	BL uart_interrupt_init
	BL gpio_interrupt_init
	;BL
	BL clr_page
loop:
	B loop

	POP {lr}
	MOV pc, lr

game:
	PUSH {lr}

	BL checker
	BL mover
	BL printer
	LDR r0, ptr_to_cordinatesNext
	LDR r0, [r0]
	LDR r1, ptr_to_cordinatesNow
	STR r0, [r1]

	POP {lr}
	MOV pc, lr


.end
