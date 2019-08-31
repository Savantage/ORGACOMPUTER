;***************************************************************************
; fileBinary.asm
; Ejercicio que lee y escribe un archivo binario
; Objetivos
;	- manejo de archivo binario
;	- usar fopen (abrir)
;	- usar fread (leer)
;	- usar rewind (rebobinar)
;	- usar fwrite (escribir)
;	- usar fclose (cerrar)
; 
;***************************************************************************
global		_main
extern		_printf
extern		_fopen
extern		_fwrite
extern		_rewind
extern		_fread
extern		_fclose

section		.data
	fileName	db	"07archivoBina.dat",0
	mode		db	"ab+",0		; modo append binary and read (actualizacion y lectura)
	fileHandle	dd	0
	msgErrOpen	db  "Error en apertura de archivo",0

	registro1	times 0		db ""
	id1						dw	2000	;Se guarda en LITTLE ENDIAN D007 en memoria y cuando se copia en el archivo
	nombre1					db	"Ricardo   ",0
	
	registro	times 0 	db ""
	id						dw 0
	nombre		times 10	db " ",0
	
	linea		db	"%5d|%s",10,13,0
	
section		.bss
section		.text
_main:
;	Abro archivo para actualizacion y lectura	
	push	mode				;Parametro 2: dir string modo de apertura
	push	fileName			;Parametro 1: dir nombre del archivo
	call	_fopen				;Abre el archivo y deja el handle en EAX
	mov		[fileHandle],eax
	add		esp,8

	cmp		eax,0				;Error en apertura?
	jle		errorOpen

	mov		[fileHandle],eax
	
;	Agrego un registro
	push	dword[fileHandle]	;Parametro 4: handle del archivo
	push	1					;Parametro 3: cantidad de registros
	push	12					;Parametro 2: longitud del registro
	push	registro1			;Parametro 1: dir area de memoria donde se copia
	call	_fwrite				;LEO registro. Devuelve en eax la cantidad de bytes leidos
	add		esp,16

;	Rebobino al inicio del archivo	
	push	dword[fileHandle]	;Parametro 1: handle del archivo
	call	_rewind				;REBOBINO al inicio del archivo
	add		esp,4

;	Leo un registro
read:
	push	dword[fileHandle]	;Parametro 4: handle del archivo
	push	1					;Parametro 3: cantidad de registros
	push	12					;Parametro 2: longitud del registro
	push	registro			;Parametro 1: dir area de memoria donde se copia
	call	_fread				;LEO registro. Devuelve en eax la cantidad de bytes leidos
	add		esp,16

	cmp		eax,0				;Fin de archivo?
	jle		eof

	sub		eax,eax
	mov		ax,[id]				;Copio el campo id en 'ax' para poder copiar 'eax' (dobleword) en la pila
	
;	Imprimo los datos del registro
	push	nombre				;Parametro 3: dir dato a ser formateado como string
	push	eax					;Parametro 2: dato a ser formateado como numero entero decimal
	push	linea				;Parametro 1: dir del texto a imprimir por pantalla
	call	_printf
	add		esp,12
	
	jmp		read

eof:
	push	dword[fileHandle]	;Parametro 1: handle del archivo
	call	_fclose
	add		esp,4
	jmp		endProg
	
errorOpen:
	push	msgErrOpen
	call	_printf
	add		esp,4
	
endProg:	
	ret