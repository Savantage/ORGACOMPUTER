@ leer dos entero de un archivo e imprimir sus not

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

	mov 	r5,#-1

abrirArchivo:
	ldr 	r0,=fileName
	mov 	r1,#0
	swi 	SWI_Open	@ abrir archivo
	mov 	r10,r0
	
leerLinea:
	mov 	r0,r10
	swi 	SWI_RdInt	@ leer entero desde archivo
	bcs 	finPrograma

imprimirEntero:
	mov 	r2,r0
	bl 		imprmir_R2

imprimirNotEntero:
	eor		r2,r0,r5 	
	bl 		imprmir_R2
	
	b 		leerLinea
	
finPrograma:
	mov 	r0,r10
	swi 	SWI_Close	@ cerrar archivo
	 
	swi 	SWI_Exit	@ fin programa
	
imprmir_R2:

	stmfd 	sp!, {r0,r1,r2,lr}
	mov 	r1,r2
	mov 	r0,#1
	swi 	SWI_PrInt	@ imprimir entero por pantalla
	
	ldr 	r1,=saltoDeLinea
	mov 	r0,#1
	swi 	SWI_PrStr	@ imprimir str por pantalla
	
	
	
	ldmfd 	sp!, {r0,r1,r2,pc}