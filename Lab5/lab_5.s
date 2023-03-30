	.data

	.global prompt
	.global mydata
	.global prompt2
	.global buttonInt2String
	.global keyInt2String


prompt:				.string "Press [q] to quit at anytime",0xA,0xD,"Button presses: ",0x00
prompt2:			.string "",0xA,0xD,"Key presses: ",0x00
buttonInt2String:	.string 0x00,0x00,0x00,0x00,0x00	;allocate space for a 4 didgit number and null teriminator
keyInt2String:		.string 0x00,0x00,0x00,0x00,0x00	;allocate space for a 4 didgit number and null teriminator
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
	.global output_string		; This is from your Lab #4 Library
	.global uart_init			; This is from your Lab #4 Library
	.global lab5
	.global printer_bar
	.global post_interupt
	.global int2string
	.global clr_page
	.global new_line

**************************************************************************************************
SYSCTL:			.word	0x400FE000	; Base address for System Control
GPIO_PORT_A:	.word	0x40004000	; Base address for GPIO Port A
GPIO_PORT_B:	.word	0x40005000	; Base address for GPIO Port B
GPIO_PORT_D:	.word	0x40007000	; Base address for GPIO Port D
GPIO_PORT_F:	.word	0x40025000	; Base address for GPIO Port F
EN0:			.word   0xE000E000  ; Base address for Set Enable Register
RCGCGPIO:		.equ	0x608		; Offset for GPIO Run Mode Clock Gating Control Register
GPIODIR:		.equ	0x400		; Offset for GPIO Direction Register
GPIODEN:		.equ	0x51C		; Offset for GPIO Digital Enable Register
GPIODATA:		.equ	0x3FC		; Offset for GPIO Data
UART0:			.word	0x4000C000	; Base address for UART0
U0FR: 			.equ 	0x18		; UART0 Flag Register
**************************************************************************************************

lab5:	; This is your main routine which is called from your C wrapper
	PUSH {lr}   		; Store lr to stack
	MOV r6, #0				;counter for button presses
	MOV r7, #0				;counter for key presses

    bl uart_init
	bl uart_interrupt_init
	bl gpio_interrupt_init
	BL clr_page
loop:
	B loop
	; This is where you should implement a loop, waiting for the user to
	; enter a q, indicating they want to end the program.

	POP {lr}		; Restore lr from the stack
	MOV pc, lr
	;############################################# lab5 END #############################################


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
	;############################################# uart_init END #############################################

uart_interrupt_init:
	PUSH {lr} ; Store register lr on stack
	;Configuring the UART for Interrupts
	LDR r0, UART0		;set address to 0x4000C000
	LDR r1, [r0, #0x038]
	ORR r1, #0x10		;mask and set bit 4 to 1
	STR r1, [r0, #0x038]
	;Configure Processor to allow UART0 to Interrupt Processor (EN0)
	MOV r0, #0xE000		;set address to 0xE000E000
	MOVT r0, #0xE000
	LDR r1, [r0, #0x100]
	ORR r1, r1, #0x20	;mask and set bit 5 to 1
	STR r1, [r0, #0x100]

	POP {lr}
	MOV pc, lr
	;############################################# uart_interrupt_init END #############################################



gpio_interrupt_init:
	PUSH {lr}
	;ENABLING SWITCH 1 ON TIVA BOARD
	;enabling clock for Port F
	LDR r0, SYSCTL				;load memory address of clock to r0
    LDR r1, [r0, #0x608]		;load content of r0 with offset of 0x608 to r1
    ORR r1, r1, #0x20			;set bit 6 to enable clock for Port F
    STR r1, [r0, #0x608]		;store r1 into r0 with offset of 0x608 enabling clock in Port F

    ;set GPIO Pin Direction as Input for Port F
    LDR r0, GPIO_PORT_F		    ;move memory address of Port F base address to r0
    LDR r1, [r0, #0x400]		;load content of r0 with offset of 0x400 to r1
    BIC r1, r1, #0x10			;bitwise manipulation to clear bit 5 for Port F Pin 4
    STR r1, [r0, #0x400]		;store r1 into GPIO Pin Direction as Input for Port F Pin 4

    ;Enable GPIO Pin 4 for Port F to Digital
    LDR r1, [r0, #0x51C]		;load content of r0 wuth offset of 0x51C to r1
	ORR r1, #0x10				;bitwise manipluation to set bit 5 as 1 for Port F Pin 4
	STR r1, [r0, #0x51C]		;store r1 to r0 with offset of 0x51C enabling Port F Pin 4 as Digital Pin

	;Enable pull-up resistor for Port F
    LDR r1, [r0, #0x510]		;load content of r0 with offset of 0x510 to r1
	ORR r1, #0x10				;set bit 5 to enable pull-up resistor for Pin 4 for Port F
	STR r1, [r0, #0x510]		;store r1 into r0 enabling pull-up resistor for Pin 5 for Port F

	;Set Edge Sensitive for Port F Pin 4
	LDR r0, GPIO_PORT_F			;move memory address of Port F base address to r0
	LDR r1, [r0, #0x404]		;load content of r0 with offset of 0x404 to r1
	BIC r1, #0x10				;bitwise manipulation to clear bit 5 for Port F Pin 4
	STR r1, [r0, #0x404]		;store r1 into r0 to change it edge sensitive (Falling or Rising Edge) for Port F Pin 4

	;Setup the Interrupt for Edge Sensitive via the GPIO Interrupt Single Edges Register for Port F Pin 4
	LDR r1, [r0, #0x408]		;load content of r0 with offset of 0x408 to r1
	BIC r1, #0x10				;bitwise manipulation to clear bit 5 for Port F Pin 4
	STR r1, [r0, #0x408]		;store r1 into r0 to change it to allow GPIO Interrupt Event (GPIOEV) Register to Control Pin for Port F Pin 4

	;Setting the Interrupt for Falling Edge Triggering via the GPIO Interrupt Event Register for Port F Pin 4
	LDR r1, [r0, #0x40C]		;load content of r0 with offset of 0x40C to r1
	BIC r1, #0x10			;clear bit 4 to enable the falling edge for Port F Pin 4
	STR r1, [r0, #0x40C]		;store r1 into r0 to enable the falling edge for Port F Pin 4

	;Enabling the Interrupt for Port F Pin 4
	LDR r1, [r0, #0x410]		;load content of r0 with offset of 0x410 to r1
	ORR r1, #0x10				;set bit 5 to enable interrupt for Pin 4 for Port F
	STR r1, [r0, #0x410]		;store r1 into r0 to enable the interrupt for Port F Pin 4

	;Configure Processor to Allow GPIO Port F to Interrupt Processor
	LDR r0, EN0
	LDR r1, [r0, #0x100]		;load content of r0 with offset with 0x100 to r1
	ORR r1, #0x40000000			;set bit 30 to allow GPIO Port F to Interrupt Processor
	STR r1, [r0, #0x100]		;store r1 into r0 to allow GPIO Port F to Interrupt Processor

	POP {lr}
	MOV pc, lr
	;############################################# gpio_interrupt_init END #############################################


;UART0_HANLDER SUBROUTINE
UART0_Handler:
	PUSH {lr}
	LDR r0, UART0
	LDR r1, [r0, #0x044]
	ORR r1, #0x10				;MASK bit
	STR r1, [r0, #0x044]		;reset interupt flag
	BL simple_read_character	;retrive character
	CMP r0, #0x71				;if q quit
	BEQ QUIT
	ADD r7, #1					;key press counter by 1
	BL post_interupt			;do prints screen functions

	POP {lr}
	BX lr       	; Return
	;############################################# UART0_Handler END #############################################


;SWITCH_HANDLER SUBROTUINE
Switch_Handler:
	PUSH {lr}
	LDR r0, GPIO_PORT_F
	LDR r1, [r0, #0x41C]
	ORR r1, #0x10			;mask bit
	STR r1, [r0, #0x41C]	;reset interupt flag
	ADD r6, #1				;button counter by 1
	BL post_interupt		;do prints screen functions

	POP {lr}
	BX lr       	; Return
	;############################################# Switch_Handler END #############################################


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

QUIT:

.end
