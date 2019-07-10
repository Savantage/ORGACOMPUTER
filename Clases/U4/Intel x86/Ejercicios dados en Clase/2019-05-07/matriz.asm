;******************************************************
; matrix.asm
; Ejercicio sobre una matriz 3x3 de nros
; Objetivos
;	- Tomar ingreso por teclado nros de [000..999]
;	- Validar por rango que los nros estén en [000..999]
;	- Calcular la sumatoria de la diag. ppal
;	- Mostrar el resultado por la pantalla
;
;******************************************************
global	_main
extern	_printf
extern	_scanf
extern	_puts
extern	_gets

section	.data
	msjIngreso	db	'Ingrese un numero [000-999]',10,13,0	;campo con el string a imprimir.  Debe finalizar con 0 binario
	traza		db	'La traza de la matriz es: %d',10,13,0
	esInvalid	db  'El nro ingresado es Invalido',10,13,0
	nro			db	'   '
section	.bss
	esValid		resb	1
	matriz		resd 	9		; reservo una matriz cuyo elementos es un BPF c/s de 4 bytes (Double Word)
section	.text
_main:
	
	call	carga
	call	calcular
	
endProg:	
	ret

carga:
	mov		esi,0
	mov		ecx,9
ingreso:
	push	ecx				;Resguardo el ecx porque las llamadas a funciones externas modifica el ecx
	push	msjIngreso		;Parametro 1: direccion del mensaje a imprimir
	call	_printf
	add		esp,4			;Coloco puntero a la pila donde estaba
	pop		ecx				;Recupero el ecx después de la llamada externa _printf
	
	push	ecx				;Resguardo el ecx porque las llamadas a funciones externas modifica el ecx
	push	nro				;Parametro 1: direccion de memoria del campo donde se guarda lo ingresado
	call	_gets			;Lee de teclado y lo guarda como string hasta que se ingresa fin de linea . Agrega un 0 binario al final
	add		esp,4
	pop		ecx				;Recupero el ecx después de la llamada externa _gets
		
	push	ecx				;Resguardo el ecx porque en la rutina validar modifica el ecx
	push 	esi				;Resguardo el esi porque en la rutina validar modifica el esi
	call	validar			;La rutina validar deja el resultado de la validación en la variable valid 'S/N'
	pop		esi				;Recupero el esi después de la llamada
	pop		ecx				;Recupero el ecx después de la llamada
	cmp		byte[esValid],'S'
	jne		errNum
		
	push	ecx
	push 	esi
	call	llenarMatriz
	pop		esi
	pop		ecx
	
	add		esi,4			;Avanzo en la matriz 4 bytes ya que cada elem. de la matriz es un BPF c/s de 32bits (Double Word)

	loop	ingreso
	ret
	
errNum:
	push	ecx				;Resguardo el ecx porque las llamadas a funciones externas modifica el ecx
	push	esInvalid			
	call	_printf
	add		esp,4
	pop		ecx				;Recupero el ecx después de la llamada externa _printf
	jmp		ingreso

calcular:
	mov		esi,0
	mov		ecx,3
	mov		eax,0
sumar:
	add		eax,dword[matriz+esi]

	add		esi,16			;Desplazamiento por el diag.ppal (n + 1 = 4) x 4 (tamaño de cada nro = 4 bytes) = 16
	loop	sumar
	
mostrar:
	push	eax				;Parametro 2: campo que se encuentra en el formato indicado q se imprime por pantalla
	push	traza			;Parametro 1: direccion de memoria del campo a imprimir
	call	_printf			
	add		esp,8	
	
	ret
	
llenarMatriz:
	mov		ecx,3						;Inicializo contador en 3, ya que el nro está comprendido [1..999]
	mov		eax,0						;Inicializo el acumulador en eax con 0
	mov		edi,0						;Utilizo el edi como puntero a la cadena de numeros
	mov		dl,10						;Inicializo el dl con 10 como multiplicador auxiliar
transformar:
	mul		dl							;Multiplico al con dl, dejando el resultado en ax
	
	mov		ebx,0						;Inicializo en 0 al ebx
	mov		bl,byte[nro+edi]			;Copio el primer nro (caracter ASCII) en el bl
	sub		bl,30h						;Le resto 30 en hexa (48 decimal) para convertir el nro en 1 BPF s/s
	
	add		eax,ebx						
	
	inc		edi
	
	loop	transformar
	
	mov		dword[matriz+esi],eax		;Copio el nro transformado en BPF c/s en la matriz
		
	ret
	
validar:
	mov		esi,0
	mov		ecx,3						;Inicializo ecx en 3 ya que acepta hasta 3 digitos
compare:
	cmp		byte[nro+esi],'0'			;Validar por rango [0..9] digito por digito
	jl		invalido
	cmp		byte[nro+esi],'9'
	jg		invalido
	inc		esi
	loop	compare
valido:
	mov		byte[esValid],'S'				;Devuelve S en la variable esValid si es un nro válido
finValidar:
	ret
invalido:
	mov		byte[esValid],'N'				;Devuelve N en la variable esValid si no es un nro válido
	jmp		finValidar