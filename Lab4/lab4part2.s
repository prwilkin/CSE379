	.text
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
SYSCTL:			.word	0x400FE000	; Base address for System Control
GPIO_PORT_A:	.word	0x40004000	; Base address for GPIO Port A
GPIO_PORT_D:	.word	0x40007000	; Base address for GPIO Port D
RCGCGPIO:		.equ	0x608		; Offset for GPIO Run Mode Clock Gating Control Register
GPIODIR:		.equ	0x400		; Offset for GPIO Direction Register
GPIODEN:		.equ	0x51C		; Offset for GPIO Digital Enable Register
GPIODATA:		.equ	0x3FC		; Offset for GPIO Data Register
U0FR: 			.equ	0x18		; UART0 Flag Register
**************************************************************************************************

*********************************
* KEYPAD_INIT					;
* This subroutine initializes 	;
*	the daughter board keypad	;
*								;
* Authors:						;
*	Caroline Hart				;
*	Anthony Roberts				;
								;
* Register Usage:				;
*	R0	- stores an address		;
*	R1	- stores the contents	;
*		   of a memory register	;
keypad_init:					;
	PUSH {lr}					;
* Enable the clock for GPIO Port A and Port D
	LDR r1, SYSCTL				; Load base address of System Control
	LDRB r0, [r1,#RCGCGPIO]		; Load contents of RCGCGPIO register
	ORR r0, r0, #0x9			; Set bit 3 to enable and provide a clock to GPIO Port A & Port D
	STRB r0, [r1,#RCGCGPIO]		; Store modifed value of RCGCGPIO register back to memory
								;
* Set GPIO Port D, Pints 0-3 direction to Output
	LDR r1, GPIO_PORT_D			; Load base address of GPIO Port D
	LDRB r0, [r1, #GPIODIR] 	; Load contents of GPIODIR register
	ORR r0, r0, #0xF			; Set bits 0-3 to set GPIO direction to Output
	STRB r0, [r1, #GPIODIR] 	; Store modifed value of GPIODIR register back to memory
								;
* Set GPIO Port A, Pints 2-5 direction to Input
	LDR r1, GPIO_PORT_A			; Load base address of GPIO Port A
	LDRB r0, [r1, #GPIODIR] 	; Load contents of GPIODIR register
	BIC r0, r0, #0x3C			; Clear bits 2-5 to set GPIO direction to input
	STRB r0, [r1, #GPIODIR] 	; Store modifed value of GPIODIR register back to memory
								;
* Enable GPIO Port D, Pins 0-3 as Digital
	LDR r1, GPIO_PORT_D			; Load base address of GPIO Port D
	LDRB r0, [r1, #GPIODEN] 	; Load contents of GPIODEN register
	ORR r0, r0, #0xF			; Set bits 0-3 to set pins to digital
	STRB r0, [r1, #GPIODEN] 	; Store modifed value of GPIODEN register back to memory
								;
* Enable GPIO Port A, Pins 2-5 as Digital
	LDR r1, GPIO_PORT_A			; Load base address of GPIO Port A
	LDRB r0, [r1, #GPIODEN] 	; Load contents of GPIODEN register
	ORR r0, r0, #0x3C			; Set bits 2-5 to set pins to digital
	STRB r0, [r1, #GPIODEN] 	; Store modifed value of GPIODEN register back to memory
								;
* Enable GPIO Port D, Pins 0-3  ;
	LDR r1, GPIO_PORT_D			; Load base address of GPIO Port D
	LDRB r0, [r1, #GPIODATA] 	; Load contents of GPIODATA register
	ORR r0, r0, #0xF			; Set bits 0-3 to set pins to digital
	STRB r0, [r1, #GPIODATA] 	; Store modifed value of GPIODATA register back to memory
								;
	POP {pc}					; Return to caller
* END OF KEYPAD_INIT			;
*********************************

;UART_INIT_SUBROUTINE
uart_init:
	PUSH {lr}  ; Store register lr on stack

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
	MOV r1, #0x60
	STR r1, [r0]
	;Enable UART0 Control
	MOV r0, #0xC030		;set address to 0x4000C030
	MOVT r0, #0x4000
	MOV r1, #0x301
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

	POP {lr}
	mov pc, lr


;GPIO_BTN_AND_LED_INIT_SUBROUTINE
gpio_btn_and_LED_init:
	PUSH {lr} ; Store register lr on stack

;ENABLING 4 BUTTON ON ALICE EDUBASE BOARD
	;enabling clock for Port D
	MOV r0, #0xE000				;move memory address of clock to r0
    MOVT r0, #0x400F
    LDR r1, [r0, #0x608]		;load content of r0 with the offset of 0x608 to r1
    ORR r1, r1, #0x8			;set bit 4 to enable clock for Port D
    STR r1, [r0, #0x608]		;store r1  to r0 with offset of 0x608 enabling clock for Port D

    ;set GPIO Pin Direction as Input for Port D Pin 0 - 3
    MOV r0, #0x7000				;move memory address of Port D base address to r0
    MOVT r0, #0x4000
    LDR r1, [r0, #0x400]		;load content of r0 with offset of 0x400 to r1
    BIC r1, r1, #0xF			;bitwise manipulation to clear bit in Pin 0 - 3
    STR r1, [r0, #0x400]		;store r1 into GPIO Pin Direction as Input for Port D Pin 0 - 3

    ;Enable GPIO Pin 0 - 3 for Port D
    LDR r1, [r0, #0x51C]		;load content of r0 with offset of 0x51C to r1
	ORR r1, #0xF				;set bit 0 - 3 to enable GPIO Pin 0 - 3 for Port D
	STR r1, [r0, #0x51C]		;store r1 to r0 with offset of 0x51C enabling Port D Pin 0 - 3 as Digital Pin

	;Enable pull-up resistor for Port D Pin 0 - 3
	MOV r0, #0x7510				;move memory address of pull-up resistor for Port D
    MOVT r0, #0x4000
    LDR r1, [r0]				;load content of r0 with memory address of pull-up resistor for Port D to r1
	ORR r1, #0xF				;set bit 0 - 3 to enable pull-up resistor for Pin 0 - 3 for Port D
	STR r1, [r0]				;store r1 into r0 enabling pull-up resistor for Pin 0 - 3 for Port D

;ENABLING 4 RGB LIGHT ON ALICE EDUBASE BOARD
	;enabling clock for Port B
	MOV r0, #0xE000				;move memory address of clock to r0
	MOVT r0, #0x400F
	LDR r1, [r0, #0x608]		;load content of r0 with offset of 0x608 to r1
	ORR r1, #0x2				;set bit 1 to enable clock for Port B
	STR r1, [r0, #0x608]		;store r1 into r0 with offset of 0x608 enabling clock in Port B

	;set GPIO Pin Direction as Input for Port B Pin 0 - 3
	MOV r0, #0x5000				;move memory address of Port B base address to r0
	MOVT r0, #0x4000
	LDR r1, [r0, #0x400]		;load content of r0 with offset of 0x400 to r1
	ORR r1, #0xF				;bitwise manipluation to set bit 0 - 3 as 1 for Port B Pin 0 - 3
	STR r1, [r0, #0x400]		;store r1 into GPIO Pin Direction as Output for Port B Pin 0 - 3

	;Enable GPIO Pin 0 - 3 for Port B
	LDR r1, [r0, #0x51C]		;load content of r0 with offset of 0x51C to r1
	ORR r1, #0xF				;bitwise manipluation to set bit 0 - 3 as 1 for Port B Pin 0 - 3
	STR r1, [r0, #0x51C]		;store r1 to r0 with offset of 0x51C enabling Port B Pin 0 - 3 as Digital Pin

;ENABLING SWITCH 1 ON TIVA BOARD
	;enabling clock for Port F
	MOV r0, #0xE000				;move memory address of clock to r0
    MOVT r0, #0x400F
    LDR r1, [r0, #0x608]		;load content of r0 with offset of 0x608 to r1
    ORR r1, r1, #0x20			;set bit 6 to enable clock for Port F
    STR r1, [r0, #0x608]		;store r1 into r0 with offset of 0x608 enabling clock in Port F

    ;set GPIO Pin Direction as Input for Port F
    MOV r0, #0x5000				;move memory address of Port F base address to r0
    MOVT r0, #0x4002
    LDR r1, [r0, #0x400]		;load content of r0 with offset of 0x400 to r1
    BIC r1, r1, #0x10			;bitwise manipulation to clear bit 5 for Port F Pin 4
    STR r1, [r0, #0x400]		;store r1 into GPIO Pin Direction as Input for Port D Pin 0 - 3
    ;Enable GPIO Pin 4 for Port F
    LDR r1, [r0, #0x51C]		;load content of r0 wuth offset of 0x51C to r1
	ORR r1, #0x10				;bitwise manipluation to set bit 5 as 1 for Port F Pin 4
	STR r1, [r0, #0x51C]		;store r1 to r0 with offset of 0x51C enabling Port F Pin 4 as Digital Pin
	;Enable pull-up resistor for Port F
    LDR r1, [r0, #0x510]		;load content of r0 wuth offset of 0x510 to r1
	ORR r1, #0x10				;set bit 5 to enable pull-up resistor for Pin 5 for Port F
	STR r1, [r0, #0x510]		;store r1 into r0 enabling pull-up resistor for Pin 5 for Port F
	 ; Your code is placed here
	POP {lr}
	MOV pc, lr

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

	 ; Your code is placed here
	POP {lr}
	MOV pc, lr


read_string:
	PUSH {lr} ; Store register lr on stack
	 ; Your code is placed here
	POP {lr}
	MOV pc, lr


output_string:
	PUSH {lr} ; Store register lr on stack
	 ; Your code is placed here
	POP {lr}
	MOV pc, lr


read_from_push_btns:
	PUSH {lr} ; Store register lr on stack

	;READ PORT D PIN 0
	MOV r0, #0x7000				;move memory address of Port D base address to r0
    MOVT r0, #0x4000
	LDR r1, [r0, #GPIODATA]
	AND r1, #0x1
	CMP r1, #0x1
	BEQ equal1
	BNE notequal1
check1:
	AND r1, #0x2
	CMP r1, #0x2
	BEQ equal2
	BNE notequal2
check2:
	AND r1, #0x4
	CMP r1, #0x4
	BEQ equal3
	BNE notequal3
check3:
	AND r1, #0x8
	CMP r1, #0x8
	BEQ equal4
	BNE equal4
equal1:
	ORR r1, #0x8
	B check1
notequal1:
	ORR r1, #0x0
	B check1
equal2:
	ORR r1, #0x4
	B check2
notequal2:
	ORR r1, #0x0
	B check2
equal3:
	ORR r1, #0x2
	B check3
notequal3:
	ORR r1, #0x0
	B check3
equal4:
	ORR r1, #0x1
	B end
notequal4:
	ORR r1, #0x0
	B end
end:
	STR r1, [r0, #GPIODATA]

	POP {lr}
	MOV pc, lr


illuminate_LEDs:
	PUSH {lr} ; Store register lr on stack
	 ; Your code is placed here
	POP {lr}
	MOV pc, lr


illuminate_RGB_LED:
	PUSH {lr} ; Store register lr on stack
	 ; Your code is placed here
	POP {lr}
	MOV pc, lr


read_tiva_pushbutton:
	PUSH {lr} ; Store register lr on stack

loop:
	;Read Port F Pin 4
	MOV r0, #0x5000
    MOVT r0, #0x4002
	LDR r1, [r0, #GPIODATA]
	AND r1, #0x10
	CMP r1, #0x10
	BEQ one						;if it 1 branch to one
	BNE zero					;if it 0 branch to zero
one:
	MOV r0, #0					;set r0 as 1 (High)
zero:
	MOV r0, #1					;set r0 as 0 (Low)

	B loop
	POP {lr}
	MOV pc, lr


read_keypad:
	PUSH {lr} ; Store register lr on stack
	 ; Your code is placed here
	POP {lr}
	MOV pc, lr

.end
