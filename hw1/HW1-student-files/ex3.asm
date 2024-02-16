.global _start

.section .text
_start:
    # init section 
    movb $1,%r15b # %dl will save the answer
    movq $0,%rsi # %rsi will save the index of the current element in the source array 
    movq $up_array,%rbx
    movq $0,%r8 # r8 saves the size of the inc array
    movq $down_array,%rcx
    movq $0,%r9  # r9 saves the size of the dec array
    movq $source_array,%rax
    # end of init section


    
.loopStart:
    test %r8,%r8
    jz emptyIncArray
    test %r9,%r9
    jz emptyDecArray
    # in this line we have validated that the dec&inc array are not empty Normal code
    lea -4(%rbx),%r10 # have the adress of the last element of inc array
    lea -4(rcx),%r11  # have the adress of the last element of dec array
    







.loopCheck:
    lea 4(%rax),%rax
    inc %rsi 
    cmpl (size),%rsi
    jbe loopStart
    jmp  exit


.insertInDec:
    movl (%rax),%r10d
    movl %r10d , (%rcx)
    lea 4(%rcx) , %rcx
    inc %r9
    jmp loopCheck

.insertInInc:
    movl (%rax),%r10d
    movl %r10d, (%rbx)
    lea 4(%rbx),%rbx
    inc %r8
    jmp loopCheck


.bothAreEmpty:
    movl (rax),%r10d
    lea 4(%rax),%r11
    movl (%r9),%r11d
    cmpl %r11d,%r10d
    jl insertInInc
    jmp insertInDec
.emptyIncArray:
    
    jz bothAreEmpty
    jmp loopCheck

.emptyDecArray:
    jmp loopCheck


.exit:
    movb %r15b,(bool)
