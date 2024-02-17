.global _start

.section .text
_start:
    # init section 
    movb $1,(bool) #  we are assuming that there is a valid partition
    movl $0,%esi # %rsi will save the index of the current element in the source array 
    movq $up_array,%rbx
    movl $0,%r8d # r8d saves the size of the inc array
    movq $down_array,%rcx
    movl $0,%r9d  # r9d saves the size of the dec array
    movq $source_array,%rax
    # end of init section

.loopStart:
    test %r8d,%r8d
    jz .emptyIncArray
    test %r9d,%r9d
    jz .emptyDecArray
    # in this line we have validated that the dec&inc array are not empty (Normal code)
    lea -4(%rbx),%r10 # have the adress of the last element of inc array
    lea -4(%rcx),%r11  # have the adress of the last element of dec array
    movl (%r10),%r10d # inc
    movl (%r11),%r11d # dec
    cmpl (%rax), %r10d # inc < (rax)
    jl  .incLastSmallerThanCurrentIndex
    # in this line arr[i]<inc  %r10>(%rax)
    cmpl (%rax) ,%r11d 
    jl .setAnswerIsWrong
    # (%rax) should put be put in dec array
    jmp .insertInDec

.loopCheck:
    lea 4(%rax),%rax # ptr++
    inc %esi 
    cmpl (size),%esi
    jb .loopStart
    jmp  .exit

.setAnswerIsWrong:
    movb $0,(bool)
    jmp .exit

.incLastSmallerThanCurrentIndex:
    cmpl (%rax),%r11d
    jl .insertInInc
    movl %esi, %r12d
    inc %r12d
    cmpl (size),%r12d
    jae .insertInInc
    # we are in the bounds of the source array 
    lea 4(%rax) ,%r10 
    movl (%r10),%r10d # getting the next element in source array arr[i+1]
    cmpl (%rax),%r10d
    jl .insertInInc
    jmp .insertInDec

.insertInDec:
    movl (%rax),%r10d
    movl %r10d , (%rcx)
    lea 4(%rcx) , %rcx
    inc %r9d
    jmp .loopCheck

.insertInInc:
    movl (%rax),%r10d
    movl %r10d, (%rbx)
    lea 4(%rbx),%rbx
    inc %r8d
    jmp .loopCheck

.bothAreEmpty:
    #  check this function again .
    movl (%rax),%r10d
    # in the next section we're gonna check if the we are in the boundaries
    movl %esi, %r12d
    inc %r12d
    cmpl (size),%r12d
    jae .insertInInc
    # we valdiated that we are in valid boundaries of the source_array
    lea 4(%rax),%r11
    movl (%r11),%r11d
    cmpl %r11d,%r10d
    jl .insertInInc
    jmp .insertInDec

.emptyIncArray:
    test %r9d,%r9d
    jz .bothAreEmpty
    # in this line inc array is empty but dec ain't
    movl (%rcx),%r10d
    cmpl (%rax),%r10d
    jl .insertInDec   
    jmp .insertInInc

.emptyDecArray:
    # inc cannot be empty
    movl (%rbx),%r10d # set the inc last val in %r10d
    cmpl (%rax),%r10d 
    jl .insertInInc 
    jmp .insertInDec

.exit:
    xor %rax,%rax # stam instruction
    