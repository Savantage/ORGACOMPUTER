;***************************************************************************
; fileText.asm
; Ejercicio que lee y escribe un archivo de texto
; Objetivos
;	- manejo de archivo de texto
;	- usar fopen (abrir)
;	- usar fgets (leer)
;	- usar fputs (escribir)
;	- usar fclose (cerrar)
; Copiar el texto que se encuentra al final en un archivo con nombre "archivoTexto.txt"
; 
;***************************************************************************
global		_main
extern		_printf
extern		_fopen
extern		_fgets
extern		_fputs
extern		_fclose

section		.data
	fileName	db	"06archivoTexto.txt",0
	mode		db	"r+",0
	fileHandle	dd	0
	registro	times 80 db " ",0
	linea		db	"Autor: Anthony De Mello",0
	msgErrOpen	db  "Error en apertura de archivo",0
	
section		.bss
section		.text
_main:
;	Abro archivo para lectura y escritura	
	push	mode				;Parametro 2: dir string modo de apertura
	push	fileName			;Parametro 1: dir nombre del archivo
	call	_fopen				;ABRO archivo y deja el handle en EAX
	add		esp,8

	cmp		eax,0				;Error en apertura?
	jle		errorOpen

	mov		[fileHandle],eax
	
;	Leo registro
read:
	push	dword[fileHandle]	;Parametro 3: handle del archivo
	push	80					;Parametro 2: cantidad de bytes maximas a leer (o hasta fin de linea)
	push	registro			;Parametro 1: dir area de memoria donde se copia
	call	_fgets				;LEO registro. Devuelve en eax la cantidad de bytes leidos
	add		esp,12

	cmp		eax,0				;Fin de archivo?
	jle		write

;	Imprimo en pantalla
	push	registro
	call	_printf
	add		esp,4
	jmp		read

;	Escribo una linea al final
write:
	push	dword[fileHandle]	;Parametro 2: handle del archivo
	push	linea				;Parametro 1: dir area de memoria a copiar
	call	_fputs				;ESCRIBO archivo.
	add		esp,8

;	Cierro el archivo
	push	dword[fileHandle]	;Parametro 1: handle del archivo
	call	_fclose				;CIERRO archivo
	add		esp,4
	jmp		endProg
	
errorOpen:
	push	msgErrOpen
	call	_printf
	add		esp,4
	
endProg:	
	ret

;************* Texto de prueba para el archivo *******************************	
;¿Cuándo realizar tu sueño?
;- ¿Y cuándo piensas realizar tu sueño? le preguntó el Maestro a su discípulo.
;- Cuándo tenga la oportunidad de hacerlo, respondió este.
;El Maestro le contestó:
;- La oportunidad nunca llega. La oportunidad ya está aquí.
;*****************************************************************************