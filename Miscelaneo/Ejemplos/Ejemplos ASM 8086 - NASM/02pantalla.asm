;******************************************************
; pantalla.asm
; Ejercicio para imprimir por pantalla con printf y puts
; Objetivos
;	- usar printf con formato
;	- usar puts
;	- comprar la diferencia con printf
;
;******************************************************
global	_main
extern	_printf
extern	_puts

section	.data
	mensaje1	db	'Imprimo con _printf--',0	
	mensaje2	db	'Imprimo con puts',0
	mensaje3	db	'Imprimo con printf el numero %d',0
	numero		dd	1234
section	.bss

section	.text
_main:
	push	mensaje1		;Parametro 1: direccion del mensaje a imprimir
	call	_printf
	add 	esp,4			;Coloco el puntero a la pila donde estaba
	
	push	mensaje2		;Parametro 1: direccion del mensaje a imprimir
	call	_puts			;Imprime hasta que llega al 0 y agrega fin de linea
	add		esp,4			;Coloco el puntero a la pila donde estaba
	
	push	dword[numero]	;Parametro 2: dato formateado para imprimir
	push	mensaje3		;direccion del mensaje a imprimir
	call	_printf
	add		esp,8			;Coloco el puntero a la pila donde estaba

	ret