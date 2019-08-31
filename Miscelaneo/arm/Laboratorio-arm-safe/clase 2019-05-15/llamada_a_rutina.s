	.equ		SWI_PRINT_STRING, 0x02
	.equ		SWI_EXIT, 0x11

	.data @ SECCION DE DEFINICION DE DATOS

msjHola:
	.asciz		"hola mundo\n"		@ defino un string que termina con \0
msjChau:
	.asciz 		"chau\n"

	.text @ SECCION DE TEXTO

	.global 	_start

_start:
	 
	ldr			r1, =msjHola
	bl			mostrar

	ldr 		r1,	=msjChau
	bl 			mostrar

	b 			fin 

mostrar:
	
	stmfd 		sp!,{r0,r1,lr} 		
	mov			r0,r1				
	swi			SWI_PRINT_STRING				
	ldmfd 		sp!,{r0,r1,pc}		
	
fin:
	swi 		SWI_EXIT			@ fin de programa
