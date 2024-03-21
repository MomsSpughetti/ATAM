.globl test_mov

.section .text

test_mov:
    xorq %rax, %rax
    pushq %rbp # prologue, 
    movq %rsp, %rbp # now %rip is in 0x10(%rbp)
    leaq (%rip), %rax
    mov %eax, %edi #triggers %rip
    subq $8, %rsp
    movq %rax, -8(%rbp)
    call my_ili_handler
    movq %rdi, %rax
    movq %rbp, %rsp # epilogue
    popq %rbp
    retq