;******************************************************
; teclado.asm
; Ejercicio para ingresar datos por teclado con scanf y gets
; Objetivos
;	- usar scanf
;	- usar gets
;	- comprar la diferencia
;	- definir campos sin contenido inicial en section .bss
;
;******************************************************
global 	_main
extern 	_printf
extern	_puts
extern	_gets
extern	_scanf

section  .data
	msgIngN		db	'Ingrese su nombre: ',0
	msgSalN		db	'Usted se llama ',0
	msgIngE		db	'Ingrese su edad ',0
	msgSalE		db	'Usted tiene %d años',0
	edadFormat	db	'%d'

section  .bss
	nombre		resb	20
	edad		resd	1	;Se define como DOBLE-WORD porque se colocara en el stack para imprimir x pantalla

section .text
_main:
	push	msgIngN		
	call	_printf			
	add		esp,4			

	push	nombre			;Parametro 1: direccion de memoria del campo donde se guarda lo ingresado
	call	_gets			;Lee de teclado y lo guarda como string hasta que se ingresa fin de linea . Agrega un 0 binario al final
	add		esp,4
	
	push	msgSalN	
	call	_printf			
	add		esp,4			
	
	push	nombre			
	call	_puts			
	add		esp,4			
	
	push	msgIngE
	call	_printf			
	add		esp,4			

	push	edad;			;Parametro 2: direccion de memoria del campo que guarda lo ingresado por teclado
	push 	edadFormat		;Parametro 1: direccion de memoria del campo que indica el formato en el que se almacena lo ingresado
	call	_scanf			;Lee de teclado y lo guarda en el formato indicado hasta que se ingresa fin de linea 
	add		esp,8
	
	push	dword[edad]		;Parametro 2: campo que se encuentra en el formato indicado q se imprime por pantalla
	push	msgSalE			;Parametro 1: direccion de memoria del campo a imprimir
	call	_printf			
	add		esp,8		

    ret