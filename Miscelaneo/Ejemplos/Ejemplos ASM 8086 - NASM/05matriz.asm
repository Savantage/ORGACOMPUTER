global		_main
extern		_printf
section		.data

matriz		times 12 dw 2
LONG_ELEM	equ	2
CANT_FIL	equ	4
CANT_COL	equ	3

elem		db	'%d ',0
crlf		db	10,13,0

section		.bss
fil			resw	1
col			resw	1

section		.text
_main:

;Imprimo la matriz con los valores iniciales
	call	printMat
	
	call	printCRLF
;Modifico un elemento	
	mov		word[fil],2
	mov		word[col],3
	call	getOffset
	mov		word[matriz+ebx],3
;Imprimo la matriz modificada
	call	printMat
	
	ret

;*************************************************************************************
;	Rutinas Internas
;*************************************************************************************
;*************************************************************************************
;Rutina printMat
;*************************************************************************************
printMat:
	mov		word[fil],1			;fila = 1
	mov		word[col],1			;columna = 1
verifyEnd:	
	cmp		word[fil],CANT_FIL	
	jg		finPrintMat			;ultima fila?
	
	cmp		word[col],CANT_COL
	jg		nextFil				;ultima columna?
	
	call	getOffset			;obtengo desplazamiento en ebx
	
	mov		ax,[matriz+ebx]		;copio el elemento de la matriz en ax
	cwde						;convierto word a doubleword (extiendo signo de ax en eax)

printElem:
	push	eax					;copio el elemento a imprimir en la pila
	push	elem				;copio la dir del string con el formato a imprimir en la pila
	call	_printf				;imprimo elemento
	add		esp,8
	
	inc		word[col]			;muevo a proxima columna
	jmp		verifyEnd
	
nextFil:
	call	printCRLF			;imprimo fin de linea para imrpmir sgte fila abajo
	
	inc		word[fil]			;muevo a la proxima fila
	mov		word[col],1			;reinicio columna en 1
	jmp		verifyEnd			
	
finPrintMat:
	ret
;*************************************************************************************
;Rutina getOffset
;deja en ebx el deplazamiento del elemento situado en (fil,col)
;*************************************************************************************
getOffset:
	mov		ax,[fil]		;ax = fila
	dec		ax				;ax = fila-1
	imul	ax,LONG_ELEM	;ax = (fila-1) * longElem
	imul	ax,CANT_COL		;ax = (fila-1) * longElem * cantCol = (fila-1) * longFila
	
	sub		ebx,ebx
	mov		bx,[col]		;bx = (columna)
	dec		bx				;bx = (columna-1)
	imul	bx,LONG_ELEM	;bx = (columna-1) * longElem

	add		bx,ax			;ebx = desplazamiento
	ret
;*************************************************************************************
;Rutina para imprimir fin de linea
;*************************************************************************************
printCRLF:
	push	crlf
	call	_printf
	add		esp,4
	ret
