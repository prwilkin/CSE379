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
	LDRB r0, [r1, #1] 	;get the int 
	CMP r0, #0 		;check if it null 
	BEQ exit 		;exit if it null
	ADD r0, r0, #48   	;convert int into string
	STRB r0, [r1] 		;store the string into the memory address
	B loopint2string    	;go back to loop
exit:
		; Your code for your int2string routine is placed here
		
	POP {lr}
	mov pc, lr

string2int:
	PUSH {lr}   ; Store register lr on stack
	
loopstring2int:
	LDRB r1,[r0, #1]	;get the string
	CMP r1, #0		;check if it null
	BEQ exit		;exit if it null
	SUB r1, r1, $48		;convert string to int
	STRB r1, [r0]		;store the int into the memory address
	B loopstring2int	;go back to loop
exit:

		; Your code for your string2int routine is placed here


	POP {lr}
	mov pc, lr

	.end
