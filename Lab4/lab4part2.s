	.text
	.global lab4part2

lab4:
	PUSH {lr}
          ; Your code is placed here

	POP {lr}
	MOV pc, lr

read_from_push_btn4:
		PUSH {lr}

	;enabling clock for Port D
	MOV r0, #0xE000
    MOVT r0, #0x400F
    LDR r1, [r0, #0x608]		;load r0 to r1
    ORR r1, r1, #0x8			;bitwise manipulation for Port F
    STR r1, [r0, #0x608]
    ;set GPIO Pin Direction as Input for Port D Pin 0 - 3
    MOV r0, #0x7000
    MOVT r0, #0x4000
    LDR r1, [r0, #0x400]
    AND r1, r1, #0xF
    STR r1, [r0, #0x400]		;store 0 into GPIO Pin Direction as Input for Port D Pin 0 - 3
    ;Enable GPIO Pin 0 - 3 for Port D
    LDR r1, [r0, #0x51C]
	ORR r1, #0xF
	STR r1, [r0, #0x51C]		;store 1 into Port D Pin 0 - 3
	;Enable pull-up resistor for Port D Pin 0 - 3
	MOV r0, #0x7510
    MOVT r0, #0x4000
    LDR r1, [r0]
	ORR r1, #0xF
	STR r1, [r0]				;store 1 into Port D Pin 0 - 3
	;Read Port F Pin 4
	MOV r0, #0x7000
    MOVT r0, #0x4000
	LDR r1, [r0, #0x3FC]		;load r1 from GPIODATA to read if it 0 or 1
	AND r1, #0x10
	CMP r1, #1
	BEQ one						;if it 1 branch to one
	BNE zero					;if it 0 branch to zero
one:
	MOV r0, #1					;set r0 as 1 (High)
zero:
	MOV r0, #0					;set r0 as 0 (Low)
	B loop
          ; Your code is placed here

	POP {lr}
	MOV pc, lr

illuminate_RGB_LED4:
	PUSH {lr}
		;system clock
		MOV r0, #0xE000
		MOVT r0, #0x400F
		LDR r1, [r0, #0x608]
		ORR r1, #0x2
		STR r1, [r0, #0x608]

		;set direction
		MOV r0, #0x5000
		MOVT r0, #0x4000
		LDR r1, [r0, #0x400]
		ORR r1, #0xF
		STR r1, [r0, #0x400]

		;set type (digital)
		LDR r1, [r0, #0x51C]
		ORR r1, #0xF
		STR r1, [r0, #0x51C]

		;led fireworks
		LDR r1, [r0, #0x3FC]
		ORR r1, #0xF
		STR r1, [r0, #0x3FC]
          ; Your code is placed here

	POP {lr}
	MOV pc, lr


	.end
