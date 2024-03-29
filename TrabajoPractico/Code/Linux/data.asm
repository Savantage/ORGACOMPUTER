%ifndef DATA_ASM
%define DATA_ASM

        section .data

        me_title    db 10,10,"                       75.03 / 95.57 Organización del Computador",10,
                    db "          Trabajo Práctico Nro. 21  || Interpretación de BPFlotante IEEE 754",10,0
        me_menu     db 10,"1 - Configuración Binaria -> Notacion científica en base 2",10,
                    db "2 - Configuración Hexadecimal -> Notación científica en base 2",10,
                    db "3 - Notación científica en base 2 -> Configuración Binaria",10,
                    db "4 - Notación científica en base 2 -> Configuración Hexadecimal",10,
                    db 10,"Ingrese el número de operación (1 dígito)",10,0

        me_bin_cfg  db "Ingrese la configuración binaria (32 dígitos): ",10,0
        me_hex_cfg  db "Ingrese la configuración hexadecimal (8 dígitos): ",10,0

        me_bin_end1 db 10,"La configuración binaria contiene el número: ",10,0
        me_bin_end2 db 10,"La configuración hexadecimal contiene el número: ",10,0
        me_sci_end1 db 10,"La configuración binaria es: ",10,0
        me_sci_end2 db 10,"La configuración hexadecimal es: ",10,0

        me_sci_sign db "Ingrese el signo del número (+/-): ",10,0
        me_sci_frac db "Ingrese la fracción (23 dígitos): ",10,0
        me_sci_exps db "Ingrese el signo del exponente (+/-): ",10,0
        me_sci_exp  db "Ingrese el exponente (8 dígitos): ",10,0

        me_err_sign db "Solo es válido ingresar '+' o '-'",10,0
        me_err_op   db "Operación inválida",10,0
        me_err_len  db "Cantidad incorrecta de caracteres",10,0
        me_err_bin  db "Solo es valido ingresar caracteres binarios",10,0
        me_err_hex  db "Sólo es válido ingresar números y letras mayúsculas",10,0

        print_inth  db "%X",0
        print_1     db "%.1s",0
        print_8     db "%.8s",0
        print_23    db "%.23s",0
        print_32    db "%.32s",0

        one_pos     db "+1,",0
        one_neg     db "-1,",0
        ten_power   db " x10^",0
        plus_symb   db "+",0
        neg_symb    db "-",0
        new_line    db 10,0

        pzerob  db "00000000000000000000000000000000",10,0
        nzerob  db "10000000000000000000000000000000",10,0
        pinfb   db "01111111100000000000000000000000",10,0
        ninfb   db "11111111100000000000000000000000",10,0
        qnanb   db "011111111",10,0
        snanb   db "111111111",10,0
        pzero   db "+0",10,0
        nzero   db "-0",10,0
        pinf    db "Infinito positivo",10,0
        ninf    db "Infinito negativo",10,0
        qnan    db "QNaN",10,0
        snan    db "SNaN",10,0

%endif
