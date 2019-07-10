global		_main
section		.data
	num1	dd	5
	num2	dd	6
section		.bss
	resMay	resd	1
	resMen	resd	1
section		.text
_main:
	mov		eax,[num1]
	mov		ebx,[num2]
	add		eax,ebx
	cmp		eax,10

	jg		mayor
	mov		[resMen],eax
	
	jmp		fin
mayor:
	mov		[resMay],eax
fin:	
	ret
	