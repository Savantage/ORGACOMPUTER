%ifndef MACROS_ASM
%define MACROS_ASM

extern _printf
extern _gets

;Imprime el string usando un formato
%macro prints2 2  ;string , formato
        push        %1
        push        %2
        call        _printf
        add         esp,8
%endmacro

;Imprime el string que termina en cero
%macro prints 1    ;string
        push        %1
        call        _printf
        add         esp,4
%endmacro

;Pide al usuario una cantidad "len" de caracteres y la almacena en dest.
%macro getstr 3     ;temp_dest, dest, len
        jmp         %%getstrR
%%getstrERR:
        prints      me_err_len
%%getstrR:
        flush       %1,%3+1
        push        %1
        call        _gets
        add         esp,4
        cmp         byte[%1+%3],byte 0
        jne         %%getstrERR
        memcopy     %1, %2, %3
%endmacro

;Escanea una longitud predefinida de caracteres,
;de encontrarse algun dígito inválido, coloca el valor -1 en edi.
%macro bintest 2   ;input, longitud
        mov         esi, %2
        mov         edi, -1
%%bintestR:
        inc         edi
        cmp         edi,esi
        je          %%bintestE
        mov         bl, byte [ %1 + edi]
        cmp         bl, 0x31
        je          %%bintestR
        cmp         bl, 0x30
        je          %%bintestR
        mov         edi, -1
%%bintestE:
%endmacro

;Escanea una longitud predefinida de caracteres,
;de encontrarse algun dígito inválido, coloca el valor -1 en edi.
%macro hextest 2   ;src, len
        mov         edx,-1
        mov         edi,0
        mov         esi,0
%%hextestR:
        mov         bl, byte [%1+esi] ;muevo el char  a  BL
        sub         bl, 48  ;  le resto  48
        mov         cl, bl ; lo copio en  CL
        sub         cl, 7;  le quito 7 a  CL
        cmp         bl, 10 ; compaaro si  BL es mayor o iguaal que  10
        cmovge      ebx,ecx;  muevvo CLL a  BL
        cmp         bl, 16; comparo si  BL es mayor o iguaal que  16
        cmovge      edi,edx
        cmp         edi,-1
        je          %%hextestE
        mov         byte [%1+esi], bl
        inc         esi
        cmp         esi,%2
        je          %%hextestE
        jmp         %%hextestR
%%hextestE:
%endmacro

;Analiza si lo ingresado es + o -, de otro modo, se vuelve a solicitar input
%macro getsign 7    ;msg_beg, temp_dest, dest, len, end_dest, sign+, sign-
        jmp         %%getsign
%%getsignR:
        prints      me_err_sign
%%getsign:
        prints      %1
        getstr      %2,%3,%4
        cmp         byte[%3],0x2B
        jne         %%getsignA
        mov         byte[%5],%6
        jmp         %%getsignE
%%getsignA:
        cmp         byte[%3],0x2D
        jne         %%getsignR
        mov         byte[%5],%7
%%getsignE:
%endmacro

;Combinación de los macros getstr y bintest fundamentalmente
%macro getbinstr 4  ;me_cfg, temp_dest, dest, len
        jmp         %%getbinstr
%%getbinstrR:
        prints      me_err_bin
%%getbinstr:
        prints      %1
        getstr      %2, %3, %4
        bintest     %3, %4
        cmp         edi, -1
        je          %%getbinstrR
%endmacro

;Combinaciòn de los macros getstr y HexToDec fundamentalmente
%macro gethexstr 4
        jmp         %%gethexstr
%%gethexstrR:
        prints      me_err_hex
%%gethexstr:
        prints      %1
        getstr      %2, %3, %4
        hextest     %3, %4
        cmp         edi, -1
        je          %%gethexstrR
%endmacro

;Testea si dos strings son iguales
%macro testspc 4 ; str, str, msg, len
        mov     esi, 0
        jmp     %%inc_esie
%%inc_esi:
        add     esi,4
        cmp     esi, %4
        je      %%pass
%%inc_esie:
        mov     ecx,dword[%1+esi]
        mov     edx,dword[%2+esi]
        cmp     ecx,edx
        je      %%inc_esi
        mov     esi,-1
        jmp     %%testzeroE
%%pass:
        mov     esi, 1
%%testzeroE:
        cmp     esi,1
        jne     %%testzeroEE
        prints  %3
%%testzeroEE:
%endmacro

;Copia una cantidad n de bytes de src en dest
%macro memcopy 3    ;src, dest, n
        mov         esi,%1
        mov         edi,%2
        mov         ecx,%3
        rep         movsb
%endmacro

;Setea una cantidad (con 0x30) n de bytes desde src
%macro flush 2      ; src, n
        mov         esi,0
%%flushR:
        mov         byte[%1+esi],0x30
        inc         esi
        cmp         esi, %2
        jne         %%flushR
%endmacro

;Convierte caracteres hexadecimales a binarios
%macro HexToBin 3   ;src, dest, src_len
        push        ebp
        mov         ebp,esp
        sub         esp, 4
        mov         edi,0
        mov         esi,0
%%nextchar:
        mov         bl, byte [%1+esi]
        mov         dword [ebp-4], 0
%%writeR:
        mov         dl, bl
        shr         dl, 3
        and         dl, 1
        mov         byte[%2+edi],byte 0x30
        cmp         dl, 1
        jne         %%writeE
        mov         byte[%2+edi],byte 0x31
%%writeE:
        shl         bl, 1
        inc         dword [ebp-4]
        inc         edi
        cmp         dword [ebp-4], 4   ;Se necesitan 4 cifras binarias
        jl          %%writeR
        inc         esi                ;Se pasa al siguiente char
        cmp         esi,%3             ;String len
        je          %%hextobinE
        jmp         %%nextchar
%%hextobinE:
        add         esp,4
        pop         ebp
%endmacro

;Imprime un carácter hexadecimal cada 4 caracteres binarios
%macro BinToHex 3   ;src, src_len, format
        mov         esi,0
%%add8:
        mov         edi,0
        mov         al, byte[%1+esi]
        inc         esi
        cmp         al, 0x31
        jne         %%add4
        add         edi,8
%%add4:
        mov         al, byte[%1+esi]
        inc         esi
        cmp         al,0x31
        jne         %%add2
        add         edi,4
%%add2:
        mov         al, byte[%1+esi]
        inc         esi
        cmp         al,0x31
        jne         %%add1
        add         edi,2
%%add1:
        mov         al, byte[%1+esi]
        inc         esi
        cmp         al,0x31
        jne         %%add0
        add         edi,1
%%add0:
        prints2     edi,%3
        cmp         esi,%2
        jne         %%add8
%endmacro

;Obtiene un número entero decimal a partir de un string
;de caracteres binarios de longitud len y lo almacena en int
%macro BinToDec 3   ;int, string, len
        mov         esi, 0             ;iter
        mov         dword[%1], 0       ;valor dword[exp_int]
        mov         edx, 0             ;resto
        mov         eax, 128           ;dividiendo
        mov         ecx, 2             ;divisor
%%bintodecR:
        cmp         byte[%2+esi], 0x31
        jne         %%bintodecE
        add         dword[%1],eax
%%bintodecE:
        inc         esi
        div         ecx
        cmp         esi,%3
        jne         %%bintodecR
%endmacro

; Genera la representación binaria en mem_8 del número en exp_int
; haciendo divisiones sucesivas
%macro DecToBin 3   ;exp_int, 8, mem_8
        mov         eax, dword[%1]     ;dividiendo
        mov         esi,%2 -1
        mov         ecx, 2             ;divisor
%%dectobinR:
        mov         edx, 0
        div         ecx                ;eax contendra el cociente
        cmp         edx,0              ;edx contendrá el resto
        jne         %%write1
        mov         byte[%3+esi],0x30
        jmp         %%write1E
%%write1:
        mov         byte[%3+esi],0x31

%%write1E:
        sub         esi, 1
        cmp         eax, 2
        jge         %%dectobinR
        mov         byte[%3+esi],0x31
%endmacro

%endif
