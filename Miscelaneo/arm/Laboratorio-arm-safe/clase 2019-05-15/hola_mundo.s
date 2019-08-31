	.data						@ SECCION DE DEFINICION DE DATOS
msj:
	.asciz "hola mundo"			@ defino un string que termina con \0

	.text						@ SECCION DE TEXTO
	.global _start

_start:
	ldr		r0, =msj			@ copia en r0 la direccion de msj
	swi		0x02				@ imprime por consola el string apuntado por r0

	swi 	0x11				@ fin de programa