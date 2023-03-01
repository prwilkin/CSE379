	.data

	.global lab3part1

U0FR: 	.equ 0x18	; UART0 Flag Register
					; 0x4000 C000

	.text
lab3:
	PUSH {lr}   ; Store lr to stack

		; Your code is placed here.
 		; Sample test code starts here
 		MOV r2, #0xC000
 		MOVT r2, #0x4000

		BL read_character
		BL output_character

		; Sample test code ends here


	POP {lr}	  ; Restore lr from stack
	mov pc, lr


output_character:
	PUSH {lr}   ; Store register lr on stack
repeat2:
	LDRB r10, [r2 , #U0FR]	;get 0xFF bit
	AND r9, r10, #0x20		;isolate 0xFF bit
	CMP r9, #0				;if bit 1 branch
	BNE repeat2
	STRB r0, [r2]			;if 0 store in data
		; Your code to output a character to be displayed in PuTTy
		; is placed here.  The character to be displayed is passed
		; into the routine in r0.

	POP {lr}
	mov pc, lr



read_character:
	PUSH {lr}   ; Store register lr on stack
repeat:
	LDRB r1, [r2 , #U0FR]	;get 0xFE bit
	AND r1, #0x10			;isolate OxFE bit
	CMP r1, #0x10			;if bit 1 branch
	BEQ repeat
	LDRB r0, [r2]			;if 0 store in data
		; Your code to receive a character obtained from the keyboard
		; in PuTTy is placed here.  The character is received in r0.

	POP {lr}
	mov pc, lr


	.end
