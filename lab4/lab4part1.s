	.text
	.global lab4

lab4:
	PUSH {lr}

          ; Your code is placed here

	POP {lr}
	MOV pc, lr

read_from_push_btn:
	PUSH {lr}

          ; Your code is placed here

	POP {lr}
	MOV pc, lr

illuminate_RGB_LED:
	PUSH {lr}
		;Red P1 Green P3 Blue P2
		MOV r1, #0x5000		;0x40025000
		MOVT r1, #0x4002
		;system clock

		;set direction
		MOV r2, #0x0			;set all pins to 0 for input
		STRB r2, [r1, #0x400]

		;set type (digital)
		MOV r2, #x7
		STRB r2, [r1, #0x51C]

		;led fireworks
		STRB r0, [r1, #0x3FC]

          ; Your code is placed here

	POP {lr}
	MOV pc, lr


	.end
