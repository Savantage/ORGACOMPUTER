.data 
dato1:  .word 2
dato2:  .word 5
sum:    .word 0

.text
.global main

main:   ldr r0, =dato1
        ldr r1, [r0]
        ldr r0, =dato2
        ldr r2, [r0]
        add r0, r1, r2
        ldr r3, =sum
        str r0, [r3]

fin:    bx lr