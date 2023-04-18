	.text
	.global lab4
	.global uart_init 						;Line 30
	.global gpio_btn_and_LED_init			;Line 90
	.global keypad_init 					;Line 180 Downloaded from the course website
	.global output_character				;Line 210
	.global read_character					;Line 230
	.global read_string						;Line 250
	.global output_string					;Line 270
	.global read_from_push_btns				;Line 290
	.global illuminate_LEDs					;Line 360
	.global illuminate_RGB_LED				;Line 370
	.global read_tiva_push_button			;Line 390
	.global read_keypad						;Line 410
	;listed in order they appear in file
	;line #'s are rough estimates

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

;UART_INIT_SUBROUTINE
uart_init:
	PUSH {lr} ; Store register lr on stack
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
	;############################################# uart_init END #############################################

;GPIO_BTN_AND_LED_INIT_SUBROUTINE
gpio_btn_and_LED_init:
	PUSH {lr} ; Store register lr on stack

;ENABLING 4 BUTTON ON ALICE EDUBASE BOARD
	;enabling clock for Port D
	LDR r0, SYSCTL				;move memory address of clock to r0
    LDR r1, [r0, #0x608]		;load content of r0 with the offset of 0x608 to r1
    ORR r1, r1, #0x8			;set bit 4 to enable clock for Port D
    STR r1, [r0, #0x608]		;store r1  to r0 with offset of 0x608 enabling clock for Port D

    ;set GPIO Pin Direction as Input for Port D Pin 0 - 3
    LDR r0, GPIO_PORT_D				;move memory address of Port D base address to r0
    LDR r1, [r0, #0x400]		;load content of r0 with offset of 0x400 to r1
    BIC r1, r1, #0xF			;bitwise manipulation to clear bit in Pin 0 - 3
    STR r1, [r0, #0x400]		;store r1 into GPIO Pin Direction as Input for Port D Pin 0 - 3

    ;Enable GPIO Pin 0 - 3 for Port D
    LDR r1, [r0, #0x51C]		;load content of r0 with offset of 0x51C to r1
	ORR r1, #0xF				;set bit 0 - 3 to enable GPIO Pin 0 - 3 for Port D
	STR r1, [r0, #0x51C]		;store r1 to r0 with offset of 0x51C enabling Port D Pin 0 - 3 as Digital Pin

;ENABLING 4 LED LIGHT ON ALICE EDUBASE BOARD
	;enabling clock for Port B
	LDR r0, SYSCTL				;move memory address of clock to r0
	LDR r1, [r0, #0x608]		;load content of r0 with offset of 0x608 to r1
	ORR r1, #0x2				;set bit 1 to enable clock for Port B
	STR r1, [r0, #0x608]		;store r1 into r0 with offset of 0x608 enabling clock in Port B

	;set GPIO Pin Direction as Output for Port B Pin 0 - 3
	LDR r0, GPIO_PORT_B		;move memory address of Port B base address to r0
	LDR r1, [r0, #0x400]		;load content of r0 with offset of 0x400 to r1
	ORR r1, #0xF				;bitwise manipluation to set bit 0 - 3 as 1 for Port B Pin 0 - 3
	STR r1, [r0, #0x400]		;store r1 into GPIO Pin Direction as Output for Port B Pin 0 - 3

	;Enable GPIO Pin 0 - 3 for Port B
	LDR r1, [r0, #0x51C]		;load content of r0 with offset of 0x51C to r1
	ORR r1, #0xF				;bitwise manipluation to set bit 0 - 3 as 1 for Port B Pin 0 - 3
	STR r1, [r0, #0x51C]		;store r1 to r0 with offset of 0x51C enabling Port B Pin 0 - 3 as Digital Pin

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

;ENABLING RGB LIGHT ON TIVA C
	;enabling clock for Port F
	LDR r0, SYSCTL			;move memory address of clock to r0
	LDR r1, [r0, #0x608]		;load content of r0 with offset of 0x608 to r1
	ORR r1, #0x20				;set bit 6 to enable clock for Port F
	STR r1, [r0, #0x608]		;store r1 into r0 with offset of 0x608 enabling clock in Port F

	;set GPIO Pin Direction as Output for Port F Pin 1 - 3
	LDR r0, GPIO_PORT_F		;move memory address of Port F base address to r0
	LDR r1, [r0, #0x400]		;load content of r0 with offset of 0x400 to r1
	ORR r1, #0xE				;bitwise manipluation to set bit 1 - 3 as 1 for Port F Pin 1 - 3
	STR r1, [r0, #0x400]		;store r1 into GPIO Pin Direction as Output for Port F Pin 1 - 3

	;Enable GPIO Pin 1 - 3 for Port F to to Digital
	LDR r1, [r0, #0x51C]		;load content of r0 wuth offset of 0x51C to r1
	ORR r1, #0xA				;bitwise manipluation to set bit 1 - 3 as 1 for Port F Pin 1 - 3
	STR r1, [r0, #0x51C]		;store r1 to r0 with offset of 0x51C enabling Port F Pin 1 - 3 as Digital Pin

	POP {lr}
	MOV pc, lr
	;############################################# gpio_btn_and_LED_init END #############################################

keypad_init:
	PUSH {lr}
* Enable the clock for GPIO Port A and Port D
	LDR r1, SYSCTL				; Load base address of System Control
	LDRB r0, [r1,#RCGCGPIO]		; Load contents of RCGCGPIO register
	ORR r0, r0, #0x9			; Set bit 3 to enable and provide a clock to GPIO Port A & Port D
	STRB r0, [r1,#RCGCGPIO]		; Store modifed value of RCGCGPIO register back to memory

* Set GPIO Port D, Pints 0-3 direction to Output
	LDR r1, GPIO_PORT_D			; Load base address of GPIO Port D
	LDRB r0, [r1, #GPIODIR] 	; Load contents of GPIODIR register
	ORR r0, r0, #0xF			; Set bits 0-3 to set GPIO direction to Output
	STRB r0, [r1, #GPIODIR] 	; Store modifed value of GPIODIR register back to memory

* Set GPIO Port A, Pins 2-5 direction to Input
	LDR r1, GPIO_PORT_A			; Load base address of GPIO Port A
	LDRB r0, [r1, #GPIODIR] 	; Load contents of GPIODIR register
	BIC r0, r0, #0x3C			; Clear bits 2-5 to set GPIO direction to input
	STRB r0, [r1, #GPIODIR] 	; Store modifed value of GPIODIR register back to memory

* Enable GPIO Port D, Pins 0-3 as Digital
	LDR r1, GPIO_PORT_D			; Load base address of GPIO Port D
	LDRB r0, [r1, #GPIODEN] 	; Load contents of GPIODEN register
	ORR r0, r0, #0xF			; Set bits 0-3 to set pins to digital
	STRB r0, [r1, #GPIODEN] 	; Store modifed value of GPIODEN register back to memory

* Enable GPIO Port A, Pins 2-5 as Digital
	LDR r1, GPIO_PORT_A			; Load base address of GPIO Port A
	LDRB r0, [r1, #GPIODEN] 	; Load contents of GPIODEN register
	ORR r0, r0, #0x3C			; Set bits 2-5 to set pins to digital
	STRB r0, [r1, #GPIODEN] 	; Store modifed value of GPIODEN register back to memory

* Enable GPIO Port D, Pins 0-3  ;
	LDR r1, GPIO_PORT_D			; Load base address of GPIO Port D
	LDRB r0, [r1, #GPIODATA] 	; Load contents of GPIODATA register
	ORR r0, r0, #0xF			; Set bits 0-3 to set pins to digital
	STRB r0, [r1, #GPIODATA] 	; Store modifed value of GPIODATA register back to memory

	POP {pc}					; Return to caller
	MOV pc, lr
	;############################################# keypad_init END #############################################


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


;READ_CHARACTER_SUBROUTINE
read_character:
	PUSH {lr}   ; Store register lr on stack
	LDR r2, UART0

read_character_loop:
	LDRB r1, [r2, #U0FR]	;get RxFE bit
	AND r1, #0x10			;isolate OxFE bit
	CMP r1, #0x10			;if bit 1 branch
	BEQ read_character_loop
	LDRB r0, [r2]			;load data

end_read_character:
	POP {lr}
	MOV pc, lr
	;############################################# read_character END #############################################

;READ_STRING_SUBROUTINE
read_string:
	PUSH {lr}   ; Store register lr on stack
read_string_loop:
	PUSH {r0}				;push addy
	BL read_character
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
	BL output_character
	POP {r0}				;pop addy from stack
	ADD r0, r0, #1			;increment addy
	B output_string_loop

end_output_string:
	POP {r0}
	POP {lr}
	MOV pc, lr
	;############################################# output_string END #############################################


;READ_FROM_PUSH_BTNS_SUBROUTINE
read_from_push_btns:
	PUSH {lr} ; Store register lr on stack

	;READ PORT D
	LDR r0, GPIO_PORT_D		;move memory address of Port D base address to r0
read_from_push_btns_loop:
	LDR r1, [r0, #GPIODATA]		;load r0 with to offset of #GPIODATA to r1
	MOV r2, r1					;copy r1 to r2
	MOV r3, #0x0				;set r3 as 0x0
	AND r2, #0x1				;bit masking
	CMP r2, #0x1				;compare r2 with 0x1
	BEQ equal1					;branch if r2 does equal to 0x1
	BNE notequal1				;branch if r2 does not equal to 0x1
check1:
	MOV r2, r1					;copy r1 to r2
	AND r2, #0x2				;bit masking
	CMP r2, #0x2				;compare r2 with 0x2
	BEQ equal2					;branch if r2 does equal to 0x2
	BNE notequal2				;branch if r2 does not equal to 0x2
check2:
	MOV r2, r1					;copy r1 to r2
	AND r2, #0x4				;bit masking
	CMP r2, #0x4				;compare r2	with 0x4
	BEQ equal3					;branch if r2 does equal to 0x4
	BNE notequal3				;branch if r2 does not equal to 0x4
check3:
	MOV r2, r1					;copy r1 to r2
	AND r2, #0x8				;bit masking
	CMP r2, #0x8				;compare r2 wih 0x8
	BEQ equal4					;branch if r2 does equal to 0x8
	BNE notequal4					;branch if r2 does not equal to 0x8
equal1:
	ORR r3, #0x1				;set bit 0 in r3
	B end						;branch to end
notequal1:
	ORR r3, #0x0				;does not do anything to the bit in r3
	B check1					;branch back to check the second button
equal2:
	ORR r3, #0x2				;set bit 1 in r3
	B end						;branch to end
notequal2:
	ORR r3, #0x0				;does not do anything to the bit in r3
	B check2					;branch back to check the third button
equal3:
	ORR r3, #0x4				;set bit 2 in r3
	B end						;branch to end
notequal3:
	ORR r3, #0x0				;does not do anything to the bit in r3
	B check3					;branch back to check the fourth button
equal4:
	ORR r3, #0x8				;set bit 3 in r3
	B end						;branch to end
notequal4:
	ORR r3, #0x0				;does not do anything to the bit in r3
	B read_from_push_btns_loop	;branch to read_from_push_btns_loop to keep checking the 4 button again
end:
	STR r3, [r0, #GPIODATA]		;store r3 to r0 with the offset GPIODATA
	MOV r0, r3

	POP {lr}
	MOV pc, lr
	;############################################# read_from_push_btns END #############################################

;ILLUMINATE_LEDs SUBROUTINE
illuminate_LEDs:
	PUSH {lr} 					; Store register lr on stack
	LDR r1, GPIO_PORT_B			;move memory address of port B
	STRB r0, [r1, #GPIODATA]	;store to Data of B port

	POP {lr}
	MOV pc, lr
	;############################################# illuminate_LEDs END #############################################

;ILLUMINATE_RGB_LED SUBROUTINE
illuminate_RGB_LED:
	PUSH {lr}
	;Red P1 Green P3 Blue P2
	;system clock
	LDR r1, SYSCTL
	LDR r2, [r1, #0x608]
	ORR r2, #0x20
	STR r2, [r1, #0x608]

	;set direction
	LDR r1, GPIO_PORT_F
	LDR r2, [r1, #GPIODIR]
	ORR r2, #0xE
	STR r2, [r1, #GPIODIR]

	;set type (digital)
	LDR r2, [r1, #GPIODEN]
	ORR r2, #0xE
	STR r2, [r1, #GPIODEN]

	;led fireworks
	STR r0, [r1, #GPIODATA]

	POP {lr}
	MOV pc, lr
	;############################################# illuminate_RGB_LED END #############################################

;READ_TIVA_PUSH_BUTTON_SUBROUTINE
read_tiva_push_button:
	PUSH {lr} ; Store register lr on stack

	;Read Port F Pin 4
	MOV r0, #0x5000				;move base address of Port F to r0
    MOVT r0, #0x4002
	LDR r1, [r0, #GPIODATA]		;load content from r0 with offset GPIODATA to r1
	AND r1, #0x10				;bit masking
	CMP r1, #0x10				;compare r1 to 0x10
	BEQ notpressed				;if it 1 branch to one
	BNE pressed 				;if it 0 branch to zero
notpressed:
	MOV r0, #0					;When not pressed store 0 to r0
	B ead_tiva_pushbutton_end
pressed:
	MOV r0, #1					;When pressed store 1 to r0

ead_tiva_pushbutton_end:
	POP {lr}
	MOV pc, lr
	;############################################# read_tiva_pushbutton END #############################################

;READ_KEYPAD_SUBROUTINE
read_keypad:
	PUSH {lr} ; Store register lr on stack
loopforkeypad:
	LDRB r1, [r0, #GPIODATA] 	; Load contents of GPIODATA register for Port D
	BIC r1, r1, #0xE			; clear bit 1 - 3 for Port D Pin 1 - 3 to keep pin 0 power
	STRB r1, [r0, #GPIODATA] 	; Store modifed value of GPIODATA register back to memory
	LDR r0, GPIO_PORT_A			;load base address of Port A to r0
	LDRB r1, [r0, #GPIODATA]	;load content of Port A
	MOV r2, r1					;copy r1 into r2
	AND r2, #0x4				;bit masking to check if 0x4 is there
	CMP r2, #0x4				;check if Port A Pin 2 is pressed
	BEQ checkfor1				;branch it it pressed for Pin 2
	MOV r2, r1					;copy r1 into r2
	AND r2, #0x8				;bit masking to check if 0x8 is there
	CMP r2, #0x8				;check if Port A Pin 3 is pressed
	BEQ checkfor2				;branch it it pressed for Pin 3
	MOV r2, r1					;copy r1 into r2
	AND r2, #0x10				;bit masking to check if 0x10 is there
	CMP r2, #0x10				;check if Port A Pin 4 is pressed
	BEQ checkfor3				;branch it it pressed for Pin 4
	LDR r0, GPIO_PORT_D			; Load base address of GPIO Port D
	LDRB r1, [r0, #GPIODATA] 	;Load contents of GPIODATA register for Port D
	BIC r1, r1, #0x1			;clear bit 0 for Port D Pin 0
	ORR r1, r1, #0x2			;set bit 1 for Port D Pin 1 to give power to pin 1
	STRB r1, [r0, #GPIODATA]	;store content into Port D Pin 1
	LDR r0, GPIO_PORT_A			;Load base address of Port A to r0
	LDRB r1, [r0, #GPIODATA]	;Load content of Port A
	MOV r2, r1					;copy r1 into r2
	AND r2, #0x4				;bit masking to check if 0x4 is there
	CMP r2, #0x4				;check if Port A Pin 2 is pressed
	BEQ checkfor4				;branch it it pressed for Pin 2
	MOV r2, r1					;copy r1 into r2
	AND r2, #0x8				;bit masking to check if 0x8 is there
	CMP r2, #0x8				;check if Port A Pin 3 is pressed
	BEQ checkfor5				;branch it it pressed for Pin 3
	MOV r2, r1					;copy r1 into r2
	AND r2, #0x10				;bit masking to check if 0x10 is there
	CMP r2, #0x10				;check if Port A Pin 4 is pressed
	BEQ checkfor6				;branch it it pressed for Pin 4
	LDR r0, GPIO_PORT_D			; Load base address of GPIO Port D
	LDRB r1, [r0, #GPIODATA] 	;Load contents of GPIODATA register for Port D
	BIC r1, r1, #0x2			;clear bit 1 for Port D Pin 1
	ORR r1, r1, #0x4			;set bit 2 for Port D Pin 2 to give power to pin 2
	STRB r1, [r0, #GPIODATA]	;store content into Port D Pin 2
	LDR r0, GPIO_PORT_A			;Load base address of Port A to r0
	LDRB r1, [r0, #GPIODATA]	;Load content of Port A
	MOV r2, r1					;copy r1 into r2
	AND r2, #0x4				;bit masking to check if 0x4 is there
	CMP r2, #0x4				;check if Port A Pin 2 is pressed
	BEQ checkfor7				;branch it it pressed for Pin 2
	MOV r2, r1					;copy r1 into r2
	AND r2, #0x8				;bit masking to check if 0x8 is there
	CMP r2, #0x8				;check if Port A Pin 3 is pressed
	BEQ checkfor8				;branch it it pressed for Pin 3
	MOV r2, r1					;copy r1 into r2
	AND r2, #0x10				;bit masking to check if 0x10 is there
	CMP r2, #0x10				;check if Port A Pin 4 is pressed
	BEQ checkfor9				;branch it it pressed for Pin 4
	LDR r0, GPIO_PORT_D			;Load base address of GPIO Port D
	LDRB r1, [r0, #GPIODATA] 	;Load contents of GPIODATA register for Port D
	BIC r1, r1, #0x4			;clear bit 2 for Port D Pin 2
	ORR r1, r1, #0x8			;set bit 3 for Port D Pin 2 to give power to pin 3
	STRB r1, [r0, #GPIODATA]	;store content into Port D Pin 3
	LDR r0, GPIO_PORT_A			;Load base address of Port A to r0
	LDRB r1, [r0, #GPIODATA]	;Load content of Port A
	MOV r2, r1					;copy r1 into r2
	AND r2, #0x8				;bit masking to check if 0x8 is there
	CMP r2, #0x8				;check if Port A Pin 3 is pressed
	BEQ checkfor0				;branch it it pressed for Pin 3
	LDR r0, GPIO_PORT_D			;Load base address of GPIO Port D
	LDRB r1, [r0, #GPIODATA] 	;Load contents of GPIODATA register for Port D
	BIC	r1, r1, #0x8			;clear bit 3 for Port D Pin 3
	ORR r1, r1, #0x1			;set bit 1 for Port D Pin 0
	STRB r1, [r0, #GPIODATA]	;store content into Port D Pin 0
	B loopforkeypad
checkfor1:
	MOV r0, #1					;put 1 to r0
	B end1						;end program
checkfor2:
	MOV r0, #2					;put 2 to r0
	B end1						;end program
checkfor3:
	MOV r0, #3					;put 3 to r0
	B end1						;end program
checkfor4:
	MOV r0, #4					;put 4 to r0
	B end1						;end program
checkfor5:
	MOV r0, #5					;put 5 to r0
	B end1						;end program
checkfor6:
	MOV r0, #6					;put 6 to r0
	B end1						;end program
checkfor7:
	MOV r0, #7					;put 7 to r0
	B end1						;end program
checkfor8:
	MOV r0, #8					;put 8 to r0
	B end1						;end program
checkfor9:
	MOV r0, #9					;put 9 to r0
	B end1						;end program
checkfor0:
	MOV r0, #0					;put 0 to r0
	B end1						;end program
end1:

	POP {lr}
	MOV pc, lr
	;############################################# read_keypad END #############################################

.end
