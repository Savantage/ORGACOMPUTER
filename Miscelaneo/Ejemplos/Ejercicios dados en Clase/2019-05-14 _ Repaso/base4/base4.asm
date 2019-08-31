;Ejercicio:
;Dado el archivo words.dat que contiene campos de 2 bytes en formato bpf c/signo de 16 bits (palabras)
;se pide hacer un programa que lea el archivo e imprima por pantalla la config en base 4 de las mismas.
;Debera hacer uso de una rutina interna para hacer obtener dicha configuración.

global	_main
extern	_puts	; int	puts(char *string)
extern	_fopen	; file	*fopen(char	*fileName, char *mode)
extern	_fclose	; int	 fclose(FILE *stream)
extern	_fread	; int	 fread(void *ptr, int longReg, int cantReg, FILE *stream)	Return: total number of elements successfully read

section		.data
palabra					dw	0
palabraB4	times	8 	db '*'
						db 0

archivo		db	'words.dat',0
mode		db	'r',0
handleArch	dd	0

msjErrApertura	db	'Error en apertura de archivo',0
	
section		.bss

section		.text
_main:
	push	mode
	push	archivo
	call	_fopen			;Abro archivo
	add		esp,8
	
	cmp		eax,0
	jle		errorApertura	;Error apertura?
	mov		dword[handleArch],eax
leerRegistro:
	push	dword[handleArch]
	push	1
	push	2
	push	palabra
	call	_fread			; Leo registro
	add		esp,16
	
	cmp		eax,0
	jle		finArchivo		;Fin archivo?
;mov	dword[palabra],1fa2h	
	call	getConfCuatro	;Paso a base 4
	
	push	palabraB4
	call	_puts			;Imprimo
	add		esp,4
	
	jmp		leerRegistro
	
finArchivo:
	push	dword[handleArch]
	call	_fclose			; Cierro archivo
	add		esp,4
	jmp		finProg
errorApertura:
	push	msjErrApertura
	call	_puts
	add		esp,4
finProg:
	ret						; FIN DE PROGRAMA
;**********************************************************************************
;	Rutinas Externas
;**********************************************************************************
getConfCuatro:
	mov		ax,[palabra];copio la palabra en ax
	shl		eax,16		;corro todo el nro a la izquierda en eax
	
	mov		esi,7		;esi: indice al final del string q contendra la conf en base 4
	mov		ecx,8		;ecx: contador loop (16 agrupaciones de 2 bits)
nextDig:
	shr		eax,2		;muevo 2 bits al inicio de ax
	shr		ax,14		;corro esos 2 bits al final de ax
	add		al,30h		;le sumo 30h (base 16) para obtener el ascii del digito
	
	mov		byte[palabraB4+esi],al	;copio el ascii en el string (de derecha a izquierda)
	dec		esi
	
	loop	nextDig
	ret