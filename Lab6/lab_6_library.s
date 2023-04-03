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

topNbottom:	.string " -------------------- ",0xA,0xD,0x00
row1:	.half 0x0000, 0x0100, 0x0200, 0x0300, 0x0400, 0x0500, 0x0600, 0x0600, 0x0700, 0x0800, 0x0900, 0x0A00, 0x0B00, 0x0C00, 0x0D00, 0x0E00, 0x0F00, 0x1000, 0x1100, 0x1200, 0x1300
row2:	.half 0x0001, 0x0101, 0x0201, 0x0301, 0x0401, 0x0501, 0x0601, 0x0601, 0x0701, 0x0801, 0x0901, 0x0A01, 0x0B01, 0x0C01, 0x0D01, 0x0E01, 0x0F01, 0x1001, 0x1101, 0x1201, 0x1301
row3:	.half 0x0002, 0x0102, 0x0202, 0x0302, 0x0402, 0x0502, 0x0602, 0x0602, 0x0702, 0x0802, 0x0902, 0x0A02, 0x0B02, 0x0C02, 0x0D02, 0x0E02, 0x0F02, 0x1002, 0x1102, 0x1202, 0x1302
row4:	.half 0x0003, 0x0103, 0x0203, 0x0303, 0x0403, 0x0503, 0x0603, 0x0603, 0x0703, 0x0803, 0x0903, 0x0A03, 0x0B03, 0x0C03, 0x0D03, 0x0E03, 0x0F03, 0x1003, 0x1103, 0x1203, 0x1303
row5:	.half 0x0004, 0x0104, 0x0204, 0x0304, 0x0404, 0x0504, 0x0604, 0x0604, 0x0704, 0x0804, 0x0904, 0x0A04, 0x0B04, 0x0C04, 0x0D04, 0x0E04, 0x0F04, 0x1004, 0x1104, 0x1204, 0x1304
row6:	.half 0x0005, 0x0105, 0x0205, 0x0305, 0x0405, 0x0505, 0x0605, 0x0605, 0x0705, 0x0805, 0x0905, 0x0A05, 0x0B05, 0x0C05, 0x0D05, 0x0E05, 0x0F05, 0x1005, 0x1105, 0x1205, 0x1305
row7:	.half 0x0006, 0x0106, 0x0206, 0x0306, 0x0406, 0x0506, 0x0606, 0x0606, 0x0706, 0x0806, 0x0906, 0x0A06, 0x0B06, 0x0C06, 0x0D06, 0x0E06, 0x0F06, 0x1006, 0x1106, 0x1206, 0x1306
row8:	.half 0x0007, 0x0107, 0x0207, 0x0307, 0x0407, 0x0507, 0x0607, 0x0607, 0x0707, 0x0807, 0x0907, 0x0A07, 0x0B07, 0x0C07, 0x0D07, 0x0E07, 0x0F07, 0x1007, 0x1107, 0x1207, 0x1307
row9:	.half 0x0008, 0x0108, 0x0208, 0x0308, 0x0408, 0x0508, 0x0608, 0x0608, 0x0708, 0x0808, 0x0908, 0x0A08, 0x0B08, 0x0C08, 0x0D08, 0x0E08, 0x0F08, 0x1008, 0x1108, 0x1208, 0x1308
row10:	.half 0x0009, 0x0109, 0x0209, 0x0309, 0x0409, 0x0509, 0x0609, 0x0609, 0x0709, 0x0809, 0x0909, 0x0A09, 0x0B09, 0x0C09, 0x0D09, 0x0E09, 0x0F09, 0x1009, 0x1109, 0x1209, 0x1309
row11:	.half 0x000A, 0x010A, 0x020A, 0x030A, 0x040A, 0x050A, 0x060A, 0x060A, 0x070A, 0x080A, 0x090A, 0x0A0A, 0x0B0A, 0x0C0A, 0x0D0A, 0x0E0A, 0x0F0A, 0x100A, 0x110A, 0x120A, 0x130A
row12:	.half 0x000B, 0x010B, 0x020B, 0x030B, 0x040B, 0x050B, 0x060B, 0x060B, 0x070B, 0x080B, 0x090B, 0x0A0B, 0x0B0B, 0x0C0B, 0x0D0B, 0x0E0B, 0x0F0B, 0x100B, 0x110B, 0x120B, 0x130B
row13:	.half 0x000C, 0x010C, 0x020C, 0x030C, 0x040C, 0x050C, 0x060C, 0x060C, 0x070C, 0x080C, 0x090C, 0x0A0C, 0x0B0C, 0x0C0C, 0x0D0C, 0x0E0C, 0x0F0C, 0x100C, 0x110C, 0x120C, 0x130C
row14:	.half 0x000D, 0x010D, 0x020D, 0x030D, 0x040D, 0x050D, 0x060D, 0x060D, 0x070D, 0x080D, 0x090D, 0x0A0D, 0x0B0D, 0x0C0D, 0x0D0D, 0x0E0D, 0x0F0D, 0x100D, 0x110D, 0x120D, 0x130D
row15:	.half 0x000E, 0x010E, 0x020E, 0x030E, 0x040E, 0x050E, 0x060E, 0x060E, 0x070E, 0x080E, 0x090E, 0x0A0E, 0x0B0E, 0x0C0E, 0x0D0E, 0x0E0E, 0x0F0E, 0x100E, 0x110E, 0x120E, 0x130E
row16:	.half 0x000F, 0x010F, 0x020F, 0x030F, 0x040F, 0x050F, 0x060F, 0x060F, 0x070F, 0x080F, 0x090F, 0x0A0F, 0x0B0F, 0x0C0F, 0x0D0F, 0x0E0F, 0x0F0F, 0x100F, 0x110F, 0x120F, 0x130F
row17:	.half 0x0010, 0x0110, 0x0210, 0x0310, 0x0410, 0x0510, 0x0610, 0x0610, 0x0710, 0x0810, 0x0910, 0x0A10, 0x0B10, 0x0C10, 0x0D10, 0x0E10, 0x0F10, 0x1010, 0x1110, 0x1210, 0x1310
row18:	.half 0x0011, 0x0111, 0x0211, 0x0311, 0x0411, 0x0511, 0x0611, 0x0611, 0x0711, 0x0811, 0x0911, 0x0A11, 0x0B11, 0x0C11, 0x0D11, 0x0E11, 0x0F11, 0x1011, 0x1111, 0x1211, 0x1311
row19:	.half 0x0012, 0x0112, 0x0212, 0x0312, 0x0412, 0x0512, 0x0612, 0x0612, 0x0712, 0x0812, 0x0912, 0x0A12, 0x0B12, 0x0C12, 0x0D12, 0x0E12, 0x0F12, 0x1012, 0x1112, 0x1212, 0x1312
row20:	.half 0x0013, 0x0113, 0x0213, 0x0313, 0x0413, 0x0513, 0x0613, 0x0613, 0x0713, 0x0813, 0x0913, 0x0A13, 0x0B13, 0x0C13, 0x0D13, 0x0E13, 0x0F13, 0x1013, 0x1113, 0x1213, 0x1313
cordinatesNow:	.half	0x0A0A	;init start at 10/10			The *  knows where it is at all times. It knows this because it knows where it isnt.
cordinatesNext:	.half	0x0B0A	;init next space at 11/10		By subtracting where it is from where it isnt, or where it isnt from where it is
direction:		.half 	0x0001	;init to move right				(whichever is greater), it obtains a difference, or deviation. The guidance subsystem
hit:		.string "You hit a wall.",0x00	;					uses deviations to generate corrective commands to drive the * from a position where
moves:		.string "Total Moves: ",0x00	;					it is to a position where it isnt, and arriving at a position where it wasnt, it now is.

	.text

	.global lab6
	.global game

	.global uart_init
	.global uart_interrupt_init
	.global gpio_interrupt_init
	.global timer_interrupt_init
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
ptr_to_topNbottom:		.word topNbottom
ptr_to_row1:			.word row1
ptr_to_row2:			.word row2
ptr_to_row3:			.word row3
ptr_to_row4:			.word row4
ptr_to_row5:			.word row5
ptr_to_row6:			.word row6
ptr_to_row7:			.word row7
ptr_to_row8:			.word row8
ptr_to_row9:			.word row9
ptr_to_row10:			.word row10
ptr_to_row11:			.word row11
ptr_to_row12:			.word row12
ptr_to_row13:			.word row13
ptr_to_row14:			.word row14
ptr_to_row15:			.word row15
ptr_to_row16:			.word row16
ptr_to_row17:			.word row17
ptr_to_row18:			.word row18
ptr_to_row19:			.word row19
ptr_to_row20:			.word row20
ptr_to_cordinatesNow:	.word cordinatesNow
ptr_to_cordinatesNext:	.word cordinatesNext
ptr_to_direction:		.word direction
ptr_to_hit:				.word hit
ptr_to_moves:			.word moves
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
	LDR r0, EN0					;move memory address of EN0 base address to r0
	LDR r1, [r0, #0x100]		;load content of r0 with offset with 0x100 to r1
	ORR r1, #0x40000000			;set bit 30 to allow GPIO Port F to Interrupt Processor
	STR r1, [r0, #0x100]		;store r1 into r0 to allow GPIO Port F to Interrupt Processor

	POP {lr}
	MOV pc, lr
	;############################################# gpio_interrupt_init END #############################################

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
	MOV r1, #0x2400				;set r1 as 16000000 to make the Timer interrupt to start at 1 second
	MOVT r1, #0x00F4
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

	POP {lr}
	MOV pc, lr
	;############################################# timer_interrupt_init END #############################################

;UART0_HANLDER SUBROUTINE
UART0_Handler:
	PUSH {lr}
	LDR r0, UART0
	LDR r1, [r0, #0x044]
	ORR r1, #0x10				;MASK bit
	STR r1, [r0, #0x044]		;reset interupt flag
	BL simple_read_character	;retrive character
	LDR r1, ptr_to_direction
W:
	CMP r0, #0x77	;if W set 0
	BNE D
	MOV r0, #0
	STR r0, [r1]
D:
	CMP r0, #0x64	;if D set 1
	BNE S
	MOV r0, #1
	LDR r0, ptr_to_direction
S:
	CMP r0, #0x73	;if S set 2
	BNE A
	MOV r0, #2
	LDR r0, ptr_to_direction
A:
	CMP r0, #0x61	;if A set 3
	BNE UART0_Handler_end
	MOV r0, #3
	LDR r0, ptr_to_direction

UART0_Handler_end:

	POP {lr}
	BX lr       	; Return
	;############################################# UART0_Handler END #############################################


;SWITCH_HANDLER SUBROTUINE
Switch_Handler:
	PUSH {lr}
	PUSH {r5}
	MOV r5, #2
	LDR r0, GPIO_PORT_F
	LDR r1, [r0, #0x41C]
	ORR r1, #0x10				;mask bit
	STR r1, [r0, #0x41C]		;reset interupt flag

	MOV r0, #0x0000				;move memory address of Timer0 base address to r0
	MOVT r0, #0x4003
	LDR r1, [r0, #0x028]		;load content of r0 with offset with 0x028 to r1
	UDIV r1, r1, r5
	STR r1, [r0, #0x028]		;store r1 into r0 to make Timer interrupt start every 1 second

	POP {r5}
	POP {lr}
	BX lr       	; Return
	;############################################# Switch_Handler END #############################################


Timer_Handler:
	PUSH {lr}
	MOV r0, #0x0000				;move memory address of Timer0 base address to r0
	MOVT r0, #0x4003
	LDR r1, [r0, #0x024]		;load content of r0 with offset of 0x024 to r1
	ORR r1, #0x1				;set bit 0 to clear Timer0 interrupt so Timer0 interrupt can be interrupted again
	STR r1, [r0, #0x024]		;store r1 into r0 to clear Timer0 interrupt so Timer0 interrupt can be itnerrupted again
	ADD r9, r9, #1
	POP {lr}
	BX lr       	; Return
	;############################################# Timer_Handler END #############################################


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


;CLR_PAGE SUBROUTINE
clr_page:
	PUSH {lr}

	MOV r0, #0xC
	BL output_character

	POP {lr}
	MOV pc, lr
	;############################################# clr_page END #############################################


;NEW_LINE SUBROUTINE
new_line:
	PUSH {lr}

	MOV r0, #0xA
	BL output_character
	MOV r0, #0xD
	BL output_character

	POP {lr}
	MOV pc, lr
	;############################################# new_line END #############################################


;INT2STRING SUBROUTINE
int2string:
	PUSH {lr}   				; Store register lr on stack
								;r0  = int
								;r1  = addy
								;r4 or higher must push pop
								;## not passed in ##
								;r2  = avg size (lmao)
	PUSH {r4}					;r4  = didgit compare
								;	 = avg maniuplated
	PUSH {r5}					;r5  = temp var
								;	 = digit to be stored
	MOV r5, #1						;init
	PUSH {r9}					;r9  = BASETEN var
	MOV r9, #10						;init
	PUSH {r10}					;r10 = 10
	MOV r10, #10					;init

integer_digit:		;get size of int if 1
	MOV r4, #9		;load 9 for digit compare
	MOV r2, #1		;load 1 to count digits
	CMP r0, r4		;compare number and digit compare to determine if more then one digit
	BGT COMPARE		;if more then one digit jump to compare
	MOV r2, #1		;return 1 as digit count

COMPARE:			;get size of average >1
	ADD r2, r2, #1
	MUL r4, r4, r10		;jump another digit ie 9 to 90
	ADD r4, r4, #9		;push to highest for digit ie 99 for two digits
	CMP r0, r4
	BGT COMPARE			;if greater then check for another digit

	MOV r4, r0		;r4 will be maniuptlated
	CMP r2, #1		;if first digit then base being 10 works
	BEQ MODULO

BASETEN:			;this will calulate the size used for MOD ie. 10/100/1000
	ADD r5, r5, #1
	MUL r9, r9, r10
	CMP r2, r5
	BNE BASETEN

loopint2string:

MODULO:
	SDIV r5, r4, r9		;input/base 10 mod
	MUL r5, r5, r9		;qoutient*base 10 mod
	SUB r5, r4, r5		;input - product = remainder
	CMP r1, #1
	BNE MODULOTWO
	B STORE_int2string

MODULOTWO:
	SDIV r9, r9, r10
	SDIV r5, r5, r9

STORE_int2string:
	ADD r5, r5, #48   	;convert int into string
	STRB r5, [r1] 		;store the string into the memory address
	CMP r2, #1 		  	;check if last didigt
	BEQ end_int2string 	;exit if it null
	ADD r1, r1, #1		;add 1 to r1 to move to the next address
	SUB r2, r2, #1		;next didgit

	B loopint2string    ;go back to loop
end_int2string:
	MOV r4, #0x00
	STRB r4, [r1, #1]

	POP {r10}	;reset stack and regs
	POP {r9}	;FIFO
	POP {r5}
	POP {r4}

	POP {lr}
	mov pc, lr
	;############################################# int2string END #############################################

decode:
	PUSH {lr}

	LDR r0, [r2]
	AND r1, r0, #0xFF	;y cordinates
	LSR r0, #8			;x cordinates

	POP {lr}
	MOV pc, lr
	;############################################# decode END #############################################

encode:
 	PUSH {lr}

	LSL r0, #8		;store x cordinates
	ORR r0, r1		;insert y cordinates
	STR r0, [r2]	;store in memory

	POP {lr}
	MOV pc, lr
	;############################################# encode END #############################################


checker:
	PUSH {lr}

	LDR r2, ptr_to_cordinatesNow
	BL decode
	LDR r2, ptr_to_direction
leftWall:
	CMP r0, #0x00
	BNE	rightWall
	CMP r2, #3
	BNE	rightWall
	B end_game
rightWall:
	CMP r0, #0x14
	BNE topWall
	CMP r2, #1
	BNE topWall
	B end_game
topWall:
	CMP r1, #0x00
	BNE bottomWall
	CMP r2, #0
	BNE bottomWall
	B end_game
bottomWall:
	CMP r1, #0x00
	BNE checker_end
	CMP r2, #2
	BNE checker_end
	B end_game
checker_end:

	POP {lr}
	MOV pc, lr
	;############################################# checker END #############################################

mover:
	PUSH {lr}

	LDR r2, ptr_to_cordinatesNow
	BL decode
	LDR r2, ptr_to_direction
	LDR r2, [r2]
Up:
	CMP r2, #0
	BNE Right
	ADD r1, #1
	B mover_end
Right:
	CMP r2, #1
	BNE Down
	ADD r0, #1
	B mover_end
Down:
	CMP r2, #2
	BNE Right
	SUB r1, #1
	B mover_end
Left:
	CMP r2, #3
	BNE mover_end
	SUB r0, #1
	B mover_end
mover_end:
	LDR r2, ptr_to_cordinatesNext
	BL encode

	POP {lr}
	MOV pc, lr

printer:
	PUSH {lr}

	BL clr_page
	LDR r0, ptr_to_topNbottom
	BL output_string			;print top wall
	LDR r1, ptr_to_row1
	BL printer_assist
	LDR r1, ptr_to_row2
	BL printer_assist
	LDR r1, ptr_to_row3
	BL printer_assist
	LDR r1, ptr_to_row4
	BL printer_assist
	LDR r1, ptr_to_row5
	BL printer_assist
	LDR r1, ptr_to_row6
	BL printer_assist
	LDR r1, ptr_to_row7
	BL printer_assist
	LDR r1, ptr_to_row8
	BL printer_assist
	LDR r1, ptr_to_row9
	BL printer_assist
	LDR r1, ptr_to_row10
	BL printer_assist
	LDR r1, ptr_to_row11
	BL printer_assist
	LDR r1, ptr_to_row12
	BL printer_assist
	LDR r1, ptr_to_row13
	BL printer_assist
	LDR r1, ptr_to_row14
	BL printer_assist
	LDR r1, ptr_to_row15
	BL printer_assist
	LDR r1, ptr_to_row16
	BL printer_assist
	LDR r1, ptr_to_row17
	BL printer_assist
	LDR r1, ptr_to_row18
	BL printer_assist
	LDR r1, ptr_to_row19
	BL printer_assist
	LDR r1, ptr_to_row20
	BL printer_assist
	LDR r0, ptr_to_topNbottom
	BL output_string			;print bottom wall


	POP {lr}
	MOV pc, lr
	;############################################# printer END #############################################

printer_assist:
	PUSH {lr}

	MOV r0, #0x7C
	BL output_character	;print left wall
	MOV r4, #1			;set counter
	LDR r2, ptr_to_cordinatesNow
	LDRB r2, [r2]
printer_assist_looper:
	CMP r4, #20
	ADD r4, #1
	BEQ printer_assist_end
	STR r3, [r1]			;store cordinates
	ADD r1, #1			;next block in row
	CMP r3,	r2			;if current is next postion
	BNE print_space
	MOV r0, #0x2A
	BL output_character
	B printer_assist_looper
print_space:
	MOV r0, #0x20
	BL output_character
	B printer_assist_looper
printer_assist_end:
	MOV r0, #0x7C
	BL output_character	;print right wall
	BL new_line

	POP {lr}
	MOV pc, lr
	;############################################# printer_assist END #############################################

end_game:
	PUSH {lr}



	POP {lr}
	MOV pc, lr


.end
