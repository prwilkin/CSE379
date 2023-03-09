	text
	.global uart_init
	.global gpio_btn_and_LED_init
	.global keypad_init ; Downloaded from the course website
	.global output_character
	.global read_character
	.global read_string
	.global output_string
	.global read_from_push_btns
	.global illuminate_LEDs
	.global illuminate_RGB_LED
	.global read_tiva_push_button
	.global read_keypad

**************************************************************************************************
SYSCTL:		.word	0x400FE000	; Base address for System Control
GPIO_PORT_D:	.word	0x40007000	; Base address for GPIO Port D
RCGCGPIO:	.word	0x608		; Offset for GPIO Run Mode Clock Gating Control Register
GPIODIR:	.word	0x400		; Offset for GPIO Direction Register
GPIODEN		.word	0x51C		; Offset for GPIO Digital Enable Register
**************************************************************************************************

uart_init:
	POP {lr} ; Store register lr on stack
	;Provide clock to UART0
	MOV r0, #0xE618
	MOVT r0, #0x400F	;set address to 0x400FE618
	MOV r1, #0x1		;mark bit #0 as 1
	STR r1,	[r0]		;store @ address
	;Enable clock to PortA
	MOV r0, #0xE608		;set address to 0x400FE608
	MOVT r0, #0x400F
	MOV r1, #0x1		;mark bit #0 as 1
	STR r1, [r0]		;store @ address
	;Disable UART0 Control
	MOV r0, #0xC030
	MOVT r0, #0x4000	;set address to 0x4000C030
	MOV r1, #0x0
	STR r1, [r0]		;store @ address
	;Set UART0_IBRD_R for 115,200 baud
	MOV r0, #0xC024		;set address to 0x4000C024
	MOVT r0, #0x4000
	MOV r1, #0x8
	STR r1, [r0]		;store @ address
	;Set UART0_FBRD_R for 115,200 baud
	MOV r0, #0xC028		;set address to 0x4000C028
	MOVT r0, #0x4000
	MOV r1, #0x2C
	STR r1, [r0]
	;Use System Clock
	MOV r0, #0xCFC8		;set address to 0x4000CFC8
	MOVT r0, #0x4000
	MOV r1, #0x0
	STR r1, [r0]
	;Use 8-bit word length, 1 stop bit, no parity
	MOV r0, #0xC02C		;set address to 0x4000C02C
	MOVT r0, #0x4000
	MOV r1, #0x3C
	STR r1, [r0]
	;Enable UART0 Control
	MOV r0, #0xC030		;set address to 0x4000C030
	MOVT r0, #0x4000
	MOV r1, #12D
	STR r1, [r0]
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

		; Your code for your uart_init routine is placed here
	 ; Your code is placed here
	POP {lr}
	MOV pc, lr

gpio_btn_and_LED_init:
	POP {lr} ; Store register lr on stack

	;ENABLING 4 BUTTON ON ALICE EDUBASE BOARD
	;enabling clock for Port D
	MOV r0, #0xE000
    MOVT r0, #0x400F
    LDR r1, [r0, #0x608]		;load r0 to r1
    ORR r1, r1, #0x8			;bitwise manipulation for Port F
    STR r1, [r0, #0x608]
    ;set GPIO Pin Direction as Input for Port D Pin 0 - 3
    MOV r0, #0x7000
    MOVT r0, #0x4000
    LDR r1, [r0, #0x400]
    AND r1, r1, #0xF
    STR r1, [r0, #0x400]		;store 0 into GPIO Pin Direction as Input for Port D Pin 0 - 3
    ;Enable GPIO Pin 0 - 3 for Port D
    LDR r1, [r0, #0x51C]
	ORR r1, #0xF
	STR r1, [r0, #0x51C]		;store 1 into Port D Pin 0 - 3
	;Enable pull-up resistor for Port D Pin 0 - 3
	MOV r0, #0x7510
    MOVT r0, #0x4000
    LDR r1, [r0]
	ORR r1, #0xF
	STR r1, [r0]

	;system clock
	MOV r0, #0xE000
	MOVT r0, #0x400F
	LDR r1, [r0, #0x608]
	ORR r1, #0x2
	STR r1, [r0, #0x608]

	;set direction
	MOV r0, #0x5000
	MOVT r0, #0x4000
	LDR r1, [r0, #0x400]
	ORR r1, #0xF
	STR r1, [r0, #0x400]

	;set type (digital)
	LDR r1, [r0, #0x51C]
	ORR r1, #0xF
	STR r1, [r0, #0x51C]

	;led fireworks
	LDR r1, [r0, #0x3FC]
	ORR r1, #0xF
	STR r1, [r0, #0x3FC]

	 ; Your code is placed here
	POP {lr}
	MOV pc, lr

keypad_init:
	PUSH {lr}

	* Enable the clock for GPIO Port D
	LDR r1, SYSCTL		; Load base address of System Control
	LDRB r0, [r1,#RCGCGPIO] ; Load contents of RCGCGPIO register
	ORR r0, r0, #8		; Set bit 3 to enalbe and provide a clock to GPIO Port D
	STRB r0, [r1,#RCGCGPIO] ; Store modifed value of RCGCGPIO register back to memory

	* Set GPIO Port D, Pints 0-3 direction to Input
	LDR r1, GPIO_PORT_D	; Load base address of GPIO Port D
	LDRB r0, [r1,#GPIODIR] 	; Load contents of GPIODIR register
	BIC r0, r0, #0xF	; Clear bits 0-3 to set GPIO direction to input
	STRB r0, [r1,#GPIODIR] 	; Store modifed value of GPIODIR register back to memory

	* Enable GPIO Port D, Pins 0-3 as Digital
	LDRB r0, [r1,#GPIODEN] 	; Load contents of GPIODEN register
	ORR r0, r0, #xF		; Set bits 0-3 to set pins to digital
	STRB r0, [r1,#GPIODEN] 	; Store modifed value of GPIODEN register back to memory

	POP {lr}

output_character:
	PUSH {lr}   ; Store register lr on stack

output_character_loop:
	MOV r2, #0xC000
 	MOVT r2, #0x4000
	LDRB r1, [r2, #U0FR]	;get TxFF bit
	AND r1, #0x20			;isolate 0xFF bit
	CMP r1, #0				;if bit 1 branch
	BNE output_character_loop
	STRB r0, [r2]			;if 0 store in data
		; Your code for your output_character routine is placed here

	POP {lr}
	mov pc, lr
	;############ output_character


read_character:
	PUSH {lr} ; Store register lr on stack

	read_character_loop:
	MOV r2, #0xC000
 	MOVT r2, #0x4000
	LDRB r1, [r2, #U0FR]	;get RxFE bit
	AND r1, #0x10			;isolate OxFE bit
	CMP r1, #0x10			;if bit 1 branch
	BEQ read_character_loop
	LDRB r0, [r2]			;if 0 store in data
		; Your code for your read_character routine is placed here

	POP {lr}
	mov pc, lr
	 ; Your code is placed here
	POP {lr}
	MOV pc, lr

read_string_loop:
	PUSH {r0}	;push addy
	BL read_character
NULL_set_num_string:
	CMP r0, #0x0D	;check for cr char
	BNE STORE_num_string
	MOV r0, #0x00	;if CR convert to NULL
STORE_num_string:
	MOV r1, r0		;store char from read_character in r1
	POP {r0}		;
	STRB r1, [r0]	;store
	ADD r0, r0, #1	;increment addy
	PUSH {r0}		;push addy to stack
	MOV r0, r1		;store char for output_character
	BL output_character
	CMP r0, #0x00
	POP {r0}		;pop addy from stack
	BNE read_string_loop
		; Your code for your read_string routine is placed here
end_read_string:
	POP {lr}
	mov pc, lr
	;############ read_string


output_string:
	PUSH {lr}   ; Store register lr on stack

	;Pat
output_string_loop:
	MOV r1, r0		;store addy in r1
	PUSH {r0}		;push addy to stack
LOAD_num_string:
	LDRB r0, [r1]	;load char
	CMP r0, #0x00	;check for NULL char
	BEQ end_output_string
	BL output_character
	POP {r0}		;pop addy from stack
	ADD r0, r0, #1	;increment addy
	B output_string_loop

		; Your code for your output_string routine is placed here
end_output_string:
	POP {r0}
	POP {lr}
	mov pc, lr
	;############ output_string


read_from_push_btns:
	PUSH {lr} ; Store register lr on stack
	 ; Your code is placed here
	POP {lr}
	MOV pc, lr
illuminate_LEDs:
	PUSH {lr} ; Store register lr on stack
	 ; Your code is placed here
	POP {lr}
	MOV pc, lr
illuminate_RGB_LED:
	PUSH {lr}
		;Red P1 Green P3 Blue P2
		;system clock
		MOV r1, #0xE000		;0x400FE000
		MOVT r1, #0x400F
		LDR r2, [r1, #0x608]
		ORR r2, #0x20
		STR r2, [r1, #0x608]

		;set direction
		MOV r1, #0x5000
		MOVT r1, #0x4002
		LDR r2, [r1, #0x400]
		ORR r2, #0xE
		STR r2, [r1, #0x400]

		;set type (digital)
		LDR r2, [r1, #0x51C]
		ORR r2, #0xE
		STR r2, [r1, #0x51C]

		;led fireworks
		LDR r0, [r1, #0x3FC]
		ORR r0, #0xE
		STR r0, [r1, #0x3FC]
          ; Your code is placed here

	POP {lr}
	MOV pc, lr

read_tiva_pushbutton:
	PUSH {lr} ; Store register lr on stack
	 ;Read Port F Pin 4
	MOV r0, #0x5000
    MOVT r0, #0x4002
	LDR r1, [r0, #0x3FC]		;load r1 from GPIODATA to read if it 0 or 1
	AND r1, #0x10
	CMP r1, #1
	BEQ one						;if it 1 branch to one
	BNE zero					;if it 0 branch to zero
one:
	MOV r0, #1					;set r0 as 1 (High)
zero:
	MOV r0, #0					;set r0 as 0 (Low)
          ; Your code is placed here

	POP {lr}
	MOV pc, lr
read_keypad:
	PUSH {lr} ; Store register lr on stack
	 ; Your code is placed here
	POP {lr}
	MOV pc, lr
.end
