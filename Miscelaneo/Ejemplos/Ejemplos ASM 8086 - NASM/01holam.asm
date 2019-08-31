;******************************************************
; holam.asm
; Ejercicio para imprimir "Hola mundo!!" por pantalla
; Objetivos
;	- hacer el primer programa en asm win32
;	- aprender la estructura de un programa
;	- uso basico de printf
;
;******************************************************
global	_main
extern	_printf

section	.data
	mensaje	db	'Hola Mundo!',0	;campo con el string a imprimir.  Debe finalizar con 0 binario
section	.bss

section	.text
_main:
	push	mensaje		;Parametro 1: direccion del mensaje a imprimir
	call	_printf
	add		esp,4		;Coloco puntero a la pila donde estaba
	
	ret