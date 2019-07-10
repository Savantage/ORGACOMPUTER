%ifndef BSS_ASM
%define BSS_ASM

        section .bss

        exp         resd 1
        mem_1       resb 1
        mem_8       resb 9
        mem_23      resb 23
        mem_32      resb 32
        string      resb 128
%endif
