	.data
;this file will only contain subroutines to initalize the hardware
	.text
;init subroutines: (in order of apperance in file)
;	uart, uart interrupt, gpio interrupt, 4 led, 4 button, rgb light, timer interrupt & timer interrupt rng

	.global uart_init
	.global uart_interrupt_init
	.global gpio_interrupt_init
	.global Four_LED_init
	.global Four_BUTTON_init
	.global RGB_LIGHT_init
	.global timer_interrupt_init
	.global timer_interrupt_init_RNG
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

	POP {pc}
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

	POP {pc}
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

	POP {pc}
	;############################################# gpio_interrupt_init END #############################################

Four_LED_init:
	PUSH {lr}
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

	POP {pc}
	;############################################# 4_LED_init #############################################

Four_BUTTON_init:
	PUSH {lr}
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
	POP {pc}
	;############################################# 4_BUTTON_init #############################################

RGB_LIGHT_init:
	PUSH {lr}
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
	ORR r1, #0xE				;bitwise manipluation to set bit 1 - 3 as 1 for Port F Pin 1 - 3
	STR r1, [r0, #0x51C]		;store r1 to r0 with offset of 0x51C enabling Port F Pin 1 - 3 as Digital Pin

	POP {pc}
	;############################################# RGB_LIGHT_init #############################################

timer_interrupt_init:
	PUSH {lr}
	;Enable Clock for Timer (Tx) where x is timer number
	MOV r0, #0xE000				;move memory address of Clock base address to r0
	MOVT r0, #0x400F
	LDR r1, [r0, #0x604]		;load content of r0 with offset with 0x604 to r1
	ORR r1, #0x1				;set bit 0 to allow enable Clock for Timer0
	STR r1, [r0, #0x604]		;store r1 into r0 to allow Clock to be enable for Timer0

	;Disable Timer
	MOV r0, #0x0000				;move memory address of Timer0 base address to r0
	MOVT r0, #0x4003
	LDR r1, [r0, #0x00C]		;load content of r0 with offset with 0x00C to r1
	BIC r1, #0x1				;clear bit 0 to disable Timer0
	STR r1, [r0, #0x00C]		;store r1 into r0 to disable Timer0

	;Setting up Timer for 32-Bit Mode
	LDR r1, [r0, #0x000]		;load content of r0 with offset with 0x000 to r1
	BIC r1, #0x000				;Clear bit 0,1,2 to configure the Timer as a single 32-bit timer
	STR r1, [r0, #0x000]		;store r1 into r0 to set Timer0 as a single 32-bit timer

	;Put Timer in Periodic Mode
	LDR r1, [r0, #0x004]		;load content of r0 with offset with 0x004 to r1
	ORR r1, #0x2				;Write 2 to TAMR to change the mode of Timer0 to Periodic Mode
	STR r1, [r0, #0x004]		;store r1 into r0 to change Timer as Periodic Mode

	;Setup Interval Period
	LDR r1, [r0, #0x028]		;load content of r0 with offset with 0x028 to r1
	MOV r1, #0x1200				;set r1 as 8000000 to make the Timer interrupt to start at 1 second
	MOVT r1, #0x007A
	STR r1, [r0, #0x028]		;store r1 into r0 to make Timer interrupt start every 1 second

	;Setup Timer to Interrupt Processor
	LDR r1, [r0, #0x018]		;load content of r0 with offset with 0x018 to r1
	ORR r1, #0x1				;set bit 0 to enable Timer to Interrupt Processor
	STR r1, [r0, #0x018]		;store r1 into r0 to enable Timer to Interrupt Processor

	;Configure Processor to Allow Timer to Interrupt Processor
	LDR r0, EN0					;move memory address of EN0 base address to r0
	LDR r1, [r0, #0x100]		;load content of r0 with offset of 0x100 to r1
	ORR r1, #0x80000			;set bit 19 to Timer0 to Interrupt Processor
	STR r1, [r0, #0x100]		;store r1 into r0 to allow Timer0 to Interrupt Processor

	;Enable Timer
	MOV r0, #0x0000				;move memory address of Timer0 base address to r0
	MOVT r0, #0x4003
	LDR r1, [r0, #0x00C]		;load content of r0 with offset of 0x00C to r1
	ORR r1, #0x1				;set bit 0 to enable Timer0
	STR r1, [r0, #0x00C]		;store r1 into r0 to enable Timer0

	POP {pc}
	;############################################# timer_interrupt_init END #############################################

timer_interrupt_init_RNG:
	PUSH {lr}
	;Enable Clock for Timer (Tx) where x is timer number
	MOV r0, #0xE000				;move memory address of Clock base address to r0
	MOVT r0, #0x400F
	LDR r1, [r0, #0x604]		;load content of r0 with offset with 0x604 to r1
	ORR r1, #0x2				;set bit 1 to allow enable Clock for Timer1
	STR r1, [r0, #0x604]		;store r1 into r0 to allow Clock to be enable for Timer0

	;Disable Timer
	MOV r0, #0x1000				;move memory address of Timer1 base address to r0
	MOVT r0, #0x4003
	LDR r1, [r0, #0x00C]		;load content of r0 with offset with 0x00C to r1
	BIC r1, #0x1				;clear bit 0 to disable Timer0
	STR r1, [r0, #0x00C]		;store r1 into r0 to disable Timer0

	;Setting up Timer for 32-Bit Mode
	LDR r1, [r0, #0x000]		;load content of r0 with offset with 0x000 to r1
	BIC r1, #0x000				;Clear bit 0,1,2 to configure the Timer as a single 32-bit timer
	STR r1, [r0, #0x000]		;store r1 into r0 to set Timer0 as a single 32-bit timer

	;Put Timer in Periodic Mode
	LDR r1, [r0, #0x004]		;load content of r0 with offset with 0x004 to r1
	ORR r1, #0x2				;Write 2 to TAMR to change the mode of Timer0 to Periodic Mode
	STR r1, [r0, #0x004]		;store r1 into r0 to change Timer as Periodic Mode

	;Setup Interval Period
	LDR r1, [r0, #0x028]		;load content of r0 with offset with 0x028 to r1
	;MOV r1, #0x064				;set r1 as 6250 to make the Timer interrupt to start at 1 millisecond
	MOV r1, #0x1200				;set r1 as 8000000 to make the Timer interrupt to start at 1 second
	MOVT r1, #0x007A
	STR r1, [r0, #0x028]		;store r1 into r0 to make Timer interrupt start every 1 second

	;Setup Timer to Interrupt Processor
	LDR r1, [r0, #0x018]		;load content of r0 with offset with 0x018 to r1
	ORR r1, #0x1				;set bit 0 to enable Timer to Interrupt Processor
	STR r1, [r0, #0x018]		;store r1 into r0 to enable Timer to Interrupt Processor

	;Configure Processor to Allow Timer to Interrupt Processor
	LDR r0, EN0					;move memory address of EN0 base address to r0
	LDR r1, [r0, #0x100]		;load content of r0 with offset of 0x100 to r1
	ORR r1, #0x200000			;set bit 19 to Timer0 to Interrupt Processor
	STR r1, [r0, #0x100]		;store r1 into r0 to allow Timer0 to Interrupt Processor

	;Enable Timer
	;MOV r0, #0x1000				;move memory address of Timer0 base address to r0
	;MOVT r0, #0x4003
	;LDR r1, [r0, #0x00C]		;load content of r0 with offset of 0x00C to r1
	;ORR r1, #0x1				;set bit 0 to enable Timer0
	;STR r1, [r0, #0x00C]		;store r1 into r0 to enable Timer0

	POP {lr}
	MOV pc, lr
	;############################################# timer_interrupt_init_RNG END #############################################

.end
