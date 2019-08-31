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
fileName:
	.asciz "archivo.txt"
separador:
	.asciz " "

	.text
	.global _start
	
_start:

	ldr 	r0, =arr
	mov 	r1, #0

sigElemento:
	cmp 	r1,#4
	beq 	fin

	ldr 	r2, [r0]
	bl 		imprmir_R2
	bl 		imprimir_separador
	add 	r0, r0, #4

	add 	r1,r1,#1
	b 		sigElemento

fin:
	swi 	SWI_Exit		@ fin programa

imprmir_R2:

	stmfd 	sp!, {r0,r1,r2,lr}
	mov 	r1,r2
	mov 	r0,#1
	swi 	SWI_PrInt	@ imprimir entero por pantalla
	ldmfd 	sp!, {r0,r1,r2,pc}

imprimir_separador:
	stmfd 	sp!, {r0,r1,r2,lr}
	ldr 	r1,=separador
	mov 	r0,#1
	swi 	SWI_PrStr	@ imprimir str por pantalla	
	ldmfd 	sp!, {r0,r1,r2,pc}