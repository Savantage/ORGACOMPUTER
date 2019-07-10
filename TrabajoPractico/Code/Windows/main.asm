%include "data.asm"
%include "macros.asm"
%include "bss.asm"

global _main
extern _ExitProcess@4

        section .text
_main:
        prints      me_title
        prints      me_menu
        call        askop
        
end:
        call        _ExitProcess@4
;_______________________________________________________________________
askopR:
        prints      me_err_op
askop:
        getstr      string, mem_1, 1
        mov         al,[mem_1]
        cmp         al,0x31
        je          op_1
        cmp         al,0x32
        je          op_2
        cmp         al,0x33
        je          op_3
        cmp         al,0x34
        je          op_4
        jmp         askopR
askopE:
        ret
;_______________________________________________________________________
op_1:
        getbinstr   me_bin_cfg, string, mem_32, 32
        prints      me_bin_end1
        call        specialtest
        cmp         esi,1
        je          op_1E
        call        printsign
        prints2     mem_32 +9, print_23
        call        printexp
op_1E:
        jmp         askopE

op_2:
        gethexstr   me_hex_cfg, string, mem_8, 8
        prints      me_bin_end2
        HexToBin    mem_8, mem_32, 8
        call        specialtest
        cmp         esi, 1
        je          op_2E
        call        printsign
        prints2     mem_32 +9, print_23
        call        printexp
op_2E:
        jmp         askopE

op_3:
        getsign     me_sci_sign, string, mem_1, 1, mem_32, 0x30, 0x31
        getbinstr   me_sci_frac, string, mem_32+9, 23
        call        getexp
        prints      me_sci_end1
        prints2     mem_32, print_32
        prints      new_line
        jmp         askopE

op_4:
        getsign     me_sci_sign, string, mem_1, 1, mem_32, 0x30, 0x31
        getbinstr   me_sci_frac, string, mem_32+9, 23
        call        getexp
        prints      me_sci_end2
        BinToHex    mem_32, 32, print_inth
        prints      new_line
        jmp         askopE
;_______________________________________________________________________
;  Imprime (+1/-1) dependiendo
;  de lo almacenado en mem_32
printsign:
        mov         eax,one_neg
        mov         edx,one_pos
        cmp         byte[mem_32],0x30
        cmove       eax,edx
        prints      eax
        ret
;_______________________________________________________________________
;   Convierte el exponente binario a decimal
;   Le resta 127 para obtener el valor original
;   Imprime el signo en caso de ser nagativo
;   y lo convierte en positivo.
;   Convierte el valor decimal, en binario y lo muestra
printexp:
        prints      ten_power
        BinToDec    exp, mem_32+1, 8
        sub         dword[exp],127
        call        showexpsign
        flush       mem_8, 8
        DecToBin    exp, 8, mem_8
        call        printexpA
        prints      new_line
        ret
;______________________________________________________________________
;   Imprime el signo del exponente y convierte el exponente a positivo
showexpsign:
        cmp         dword[exp],0
        jge         showexpsignE
        prints      neg_symb
        neg         dword[exp]
showexpsignE:
        ret
;_______________________________________________________________________
;   Imprime el exponente filtrando los ceros del comienzo
printexpA:
       mov byte[mem_8+8],0
       mov esi,0
       jmp inc_esie
inc_esi:
       inc esi
inc_esie:
       cmp byte[mem_8+esi],0x30
       je  inc_esi
       mov edx,mem_8
       add edx,esi
       prints edx
       ret
;_______________________________________________________________________
;   Rutina para pedir informacion del exponente, convertirlo a decimal,
;   convertir el decimal en negativo (si el signo ingresado para
;   el exponente es negativo), sumarle 127 (porque sera almacenado
;   en exceso 127), convertir el decimal en binario y almacenar
;   esta ultima configuracion en mem_32+1
getexp:
        getsign     me_sci_exps, string, mem_1, 1, mem_1, 0x2B, 0x2D
        getbinstr   me_sci_exp, string, mem_8, 8
        memcopy     mem_8, mem_32+1,8
        BinToDec    exp, mem_32+1, 8
        call        expchecksign
        add         dword[exp],127
        flush       mem_8, 8
        DecToBin    exp, 8, mem_8
        memcopy     mem_8, mem_32+1,8
        ret
;_______________________________________________________________________
;   Si el signo ingresado para el exponente es negativo,
;   se convierte el exponente decimal a negativo
expchecksign:
        cmp         byte[mem_1],0x2B
        je          expchecksignE
        neg         dword[exp]
expchecksignE:
        ret
;______________________________________________________________________
;   Testea los valores especiales de IEEE 754
specialtest:
        testspc   mem_32, pzerob, pzero, 32
        cmp       esi,1
        je        specialtestE
        testspc   mem_32, nzerob, nzero, 32
        cmp       esi,1
        je        specialtestE
        testspc   mem_32, pinfb, pinf, 32
        cmp       esi,1
        je        specialtestE
        testspc   mem_32, ninfb, ninf, 32
        cmp       esi,1
        je        specialtestE
        testspc   mem_32, qnanb, qnan, 8
        cmp       esi,1
        je        specialtestE
        testspc   mem_32, snanb, snan, 8
specialtestE:
        ret
