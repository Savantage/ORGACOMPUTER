; Dado un archivo en formato texto que contiene informacion sobre autos llamado listado.txt
; donde cada linea del archivo representa un registro de informacion de un auto con los campos: 
;   marca:					10 caracteres
;   modelo: 				15 caracteres
;   año de fabricacion:		4 caracteres
;   patente:				7 caracteres
;   precio:					7 caracteres
; Se pide codificar un programa en assembler intel que lea cada registro del archivo listado y guarde
; en un nuevo archivo en formato binario llamado seleccionados.dat aquellos que cumplan las sgtes condiciones:
;   Pertenecer a las marcas contenidas en una tabla en memoria llamada vecMarcas
;	Haber sido fabricado entre 2010 y 2018 inclusive
; Como los datos del archivo pueden ser incorrectos, se deberan validar mediante una rutina interna. 
; El formato de registro del archivo de seleccionados es el sgte:
;   marca:					10 caracteres
;   modelo:					15 caracteres
;	año de fabricacion:		4 bytes en formato numerico (binario punto fijo con signo)
;	patente:				4 caracteres
; 
; Adicional: Como cada registro puede considerarse seleccionado (cumple las condiciones), descartado (no cumple)
; o erroneo (contiene datos invalidos) pueden ademas estos ultimos 2 casos guardarse cada uno en archivos separados
;
global	_main
extern	_printf
extern	_gets
extern	_sscanf

extern	_fopen
extern	_fclose

extern	_fgets
extern	_fputs

extern	_fwrite
extern	_rewind
extern	_fread

section	.data
	fileListado		db	'listado.txt',0
	modeListado		db	'r',0	;read | text | open or error
	handleListado	dd	0
	regListado		times 	0	db ''
	 marca			times	10	db ' '
	 modelo			times	15	db ' '
	 anio			times	4	db ' '
	 patente		times	7	db ' '
	 precio			times	7	db ' '

	anioStr			times	4	db ' ',0
	numFormat					db '%d',0
	anioNumD					dd 0
	regStatus		db  ' ',0	;[e]rroneo - [s]eleccionado - [d]escartado


	fileSeleccion	db	'seleccion.dat',0
	modeSeleccion	db	'a+b',0	;append + read  | bina | open or create
	handleSeleccion	dd	0
	regSeleccion	times	0	db	''
	 marcaS			times	10	db ' '
	 modeloS		times	15	db ' '
	 anioS						dd 0
	 patenteS		times	7	db ' '


	msjErrOpenLis	db  "Error en apertura de listado",0
	msjErrOpenSel	db  "Error en apertura de seleccion",0

	vecMarcas		db	'Ford      Fiat      Chevrolet Peugeot   '
	
	
msgDbgLeyendo	db	"leyendo...",10,13,0
msgRegS	db	"Registro seleccionado...",10,13,0
msgRegD	db	"Registro descartado...",10,13,0
msgRegE	db	"Registro erroneo...",10,13,0
section	.text
_main:
;	Abro archivo listado
	push	modeListado			;Parametro 2: dir string modo de apertura
	push	fileListado			;Parametro 1: dir nombre del archivo
	call	_fopen				;ABRO archivo y deja el handle en EAX
	add		esp,8

	cmp		eax,0				;Error en apertura?
	jle		errorOpenLis

	mov		[handleListado],eax

	;Abro archivo Seleccion
	push	modeSeleccion			;Parametro 2: dir string modo de apertura
	push	fileSeleccion			;Parametro 1: dir nombre del archivo
	call	_fopen					;ABRO archivo y deja el handle en EAX
	add		esp,8

	cmp		eax,0					;Error en apertura?
	jle		errorOpenSel

	mov		[handleSeleccion],eax

;	Leo registro
readListado:
	push	dword[handleListado]	;Parametro 3: handle del archivo
	push	45					;Parametro 2: cantidad de bytes maximas a leer (o hasta fin de linea)
	push	regListado			;Parametro 1: dir area de memoria donde se copia
	call	_fgets				;LEO registro. Devuelve en eax la cantidad de bytes leidos
	add		esp,12
	
	cmp		eax,0				;Fin de archivo?
	jle		closeFiles
; aca va la solucion
	push	msgDbgLeyendo
	call	_printf
	add		esp,4	
	
	call	validarRegistro
	cmp		byte[regStatus],'e'
	je		regErroneo
	cmp		byte[regStatus],'d'
	je		regDescartado
regSeleccionado:
	push	msgRegS
	call	_printf
	add		esp,4	
	
	;Copio Marca, Modelo
	mov		ecx,25
	mov		esi,regListado
	mov		edi,regSeleccion
	rep	movsb
	;Copio Año
	mov		ebx,[anioNumD]
	mov		dword[anioS],ebx
	
	;Copio Patnte
	mov		ecx,7
	mov		esi,patente
	mov		edi,patenteS
	rep	movsb
	
	;Guardo registro en archivo Seleccion
	push	dword[handleSeleccion];Parametro 4: handle del archivo
	push	1					;Parametro 3: cantidad de registros
	push	36					;Parametro 2: longitud del registro
	push	regSeleccion		;Parametro 1: dir area de memoria donde se copia
	call	_fwrite				;LEO registro. Devuelve en eax la cantidad de bytes leidos
	add		esp,16	

	
	jmp		readListado
regErroneo:
	push	msgRegE
	call	_printf
	add		esp,4
	
	jmp		readListado
regDescartado:
	push	msgRegD
	call	_printf
	add		esp,4
	jmp		readListado

	
;MANEJO DE ERRORES
errorOpenSel:
	push	msjErrOpenSel
	call	_printf
	add		esp,4
	;Cierro archivo Listado
	push	dword[handleListado]	;Parametro 1: handle del archivo
	call	_fclose					;CIERRO archivo
	add		esp,4
	jmp		endProg
errorOpenLis:
	push	msjErrOpenLis
	call	_printf
	add		esp,4
	jmp		endProg
closeFiles:
	;Cierro todos los archivos
	;Cierro archivo Listado
	push	dword[handleListado]	;Parametro 1: handle del archivo
	call	_fclose					;CIERRO archivo
	add		esp,4	
	;Cierro archivo Seleccion
	push	dword[handleSeleccion]	;Parametro 1: handle del archivo
	call	_fclose					;CIERRO archivo
	add		esp,4
endProg:
	ret
	
	
;**	RUTINAS INTERNAS***********************	
validarRegistro:
	;Valido Marca (por tabla)
	mov		ecx,4		;longitud del vector para loop
	mov		ebx,0		;indice para vecMarcas
nextMarca:	
	push	ecx
	mov		ecx,10		;cantidad de bytes a comparar
	mov		esi,marca
	lea		edi,[vecMarcas+ebx]
	repe cmpsb
	pop		ecx
	je		marcaOk
	add		ebx,10
	loop	nextMarca
	jmp		datoDescartado
marcaOk:
	;Valido Año fisicamente
	mov		ecx,4		;cantidad para ciclo
	mov		ebx,0		;indice para anio
nextDigito:	
	cmp		byte[anio+ebx],'0'
	jl		datoErroneo
	cmp		byte[anio+ebx],'9'
	jg		datoErroneo
	inc		ebx
	loop	nextDigito
anioFisicoOk:
	;Valido año logicamente (por rango)
	mov		ecx,4
	mov		esi,anio
	mov		edi,anioStr
	rep	movsb
	
	push	anioNumD
	push	numFormat
	push	anioStr
	call	_sscanf
	add		esp,12

	cmp		dword[anioNumD],2010
	jl		datoDescartado
	cmp		dword[anioNumD],2018
	jg		datoDescartado
datoSeleccionado:
	mov		byte[regStatus],'s'	;registro erroneo
	jmp		finValidarRegistro
datoDescartado:
	mov		byte[regStatus],'d'	;registro erroneo
	jmp		finValidarRegistro
datoErroneo:
	mov		byte[regStatus],'e'	;registro erroneo
	jmp		finValidarRegistro
finValidarRegistro:
	ret
	
	
	
	ret