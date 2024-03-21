.globl test_push

.section .text

test_push:
    xorq %rax, %rax
    leaq (%rip), %rax
    pushq %rbp # prologue,  #triggers %rip
    movq %rsp, %rbp # now %rip is in 0x10(%rbp)
    subq $8, %rsp
    movq %rax, -8(%rbp)
    call my_ili_handler
    movq %rdi, %rax
    movq %rbp, %rsp # epilogue
    popq %rbp
    retq