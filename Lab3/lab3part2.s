	.data

	.global prompt
	.global results
	.global num_1_string
	.global num_2_string

prompt:	.string "Enter Numbers\|Average is |\Press Enter to run again|", 0
	;			"Your prompts are placed here", 0
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
	BL uart_init
	MOV r0, #0x12
	STRB r0, [r4, #0xD]	;new line after 'Enter Numbers' prompt
	STRB r0, [r4, #0xE]	;new line before 'Press Enter to run again' prompt
	MOV r0, #0x00
	STRB r0, [r4, #0xE]		;null after 'Enter Numbers\n'
	STRB r0, [r4, #0x1A]	;null after 'Average is '
	STRB r0, [r4, #0x34]	;null after '\nPress Enter to run again'
	MOV r0, r4			;set r0 to base addy for prompt
	BL output_string	;call <-- to print prompt
	MOV r0, r6			;set r0 to base addy for 1st number
	BL read_string		;call <-- to get number
	MOV r0, r7			;set r0 to base addy for 2nd number
	BL read_string		;call <-- to get number
	MOV r0, r6			;set r0 to base addy for 1st number
	BL string2int		;call <-- to convert to number
	PUSH {r0}			;push 1st number to stack
	MOV r0, r7			;set r0 to base addy for 2nd number
	BL string2int		;call <-- to convert to number
	MOV r1, r0			;stores 2nd number in r1
	POP {r0}			;pop 1st number from stack
	ADD r0, r0, r1		;begin to calculate avg
	SDIV r0, r0, #2		;divide tot by 2 for avg
	MOV r1, r5			;pass addy of prompt
	BL int2string		;call <-- to convert average to string
	MOV r0, r4			;set r0 to base addy for prompt
	ADD r0,	r0, #0xF	;offset base addy
	BL output_string	;call <-- to print prompt
	MOV r0, r5			;set r0 base addy result
	BL output_string	;call <-- to print result
	MOV r0, r4			;set r0 to base addy for prompt
	ADD r0,	r0, #0x		;offset base addy
	BL output_string	;call <-- to print prompt
reset_lab3:
	BL read_character	;get char
	CMP r0, #0x13		;cmp for CR
	BNE reset_lab3		;not CR then loop
	BEQ	lab3			;if CR then reset program
		; Your code is placed here.  This is your main routine for
		; Lab #3.  This should call your other routines such as
		; uart_init, read_string, output_string, int2string, &
		; string2int

		;lab3 doc code Pat

	POP {lr}	  ; Restore lr from stack
	mov pc, lr
	;############ Lab3


read_string:
	PUSH {lr}   ; Store register lr on stack

	;Pat
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
	POP {r0}		;pop addy from stack
	BL read_string_loop
		; Your code for your read_string routine is placed here
end_read_string
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
	BL output_string_loop

		; Your code for your output_string routine is placed here
end_output_string:
	POP {lr}
	mov pc, lr
	;############ output_string


read_character:
	PUSH {lr}   ; Store register lr on stack

read_character_loop:
	MOV r2, #0xC000
 	MOVT r2, #0x4000
	LDRB r1, [r2, #U0FR]	;get 0xFE bit
	AND r1, #0x10			;isolate OxFE bit
	CMP r1, #0x10			;if bit 1 branch
	BEQ read_character_loop
	LDRB r0, [r2]			;if 0 store in data
		; Your code for your read_character routine is placed here

	POP {lr}
	mov pc, lr
	;############ read_character


output_character:
	PUSH {lr}   ; Store register lr on stack

output_character_loop:
	MOV r2, #0xC000
 	MOVT r2, #0x4000
	LDRB r1, [r2, #U0FR]	;get 0xFF bit
	AND r1, #0x20			;isolate 0xFF bit
	CMP r1, #0				;if bit 1 branch
	BNE output_character_loop
	STRB r0, [r2]			;if 0 store in data
		; Your code for your output_character routine is placed here

	POP {lr}
	mov pc, lr
	;############ output_character


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
	ORR r1, r1, #0x03
	STR r1, [r0]
	;Change PA0,PA1 to Use an Alternate Function
	MOV r0, #0x4420		;set address to 0x40004420
	LDR r1, [r0]
	ORR r1, r1, #0x03
	STR r1, [r0]
	;Configure PA0 and PA1 for UART
	MOV r0, #0x452C		;set address to 0x4000452C
	LDR r1, [r0]
	ORR r1, r1, #0x11
	STR r1, [r0]

		; Your code for your uart_init routine is placed here

	POP {lr}
	mov pc, lr
	;############ uart_init


int2string:
	PUSH {lr}   ; Store register lr on stack

		; Your code for your int2string routine is placed here

	POP {lr}
	mov pc, lr
	;############ int2string


string2int:
	PUSH {lr}   ; Store register lr on stack

		; Your code for your string2int routine is placed here

	POP {lr}
	mov pc, lr
	;############ string2int

	.end
