;***************************************************************************
; invertir.asm
; Ejercicio que calcula la longitud de un string y lo imprime invertido
; 
;***************************************************************************
global		_main
extern		_puts
extern		_printf

section		.data
	texto		db	"rodatupmoc led noicazinagro",0
	msjLong		db	"La longitud es %d",10,0
	msjTextoInv	db	"El texto dice: %s",0
section		.bss
	textoInv	resb 30
section		.text
_main:
;	Imprimo texto original
	push	texto
	call	_puts
	add		esp,4

;	Calculo la longitud	en esi
	mov		esi,0
verFin:	
	cmp		byte[texto+esi],0
	je		finString
	inc		esi
	jmp		verFin
	
finString:
;	Imprimo la longitud	
	push	esi
	push	msjLong
	call	_printf
	add		esp,8
	
;   Copio el texto de derecha a izquierda	
	mov		edi,0
verFinCopia:	
	cmp		esi,0
	je		finCopia
	mov		al,	[texto+esi-1]
	mov		[textoInv+edi],al
	dec		esi
	inc		edi
	jmp		verFinCopia	

finCopia:
	mov		byte[textoInv+edi],0
	
;	push	textoInv
;	call	_printf
;	add		esp,4
	
	push	textoInv
	push	msjTextoInv
	call	_printf
	add		esp,8
	
endProg:	
	ret
