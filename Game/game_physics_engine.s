.data
	.global paddleX

blocksrow2:			.byte 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01	;init alive with no color	1st 4 bits are for live
blocksrow3:			.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00	;init dead with no color	2nd 4 bits are for color
blocksrow4:			.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00	;init dead with no color
blocksrow5:			.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00	;init dead with no color
LeftRight: 			.byte 0x00 		;init to be straight	Left=0 NUll=1 Right=2 | x = LeftRight - 1
UpDown:				.byte 0x01		;init to fall down		Up=2 Down=0			  | y = (UpDown -1) * angle
angle:				.byte 0x00		;						180=1 60=2 45=1		  | angle = paddle section
cordinatesNow:		.half 0x0B06
cordinatesNext: 	.half 0x0b07
paddleX:			.byte 0x09
blocklvls:			.byte 0x01
**********************************from exterior file**********************************************
	.global ballcolor	;game_printer_and_sub
	.global scorestr	;game_printer_and_sub
	.global score		;game
	.global gamelevel	;game

.text
	.global phsyics
	.global paddle
	.global checkermanager
	.global decode
	.global encode
	.global decodeBlock
	.global encodeBlock
**********************************from exterior file**********************************************
	.global int2string	;game_printer_and_sub
	.global lifelost	;game
**************************************************************************************************
ptr_to_blocksrow2:		.word blocksrow2
ptr_to_blocksrow3:		.word blocksrow3
ptr_to_blocksrow4:		.word blocksrow4
ptr_to_blocksrow5:		.word blocksrow5
ptr_to_LeftRight:		.word LeftRight
ptr_to_UpDown:			.word UpDown
ptr_to_angle:			.word angle
ptr_to_cordinatesNow:	.word cordinatesNow
ptr_to_cordinatesNext:	.word cordinatesNext
ptr_to_paddleX:			.word paddleX
ptr_to_blocklvls:		.word blocklvls
**********************************ptr to exterior file**********************************************
ptr_to_ballcolor:		.word ballcolor
ptr_to_scorestr:		.word scorestr
ptr_to_score:			.word score
ptr_to_gamelevel:		.word gamelevel
****************************************************************************************************

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
	POP {pc}
	;############################################# phsyics END #############################################

paddle:
	PUSH {lr}	;takes r0 & r1 as x & y, r2 as left paddle, r3 as LeftRight, r4 as UpDown, r5 as right paddle
paddle1:
	CMP r2, r0
	BNE paddle2
	MOV r3, #0
	LDR	r2, ptr_to_LeftRight
	STRB r3, [r2]
	MOV r4, #2
	LDR	r2, ptr_to_UpDown
	STRB r4, [r2]
	MOV r5, #1
	LDR r2, ptr_to_angle
	STRB r5, [r2]
paddle2:
	ADD r2, #1
	CMP r2, r0
	BNE paddle3
	MOV r3, #0
	LDR	r2, ptr_to_LeftRight
	STRB r3, [r2]
	MOV r4, #2
	LDR	r2, ptr_to_UpDown
	STRB r4, [r2]
	MOV r5, #2
	LDR r2, ptr_to_angle
	STRB r5, [r2]
paddle3:
	ADD r2, #1
	CMP r2, r0
	BNE paddle4
	MOV r3, #1
	LDR	r2, ptr_to_LeftRight
	STRB r3, [r2]
	MOV r4, #2
	LDR	r2, ptr_to_UpDown
	STRB r4, [r2]
	MOV r5, #1
	LDR r2, ptr_to_angle
	STRB r5, [r2]
paddle4:
	ADD r2, #1
	CMP r2, r0
	BNE paddle5
	MOV r3, #2
	LDR	r2, ptr_to_LeftRight
	STRB r3, [r2]
	MOV r4, #2
	LDR	r2, ptr_to_UpDown
	STRB r4, [r2]
	MOV r5, #2
	LDR r2, ptr_to_angle
	STRB r5, [r2]
paddle5:
	ADD r2, #1
	CMP r2, r0
	BNE paddleE
	MOV r3, #2
	LDR	r2, ptr_to_LeftRight
	STRB r3, [r2]
	MOV r4, #2
	LDR	r2, ptr_to_UpDown
	STRB r4, [r2]
	MOV r5, #1
	LDR r2, ptr_to_angle
	STRB r5, [r2]
paddleE:
	POP {lr}	;move lr to game
	B checkermanager
	;############################################# paddle END #############################################

checkermanager:
	PUSH {lr}
	LDR r0, ptr_to_LeftRight
	LDR r3, [r0]
	LDR r0, ptr_to_UpDown
	LDR r4, [r0]
	LDR r0, ptr_to_angle
	LDR r2, [r0]
	LDR r2, ptr_to_cordinatesNow
	BL decode
	CMP r3, #1
	BEQ checker180	;Ball is going up or down only
	CMP r2, #1
	BEQ checker45

	LDR r2, ptr_to_cordinatesNext
	BL encode


	;############################################# checkermanager #############################################


checker180:
	CMP r4, #1		;is direction up?
	BNE checker180Down
checker180Up:
	CMP r1, #0x01	;on row 1
	IT EQ
	SUBEQ r1, #1	;sub 1 from y
	BEQ checker180end
	;exit checker180
	BGT checker180UpBlock
checker180UpWall:
	;is at wall then send down
	ADD r1, #1		;add 1 to y
	MOV r4, #0		;set UpDown to down
	B checker180end
	;exit checker180
checker180UpBlock:
	CMP r1, #0x07	;if on row 7 to 16 adjust and exit
	IT GE
	SUBGE r1, #1	;sub 1 from y
	BGE checker180end
	;exit checker180
	;have to check if in block area
	SUB  r2, r1, #1
	LDR r5, ptr_to_blocklvls
	LDR r5, [r5]
	ADD r5, #1
	CMP r2, r5
	IT GT			;not in block range
	SUBGT r1, #1	;sub 1 from y
	BGT checker180end
	;exit checker180
	;else see if block is alive
	PUSH {r3, r4}
	BL getBlockLive
	CMP r4, #1		;is block alive
	BLEQ blockHit	;yes
	POP {r3, r4}
	;set cordinates for yes and no
	CMP r4, #1
	ITTE EQ
	ADDEQ r1, #1	;add 1 to y
	MOVEQ r4, #0	;set UpDown to down
	SUBNE r1, #1	;sub 1 from y
	B checker180end
	;exit checker180
checker180Down:
	CMP r1, #0x10	;bottom row past paddle
	BEQ lifelost
	CMP r1, #0x0F	;one above paddle
	BNE checker180DownBlock
checker180DownPaddle:
	LDR r5, ptr_to_paddleX
	LDRB r2, [r5]		;get left x cord
	ADD r5, r2, #4		;get right x cord
	CMP r2, r0			;if left of paddle
	IT GT
	ADDGT r1, #1
	BGT checker180end
	;exit checker180
	CMP r0, r5			;if right of paddle
	IT GT
	ADDGT r1, #1
	BGT checker180end
	;exit checker180
	B paddle
	;exit back to checkermanager restart after paddle is done
checker180DownBlock:
	CMP r1, #0x06	;if on row 6 to 16 adjust and exit
	IT GE
	ADDGE r1, #1	;add 1 from y
	BGE checker180end
	;exit checker180
	CMP r1, #0x00	;on row 0
	IT EQ
	ADDEQ r1, #1	;add 1 from y
	BEQ checker180end
	;exit checker180
	;have to check if in block area
	ADD r2, r1, #1
	LDR r5, ptr_to_blocklvls
	LDR r5, [r5]
	ADD r5, #1
	CMP r2, r5
	IT GT			;not in block range
	SUBGT r1, #1	;sub 1 from y
	BGT checker180end
	;exit checker180
	;else see if block is alive
	PUSH {r3, r4}
	BL getBlockLive
	CMP r4, #1		;is block alive
	BLEQ blockHit	;yes
	POP {r3, r4}
	;set cordinates for yes and no
	CMP r4, #1
	ITTE EQ
	SUBEQ r1, #1	;add 1 to y
	MOVEQ r4, #2	;set UpDown to down
	ADDNE r1, #1	;sub 1 from y
checker180end:
	LDR r2, ptr_to_cordinatesNext
	BL encode
	POP {pc}
	;exit checker180
	;############################################# checker180 END #############################################

checker45:

checker45end:
	LDR r2, ptr_to_cordinatesNext
	BL encode
	POP {pc}
	;exit checker180
	;############################################# checker45 END #############################################

getBlockLive:
	PUSH {lr}
	;determine which row to check
	CMP r1, #0x02
	IT EQ
	LDREQ r2, ptr_to_blocksrow2
	CMP r1, #0x03
	IT EQ
	LDREQ r2, ptr_to_blocksrow3
	CMP r1, #0x04
	IT EQ
	LDREQ r2, ptr_to_blocksrow4
	CMP r1, #0x05
	IT EQ
	LDREQ r2, ptr_to_blocksrow5
	;determine block number
	CMP r0, #0x02	;block 0
	ITT LE
	MOVLE r5, #0
	BLE gotBlock
	CMP r0, #0x05	;block 1
	ITT LE
	MOVLE r5, #1
	BLE gotBlock
	CMP r0, #0x08	;block 2
	ITT LE
	MOVLE r5, #2
	BLE gotBlock
	CMP r0, #0x0B	;block 3
	ITT LE
	MOVLE r5, #3
	BLE gotBlock
	CMP r0, #0x0E	;block 4
	ITT LE
	MOVLE r5, #0
	BLE gotBlock
	CMP r0, #0x11	;block 5
	ITT LE
	MOVLE r5, #0
	BLE gotBlock
	CMP r0, #0x14	;block 6
	IT LE
	MOVLE r5, #0
gotBlock:
	BL decodeBlock
	POP {pc}
	;############################################# getBlockLive END #############################################

blockHit:
	PUSH {lr}
	MOV r4, #0
	BL decodeBlock	;kill block
	LDR r4, ptr_to_ballcolor
	STRB r3, [r4]	;update ball color
	;BL rgb light
	LDR r4, ptr_to_score
	LDRH r2, [r4]
	LDR r4, ptr_to_gamelevel
	LDRB r3, [r4]
	ADD r2, r3
	STRH r2, [r4]
	PUSH {r0, r1}
	MOV r0, r2
	LDR r1, ptr_to_scorestr
	BL int2string
	POP {r0, r1}
	POP {pc}
	;############################################# blockHit END #############################################




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
	POP {pc}
	;############################################# checker_walls END #############################################

checker_block:
	PUSH {lr}
	POP {pc}
	;############################################# checker_block END #############################################

decode:
	PUSH {lr}

	LDRH r0, [r2]
	AND r1, r0, #0xFF	;y cordinates
	LSR r0, #8			;x cordinates

	POP {pc}
	;############################################# decode END #############################################

encode:
 	PUSH {lr}

	LSL r0, #8		;store x cordinates
	ORR r0, r1		;insert y cordinates
	STRH r0, [r2]	;store in memory

	POP {pc}
	;############################################# encode END #############################################

decodeBlock:
	PUSH {lr}
	;takes r2 as ptr_to_blockrow#
	;takes r5 as block# for offset
	LDRB r3, [r2, r5]
	AND r4, r3, #0xF	;live status
	LSR r3, #4			;color

	POP {pc}
	;############################################# decodeBlock END #############################################

encodeBlock:
 	PUSH {lr}
	;takes r2 as ptr_to_blockrow#
	;takes r5 as block# for offset
	LSL r3, #4		;store color
	ORR r3, r4		;insert live status
	STRB r3, [r2]	;store in memory

	POP {pc}
	;############################################# encodeBlock END #############################################

directionflip:
	CMP r3, #1
	IT EQ
	POPEQ {pc}
	CMP r3, #0
	ITE EQ
	MOVEQ r3, #2
	MOVNE r3, #0
	POP {pc}
	;############################################# directionflip END #############################################

.end
