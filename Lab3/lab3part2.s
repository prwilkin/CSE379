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

		; Your code for your uart_init routine is placed here

	POP {lr}
	mov pc, lr

int2string:
	PUSH {lr}   ; Store register lr on stack
	
loopint2string:	
	LDRB r6, [ptr_to_num_1_string, #1]
	CMP r6, #0
	BEQ exit
	ADD r6, r6, #48
	STRB r6, [ptr_to_num_1_string]
	B loopint2string
exit:
	POP {lr}
	mov pc, lr


string2int:
	PUSH {lr}   ; Store register lr on stack
	MOV r8, #0
	MOV r9, #10
loopstring2int:
	LDRB r6, [ptr_to_num_1_string, #1]
	SUB r6, #48
	ADD r8, r8, r6
	MUL r8, r8, r9
	
		; Your code for your string2int routine is placed here
	

	POP {lr}
	mov pc, lr

	.end
