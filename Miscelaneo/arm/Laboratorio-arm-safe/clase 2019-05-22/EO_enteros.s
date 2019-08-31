@ leer un entero de un archivo e imprimirlo por pantalla

	.equ 	SWI_Open, 	0x66
	.equ 	SWI_Close,	0x68
	.equ 	SWI_RdInt, 	0x6C
	.equ 	SWI_PrInt, 	0x6B
	.equ 	SWI_Exit, 	0x11

	.data

fileName:
	.asciz "archivo.txt"
fileHandle:
	.word 0
	
	.text
	.global _start
	
_start:

	ldr 	r0,=fileName
	mov 	r1,#0
	swi 	SWI_Open	@ abrir archivo
	mov 	r10,r0
	
	mov 	r0,r10
	swi 	SWI_RdInt	@ leer entero desde archivo
	
	
	mov 	r1,r0
	mov 	r0,#1
	swi 	SWI_PrInt	@ imprimir entero por pantalla
	
	mov 	r0,r10
	swi 	SWI_Close	@ cerrar archivo
	 
	swi 	SWI_Exit	@ fin programa
	
