;***************************************************************************
; vector.asm
; Ejercicio que llena un vector ingresando datos por telcado y luego imprime
; Objetivos
;	- definir un vector con times y resb
;	- manejar un vector usando formula (i-1)*longElem
;	- usar printf con varios parametros de distinto tipo
; 
;***************************************************************************
global 	_main
extern 	_printf
extern	_gets

section  .data
msgIng		db	'Ingrese un nombre para la posicion %d: ',0
msgSal		db	'Elemento guardado en posicion %d: %s',10,13,0
longNombre	dw	10

section  .bss
vector		times 3 resb 	10

section .text
_main:
	mov		esi,1
ingElem:
	push	esi
	push	msgIng
	call	_printf
	add		esp,8

	mov		eax,esi					;eax = posicion
	dec		eax						;eax = posicion - 1
	imul	word[longNombre]		;eax = (posicion - 1) * 10
	lea		eax,[vector+eax]		;eax = dir nombre
	
	push	eax
	call	_gets
	add		esp,4

	inc		esi						;incremento esi para posicionarlo en la sgte posicion del vector
	cmp		esi,3
	jle		ingElem


	mov		esi,1
impElem:	
	mov		eax,esi					;eax = posicion
	dec		eax						;eax = posicion - 1
	imul	word[longNombre]		;eax = (posicion - 1) * 10
	lea		eax,[vector+eax]		;eax = dir nombre
	
	push	eax
	push	esi
	push	msgSal
	call	_printf
	add		esp,12
	
	inc		esi						;incremento esi para posicionarlo en la sgte posicion del vector
	cmp		esi,3
	jle		impElem

    ret