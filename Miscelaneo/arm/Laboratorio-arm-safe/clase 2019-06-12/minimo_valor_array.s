@ dato de color: geany
@ ARRAYS
@ imprimir los valores de un vector de cuatro enteros 
@ recorriendo el vector mediante una subrutino que utilice 
@ direccionamiento indirecto

	.equ 	SWI_Open, 	0x66
	.equ 	SWI_Close,	0x68
	.equ 	SWI_RdInt, 	0x6C
	.equ 	SWI_PrInt, 	0x6B
	.equ 	SWI_PrStr, 	0x69
	.equ 	SWI_Exit, 	0x11

	.data
arr:
	.word 45, 76, 98, 12

	.text
	.global _start
	
_start:

	ldr 	r3, =arr
	mov 	r2, #0
	mov 	r0, #99

sigElemento:
	cmp 	r2,#4
	beq 	fin

	ldr 	r1, [r3], #4
	bl 		minMax 			@ deja en r0 el menor entre r0 y r1
	add 	r2,r2,#1
	b 		sigElemento

fin:
	bl 		imprmir_R0
	swi 	SWI_Exit		@ fin programa

imprmir_R0:

	stmfd 	sp!, {r0,r1,r2,lr}
	mov 	r1,r0
	mov 	r0,#1
	swi 	SWI_PrInt	@ imprimir entero por pantalla
	ldmfd 	sp!, {r0,r1,r2,pc}

minMax:
	stmfd 	sp!, {r2,lr}
	cmp 	r0,r1			@ salta si r0 es menor a r1
	bmi 	finMinMax

intercambiar:
	mov 	r2, r0
	mov 	r0, r1
	mov 	r1, r2

finMinMax:
	ldmfd 	sp!, {r2,pc}