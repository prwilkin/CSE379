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
	.global Four_LED_subroutine
	.global Timer_Handler_RNG
	.global read_from_push_btns
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
	B end_game

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

	;Set RGB Color to Blue when paused
	LDR r0, GPIO_PORT_F
	LDR r1, [r0, #GPIODATA]
	ORR r1, #0x4
	STR r1, [r0, #GPIODATA]
	B endswitch


Enable:
	;Enable Timer
	MOV r0, #0x0000				;move memory address of Timer0 base address to r0
	MOVT r0, #0x4003
	LDR r1, [r0, #0x00C]		;load content of r0 with offset of 0x00C to r1
	ORR r1, #0x1				;set bit 0 to enable Timer0
	STR r1, [r0, #0x00C]		;store r1 into r0 to enable Timer0
	SUB r7, #1

	;Stop RGB Color to Blue when resumed
	LDR r0, GPIO_PORT_F
	LDR r1, [r0, #GPIODATA]
	BIC r1, #0x4
	STR r1, [r0, #GPIODATA]
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

Timer_Handler_RNG:
	PUSH {lr}					;random number goes in r9
	PUSH {r10,r6,r8}

	MOV r10, #5

	MOV r0, #0x0000				;move memory address of Timer1 base address to r0
	MOVT r0, #0x4003
	LDR r1, [r0, #0x024]		;load content of r0 with offset of 0x024 to r1
	ORR r1, #0x1				;set bit 0 to clear Timer1 interrupt so Timer1 interrupt can be interrupted again
	STR r1, [r0, #0x024]		;store r1 into r0 to clear Timer0 interrupt so Timer1 interrupt can be interrupted again

AGAIN:
	MOV r6, #0xFFFF
DELAY:
    SUBS r6, r6, #1
    BNE DELAY
	LDR r1, [r0, #0x050]
	MOV r8, r9
	SDIV r2, r1, r10
	MUL r3, r2, r10
	SUB r9, r1, r3
	CMP r9, r8
	BEQ AGAIN



	POP {r10,r6,r8}
	POP {lr}
	BX lr       	; Return
	;############################################# Timer_Handler_RNG END #############################################

Four_LED_subroutine:
	PUSH {lr}
	CMP r6, #0xF
	BEQ setlight1
	BNE Threelives
setlight1:
	LDR r0, GPIO_PORT_B
	LDR r1, [r0, #GPIODATA]
	BIC r1, #0x00
	ORR r1, r6
	STR r1, [r0, #GPIODATA]
	MOV r6, #0x7
	B end4light
Threelives:
	CMP r6, #0x7
	BEQ setlight2
	BNE Twolives
setlight2:
	LDR r0, GPIO_PORT_B
	LDR r1, [r0, #GPIODATA]
	AND r1, #0x00
	ORR r1, r6
	STR r1, [r0, #GPIODATA]
	MOV r6, #0x3
	B end4light
Twolives:
	CMP r6, #0x3
	BEQ setlight3
	BNE Onelives
setlight3:
	LDR r0, GPIO_PORT_B
	LDR r1, [r0, #GPIODATA]
	AND r1, #0x00
	ORR r1, r6
	STR r1, [r0, #GPIODATA]
	MOV r6, #0x1
	B end4light
Onelives:
	CMP r6, #0x1
	BEQ setlight4
	BNE Zerolives
setlight4:
	LDR r0, GPIO_PORT_B
	LDR r1, [r0, #GPIODATA]
	AND r1, #0x00
	ORR r1, r6
	STR r1, [r0, #GPIODATA]
	MOV r6, #0x0
	B end4light
Zerolives:
	CMP r6, #0x0
	BEQ setlight5
setlight5:
	LDR r0, GPIO_PORT_B
	LDR r1, [r0, #GPIODATA]
	AND r1, #0x00
	ORR r1, r6
	STR r1, [r0, #GPIODATA]
end4light:
	POP {lr}
	MOV pc, lr
	;############################################# Four_LED_subroutine END #############################################

read_from_push_btns:
	PUSH {lr} ; Store register lr on stack

	;READ PORT D
	LDR r0, GPIO_PORT_D		;move memory address of Port D base address to r0
read_from_push_btns_loop:
	LDR r1, [r0, #GPIODATA]		;load r0 with to offset of #GPIODATA to r1
	MOV r2, r1					;copy r1 to r2
	MOV r3, #0x0				;set r3 as 0x0
	AND r2, #0x1				;bit masking
	CMP r2, #0x1				;compare r2 with 0x1
	BEQ equal1					;branch if r2 does equal to 0x1
	BNE notequal1				;branch if r2 does not equal to 0x1
check1:
	MOV r2, r1					;copy r1 to r2
	AND r2, #0x2				;bit masking
	CMP r2, #0x2				;compare r2 with 0x2
	BEQ equal2					;branch if r2 does equal to 0x2
	BNE notequal2				;branch if r2 does not equal to 0x2
check2:
	MOV r2, r1					;copy r1 to r2
	AND r2, #0x4				;bit masking
	CMP r2, #0x4				;compare r2	with 0x4
	BEQ equal3					;branch if r2 does equal to 0x4
	BNE notequal3				;branch if r2 does not equal to 0x4
check3:
	MOV r2, r1					;copy r1 to r2
	AND r2, #0x8				;bit masking
	CMP r2, #0x8				;compare r2 wih 0x8
	BEQ equal4					;branch if r2 does equal to 0x8
	BNE notequal4				;branch if r2 does not equal to 0x8
equal1:
	ORR r3, #1					;set bit 0 in r3
	B end						;branch to end
notequal1:
	ORR r3, #0x0				;does not do anything to the bit in r3
	B check1					;branch back to check the second button
equal2:
	ORR r3, #2					;set bit 1 in r3
	B end						;branch to end
notequal2:
	ORR r3, #0x0				;does not do anything to the bit in r3
	B check2					;branch back to check the third button
equal3:
	ORR r3, #3					;set bit 2 in r3
	B end						;branch to end
notequal3:
	ORR r3, #0x0				;does not do anything to the bit in r3
	B check3					;branch back to check the fourth button
equal4:
	ORR r3, #4					;set bit 3 in r3
	B end						;branch to end
notequal4:
	ORR r3, #0x0				;does not do anything to the bit in r3
	B read_from_push_btns_loop	;branch to read_from_push_btns_loop to keep checking the 4 button again
end:
	STR r3, [r0, #GPIODATA]		;store r3 to r0 with the offset GPIODATA
	MOV r0, r3

	POP {lr}
	MOV pc, lr
	;############################################# read_from_push_btns END #############################################
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

end_game:
.end
