	.text
	.global keypad_init

keypad_init:
	PUSH {lr}

; Enable the clock for GPIO Port D
	MOV r1, #0xE000		; Load base address of System Control
	MOVT r1, #0x400F
	LDRB r0, [r1,#RCGCGPIO] ; Load contents of RCGCGPIO register
	ORR r0, r0, #8		; Set bit 3 to enalbe and provide a clock to GPIO Port D
	STRB r0, [r1,#RCGCGPIO] ; Store modifed value of RCGCGPIO register back to memory

; Set GPIO Port D, Pints 0-3 direction to Input
	MOV r1, #0x7000		; Load base address of GPIO Port D
	MOVT r1, #0x4000
	LDRB r0, [r1,#0x400] 	; Load contents of 0x400 register
	BIC r0, r0, #0xF	; Clear bits 0-3 to set GPIO direction to input
	STRB r0, [r1,#0x400] 	; Store modifed value of 0x400 register back to memory

; Enable GPIO Port D, Pins 0-3 as Digital
	LDRB r0, [r1,#0x51C] 	; Load contents of 0x51C register
	ORR r0, r0, #xF		; Set bits 0-3 to set pins to digital
	STRB r0, [r1,#0x51C] 	; Store modifed value of 0x51C register back to memory

	POP {pc}