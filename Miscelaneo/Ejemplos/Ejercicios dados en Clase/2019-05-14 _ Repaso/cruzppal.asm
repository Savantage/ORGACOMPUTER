; Se dispone de una matriz M de 21 filas por 21 columnas cuyos elementos son BPF c/s de 2 bytes. 
; También se dispone de un archivo de entrada (BIN.DAT) para la carga de la matriz. 
; Cada registro está formado por 3 campos: 
; -	BPF s/s de 1 byte para indicar el nro de fila (0(10) a 20(10))
; -	BPF s/s de 1 byte para indicar el nro de columna (0(10) a 20(10))
; -	BPF c/s de 2 bytes
; Se pide realizar un programa en assembler Intel 8086 que calcule y muestre por 
; pantalla la sumatoria de los elementos de la cruz principal de la matriz.
global 	_main
extern 	_printf
extern	_fopen
extern	_fread
extern	_fclose

section  .data
	; Definiciones del archivo binario
	fileName	db	"BIN.dat",0
	mode		db	"rb",0		; modo lectura del archivo binario
	fileHandle	dd	0
	msgErrOpen	db  "Error en apertura de archivo",0
	
	matriz		times 441 dw 0	; defino una matriz inicializada de 21x21 en 0
	
	registro	times 0 	db ""
	fila					db 0
	columna					db 0
	nro						dw 0
	
	msjResult		db	"La sumatoria de la cruz principal es: %d",10,13,0

	; deplazamiento de una matriz
	; (col - 1) * L + (fil - 1) * L * cant. cols
section  .bss
	
section .text
_main:
	call	abrirArch
	
	cmp		eax,0				;Error en apertura?
	jle		errorOpen
	
	call	leerArch
	call	calcular
endProg:	
	ret
	
errorOpen:
	push	msgErrOpen
	call	_printf
	add		esp,4
	
	jmp		endProg
	
abrirArch:
;	Abro archivo para lectura	
	push	mode				;Parametro 2: dir string modo de apertura
	push	fileName			;Parametro 1: dir nombre del archivo
	call	_fopen				;Abre el archivo y deja el handle en EAX
	mov		[fileHandle],eax
	add		esp,8
	
	ret
	
leerArch:
	push	dword[fileHandle]	;Parametro 4: handle del archivo
	push	1					;Parametro 3: cantidad de registros
	push	4					;Parametro 2: longitud del registro
	push	registro			;Parametro 1: dir area de memoria donde se copia
	call	_fread				;LEO registro. Devuelve en eax la cantidad de bytes leidos
	add		esp,16
	
	cmp		eax,0				;Fin de archivo?
	jle		eof
	
	; llenar en la matriz el número leído del archivo
	call	llenarNro
	
	jmp		leerArch
	
eof:
;	Cierro archivo cuando llega a fin del archivo
	push	dword[fileHandle]	;Parametro 1: handle del archivo
	call	_fclose
	add		esp,4
	ret
	
llenarNro:
	mov		eax,0
	mov		al,byte[columna]
	mov		dl,2	;	muevo 2 al dl como multiplicador de longitud de cada elemento de la matriz
	mul		dl		;	Multiplico al con dl, dejando el resultado en ax
	
	mov		ebx,eax	;	paso el resultado de la 1ra multip. al ebx (desplaz. en columnas)
	
	mov		eax,0
	mov		al,byte[fila]
	mov		dl,42	;	muevo 42 al dl (resultado de la multip. long.elem. x cant. cols de la matriz)
	mul		dl		;	En ax queda el resultado de la multip. (desplaz. en filas)
	
	add		eax,ebx	;	Sumo ambos desplaz. (desplaz. cols + desplaz. filas)
	
	mov		ebx,0
	mov		bx,word[nro]
	
	mov		word[matriz + eax],bx
	
	ret
	
calcular:
	mov		esi,20		; Posiciono en la columna central (10,0) de la matriz
	mov		ecx,21
	mov		eax,0
sumarCol:
	mov		ebx,0
	mov		bx,word[matriz + esi]
	add		eax,ebx
	
	add		esi,42		; Desplazo hacia próxima fila (cant.cols x long.elem.)
	loop	sumarCol
	
	mov		esi,420		; Posiciono en la fila central (0,10) de la matriz
	mov		ecx,21
sumarFila:
	mov		ebx,0
	mov		bx,word[matriz + esi]
	add		eax,ebx
	
	add		esi,2
	loop	sumarFila
restarCentral:
	mov		esi,440		; Posiciono en la celda central (10,10) de la matriz
	mov		ebx,0
	mov		bx,word[matriz + esi]
	sub		eax,ebx

	push	eax				;Parametro 2: campo que se encuentra en el formato indicado q se imprime por pantalla
	push	msjResult		;Parametro 1: direccion de memoria del campo a imprimir
	call	_printf			
	add		esp,8
	
	ret