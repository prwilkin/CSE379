.data
;this file is for interrupt hanlders only
**********************************from exterior file**********************************************
	.global paddleX
.text
;handler subroutines: (in order of apperance in file)
;	uart, switch, timer, simple read char, disable timer, & enable timer
	.global UART0_Handler
	.global Switch_Handler
	.global Timer_Handler
	.global simple_read_character
	.global DisableT
	.global EnableT
**********************************from exterior file**********************************************
	.global game
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
ptr_to_paddleX: .word paddleX
**************************************************************************************************

;UART0_HANLDER SUBROUTINE
UART0_Handler:
	PUSH {lr}
	LDR r0, UART0
	LDR r1, [r0, #0x044]
	ORR r1, #0x10				;MASK bit
	STR r1, [r0, #0x044]		;reset interupt flag
	BL simple_read_character	;retrive character

Q:
	CMP r0, #0x71	;if q end game
	BNE D
	B end

D:
	CMP r0, #0x64	;if D move 1 right
	BNE A
	LDR r0, ptr_to_paddleX
	LDRH r1, [r0]
	LSR r2, r1, #8
	CMP r2, #0x14
	BEQ UART0_Handler_end
	ADD r1, #0x0100
	STRH r1, [r0]			;TODO NEED debug

A:
	CMP r0, #0x61	;if A move 1 left
	BNE UART0_Handler_end
	LDR r0, ptr_to_paddleX
	LDRH r1, [r0]
	CMP r1, #0x0010
	BEQ UART0_Handler_end
	SUB r1, #0x0100
	STRH r1, [r0]			;TODO NEED debug

UART0_Handler_end:
	POP {lr}
	BX lr       	; Return
	;############################################# UART0_Handler END #############################################

Switch_Handler:
	PUSH {lr}
	ADD r5, r5, #1
	LDR r0, GPIO_PORT_F
	LDR r1, [r0, #0x41C]
	ORR r1, #0x10			;mask bit
	STR r1, [r0, #0x41C]	;reset interupt flag

	CMP r7, #0
	BEQ Disable
	BNE Enable

Disable:
	;Disable Timer
	MOV r0, #0x0000				;move memory address of Timer0 base address to r0
	MOVT r0, #0x4003
	LDR r1, [r0, #0x00C]		;load content of r0 with offset with 0x00C to r1
	BIC r1, #0x1				;clear bit 0 to disable Timer0
	STR r1, [r0, #0x00C]		;store r1 into r0 to disable Timer0
	ADD r7, #1
	B endswitch

Enable:
	;Enable Timer
	MOV r0, #0x0000				;move memory address of Timer0 base address to r0
	MOVT r0, #0x4003
	LDR r1, [r0, #0x00C]		;load content of r0 with offset of 0x00C to r1
	ORR r1, #0x1				;set bit 0 to enable Timer0
	STR r1, [r0, #0x00C]		;store r1 into r0 to enable Timer0
	SUB r7, #1
	B endswitch

endswitch:
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
	BL game

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

DisableT:
	;Disable Timer
	PUSH {lr}
	MOV r0, #0x0000				;move memory address of Timer0 base address to r0
	MOVT r0, #0x4003
	LDR r1, [r0, #0x00C]		;load content of r0 with offset with 0x00C to r1
	BIC r1, #0x1				;clear bit 0 to disable Timer0
	STR r1, [r0, #0x00C]		;store r1 into r0 to disable Timer0
	POP {lr}
	MOV pc, lr
	;############################################# DisableT END #############################################

EnableT:
	;Enable Timer
	PUSH {lr}
	MOV r0, #0x0000				;move memory address of Timer0 base address to r0
	MOVT r0, #0x4003
	LDR r1, [r0, #0x00C]		;load content of r0 with offset of 0x00C to r1
	ORR r1, #0x1				;set bit 0 to enable Timer0
	STR r1, [r0, #0x00C]		;store r1 into r0 to enable Timer0
	POP {pc}
	;############################################# EnableT END #############################################

end:
.end
