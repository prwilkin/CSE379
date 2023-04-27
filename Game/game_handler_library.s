	.data
;this file is for interrupt hanlders only
**********************************from exterior file**********************************************
	.global paddleX		;game_physics_engine
	.global blocklvls	;game_physics_engine
	.global ballcolor	;game_printer_and_sub
**************************************************************************************************

	.text
;handler subroutines: (in order of apperance in file)
;	uart, rgbLED, switch, read push button, four led, timer, timer rng, EnableRNG, DisableRNG
;	simple read char, disable timer, & enable timer
	.global UART0_Handler
	.global rgbLED
	.global Switch_Handler
	.global read_from_push_btns
	.global Four_LED_subroutine
	.global Timer_Handler
	.global Timer_Handler_RNG
	.global EnableRNG
	.global DisableRNG
	.global simple_read_character
	.global DisableT
	.global EnableT
**********************************from exterior file**********************************************
	.global game		;game
	.global BlockCreate	;game
	.global BeginBlockLoop	;game
	.global gameprinter	;game_printer_and_sub
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
**********************************from exterior file**********************************************
ptr_to_paddleX: 		.word paddleX
ptr_to_blocklvls:		.word blocklvls
ptr_to_ballcolor:		.word ballcolor
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
	STRH r1, [r0]

A:
	CMP r0, #0x61	;if A move 1 left
	BNE UART0_Handler_end
	LDR r0, ptr_to_paddleX
	LDRH r1, [r0]
	CMP r1, #0x0010
	BEQ UART0_Handler_end
	SUB r1, #0x0100
	STRH r1, [r0]

UART0_Handler_end:
	POP {lr}
	BX lr       	; Return
	;############################################# UART0_Handler END #############################################

rgbLED:
	PUSH {lr}
	LDR r0, ptr_to_ballcolor
	LDRB r0, [r0]
	LDR r1, GPIO_PORT_F
	STR r0, [r1, #GPIODATA]
	POP {pc}
	;############################################# rgbLED END #############################################

Switch_Handler:
	PUSH {lr}				;r7 has puase status
	LDR r0, GPIO_PORT_F			;move memory address of GPIO_PORT_F base address to r0
	LDR r1, [r0, #0x41C]		;load content of r0 with offset with 0x41C to r1
	ORR r1, #0x10				;mask bit
	STR r1, [r0, #0x41C]		;reset interupt flag

	CMP r7, #0					;register to keep check if it disable or enable
	BEQ Disable					;if r7 = 0 go to disable branch
	BNE Enable					;if r7 = 1 go to enable branch

Disable:
	;Disable Timer
	MOV r0, #0x0000				;move memory address of Timer0 base address to r0
	MOVT r0, #0x4003
	LDR r1, [r0, #0x00C]		;load content of r0 with offset with 0x00C to r1
	BIC r1, #0x1				;clear bit 0 to disable Timer0
	STR r1, [r0, #0x00C]		;store r1 into r0 to disable Timer0
	ADD r7, #1					;add 1 to r7 to make sure next time the switch is pressed go to enable branch

	;Set RGB Color to Blue when paused
	LDR r0, GPIO_PORT_F
	LDR r1, [r0, #GPIODATA]
	MOV r1, #0x4
	STR r1, [r0, #GPIODATA]
	BL gameprinter
	B endswitch

Enable:
	;Enable Timer
	MOV r0, #0x0000				;move memory address of Timer0 base address to r0
	MOVT r0, #0x4003
	LDR r1, [r0, #0x00C]		;load content of r0 with offset of 0x00C to r1
	ORR r1, #0x1				;set bit 0 to enable Timer0
	STR r1, [r0, #0x00C]		;store r1 into r0 to enable Timer0
	SUB r7, #1					;sub 1 to r7 to make sure next time the switch is pressed go to disable branch

	;Stop RGB Color to Blue when resumed
	LDR r0, GPIO_PORT_F
	LDR r1, ptr_to_ballcolor
	LDRB r1, [r1]
	STR r1, [r0, #GPIODATA]
	B endswitch

endswitch:
	POP {lr}
	BX lr       	; Return
	;############################################# Switch_Handler END #############################################

;READ_FROM_PUSH_BTNS_SUBROUTINE
read_from_push_btns:
	PUSH {lr} ; Store register lr on stack
	;rows are stored in r11///// ignore
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
	ORR r3, #7					;set r3 = 1 x 7
	B end						;branch to end
notequal1:
	ORR r3, #0x0				;does not do anything to the bit in r3
	B check1					;branch back to check the second button
equal2:
	ORR r3, #14					;set r3 = 2 x 7
	B end						;branch to end
notequal2:
	ORR r3, #0x0				;does not do anything to the bit in r3
	B check2					;branch back to check the third button
equal3:
	ORR r3, #21					;set r3 = 3 x 7
	B end						;branch to end
notequal3:
	ORR r3, #0x0				;does not do anything to the bit in r3
	B check3					;branch back to check the fourth button
equal4:
	ORR r3, #28					;set r3 = 4 x 7
	B end						;branch to end
notequal4:
	ORR r3, #0x0				;does not do anything to the bit in r3
	B read_from_push_btns_loop	;branch to read_from_push_btns_loop to keep checking the 4 button again
end:
	STR r3, [r0, #GPIODATA]		;store r3 to r0 with the offset GPIODATA
	LDR r0, ptr_to_blocklvls
	STRB r3, [r0]
	;MOV r11, r3					;copy r3 to r11

	POP {lr}
	MOV pc, lr
	;############################################# read_from_push_btns END #############################################

Four_LED_subroutine:
	PUSH {lr}				;lives stored in r6
	CMP r6, #0xF				;compare if r6 is 0xF
	BEQ setlight1				;if r6 is 0xF go to setlight1
	BNE Threelives				;if not go to Threelives
setlight1:
	LDR r0, GPIO_PORT_B			;move memory address of GPIO_PORT_B base address to r0
	LDR r1, [r0, #GPIODATA]		;load content of r0 with offset with GPIODATA to r1
	BIC r1, #0x00				;clear all bit to clear all the 4 LEDS on the ALICE Board
	ORR r1, r6					;set bit 0-3 to set all the 4 LEDs on the ALICE Board on
	STR r1, [r0, #GPIODATA]		;store r1 to r0 to set all the 4 LEDS on
	MOV r6, #0x7				;set r6 to 0x7 because next time the player lose a life it will go back here to set 3 LED on
	B end4light					;branch to end4light to end the subroutine
Threelives:
	CMP r6, #0x7				;compare if r6 is 0x7
	BEQ setlight2				;if r6 is 0x7 go to setlight2
	BNE Twolives				;if not go to Twolives
setlight2:
	LDR r0, GPIO_PORT_B			;move memory address of GPIO_PORT_B base address to r0
	LDR r1, [r0, #GPIODATA]		;load content of r0 with offset with GPIODATA to r1
	AND r1, #0x00				;clear all bit to clear all the 4 LEDS on the ALICE Board
	ORR r1, r6					;set bit 0-2 to set 3 LEDs on the ALICE Board on
	STR r1, [r0, #GPIODATA]		;store r1 to r0 to set 3 LEDS on
	MOV r6, #0x3				;set r6 to 0x3 because next time the player lose a life it will go back here to set 2 LED on
	B end4light					;branch to end4light to end the subroutine
Twolives:
	CMP r6, #0x3				;compare if r6 is 0x3
	BEQ setlight3				;if r6 is 0x7 go to setlight3
	BNE Onelives				;if not go to Onelives
setlight3:
	LDR r0, GPIO_PORT_B			;move memory address of GPIO_PORT_B base address to r0
	LDR r1, [r0, #GPIODATA]		;load content of r0 with offset with GPIODATA to r1
	AND r1, #0x00				;clear all bit to clear all the 4 LEDS on the ALICE Board
	ORR r1, r6					;set bit 0-1 to set 2 LEDs on the ALICE Board on
	STR r1, [r0, #GPIODATA]		;store r1 to r0 to set 2 LEDS on
	MOV r6, #0x1				;set r6 to 0x1 because next time the player lose a life it will go back here to set 1 LED on
	B end4light					;branch to end4light to end the subroutine
Onelives:
	CMP r6, #0x1				;compare if r6 is 0x1
	BEQ setlight4				;if r6 is 0x7 go to setlight4
	BNE Zerolives				;if not go to Zerolives
setlight4:
	LDR r0, GPIO_PORT_B			;move memory address of GPIO_PORT_B base address to r0
	LDR r1, [r0, #GPIODATA]		;load content of r0 with offset with GPIODATA to r1
	AND r1, #0x00				;clear all bit to clear all the 4 LEDS on the ALICE Board
	ORR r1, r6					;set bit 0 to set 1 LEDs on the ALICE Board on
	STR r1, [r0, #GPIODATA]		;store r1 to r0 to set 1 LEDS on
	MOV r6, #0x0				;set r6 to 0x1 because next time the player lose a life it will go back here to set 0 LED on
	B end4light					;branch to end4light to end the subroutine
Zerolives:
	CMP r6, #0x0				;compare if r6 is 0x0
	BEQ setlight5				;if r6 is 0x7 go to setlight4
setlight5:
	LDR r0, GPIO_PORT_B			;move memory address of GPIO_PORT_B base address to r0
	LDR r1, [r0, #GPIODATA]		;load content of r0 with offset with GPIODATA to r1
	AND r1, #0x00				;clear all bit to clear all the 4 LEDS on the ALICE Board
	ORR r1, r6					;clear all bit to set 0 LEDs on the ALICE Board on
	STR r1, [r0, #GPIODATA]		;store r1 to r0 to set 0 LEDS on
end4light:
	POP {lr}
	MOV pc, lr
	;############################################# Four_LED_subroutine END #############################################

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
	PUSH {lr}				;random number goes in r9
	PUSH {r10,r6,r8}

	MOV r10, #5					;r10 = 5 to be use to mod 5

	MOV r0, #0x1000				;move memory address of Timer1 base address to r0
	MOVT r0, #0x4003
	LDR r1, [r0, #0x024]		;load content of r0 with offset of 0x024 to r1
	ORR r1, #0x1				;set bit 0 to clear Timer1 interrupt so Timer1 interrupt can be interrupted again
	STR r1, [r0, #0x024]		;store r1 into r0 to clear Timer0 interrupt so Timer1 interrupt can be interrupted again

AGAIN:							;use a delay to make sure there no pattern in the Timer1 A Value
	MOV r6, #0x0009				;set r6 as a big value
DELAY:
    SUBS r6, r6, #1				;do a loop subracting r6 by 1 and setting r6 with the new value when it done subtracting
    BNE DELAY					;if r6 does not equal zero go back to loop to keep subtracting

	LDR r1, [r0, #0x050]		;load Timer A Value to r1
	MOV r8, r9					;copy r9 to r8
	SDIV r2, r1, r10			;divide Timer A Value by 5 to r2
	MUL r3, r2, r10				;multiply r2 with 5 to r3
	SUB r9, r1, r3				;subtract Timer A Value with the value of r3 to get the value of Timer A Value mod 5
	CMP r9, r8					;compare r9 and r8
	BEQ AGAIN					;branch to delay if r9 and r8 are equal to make sure pattern is randomized and no repeated number

	;///////disregard
	;CMP r11, #0
	;BEQ DisableRNG				;if r11 have a value of zero go to DisableRNG branch to disable the timer
	;BNE EnableRNG				;if r11 does not have of zero go to EnableRNG branch to enable the timer

	BL DisableRNG
	BL BlockCreate
	POP {r10,r6,r8}
	POP {lr}
	;ADR r0, GotoBeginBlockLoop
	;MOV lr, r0
	BX lr       	; Return
	;############################################# Timer_Handler_RNG END #############################################

EnableRNG:
	;Enable Timer
	MOV r0, #0x1000				;move memory address of Timer1 base address to r0
	MOVT r0, #0x4003
	LDR r1, [r0, #0x00C]		;load content of r0 with offset of 0x00C to r1
	ORR r1, #0x1				;set bit 0 to enable Timer1
	STR r1, [r0, #0x00C]		;store r1 into r0 to enable Timer1
	SUB r11, #1					;decrementing r11 by 1
	MOV pc, lr

DisableRNG:
	;Disable Timer
	MOV r0, #0x1000				;move memory address of Timer1 base address to r0
	MOVT r0, #0x4003
	LDR r1, [r0, #0x00C]		;load content of r0 with offset with 0x00C to r1
	BIC r1, #0x1				;clear bit 0 to disable Timer1
	STR r1, [r0, #0x00C]		;store r1 into r0 to disable Timer1
	MOV pc, lr


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

GotoBeginBlockLoop:
	B BeginBlockLoop

end_game:
	MOV r0, #0
	LDR r1, SYSCTL
	STR r0, [r1, #GPIODATA]
.end
