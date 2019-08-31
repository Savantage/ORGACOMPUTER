@ CALCULO DE MIN Y MAX
@ leer dos enteros (desde archivo o de memoria) 
@ minimo y el maximo e identificar el 

	.equ 	SWI_Open, 	0x66
	.equ 	SWI_Close,	0x68
	.equ 	SWI_RdInt, 	0x6C
	.equ 	SWI_PrInt, 	0x6B
	.equ 	SWI_PrStr, 	0x69
	.equ 	SWI_Exit, 	0x11

	.data

fileName:
	.asciz "archivo.txt"
saltoDeLinea:
	.asciz "\n"

	.text
	.global _start
	
_start:

	mov 	r0,#5
	bl 		factorial 		

	swi 	SWI_Exit		@ fin programa
	
factoria:
	stmfd 	sp!, {r0,lr}
	
	cmp 	r0,#1
	beq 	finFactorial

		
	bl 		factorial

	sub 	r1,r0,#1
	mul 	r0,r0,r1

finFactorial:
	ldmfd 	sp!, {r0,pc}


