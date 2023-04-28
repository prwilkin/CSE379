	.data

	.global blocksrow2
	.global blocksrow3
	.global blocksrow4
	.global blocksrow5
	.global cordinatesNow
	.global cordinatesNext
	.global paddleX
	.global blocklvls

blocksrow2:			.byte 0xA1, 0x61, 0x21, 0x81, 0x61, 0xA1, 0x41	;init alive with no color	1st 4 bits are for live
blocksrow3:			.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00	;init dead with no color	2nd 4 bits are for color
blocksrow4:			.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00	;init dead with no color
blocksrow5:			.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00	;init dead with no color
LeftRight: 			.byte 0x01 		;init to be straight	Left=0 NUll=1 Right=2 | x = LeftRight - 1
UpDown:				.byte 0x00		;init to fall down		Up=2 Down=0			  | y = (UpDown -1) * angle
angle:				.byte 0x01		;						180=1 60=2 45=1		  | angle = paddle section
cordinatesNow:		.half 0x0A06
cordinatesNext: 	.half 0x0A07
paddleX:			.half 0x0810
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
	.global rgbLED		;game_handler_library
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
	;takes r0 & r1 as x & y, r2 as left paddle, r3 as LeftRight, r4 as UpDown, r5 as right paddle
paddle1:
	CMP r2, r0		;is x at paddle 1
	BNE paddle2
	MOV r3, #0		;set LeftRight to left
	LDR	r2, ptr_to_LeftRight
	STRB r3, [r2]	;store LeftRight
	MOV r4, #2		;set UpDown to Up
	LDR	r2, ptr_to_UpDown
	STRB r4, [r2]	;store UpDown
	MOV r5, #1		;set angle to 45/180
	LDR r2, ptr_to_angle
	STRB r5, [r2]	;store angle
	B paddleE				;exit <=
paddle2:
	ADD r2, #1
	CMP r2, r0		;is x at paddle 2
	BNE paddle3
	MOV r3, #0		;set LeftRight to left
	LDR	r2, ptr_to_LeftRight
	STRB r3, [r2]	;store LeftRight
	MOV r4, #2		;store UpDown to Up
	LDR	r2, ptr_to_UpDown
	STRB r4, [r2]	;store UpDown
	MOV r5, #2		;set angle to 60
	LDR r2, ptr_to_angle
	STRB r5, [r2]	;store angle
	B paddleE				;exit <=
paddle3:
	ADD r2, #1
	CMP r2, r0		;is x at paddle 3
	BNE paddle4
	MOV r3, #1		;set LeftRight to Null
	LDR	r2, ptr_to_LeftRight
	STRB r3, [r2]	;store LeftRight
	MOV r4, #2		;store UpDown to Up
	LDR	r2, ptr_to_UpDown
	STRB r4, [r2]	;store UpDown
	MOV r5, #1		;set angle to 45/180
	LDR r2, ptr_to_angle
	STRB r5, [r2]	;store angle
	B paddleE				;exit <=
paddle4:
	ADD r2, #1
	CMP r2, r0		;is x at paddle 4
	BNE paddle5
	MOV r3, #2		;set LeftRight to Right
	LDR	r2, ptr_to_LeftRight
	STRB r3, [r2]	;store LeftRight
	MOV r4, #2		;set UpDown to Up
	LDR	r2, ptr_to_UpDown
	STRB r4, [r2]	;store UpDown
	MOV r5, #2		;set angle to 60
	LDR r2, ptr_to_angle
	STRB r5, [r2]	;store 60
	B paddleE				;exit <=
paddle5:
	ADD r2, #1
	CMP r2, r0		;is x at paddle 5
	BNE paddleE
	MOV r3, #2		;set LeftRight to Right
	LDR	r2, ptr_to_LeftRight
	STRB r3, [r2]	;store LeftRight
	MOV r4, #2		;set UpDown to Up
	LDR	r2, ptr_to_UpDown
	STRB r4, [r2]	;store UpDown
	MOV r5, #1		;set angle to 45/180
	LDR r2, ptr_to_angle
	STRB r5, [r2]	;store angle
paddleE:
	POP {lr}	;move lr to game
	B checkermanager
	;############################################# paddle END #############################################

checkermanager:
	PUSH {lr}
	LDR r0, ptr_to_LeftRight
	LDRB r3, [r0]
	LDR r0, ptr_to_UpDown
	LDRB r4, [r0]
	LDR r2, ptr_to_cordinatesNow
	BL decode
	LDR r2, ptr_to_angle
	LDRB r2, [r2]
	CMP r3, #1
	BEQ checker180	;Ball is going up or down only
	CMP r2, #1
	BEQ checker45	;if ball goin 45
	CMP r2, #2
	BEQ checker60	;if ball going 60

	;for fall though only
	POP {pc}
	;############################################# checkermanager #############################################


checker180:
	CMP r4, #2		;is direction up?
	BNE checker180Down
checker180Up:
	CMP r1, #0x01	;on row 1
	IT EQ
	SUBEQ r1, #1	;move 1 up
	BEQ checker180end		;exit <=
	BGT checker180UpBlock
checker180UpWall:
	;is at wall then send down
	ADD r1, #1		;move 1 down
	MOV r4, #0		;set UpDown to down
	B checker180end			;exit <=
checker180UpBlock:
	CMP r1, #0x07	;if on row 7 to 16 adjust and exit
	IT GE
	SUBGE r1, #1	;move 1 up
	BGE checker180end		;exit <=
	;have to check if in block area
	SUB  r2, r1, #1		;move 1 up
	LDR r5, ptr_to_blocklvls
	LDR r5, [r5]
	ADD r5, #1
	CMP r2, r5
	IT GT			;not in block range
	SUBGT r1, #1	;move 1 up
	BGT checker180end		;exit <=
	;else see if block is alive
	PUSH {r3, r4}
	SUB r1, #1
	BL getBlockLive
	ADD r1, #1
	CMP r4, #1		;is block alive
	IT EQ
	BLEQ blockHit	;yes
	;set cordinates for yes and no
	CMP r4, #1
	POP {r3, r4}
	ITTE EQ
	ADDEQ r1, #1	;then move 1 down
	MOVEQ r4, #0	;then set UpDown to down
	SUBNE r1, #1	;else move 1 up
	B checker180end			;exit <=
	;											+++++DOWN+++++
checker180Down:
	CMP r4, #0		;check for down
	BNE checker180end
	CMP r1, #0x10	;bottom row past paddle
	BEQ lifelost
checker180DownPaddle:
	CMP r1, #0x0F	;one above paddle
	BNE checker180DownBlock
	LDR r5, ptr_to_paddleX
	LDRB r2, [r5, #1]		;get left x cord
	ADD r5, r2, #4
	CMP r2, r0			;if left of paddle
	IT GT
	ADDGT r1, #1
	BGT checker180end		;exit <=
	CMP r5, r0			;if right of paddle
	IT LT
	ADDLT r1, #1
	BLT checker180end		;exit <=
	B paddle
	;exit back to checkermanager restart after paddle is done
checker180DownBlock:
	CMP r1, #0x06	;if on row 6 to 16 adjust and exit
	IT GE
	ADDGE r1, #1	;move 1 down
	BGE checker180end		;exit <=
	CMP r1, #0x00	;on row 0
	IT EQ
	ADDEQ r1, #1	;move 1 down
	BEQ checker180end		;exit <=
	;have to check if in block area
	ADD r2, r1, #1
	LDR r5, ptr_to_blocklvls
	LDR r5, [r5]
	ADD r5, #1
	CMP r2, r5
	IT GT			;not in block range
	ADDGT r1, #1	;move 1 up
	BGT checker180end		;exit <=
	;else see if block is alive
	PUSH {r3, r4}
	ADD r1, #1		;move 1 down
	BL getBlockLive
	SUB r1, #1		;reset y
	CMP r4, #1		;is block alive
	IT EQ
	BLEQ blockHit	;yes
	POP {r3, r4}
	;set cordinates for yes and no
	CMP r4, #1
	ITTE EQ
	SUBEQ r1, #1	;then move 1 up
	MOVEQ r4, #2	;then set UpDown to up
	ADDNE r1, #1	;else move 1 down
checker180end:
	LDR r2, ptr_to_cordinatesNext
	BL encode
	LDR r2, ptr_to_LeftRight
	STRB r3, [r2]
	LDR r2, ptr_to_UpDown
	STRB r4, [r2]
	POP {pc}
	;############################################# checker180 END #############################################

checker45:
	CMP r4, #2		;check for up
	BNE checker45Down
checker45Up:
	CMP r3, #0		;check for left
	BNE checker45UpRight
checker45UpLeft:
	CMP r1, #0x00	;check if along top
	BNE checker45UpLeftBlock
checker45UpLeftTop:
	CMP r0, #0x00	;test for edge case of corner
	ITTTT EQ		;if in upper left corner set variables and move to 1,1
	MOVEQ r0, #0x01
	MOVEQ r1, #0x01
	MOVEQ r3, #2
	MOVEQ r4, #0
	BEQ checker45end		;exit <=
	SUB r0, #1		;move 1 left
	ADD r1, #1		;move 1 down
	MOV r4, #0			;set UpDown to down
	B checker45end			;exit <=
checker45UpLeftBlock:
	CMP r1, #0x07
	BGE checker45UpLeftWall
	;have to check if in block area
	SUB  r2, r1, #1
	LDR r5, ptr_to_blocklvls
	LDRB r5, [r5]
	ADD r5, #1
	CMP r2, r5
	BGT	checker45UpLeftWall		;not in block range
	CMP r0, #0x00		;see if block and wall corner
	ITTTT EQ			;if yes
	SUBEQ r1, #1		;move 1 up
	PUSHEQ {r3, r4}
	BLEQ getBlockLive
	CMPEQ r4, #1		;if yes and block is alive then
	ITTTT EQ
	BLEQ blockHit		;kill block
	ADDEQ r0, #1		;move 1 right
	ADDEQ r1, #1		;move 1 down
	CMPEQ r4, #1
	ITTT EQ
	POPEQ {r3, r4}
	MOVEQ r3, #2		;set LeftRight to right
	MOVEQ r4, #0		;set UpDown to down
	BEQ checker45end		;exit <=
	;else see if blocks is alive
	PUSH {r0, r1}
	BL blockCheck45
	POP {r0, r1}
	;SUB r3, #1		;set LeftRight modified
	;SUB r4, #1		;set UpDown modifed
	ADD r0, r3		;move x
	SUB r1, r4		;move y
	ADD r3, #1		;reset LeftRight
	ADD r4, #1		;reset UpDown
	B checker45end			;exit <=
checker45UpLeftWall:
	CMP r0, #0x00
	ITTTT EQ
	ADDEQ r0, #1	;move 1 right
	SUBEQ r1, #1	;move 1 up
	MOVEQ r3, #2	;set LeftRight to right
	BEQ checker45end		;exit <=
checker45UpLeftElse:
	SUB r0, #1	;move 1 left
	SUB r1, #1	;move 1 up
	B checker45end			;exit <=
checker45UpRight:
	CMP r3, #2		;check for right
	BNE checker45Down
checker45UpRightTop:
	CMP r1, #0x00
	BNE checker45UpRightBlock
	CMP r0, #0x14	;test for edge case of corner
	ITTTT EQ		;if in upper left corner set variables and move to 19, 1
	MOVEQ r0, #0x13		;set x 19
	MOVEQ r1, #0x01		;set y 1
	MOVEQ r3, #0		;set LeftRight to left
	MOVEQ r4, #0		;set UpDown to Down
	BEQ checker45end		;exit <=
	ADD r0, #1			;move 1 right
	ADD r1, #1			;move 1 down
	MOV r4, #0			;set UpDown to down
	B checker45end			;exit <=
checker45UpRightBlock:
	CMP r1, #0x07
	BGE checker45UpRightWall
	;have to check if in block area
	SUB  r2, r1, #1
	LDR r5, ptr_to_blocklvls
	LDRB r5, [r5]
	ADD r5, #1
	CMP r2, r5
	BGT	checker45UpRightWall		;not in block range
	CMP r0, #0x14		;see if block and wall corner
	ITTTT EQ			;if yes
	SUBEQ r1, #1		;move 1 up
	PUSHEQ {r3, r4}
	BLEQ getBlockLive
	CMPEQ r4, #1		;if yes and block is alive then
	ITTTT EQ
	BLEQ blockHit		;kill block
	SUBEQ r0, #1		;move 1 left
	ADDEQ r1, #1		;move 1 down
	CMPEQ r4, #1
	ITTT EQ
	POPEQ {r3, r4}
	MOVEQ r3, #0		;set LeftRight to left
	MOVEQ r4, #0		;set UpDown to down
	BEQ checker45end		;exit <=
	;else see if blocks is alive
	PUSH {r0, r1}
	BL blockCheck45
	POP {r0, r1}
	;SUB r3, #1		;set LeftRight modified
	;SUB r4, #1		;set UpDown modifed
	ADD r0, r3		;move x
	SUB r1, r4		;move y
	ADD r3, #1		;reset LeftRight
	ADD r4, #1		;reset UpDown
	B checker45end			;exit <=
checker45UpRightWall:
	CMP r0, #0x14
	ITTTT EQ
	SUBEQ r0, #1	;move 1 left
	SUBEQ r1, #1	;move 1 up
	MOVEQ r3, #0	;set LeftRight to left
	BEQ checker45end		;exit <=
checker45UpRightElse:
	ADD r0, #1	;move 1 right
	SUB r1, #1	;move 1 up
	B checker45end			;exit <=
	;											+++++DOWN+++++
checker45Down:
	CMP r4, #0		;check for down
	BNE checker45end
checker45DownLeft:
	CMP r3, #0		;check for left
	BNE checker45DownRight
checker45DownLeftLifeLost:
	CMP r1, #0x10	;check if bottom row
	BEQ lifelost
checker45DownLeftPaddle:
	CMP r1, #0x0F
	BNE checker45DownLeftBlock
	LDR r5, ptr_to_paddleX
	LDRB r2, [r5, #1]		;get left x cord
	ADD r5, r2, #4		;get right x cord
	CMP r2, r0 		;if left of paddle
	BGT checker45DownLeftWall
	CMP r5, r0		;if right of paddle
	BLT checker45DownLeftWall
	B paddle			;exit <=
checker45DownLeftBlock:
	CMP r1, #0x06	;if on row 6 to 16 check walls
	BGE checker45DownLeftWall
	CMP r1, #0x00	;on row 0
	ITT EQ
	ADDEQ r0, #1	;move 1 left
	ADDEQ r1, #1	;move 1 down
	BEQ checker180end		;exit <=
	;have to check if in block area
	ADD r2, r1, #1
	LDR r5, ptr_to_blocklvls
	LDR r5, [r5]
	ADD r5, #1
	CMP r2, r5
	BGT checker45DownLeftWall	;not in block area
	CMP r0, #0x00		;see if block and wall corner
	ITTTT EQ			;if yes
	ADDEQ r1, #1		;move 1 down
	PUSHEQ {r3, r4}
	BLEQ getBlockLive
	CMPEQ r4, #1		;if yes and block is alive then
	ITTTT EQ
	BLEQ blockHit		;kill block
	ADDEQ r0, #1		;move 1 right
	SUBEQ r1, #1		;move 1 up
	CMPEQ r4, #1
	ITTT EQ
	POPEQ {r3, r4}
	MOVEQ r3, #2		;set LeftRight to right
	MOVEQ r4, #2		;set UpDown to up
	BEQ checker45end		;exit <=
	;else see if blocks is alive
	PUSH {r0, r1}
	BL blockCheck45
	POP {r0, r1}
	;SUB r3, #1		;set LeftRight modified
	;SUB r4, #1		;set UpDown modifed
	ADD r0, r3		;move x
	SUB r1, r4		;move y
	ADD r3, #1		;reset LeftRight
	ADD r4, #1		;reset UpDown
	B checker45end			;exit <=
checker45DownLeftWall:
	CMP r0, #0x00	;if along wall
	ITTTT EQ
	ADDEQ r0, #1	;move 1 right
	ADDEQ r1, #1	;move 1 down
	MOVEQ r3, #2	;set LeftRight to right
	BEQ checker45end		;exit <=
checker45DownLeftElse:
	SUB r0, #1		;move 1 left
	ADD r1, #1		;move 1 down
	B checker45end			;exit <=
checker45DownRight:
	CMP r3, #2		;check for right
	BNE checker45end
checker45DownRightLifeLost:
	CMP r1, #0x10	;check if bottom row
	BEQ lifelost
checker45DownRightPaddle:
	CMP r1, #0x0F
	BNE checker45DownRightBlock
	LDR r5, ptr_to_paddleX
	LDRB r2, [r5, #1]		;get left x cord
	ADD r5, r2, #4		;get right x cord
	CMP r2, r0 		;if left of paddle
	BGT checker45DownRightWall
	CMP r5, r0		;if right of paddle
	BLT checker45DownRightWall
	B paddle			;exit <=
checker45DownRightBlock:
	CMP r1, #0x06	;if on row 6 to 16 check walls
	BGE checker45DownRightWall
	CMP r1, #0x00	;on row 0
	ITT EQ
	ADDEQ r0, #1	;move 1 right
	ADDEQ r1, #1	;move 1 down
	BEQ checker180end		;exit <=
	CMP r0, #0x14		;see if block and wall corner
	ITTTT EQ			;if yes
	ADDEQ r1, #1		;move 1 down
	PUSHEQ {r3, r4}
	BLEQ getBlockLive
	CMPEQ r4, #1		;if yes and block is alive then
	ITTTT EQ
	BLEQ blockHit		;kill block
	SUBEQ r0, #1		;move 1 left
	SUBEQ r1, #1		;move 1 up
	CMPEQ r4, #1
	ITTT EQ
	POPEQ {r3, r4}
	MOVEQ r3, #0		;set LeftRight to left
	MOVEQ r4, #2		;set UpDown to up
	BEQ checker45end		;exit <=
	;else see if blocks is alive
	PUSH {r0, r1}
	BL blockCheck45
	POP {r0, r1}
	;SUB r3, #1		;set LeftRight modified
	;SUB r4, #1		;set UpDown modifed
	ADD r0, r3		;move x
	SUB r1, r4		;move y
	ADD r3, #1		;reset LeftRight
	ADD r4, #1		;reset UpDown
	B checker45end			;exit <=
checker45DownRightWall:
	CMP r0, #0x14	;if along wall
	ITTTT EQ
	SUBEQ r0, #1	;move 1 left
	ADDEQ r1, #1	;move 1 down
	MOVEQ r3, #0	;set LeftRight to left
	BEQ checker45end		;exit <=
checker45DownRightElse:
	ADD r0, #1		;move 1 right
	ADD r1, #1		;move 1 down
checker45end:
	LDR r2, ptr_to_cordinatesNext
	BL encode
	LDR r2, ptr_to_LeftRight
	STRB r3, [r2]
	LDR r2, ptr_to_UpDown
	STRB r4, [r2]
	POP {pc}
	;############################################# checker45 END #############################################

blockCheck45:
	PUSH {lr}
	SUB r3, r3, #1	;set LeftRight
	SUB r4, r4, #1	;set UpDown
	;check up down first
	SUB r1, r4		;adjust y
	PUSH {r3, r4}
	BL getBlockLive
	CMP r4, #1
	BNE blockCheck45noUpDown
	BLEQ blockHit
	;check for left
	POP {r3, r4}
	ADD r1, r4		;reset y
	ADD r0, r3		;adjust x
	PUSH {r3, r4}
	BL getBlockLive
	CMP r4, #1
	BNE blockCheck45noLeftRight
	BLEQ blockHit
	POP {r3, r4}
	ITTT EQ			;reset cordinates
	ADDEQ r1, r4
	ADDEQ r0, r3
	ADDEQ r0, r3
	CMP r3, #1
	ITE EQ		;if LeftRight is right then
	MOVEQ r3, #-1	;set left
	MOVNE r3, #1	;else set right
	CMP r4, #1
	ITE EQ		;if UpDown is Up
	MOVEQ r4, #-1	;set down
	MOVNE r4, #1	;else set Up
	POP {pc}
blockCheck45noLeftRight:
	POP {r3, r4}
	CMP r4, #1
	ITE EQ		;if UpDown is Up
	MOVEQ r4, #-1	;set down
	MOVNE r4, #1	;else set Up
	POP {pc}
blockCheck45noUpDown:
	;check for left
	POP {r3, r4}
	ADD r1, r4		;reset y
	ADD r0, r3		;adjust x
	PUSH {r3, r4}
	BL getBlockLive
	CMP r4, #1
	BNE blockCheck45cornerBlock
	BLEQ blockHit
	POP {r3, r4}
	CMP r3, #1
	ITE EQ		;if LeftRight is right then
	MOVEQ r3, #-1	;set left
	MOVNE r3, #1	;else set right
	POP {pc}
blockCheck45cornerBlock:
	POP {r3, r4}
	SUB r1, r4		;adjust y
	PUSH {r3, r4}
	BL getBlockLive
	CMP r4, #1
	ITT NE
	POPNE {r3, r4}
	POPNE {pc}
	BL blockHit		;if live note in r2
	MOV r2, #1
	POP {r3, r4}
	CMP r3, #1	;else set UpDown & LeftRight
	ITE EQ		;if LeftRight is right then
	MOVEQ r3, #-1	;set left
	MOVNE r3, #1	;else set right
	CMP r4, #1
	ITE EQ		;if UpDown is Up
	MOVEQ r4, #-1	;set down
	MOVNE r4, #1	;else set Up
	POP {pc}
	;############################################# blockCheck45 END #############################################

checker60:
	SUB r3, #1	;set LeftRight mod
	SUB r4, #1	;set UpDown mod
	BL checker60UpDown
	BL checker60LeftRight
	BL checker60UpDown2
checker60end:
	ADD r3, #1	;reset LeftRight
	ADD r4, #1	;reset UpDown
	LDR r2, ptr_to_cordinatesNext
	BL encode
	LDR r2, ptr_to_LeftRight
	STRB r3, [r2]
	LDR r2, ptr_to_UpDown
	STRB r4, [r2]
	POP {pc}
	;############################################# checker60 END #############################################

checker60UpDown:
	PUSH {lr}
	CMP r4, #1		;is UpDown up
	BNE checker60Down
checker60Up:
	CMP r1, #0x01	;row 1
	ITTT EQ
	SUBEQ r1, #1	;move up 1
	ADDEQ r0, r3		;move x accordingly
	POPEQ {lr}			;lr to game
	;BEQ checker60end		;exit <=
	CMP r1, #0x00	;row 0
	BNE	checker60UpDownBlock
	ADD r1, #1		;move down 1
	MOV r4, #-1		;set UpDown down
	CMP r3, #1
	ITE EQ			;if LeftRight is right
	MOVEQ r3, #-1	;then set left
	MOVNE r3, #1	;else set right
	POP {pc}			;exit <=
checker60Down:
	CMP r1, #0x10	;if bottom row
	ITTTT EQ
	ADDEQ r3, #1	;reset LeftRight
	ADDEQ r4, #1	;reset UpDown
	POPEQ {lr}
	BEQ lifelost
	CMP r1, #0x0F	;if above paddle
	BNE checker60UpDownBlock
	LDR r5, ptr_to_paddleX
	LDRB r2, [r5, #1]		;get left x cord
	ADD r5, r2, #4		;get right x cord
	CMP r2, r0 		;if left of paddle
	BGT checker60UpDownBlock
	CMP r5, r0		;if right of paddle
	BLT checker60UpDownBlock
	POP {lr}
	B paddle			;exit <=
checker60UpDownBlock:
	SUB r1, r4	;set y for check
	CMP r1, #0x06
	BGE checker60UpDownEnd
	;have to check if in block area
	LDR r5, ptr_to_blocklvls
	LDRB r5, [r5]
	ADD r5, #1
	CMP r1, r5
	BGT	checker60UpDownEnd		;not in block range
	PUSH {r3, r4}
	BL getBlockLive
	CMP r4, #1
	ITT NE
	POPNE {r3, r4}
	BNE checker60UpDownEnd	;if block dead exit
	BL blockHit
	POP {r3, r4}
	ADD r1, r4
	ADD r1, r4		;reset y move 1 accordingly
	CMP r4, #1		;if UpDown is up
	ITE EQ
	MOVEQ r4, #-1	;then set down
	MOVNE r4, #1	;else set up
checker60UpDownEnd:
	POP {pc}
	;############################################# checker60UpDown END #############################################

checker60LeftRight:
	PUSH {lr}
	CMP r0, #0x00	;left wall
	ITTT EQ
	ADDEQ r0, #1	;move 1 right
	MOVEQ r3, #1	;set LeftRight to right
	BEQ checker60LeftRightEnd	;exit <=
	CMP r0, #0x14	;right wall
	ITTT EQ
	SUBEQ r0, #1	;move 1 left
	MOVEQ r3, #-1	;set LeftRight to left
	BEQ checker60LeftRightEnd	;exit <=
	ADD r0, r3	;set x for check
	CMP r1, #0x01
	BLE checker60LeftRightEnd
	CMP r1, #0x06
	BGE checker60LeftRightEnd
	;have to check if in block area
	SUB  r2, r1, #1
	LDR r5, ptr_to_blocklvls
	LDRB r5, [r5]
	ADD r5, #1
	CMP r2, r5
	BGT	checker60UpDownEnd		;not in block range
	PUSH {r3, r4}
	BL getBlockLive
	CMP r4, #1
	ITT NE
	POPNE {r3, r4}
	BNE checker60UpDownEnd	;if block dead exit
	BL blockHit
	POP {r3, r4}
	SUB r0, r3
	SUB r0, r3		;reset x move 1 accordingly
	CMP r3, #1		;if LeftRight is right
	ITE EQ
	MOVEQ r3, #-1	;then set left
	MOVNE r3, #1	;else set right
checker60LeftRightEnd:
	POP {pc}
	;############################################# checker60LeftRight END #############################################

checker60UpDown2:
	PUSH {lr}
	CMP r4, #1		;is UpDown up
	BNE checker60Down2
checker60Up2:
	CMP r1, #0x01	;row 1
	ITT EQ
	SUBEQ r1, #1	;move up 1
	POPEQ {pc}			;exit <=
checker60Down2:
	CMP r1, #0x10	;if bottom row
	ITTTT EQ
	ADDEQ r3, #1	;reset LeftRight
	ADDEQ r4, #1	;reset UpDown
	POPEQ {lr}
	BEQ lifelost
	CMP r1, #0x0F	;if above paddle
	BNE checker60UpDownBlock2
	LDR r5, ptr_to_paddleX
	LDRB r2, [r5, #1]		;get left x cord
	ADD r5, r2, #4		;get right x cord
	CMP r2, r0 		;if left of paddle
	BGT checker60UpDownBlock2
	CMP r5, r0		;if right of paddle
	BLT checker60UpDownBlock2
	POP {lr}
	B paddle			;exit <=
checker60UpDownBlock2:
	SUB r1, r4	;set y for check
	CMP r1, #0x06
	BGE checker60UpDownEnd2
	;have to check if in block area
	LDR r5, ptr_to_blocklvls
	LDRB r5, [r5]
	ADD r5, #1
	CMP r1, r5
	BGT	checker60UpDownEnd2		;not in block range
	PUSH {r3, r4}
	BL getBlockLive
	CMP r4, #1
	ITT NE
	POPNE {r3, r4}
	BNE checker60UpDownEnd2	;if block dead exit
	BL blockHit
	POP {r3, r4}
	ADD r1, r4		;reset y
	CMP r4, #1		;if UpDown is up
	ITE EQ
	MOVEQ r4, #-1	;then set down
	MOVNE r4, #1	;else set up
checker60UpDownEnd2:
	POP {pc}
	;############################################# checker60LeftRight END #############################################

getBlockLive:
	PUSH {lr}	;takes r0 & r1 as x & y // must be modified for the block you want to check before passing on
	;determine which row to check
	CMP r1, #0x06
	ITT EQ
	MOVEQ r4, #0
	POPEQ {pc}
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
	MOVLE r5, #4
	BLE gotBlock
	CMP r0, #0x11	;block 5
	ITT LE
	MOVLE r5, #5
	BLE gotBlock
	CMP r0, #0x14	;block 6
	IT LE
	MOVLE r5, #6
gotBlock:
	BL decodeBlock
	POP {pc}
	;############################################# getBlockLive END #############################################

blockHit:
	PUSH {lr}
	PUSH {r0, r1, r4}
	LDR r4, ptr_to_ballcolor
	STRB r3, [r4]	;update ball color
	BL rgbLED
	MOV r4, #0
	MOV r3, #0
	BL encodeBlock	;kill block
	LDR r4, ptr_to_gamelevel		;score
	LDRB r3, [r4]
	LDR r4, ptr_to_score
	LDRH r2, [r4]
	ADD r2, r3
	STRH r2, [r4]
	MOV r0, r2
	LDR r1, ptr_to_scorestr
	BL int2string
	ADD r11, #-1		;update block counter
	POP {r0, r1, r4}
	POP {pc}
	;############################################# blockHit END #############################################

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
	STRB r3, [r2, r5]	;store in memory

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
