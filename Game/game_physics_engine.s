.data
	.global paddleX

LeftRight: 			.byte 0x00 		;init to be straight	Left=0 NUll=1 Right=2 | x = LeftRight - 1
UpDown:				.byte 0x01		;init to fall down		Up=2 Down=0			  | y = (UpDown -1) * angle
angle:				.byte 0x00		;						180=2 60=2 45=1		  | angle = paddle section
cordinatesNow:		.half 0x0B06
cordinatesNext: 	.half 0x0b07
paddleX:			.byte 0x09
blocklvls:			.byte 0x01

.text
	.global phsyics
	.global paddle
	.global checker
	.global decode
	.global encode
**********************************from exterior file**********************************************

**************************************************************************************************
ptr_to_LeftRight:		.word LeftRight
ptr_to_UpDown:			.word UpDown
ptr_to_angle:			.word angle
ptr_to_cordinatesNow:	.word cordinatesNow
ptr_to_cordinatesNext:	.word cordinatesNext
ptr_to_paddleX:			.word paddleX

phsyics:
	PUSH {lr}
	LDR r0, ptr_to_LeftRight
	LDR r3, [r0]
	MOV r2, #1
	SSUB8 r3, r3, r2			;set x modifyer
	LDR r0, ptr_to_UpDown
	LDR r4, [r0]
	SSUB8 r4, r4, r2			;begin y modifyer
	LDR r0, ptr_to_angle
	LDR r2, [r0]
	SMULBB r4, r4, r2			;finish y modifer
	LDR r2, ptr_to_cordinatesNow
	BL decode	;returns current x in r0 and y in r1
				;modifyers to x are in r3 and y in r4
	ADD r0, r3	;move x
	ADD r1, r4	;move y
	LDR r2, ptr_to_cordinatesNext
	BL encode
	POP {lr}
	MOV pc, lr
	;############################################# phsyics END #############################################

paddle:
	PUSH {lr}

;check if going to hit paddle if not take life

	POP {lr}
	MOV pc, lr
	;############################################# paddle END #############################################

checker:
	PUSH {lr}
	LDR r0, ptr_to_LeftRight
	LDR r3, [r0]
	LDR r0, ptr_to_UpDown
	LDR r4, [r0]
	LDR r0, ptr_to_angle
	LDR r2, [r0]
	LDR r2, ptr_to_cordinatesNow
	BL decode
	BL checker_walls
	BL checker_block


	POP {lr}
	MOV pc, lr
	;############################################# paddle END #############################################

checker_walls:
	PUSH {lr}

	CMP r0, #0x00
	BNE rightwall
	CMP r3, #0
	BNE rightwall
	ADD r3, #2
	B topwall
rightwall:
	CMP r0, #0x14
	BNE topwall
	CMP r3, #2
	BNE topwall
	SUB r3, #2
	B topwall
topwall:
	CMP r1, #0x01
	BLT bottomwall
	CMP r4, #0x00
	BNE bottomwall
	SUB r4, #2
bottomwall:
	BL paddle
	CMP r1, #0x0F
	BGT checker_walls_end
	CMP r4, #0x02
	BNE checker_walls_end


checker_walls_end:
	POP {lr}
	MOV pc, lr
	;############################################# paddle END #############################################

checker_block:
	PUSH {lr}

	POP {lr}
	MOV pc, lr
	;############################################# paddle END #############################################

decode:
	PUSH {lr}

	LDRH r0, [r2]
	AND r1, r0, #0xFF	;y cordinates
	LSR r0, #8			;x cordinates

	POP {lr}
	MOV pc, lr
	;############################################# decode END #############################################

encode:
 	PUSH {lr}

	LSL r0, #8		;store x cordinates
	ORR r0, r1		;insert y cordinates
	STRH r0, [r2]	;store in memory

	POP {lr}
	MOV pc, lr
	;############################################# encode END #############################################

.end
