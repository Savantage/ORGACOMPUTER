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
	mov 	r1,#2


	bl 		minMax 			@ dejamos el menor en r0

	swi 	SWI_Exit		@ fin programa
	
minMax:
	stmfd 	sp!, {r0,r1,lr}
	cmp 	r0,r1			@ salta si r0 es menor a r1
	bmi 	fin

intercambiar:
	mov 	r2, r0
	mov 	r0, r1
	mov 	r1, r2

fin:
	ldmfd 	sp!, {r0,r1,pc}

