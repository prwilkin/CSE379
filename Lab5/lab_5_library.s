	.data

	.global prompt
	.global mydata
	.global prompt2
	.global buttonInt2String
	.global keyInt2String

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

ptr_to_prompt:		.word prompt
ptr_to_prompt2:		.word prompt2
ptr_to_buttonInt2String:	.word buttonInt2String
ptr_to_keyInt2String:		.word keyInt2String
ptr_to_mydata:		.word mydata

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

;POST_INTERUPT SUBROUTINE
post_interupt:
	PUSH {lr}

	BL clr_page				;clear terminal
	LDR r0, ptr_to_prompt
	BL output_string		;print prompt
	LDR r1, ptr_to_buttonInt2String
	MOV r0, r6				;pass button press counter
	BL int2string			;convert counter to string
	LDR r0, ptr_to_buttonInt2String
	BL output_string		;print button int
	BL new_line
	MOV r1, r6				;pass button press counter
	BL printer_bar			;print button bar
	LDR r0, ptr_to_prompt2
	BL output_string		;print key prompt
	LDR r1, ptr_to_keyInt2String
	MOV r0, r7				;pass key press counter
	BL int2string			;convert counter to string
	LDR r0, ptr_to_keyInt2String
	BL output_string		;print key int
	BL new_line
	MOV r1, r7				;pass button press counter
	BL printer_bar			;print key bar

	POP {lr}
	MOV pc, lr
	;############################################# post_interupt END #############################################

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


;PRINTER_BAR SUBROUTINE
printer_bar:
	PUSH {lr}
	PUSH {r0}

	MOV r8, #0				;set counter to 0
	MOV r0, #0x23			;set char to #
printer_loop:
	CMP r8, r1				;see how many times to print
	BEQ printer_end
	PUSH {r1}
	BL output_character		;print one char
	POP {r1}
	ADD r8, #1				;++ counter
	B printer_loop
printer_end:

	POP {r0}
	POP {lr}
	MOV pc, lr
	;############################################# printer_bar END #############################################


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

.end
