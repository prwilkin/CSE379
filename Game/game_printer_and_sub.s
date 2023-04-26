	.data
;this file contains relevant subs and the printer function
	.global ballcolor
	.global scorestr
**********************************from exterior file**********************************************
	.global paddleX			;game_physics_engine
	.global cordinatesNow	;game_physics_engine
	.global cordinatesNext	;game_physics_engine
	.global blocksrow2		;game_physics_engine
	.global blocksrow3		;game_physics_engine
	.global blocksrow4		;game_physics_engine
	.global blocksrow5		;game_physics_engine
**************************************************************************************************
startscore:		.string "      Score: 0",0x00
scorePrompt: 	.string "      Score: ",0x00
scorestr:		.string 0x30, 0x00, 0x00, 0x00, 0x00, 0x00
topNbottom: 	.string "+---------------------+",0x00
center:			.string "|                     |",0x00
paddle:			.string "|        =====        |",0x00
startrow5:		.string "|     Start Game:     |",0x00
startrow6:		.string "|    Press switches   |",0x00
startrow7:		.string "|   for block levels  |",0x00
pause:			.string "PAUSE",0x00
row0:	.half 0x0000, 0x0100, 0x0200, 0x0300, 0x0400, 0x0500, 0x0600, 0x0700, 0x0800, 0x0900, 0x0A00, 0x0B00, 0x0C00, 0x0D00, 0x0E00, 0x0F00, 0x1000, 0x1100, 0x1200, 0x1300, 0x1400
row1:	.half 0x0001, 0x0101, 0x0201, 0x0301, 0x0401, 0x0501, 0x0601, 0x0701, 0x0801, 0x0901, 0x0A01, 0x0B01, 0x0C01, 0x0D01, 0x0E01, 0x0F01, 0x1001, 0x1101, 0x1201, 0x1301, 0x1401
row2:	.half 0x0002, 0x0102, 0x0202, 0x0302, 0x0402, 0x0502, 0x0602, 0x0702, 0x0802, 0x0902, 0x0A02, 0x0B02, 0x0C02, 0x0D02, 0x0E02, 0x0F02, 0x1002, 0x1102, 0x1202, 0x1302, 0x1402
row3:	.half 0x0003, 0x0103, 0x0203, 0x0303, 0x0403, 0x0503, 0x0603, 0x0703, 0x0803, 0x0903, 0x0A03, 0x0B03, 0x0C03, 0x0D03, 0x0E03, 0x0F03, 0x1003, 0x1103, 0x1203, 0x1303, 0x1403
row4:	.half 0x0004, 0x0104, 0x0204, 0x0304, 0x0404, 0x0504, 0x0604, 0x0704, 0x0804, 0x0904, 0x0A04, 0x0B04, 0x0C04, 0x0D04, 0x0E04, 0x0F04, 0x1004, 0x1104, 0x1204, 0x1304, 0x1404
row5:	.half 0x0005, 0x0105, 0x0205, 0x0305, 0x0405, 0x0505, 0x0605, 0x0705, 0x0805, 0x0905, 0x0A05, 0x0B05, 0x0C05, 0x0D05, 0x0E05, 0x0F05, 0x1005, 0x1105, 0x1205, 0x1305, 0x1405
row6:	.half 0x0006, 0x0106, 0x0206, 0x0306, 0x0406, 0x0506, 0x0606, 0x0706, 0x0806, 0x0906, 0x0A06, 0x0B06, 0x0C06, 0x0D06, 0x0E06, 0x0F06, 0x1006, 0x1106, 0x1206, 0x1306, 0x1406
row7:	.half 0x0007, 0x0107, 0x0207, 0x0307, 0x0407, 0x0507, 0x0607, 0x0707, 0x0807, 0x0907, 0x0A07, 0x0B07, 0x0C07, 0x0D07, 0x0E07, 0x0F07, 0x1007, 0x1107, 0x1207, 0x1307, 0x1407
row8:	.half 0x0008, 0x0108, 0x0208, 0x0308, 0x0408, 0x0508, 0x0608, 0x0708, 0x0808, 0x0908, 0x0A08, 0x0B08, 0x0C08, 0x0D08, 0x0E08, 0x0F08, 0x1008, 0x1108, 0x1208, 0x1308, 0x1408
row9:	.half 0x0009, 0x0109, 0x0209, 0x0309, 0x0409, 0x0509, 0x0609, 0x0709, 0x0809, 0x0909, 0x0A09, 0x0B09, 0x0C09, 0x0D09, 0x0E09, 0x0F09, 0x1009, 0x1109, 0x1209, 0x1309, 0x1409
row10:	.half 0x000A, 0x010A, 0x020A, 0x030A, 0x040A, 0x050A, 0x060A, 0x070A, 0x080A, 0x090A, 0x0A0A, 0x0B0A, 0x0C0A, 0x0D0A, 0x0E0A, 0x0F0A, 0x100A, 0x110A, 0x120A, 0x130A, 0x140A
row11:	.half 0x000B, 0x010B, 0x020B, 0x030B, 0x040B, 0x050B, 0x060B, 0x070B, 0x080B, 0x090B, 0x0A0B, 0x0B0B, 0x0C0B, 0x0D0B, 0x0E0B, 0x0F0B, 0x100B, 0x110B, 0x120B, 0x130B, 0x140B
row12:	.half 0x000C, 0x010C, 0x020C, 0x030C, 0x040C, 0x050C, 0x060C, 0x070C, 0x080C, 0x090C, 0x0A0C, 0x0B0C, 0x0C0C, 0x0D0C, 0x0E0C, 0x0F0C, 0x100C, 0x110C, 0x120C, 0x130C, 0x140C
row13:	.half 0x000D, 0x010D, 0x020D, 0x030D, 0x040D, 0x050D, 0x060D, 0x070D, 0x080D, 0x090D, 0x0A0D, 0x0B0D, 0x0C0D, 0x0D0D, 0x0E0D, 0x0F0D, 0x100D, 0x110D, 0x120D, 0x130D, 0x140D
row14:	.half 0x000E, 0x010E, 0x020E, 0x030E, 0x040E, 0x050E, 0x060E, 0x070E, 0x080E, 0x090E, 0x0A0E, 0x0B0E, 0x0C0E, 0x0D0E, 0x0E0E, 0x0F0E, 0x100E, 0x110E, 0x120E, 0x130E, 0x140E
row15:	.half 0x000F, 0x010F, 0x020F, 0x030F, 0x040F, 0x050F, 0x060F, 0x070F, 0x080F, 0x090F, 0x0A0F, 0x0B0F, 0x0C0F, 0x0D0F, 0x0E0F, 0x0F0F, 0x100F, 0x110F, 0x120F, 0x130F, 0x140F
row16:	.half 0x0010, 0x0110, 0x0210, 0x0310, 0x0410, 0x0510, 0x0610, 0x0710, 0x0810, 0x0910, 0x0A10, 0x0B10, 0x0C10, 0x0D10, 0x0E10, 0x0F10, 0x1010, 0x1110, 0x1210, 0x1310, 0x1410
ballcolor:		.byte 	0x00
;ANSI ESC Lookup Table
disablecur:	.string 27,"[?25l",0x00	;disable cursor
blink:		.string 27,"[5m",0x00	;blink
NBlink:		.string 27,"[25m",0x00	;stop blink
red:		.string 27,"[41m",0x00	;red bg
green:		.string 27,"[42m",0x00	;green bg
purple:		.string 27,"[45m",0x00	;purple bg
blue:		.string 27,"[44m",0x00	;blue bg
yellow:		.string 27,"[43m",0x00	;yellow bg
default:	.string 27,"[49m",0x00	;default bg
redtx:		.string 27,"[31m",0x00	;red fg
greentx:	.string 27,"[32m",0x00	;green fg
purpletx:	.string 27,"[35m",0x00	;purple fg
bluetx:		.string 27,"[34m",0x00	;blue fg
yellowtx:	.string 27,"[33m",0x00	;yellow fg
defaulttx:	.string 27,"[39m",0x00	;default fg

	.text
;printer and subroutines: (in order of apperance in file)
;	gameprint, printer assist, printer assist block row, ballPrint, spacePrint, blockPrint, color,
;	 output charcater, output string, clear page, new line, & int2string
	.global gameprinter
	.global start_printer
	.global output_character
	.global output_string
	.global clr_page
	.global new_line
	.global int2string
**********************************from exterior file**********************************************
	.global decode		;game_physics_engine
	.global encode		;game_physics_engine
	.global decodeBlock	;game_physics_engine
	.global encodeBlock	;game_physics_engine
**************************************************************************************************
UART0:			.word	0x4000C000	; Base address for UART0
U0FR: 			.equ 	0x18		; UART0 Flag Register
**************************************************************************************************
ptr_to_scorestr:		.word scorestr
ptr_to_scorePrompt:		.word scorePrompt
ptr_to_topNbottom:		.word topNbottom
ptr_to_center:			.word center
ptr_to_paddle:			.word paddle
ptr_to_startscore:		.word startscore
ptr_to_startrow5:		.word startrow5
ptr_to_startrow6:		.word startrow6
ptr_to_startrow7:		.word startrow7
ptr_to_pause:			.word pause
ptr_to_row0:			.word row0
ptr_to_row1:            .word row1
ptr_to_row2:            .word row2
ptr_to_row3:            .word row3
ptr_to_row4:            .word row4
ptr_to_row5:            .word row5
ptr_to_row6:            .word row6
ptr_to_row7:            .word row7
ptr_to_row8:            .word row8
ptr_to_row9:            .word row9
ptr_to_row10:           .word row10
ptr_to_row11:           .word row11
ptr_to_row12:           .word row12
ptr_to_row13:           .word row13
ptr_to_row14:           .word row14
ptr_to_row15:           .word row15
ptr_to_row16:           .word row16
ptr_to_ballcolor:		.word ballcolor
ptr_to_disablecur:		.word disablecur
ptr_to_blink:		    .word blink
ptr_to_NBlink:		    .word NBlink
ptr_to_red:		        .word red
ptr_to_green:		    .word green
ptr_to_purple:		    .word purple
ptr_to_blue:		    .word blue
ptr_to_yellow:		    .word yellow
ptr_to_default:	        .word default
ptr_to_redtx:		    .word redtx
ptr_to_greentx:	        .word greentx
ptr_to_purpletx:        .word purpletx
ptr_to_bluetx:		    .word bluetx
ptr_to_yellowtx:        .word yellowtx
ptr_to_defaulttx:       .word defaulttx
**********************************ptr to exterior file**********************************************
ptr_to_paddleX:			.word paddleX
ptr_to_cordinatesNow:	.word cordinatesNow
ptr_to_cordinatesNext:	.word cordinatesNext
ptr_to_blocksrow2:		.word blocksrow2
ptr_to_blocksrow3:		.word blocksrow3
ptr_to_blocksrow4:		.word blocksrow4
ptr_to_blocksrow5:		.word blocksrow5
****************************************************************************************************


gameprinter:
	PUSH {lr}
	BL clr_page
	LDR r0, ptr_to_scorePrompt
	BL output_string			;print score prompt
	LDR r0, ptr_to_scorestr
	BL output_string			;print score as #
	BL new_line
	LDR r0, ptr_to_topNbottom
	BL output_string			;print top wall
	BL new_line
	LDR r1, ptr_to_row0
	BL printer_assist		;print row 0
	LDR r1, ptr_to_row1
	BL printer_assist		;print row 1
	LDR r1, ptr_to_row2
	LDR r2, ptr_to_blocksrow2
	BL printer_assist_block_row	;print row 2
	LDR r1, ptr_to_row3
	LDR r2, ptr_to_blocksrow3
	BL printer_assist_block_row	;print row 3
	LDR r1, ptr_to_row4
	LDR r2, ptr_to_blocksrow4
	BL printer_assist_block_row	;print row 4
	LDR r1, ptr_to_row5
	LDR r2, ptr_to_blocksrow5
	BL printer_assist_block_row	;print row 5
	LDR r1, ptr_to_row6
	BL printer_assist		;print row 6
	LDR r1, ptr_to_row7
	BL printer_assist		;print row 7
	LDR r1, ptr_to_row8
	BL printer_assist		;print row 8
	LDR r1, ptr_to_row9
	BL printer_assist		;print row 9
	LDR r1, ptr_to_row10
	BL printer_assist		;print row 10
	LDR r1, ptr_to_row11
	BL printer_assist		;print row 11
	LDR r1, ptr_to_row12
	BL printer_assist		;print row 12
	LDR r1, ptr_to_row13
	BL printer_assist		;print row 13
	LDR r1, ptr_to_row14
	BL printer_assist		;print row 14
	LDR r1, ptr_to_row15
	BL printer_assist		;print row 15
	LDR r1, ptr_to_row16
	BL printer_assist_paddle	;print row 16
	LDR r0, ptr_to_topNbottom
	BL output_string			;print bottom wall

	POP {pc}
	;############################################# printer END #############################################

printer_assist:
	PUSH {lr}		;r1 ptr to cordinates,
	PUSH {r1}
	MOV r0, #0x7C
	BL output_character	;print left wall
	POP {r1}
	LDRB r1, [r1]	;load cordinates
	LDR r5, ptr_to_cordinatesNext
	LDRH r5, [r5]
printer_assist_loop:
	CMP r1, #0x1500		;if more then 20
	BGE printer_assist_end
	CMP r1, r5
	IT EQ
	BLEQ ballPrint	;if at ball print ball
	CMP r1, r5
	IT NE
	BLNE spacePrint
	ADD r1, #0x0100		;move 1 right
	B printer_assist_loop
printer_assist_end:
	MOV r0, #0x7C
	BL output_character		;print right wall
	BL new_line
	POP {pc}
	;############################################# printer_assist END #############################################

printer_assist_paddle:
	PUSH {lr}		;r1 ptr to cordinates,
	PUSH {r1}
	MOV r0, #0x7C
	BL output_character	;print left wall
	POP {r1}
	LDRB r1, [r1]	;load cordinates
	LDR r5, ptr_to_cordinatesNext
	LDRH r5, [r5]
	LDR r2, ptr_to_paddleX
	LDRH r2, [r2]
printer_assist_paddle_loop:
	CMP r1, #0x1500		;exit on 21st loop
	BGE printer_assist_paddle_end	;exit <=
	CMP r1, r2			;if at paddle
	ITT EQ
	ADDEQ r1, #0x0500	;move 5 right
	BLEQ paddlePrint
	CMP r1, r5			;if not at paddle check for ball
	ITE EQ
	BLEQ ballPrint		;if at ball print ball
	BLNE spacePrint		;else print ball
	ADD r1, #0x0100		;move 1 right
	B printer_assist_paddle_loop
printer_assist_paddle_end:
	MOV r0, #0x7C
	BL output_character		;print right wall
	BL new_line
	POP {pc}
	;############################################# printer_assist END #############################################

printer_assist_block_row:
	PUSH {lr}		;r1 ptr to cordinates, r2 pointer to blockrow
	PUSH {r1, r2, r6}
	MOV r0, #0x7C
	BL output_character	;print left wall
	POP {r1, r2}
	LDRH r1, [r1]	;load cordinates
	LDR r6, ptr_to_cordinatesNext
	LDRH r6, [r6]
	MOV r5, #0		;set block offset and counter
printer_assist_row:
	CMP r5, #7			;exit on 8th loop
	BGE printer_assist_block_row_end	;exit <=
	BL decodeBlock		;get block color and live in r3 and r4
	ADD r5, #1			;increment block offset/counter
	CMP r4, #1			;if block live
	ITTT EQ
	ADDEQ r1, #0x0300	;move 3 right
	BLEQ blockPrint
	BEQ printer_assist_row	;restart loop
	BL ballspace
	ADD r1, #0x0100		;move 1 right
	BL ballspace
	ADD r1, #0x0100		;move 1 right
	BL ballspace
	ADD r1, #0x0100		;move 1 right
	B printer_assist_row
printer_assist_block_row_end:
	MOV r0, #0x7C
	BL output_character		;print right wall
	BL new_line
	POP {r6, pc}
	;############################################# printer_assist_block_row END #############################################

paddlePrint:
	PUSH {r1, r2, lr}

	MOV r0, #0x3D
	BL output_character
	BL output_character
	BL output_character
	BL output_character
	BL output_character

	POP {r1, r2, pc}
	;############################################# paddlePrint END #############################################

ballspace:
	CMP r1, r6			;check for ball
	ITE EQ				;if alive
	BEQ ballPrint		;then print ball
	BNE spacePrint		;else print space

ballPrint:
	PUSH {r1, r2, lr}

	LDR r3, ptr_to_ballcolor
	LDRB r3, [r3]
	BL colorBall		;set ball color
	MOV r0, #0x2A		;ascii *
	BL output_character
	MOV r3, #0
	BL colorBall		;back to default color

	POP {r1, r2, pc}
	;############################################# ballPrint END #############################################

spacePrint:
	PUSH {r1, r2, lr}
	MOV r0, #0x20
	BL output_character
	POP {r1, r2, pc}
	;############################################# spacePrint END #############################################

blockPrint:
	PUSH {r1, r2, lr}

	BL color			;set block color
	MOV r0, #0x20		;ascii space
	BL output_character
	BL output_character
	BL output_character	;print 3 spaces for block
	MOV r3, #0
	BL color			;set back to default color

	POP {r1, r2, pc}
	;############################################# blockPrint END #############################################

color:
	PUSH {r1, lr}
	CMP r3, #0		;default
	ITTT EQ
	LDREQ r0, ptr_to_default
	BLEQ output_string
	POPEQ {r1, pc}
	CMP r3, #2		;red
	ITTT EQ
	LDREQ r0, ptr_to_red
	BLEQ output_string
	POPEQ {r1, pc}
	CMP r3, #4		;blue
	ITTT EQ
	LDREQ r0, ptr_to_blue
	BLEQ output_string
	POPEQ {r1, pc}
	CMP r3, #6		;purple
	ITTT EQ
	LDREQ r0, ptr_to_purple
	BLEQ output_string
	POPEQ {r1, pc}
	CMP r3, #8		;green
	ITTT EQ
	LDREQ r0, ptr_to_green
	BLEQ output_string
	POPEQ {r1, pc}
	CMP r3, #10		;yellow
	ITTT EQ
	LDREQ r0, ptr_to_yellow
	BLEQ output_string
	POPEQ {r1, pc}
	;############################################# colorBall END #############################################

colorBall:
	PUSH {r1, lr}
	CMP r3, #0		;default
	ITTT EQ
	LDREQ r1, ptr_to_defaulttx
	BLEQ output_string
	POPEQ {r1, pc}
	CMP r3, #2		;red
	ITTT EQ
	LDREQ r1, ptr_to_redtx
	BLEQ output_string
	POPEQ {r1, pc}
	CMP r3, #4		;blue
	ITTT EQ
	LDREQ r1, ptr_to_bluetx
	BLEQ output_string
	POPEQ {r1, pc}
	CMP r3, #6		;purple
	ITTT EQ
	LDREQ r1, ptr_to_purpletx
	BLEQ output_string
	POPEQ {r1, pc}
	CMP r3, #8		;green
	ITTT EQ
	LDREQ r1, ptr_to_greentx
	BLEQ output_string
	POPEQ {r1, pc}
	CMP r3, #10		;yellow
	ITTT EQ
	LDREQ r1, ptr_to_yellowtx
	BLEQ output_string
	POPEQ {pc}
	;############################################# color END #############################################

start_printer:
	PUSH {lr}

	BL clr_page
	LDR r0, ptr_to_disablecur
	BL output_string
	LDR r0, ptr_to_startscore
	BL output_string
	BL new_line
	LDR r0, ptr_to_topNbottom
	BL output_string
	BL new_line
	LDR r0, ptr_to_center
	BL output_string	;row 0
	BL new_line
	LDR r0, ptr_to_center
	BL output_string	;row 1
	BL new_line
	LDR r0, ptr_to_center
	BL output_string	;row 2
	BL new_line
	LDR r0, ptr_to_center
	BL output_string	;row 3
	BL new_line
	LDR r0, ptr_to_center
	BL output_string	;row 4
	BL new_line
	LDR r0, ptr_to_startrow5
	BL output_string
	BL new_line
	LDR r0, ptr_to_startrow6
	BL output_string
	BL new_line
	LDR r0, ptr_to_startrow7
	BL output_string
	BL new_line
	LDR r0, ptr_to_center
	BL output_string	;row 8
	BL new_line
	LDR r0, ptr_to_center
	BL output_string	;row 9
	BL new_line
	LDR r0, ptr_to_center
	BL output_string	;row 10
	BL new_line
	LDR r0, ptr_to_center
	BL output_string	;row 11
	BL new_line
	LDR r0, ptr_to_center
	BL output_string	;row 12
	BL new_line
	LDR r0, ptr_to_center
	BL output_string	;row 13
	BL new_line
	LDR r0, ptr_to_center
	BL output_string	;row 14
	BL new_line
	LDR r0, ptr_to_center
	BL output_string	;row 15
	BL new_line
	LDR r0, ptr_to_paddle
	BL output_string	;row 16
	BL new_line
	LDR r0, ptr_to_topNbottom
	BL output_string
	BL new_line

	POP {pc}
	;############################################# start_printer END #############################################

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

	POP {pc}
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
	POP {pc}
	;############################################# output_string END #############################################

;CLR_PAGE SUBROUTINE
clr_page:
	PUSH {lr}

	MOV r0, #0xC
	BL output_character

	POP {pc}
	;############################################# clr_page END #############################################

;NEW_LINE SUBROUTINE
new_line:
	PUSH {lr}

	MOV r0, #0xA
	BL output_character
	MOV r0, #0xD
	BL output_character

	POP {pc}
	;############################################# new_line END #############################################

;INT2STRING SUBROUTINE
int2string:
	PUSH {lr}   				; Store register lr on stack
								;r0  = int
								;r1  = addy
								;r4 or higher must push pop
								;## not passed in ##
								;r2  = avg size (lmao)
								;r3  = didgit compare
								;	 = avg maniuplated
	PUSH {r5}					;r5  = temp var
								;	 = digit to be stored
	MOV r5, #1						;init
	PUSH {r9}					;r9  = BASETEN var
	MOV r9, #10						;init
	PUSH {r10}					;r10 = 10
	MOV r10, #10					;init

integer_digit:		;get size of int if 1
	MOV r3, #9		;load 9 for digit compare
	MOV r2, #1		;load 1 to count digits
	CMP r0, r3		;compare number and digit compare to determine if more then one digit
	BGT COMPARE		;if more then one digit jump to compare
	MOV r2, #1		;return 1 as digit count

COMPARE:			;get size of average >1
	ADD r2, r2, #1
	MUL r3, r3, r10		;jump another digit ie 9 to 90
	ADD r3, r3, #9		;push to highest for digit ie 99 for two digits
	CMP r0, r3
	BGT COMPARE			;if greater then check for another digit

	MOV r3, r0		;r3 will be maniuptlated
	CMP r2, #1		;if first digit then base being 10 works
	BEQ MODULO

BASETEN:			;this will calulate the size used for MOD ie. 10/100/1000
	ADD r5, r5, #1
	MUL r9, r9, r10
	CMP r2, r5
	BNE BASETEN

loopint2string:

MODULO:
	SDIV r5, r3, r9		;input/base 10 mod
	MUL r5, r5, r9		;qoutient*base 10 mod
	SUB r5, r3, r5		;input - product = remainder
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
	MOV r3, #0x00
	STRB r3, [r1, #1]

	POP {r10}	;reset stack and regs
	POP {r9}	;FIFO
	POP {r5}

	POP {pc}
	;############################################# int2string END #############################################

.end
