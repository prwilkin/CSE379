	.data

	.global prompt
	.global mydata

prompt:	.string "You pressed the button # times",0xA,0xD, "Your key presses:",0xA,0xD,0x00
mydata:	.byte	0x20	; This is where you can store data.
			; The .byte assembler directive stores a byte
			; (initialized to 0x20) at the label mydata.
			; Halfwords & Words can be stored using the
			; directives .half & .word

	.text

	.global uart_interrupt_init
	.global gpio_interrupt_init
	.global UART0_Handler
	.global Switch_Handler
	.global Timer_Handler		; This is needed for Lab #6
	.global simple_read_character
	.global output_character	; This is from your Lab #4 Library
	.global read_string		; This is from your Lab #4 Library
	.global output_string		; This is from your Lab #4 Library
	.global uart_init		; This is from your Lab #4 Library
	.global lab5

**************************************************************************************************
SYSCTL:			.word	0x400FE000	; Base address for System Control
GPIO_PORT_A:	.word	0x40004000	; Base address for GPIO Port A
GPIO_PORT_B:	.word	0x40005000	; Base address for GPIO Port B
GPIO_PORT_D:	.word	0x40007000	; Base address for GPIO Port D
GPIO_PORT_F:	.word	0x40025000	; Base address for GPIO Port F
RCGCGPIO:		.equ	0x608		; Offset for GPIO Run Mode Clock Gating Control Register
GPIODIR:		.equ	0x400		; Offset for GPIO Direction Register
GPIODEN:		.equ	0x51C		; Offset for GPIO Digital Enable Register
GPIODATA:		.equ	0x3FC		; Offset for GPIO Data
UART0:			.word	0x4000C000	; Base address for UART0
U0FR: 			.equ 	0x18		; UART0 Flag Register
**************************************************************************************************

ptr_to_prompt:		.word prompt
ptr_to_mydata:		.word mydata




lab5:	; This is your main routine which is called from your C wrapper
	PUSH {lr}   		; Store lr to stack
	ldr r4, ptr_to_prompt
	ldr r5, ptr_to_mydata
	MOV r6, #0				;counter for button presses
	LDR r7, ptr_to_mydata	;data for characters pressed

    bl uart_init
	bl uart_interrupt_init
	bl gpio_interrupt_init

	; This is where you should implement a loop, waiting for the user to
	; enter a q, indicating they want to end the program.

	POP {lr}		; Restore lr from the stack
	MOV pc, lr


uart_init:
	PUSH {lr}
	;Provide clock to UART0
	LDR r0, SYSCTL			;set address to System Control
	MOV r1, #0x1			;mark bit #0 as 1
	STR r1,	[r0, #0x618]	;store @ address
	;Enable clock to PortA
	MOV r1, #0x1			;mark bit #0 as 1
	STR r1, [r0, #0x608]	;store @ address
	;Disable UART0 Control
	LDR r0, UART0			;set address to UART0
	MOV r1, #0x0
	STR r1, [r0, #0x30]		;store @ address
	;Set UART0_IBRD_R for 115,200 baud
	MOV r1, #0x8
	STR r1, [r0, #0x24]		;store @ address
	;Set UART0_FBRD_R for 115,200 baud
	MOV r1, #0x2C
	STR r1, [r0, #0x28]
	;Use System Clock
	MOV r1, #0x0
	STR r1, [r0, #0xFC8]
	;Use 8-bit word length, 1 stop bit, no parity
	MOV r1, #0x60
	STR r1, [r0, #0x2C]
	;Enable UART0 Control
	MOV r1, #0x301
	STR r1, [r0, #0x30]
	;Make PA0 and PA1 as Digital Ports
	MOV r0, #0x451C		;set address to 0x4000451C
	MOVT r0, #0x4000
	LDR r1, [r0]
	ORR r1, r1, #0x03
	STR r1, [r0]
	;Change PA0,PA1 to Use an Alternate Function
	MOV r0, #0x4420		;set address to 0x40004420
	MOVT r0, #0x4000
	LDR r1, [r0]
	ORR r1, r1, #0x03
	STR r1, [r0]
	;Configure PA0 and PA1 for UART
	MOV r0, #0x452C		;set address to 0x4000452C
	MOVT r0, #0x4000
	LDR r1, [r0]
	ORR r1, r1, #0x11
	STR r1, [r0]

	POP {lr}
	MOV pc, lr

uart_interrupt_init:

	PUSH {lr} ; Store register lr on stack
	;Configuring the UART for Interrupts
	LDR r0, UART0
	LDR r1, [r0, #0x038]
	ORR r1, #0x10
	STR r1, [r0, #0x038]
	;Configure Processor to allow UART0 to Interrupt Processor (EN0)
	MOV r0, #0xE000		;set address to 0xE000E000
	MOVT r0, #0xE000
	LDR r1, [r0, #0x100]
	ORR r1, r1, #0x20
	STR r1, [r0, #0x100]

	; Your code to initialize the UART0 interrupt goes here
	POP {lr}
	MOV pc, lr



gpio_interrupt_init:
	;ENABLING SWITCH 1 ON TIVA BOARD
	;enabling clock for Port F
	LDR r0, SYSCTL				;load memory address of clock to r0
    LDR r1, [r0, #0x608]		;load content of r0 with offset of 0x608 to r1
    ORR r1, r1, #0x20			;set bit 6 to enable clock for Port F
    STR r1, [r0, #0x608]		;store r1 into r0 with offset of 0x608 enabling clock in Port F

    ;set GPIO Pin Direction as Input for Port F
    LDR r0, GPIO_PORT_F		;move memory address of Port F base address to r0
    LDR r1, [r0, #0x400]		;load content of r0 with offset of 0x400 to r1
    BIC r1, r1, #0x10			;bitwise manipulation to clear bit 5 for Port F Pin 4
    STR r1, [r0, #0x400]		;store r1 into GPIO Pin Direction as Input for Port F Pin 4

    ;Enable GPIO Pin 4 for Port F to Digital
    LDR r1, [r0, #0x51C]		;load content of r0 wuth offset of 0x51C to r1
	ORR r1, #0x10				;bitwise manipluation to set bit 5 as 1 for Port F Pin 4
	STR r1, [r0, #0x51C]		;store r1 to r0 with offset of 0x51C enabling Port F Pin 4 as Digital Pin

	;Enable pull-up resistor for Port F
    LDR r1, [r0, #0x510]		;load content of r0 wuth offset of 0x510 to r1
	ORR r1, #0x10				;set bit 5 to enable pull-up resistor for Pin 5 for Port F
	STR r1, [r0, #0x510]		;store r1 into r0 enabling pull-up resistor for Pin 5 for Port F

	;Set Edge Sensitive for Port F Pin 4
	LDR r0, GPIO_PORT_F
	LDR r1, [r0, #0x404]
	ORR r1, #0x10
	STR r1, [r0, #0x404]

	;Setup the Interrupt for Edge Sensitive via the GPIO Interrupt Both Edges Register for Port F Pin 4
	LDR r1, [r0, #0x408]
	ORR r1, #0x10
	STR r1, [r0, #0x408]

	;Setting the Interrupt for Falling Edge Triggering via the GPIO Interrupt Event Register for Port F Pin 4
	LDR r1, [r0, #0x40C]
	BIC r1, #0x10				;clear bit 4 to enable the falling edge for Port F Pin 4
	STR r1, [r0, #0x40C]

	;Enabling the Interrupt for Port F Pin 4
	LDR r1, [r0, #0x410]
	ORR r1, #0x10
	STR r1, [r0, #0x410]

	;Configure Processor to Allow GPIO Port F to Interrupt Processor
	MOV r0, #0xE000
	MOVT r0, #0xE000
	LDR r1, [r0, #0x100]
	ORR r1, #0x20000000
	LDR r1, [r0, #0x100]

	; Your code to initialize the SW1 interrupt goes here
	; Don't forget to follow the procedure you followed in Lab #4
	; to initialize SW1.

	MOV pc, lr


UART0_Handler:
	LDR r0, UART0
	LDR r1, [r0, #0x044]
	ORR r1, #0x10			;MASK bit
	STR r1, [r0, #0x044]	;reset interupt flag
	BL simple_read_character
	STRB r0, [r7]


	; Your code for your UART handler goes here.
	; Remember to preserver registers r4-r11 by pushing then popping
	; them to & from the stack at the beginning & end of the handler

	BX lr       	; Return


Switch_Handler:
	LDR r0, GPIO_PORT_F
	LDR r1, [r0, #0x41C]
	ORR r1, #0x10
	STR r1, [r0, #0x41C]

	; Your code for your UART handler goes here.
	; Remember to preserver registers r4-r11 by pushing then popping
	; them to & from the stack at the beginning & end of the handler

	BX lr       	; Return


Timer_Handler:

	; Your code for your Timer handler goes here.  It is not needed
	; for Lab #5, but will be used in Lab #6.  It is referenced here
	; because the interrupt enabled startup code has declared Timer_Handler.
	; This will allow you to not have to redownload startup code for
	; Lab #6.  Instead, you can use the same startup code as for Lab #5.
	; Remember to preserver registers r4-r11 by pushing then popping
	; them to & from the stack at the beginning & end of the handler.

	BX lr       	; Return


simple_read_character:
	PUSH {lr}   ; Store register lr on stack
	LDR r2, UART0
	LDRB r0, [r2]			;load data

	POP {lr}
	MOV pc, lr
	;############################################# simple_read_character END #############################################

;OUTPUT_CHARACTER_SUBROUTINE
output_character:
	PUSH {lr}   ; Store register lr on stack

output_character_loop:
	LDR r2, UART0
	LDRB r1, [r2, #U0FR]		;get TxFF bit
	AND r1, #0x20				;isolate 0xFF bit
	CMP r1, #0					;if bit 1 branch
	BNE output_character_loop
	STRB r0, [r2]				;if 0 store in data

	POP {lr}
	MOV pc, lr
	;############################################# output_character END #############################################


;READ_STRING_SUBROUTINE
read_string:
	PUSH {lr}   ; Store register lr on stack
read_string_loop:
	PUSH {r0}				;push addy
	BL simple_read_character
NULL_set_num_string:
	CMP r0, #0x0D			;check for cr char
	BNE STORE_num_string
	MOV r0, #0x00			;if CR convert to NULL
STORE_num_string:
	MOV r1, r0				;store char from read_character in r1
	POP {r0}
	STRB r1, [r0]			;store
	ADD r0, r0, #1			;increment addy
	PUSH {r0}				;push addy to stack
	MOV r0, r1				;store char for output_character
	BL output_character
	CMP r0, #0x00
	POP {r0}				;pop addy from stack
	BNE read_string_loop

end_read_string:
	POP {lr}
	MOV pc, lr
	;############################################# read_string END #############################################


;OUTPUT_STRING SUBROUTINE
output_string:
	PUSH {lr}   			; Store register lr on stack

output_string_loop:
	MOV r1, r0				;store addy in r1
	PUSH {r0}				;push addy to stack
LOAD_num_string:
	LDRB r0, [r1]			;load char
	CMP r0, #0x00			;check for NULL char
	BEQ end_output_string
	CMP r0, #0x23			;check for #
	BNE no_number
	MOV r0, r4				;print number
no_number:
	BL output_character
	POP {r0}				;pop addy from stack
	ADD r0, r0, #1			;increment addy
	B output_string_loop

end_output_string:
	POP {r0}
	POP {lr}
	MOV pc, lr
	;############################################# output_string END #############################################

post_interupt:
	PUSH {lr}
	BL clr_page
	MOV r0, #0x00
	STRB r0, [r7]
	LDR r0, ptr_to_prompt
	BL output_string
	LDR r0, ptr_to_mydata
	BL output_string

	MOV pc, lr
	;############################################# post_interupt END #############################################

clr_page:
	PUSH {lr}

	MOV r0, #0xC
	BL output_character

	POP {lr}
	MOV pc, lr
	;############################################# clr_page END #############################################


.end
