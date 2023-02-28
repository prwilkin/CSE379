	.data

	.global prompt
	.global results
	.global num_1_string
	.global num_2_string

prompt:	.string "Your prompts are placed here", 0
result:	.string "Your results are reported here", 0
num_1_string: 	.string "Place holder string for your first number", 0
num_2_string:  	.string "Place holder string for your second number", 0

	.text

	.global lab3
U0FR: 	.equ 0x18	; UART0 Flag Register
					; UART0 Data 0x4000C000

ptr_to_prompt:		.word prompt
ptr_to_result:		.word result
ptr_to_num_1_string:	.word num_1_string
ptr_to_num_2_string:	.word num_2_string

lab3:
	PUSH {lr}   ; Store lr to stack
	ldr r4, ptr_to_prompt
	ldr r5, ptr_to_result
	ldr r6, ptr_to_num_1_string
	ldr r7, ptr_to_num_2_string

		; Your code is placed here.  This is your main routine for
		; Lab #3.  This should call your other routines such as
		; uart_init, read_string, output_string, int2string, &
		; string2int

	POP {lr}	  ; Restore lr from stack
	mov pc, lr


read_string:
	PUSH {lr}   ; Store register lr on stack

		; Your code for your read_string routine is placed here

	POP {lr}
	mov pc, lr


output_string:
	PUSH {lr}   ; Store register lr on stack

		; Your code for your output_string routine is placed here

	POP {lr}
	mov pc, lr
read_character:
	PUSH {lr}   ; Store register lr on stack

		; Your code for your read_character routine is placed here

	POP {lr}
	mov pc, lr


output_character:
	PUSH {lr}   ; Store register lr on stack

		; Your code for your output_character routine is placed here

	POP {lr}
	mov pc, lr


uart_init:
	PUSH {lr}  ; Store register lr on stack

	;Provide clock to UART0
	MOV r0, #0xE618
	MOVT r0, #0x400F	;set address to 0x400FE618
	MOV r1, #0x1		;mark bit #0 as 1
	STR r1,	[r0]		;store @ address
	;Enable clock to PortA
	MOV r0, #0xE608		;set address to 0x400FE618
	MOV r1, #0x1		;mark bit #0 as 1
	STR r1, [r0]		;store @ address
	;Disable UART0 Control
	MOV r0, #0xC030
	MOVT r0, #0x4000	;set address to 0x4000C030
	MOV r1, #0x0
	STR r1, [r0]		;store @ address
	;Set UART0_IBRD_R for 115,200 baud
	MOV r0, #0xC024		;set address to 0x4000C024
	MOV r1, #0x8
	STR r1, [r0]		;store @ address
	;Set UART0_FBRD_R for 115,200 baud
	MOV r0, #0xC028		;set address to 0x4000C028
	MOV r1, #0x2C
	STR r1, [r0]
	;Use System Clock
	MOV r0, #0xCFC8		;set address to 0x4000CFC8
	MOV r1, #0x0
	STR r1, [r0]
	;Use 8-bit word length, 1 stop bit, no parity
	MOV r0, #0xC02C		;set address to 0x4000C02C
	MOV r1, #0x3C
	STR r1, [r0]
	;Enable UART0 Control
	MOV r0, #0xC030		;set address to 0x4000C030
	MOV r1, #12D
	STR r1, [r0]
	;Make PA0 and PA1 as Digital Ports
	MOV r0, #0x451C		;set address to 0x4000451C
	LDR r1, [r0]
	ORR r1, r1, 0x03
	STR r1, [r0]
	;Change PA0,PA1 to Use an Alternate Function
	MOV r0, #0x4420		;set address to 0x40004420
	LDR r1, [r0]
	ORR r1, r1, 0x03
	STR r1, [r0]
	;Configure PA0 and PA1 for UART
	MOV r0, #0x452C		;set address to 0x4000452C
	LDR r1, [r0]
	ORR r1, r1, #0x11
	STR r1, [r0]

		; Your code for your uart_init routine is placed here

	POP {lr}
	mov pc, lr

int2string:
	PUSH {lr}   ; Store register lr on stack

		; Your code for your int2string routine is placed here

	POP {lr}
	mov pc, lr


string2int:
	PUSH {lr}   ; Store register lr on stack

		; Your code for your string2int routine is placed here

	POP {lr}
	mov pc, lr

	.end
