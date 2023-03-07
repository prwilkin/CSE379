	.text
	.global lab4

lab4:
	PUSH {lr}
	BL read_from_push_btn
          ; Your code is placed here

	POP {lr}
	MOV pc, lr

read_from_push_btn:
	PUSH {lr}
loop:
	;enabling clock for Port F
	MOV r0, #0xE000
    MOVT r0, #0x400F
    LDR r1, [r0, #0x608]		;load r0 to r1
    ORR r1, r1, #0x20			;bitwise manipulation for Port F
    STR r1, [r0, #0x608]
    ;set GPIO Pin Direction as Input for Port F
    MOV r0, #0x5000
    MOVT r0, #0x4002
    MOV r1, #0
    STR r1, [r0, #0x400]		;store 0 into GPIO Pin Direction as Input for Port F
    ;Enable GPIO Pin for Port F
	MOV r1, #0x1
	STR r1, [r0, #0x51C]		;store 1 into Port F Pin 4
	;Enable pull-up resistor for Port F
	MOV r0, #0x5510
    MOVT r0, #0x4002
	MOV r1, #1
	STR r1, [r0]
	;Read Port F Pin 4
	MOV r0, #0x5000
    MOVT r0, #0x4002
	LDR r1, [r0, #0x400]
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

illuminate_RGB_LED:
	PUSH {lr}

          ; Your code is placed here

	POP {lr}
	MOV pc, lr


	.end
