	.equ		SWI_EXIT, 0x11

	.data						
nro1:	
	.word		3
nro2:
	.word		4	

	.text						
	.global _start

_start:
	
	ldr		r0, =nro1
	ldr		r0, [r0]
	ldr		r1, =nro2
	ldr		r1, [r1]

	add		r2, r1, r0
	sub		r3, r1, r0
	mul		r4, r1, r0
	and		r5, r1, r0
	orr		r6, r1, r0
	eor		r7, r1, r0
	mov		r8, r1, lsl r0
	mov		r9, r1, lsr r0
	mov		r10,r1, asr r0

	swi 	SWI_EXIT