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

.loopStart_HW1:
    test %r8d,%r8d
    jz .emptyIncArray_HW1
    test %r9d,%r9d
    jz .emptyDecArray_HW1
    # in this line we have validated that the dec&inc array are not empty (Normal code)
    lea -4(%rbx),%r10 # have the adress of the last element of inc array
    lea -4(%rcx),%r11  # have the adress of the last element of dec array
    movl (%r10),%r10d # inc
    movl (%r11),%r11d # dec
    cmpl (%rax), %r10d # inc < (rax)
    jl  .incLastSmallerThanCurrentIndex_HW1
    # in this line arr[i]<inc  %r10>(%rax)
    cmpl (%rax) ,%r11d 
    jle .setAnswerIsWrong_HW1
    # (%rax) should put be put in dec array
    jmp .insertInDec_HW1

.loopCheck_HW1:
    lea 4(%rax),%rax # ptr++
    inc %esi 
    cmpl (size),%esi
    jb .loopStart_HW1
    jmp  .exit

.setAnswerIsWrong_HW1:
    movb $0,(bool)
    jmp .exit

.incLastSmallerThanCurrentIndex_HW1:
    cmpl (%rax),%r11d
    jl .insertInInc_HW1
    movl %esi, %r12d
    inc %r12d
    cmpl (size),%r12d
    jae .insertInInc_HW1
    # we are in the bounds of the source array 
    lea 4(%rax) ,%r10 
    movl (%r10),%r10d # getting the next element in source array arr[i+1]
    cmpl (%rax),%r10d
    jg .insertInInc_HW1
    jmp .insertInDec_HW1

.insertInDec_HW1:
    movl (%rax),%r10d
    movl %r10d , (%rcx)
    lea 4(%rcx) , %rcx
    inc %r9d
    jmp .loopCheck_HW1

.insertInInc_HW1:
    movl (%rax),%r10d
    movl %r10d, (%rbx)
    lea 4(%rbx),%rbx
    inc %r8d
    jmp .loopCheck_HW1

.bothAreEmpty_HW1:
    #  check this function again .
    movl (%rax),%r10d
    # in the next section we're gonna check if the we are in the boundaries
    movl %esi, %r12d
    inc %r12d
    cmpl (size),%r12d
    jae .insertInInc_HW1
    # we valdiated that we are in valid boundaries of the source_array
    lea 4(%rax),%r11
    movl (%r11),%r11d
    cmpl %r11d,%r10d
    jl .insertInInc_HW1
    jmp .insertInDec_HW1

.emptyIncArray_HW1:
    test %r9d,%r9d
    jz .bothAreEmpty_HW1
    # in this line inc array is empty but dec ain't
    lea -4(%rcx),%r11
    movl (%r11),%r11d # r11d gets the last value of the dec  value
    cmpl (%rax),%r11d 
    jl .insertInInc_HW1 # dec <arr[i]
    # in this line dec> arr[i] && arr[i]>inc boefen rek (we can put it in the dec array)
    # we have to the order of the next element
    movl %esi, %r12d
    inc %r12d
    cmpl (size),%r12d
    jae .insertInInc_HW1 # doesn't matter where to put 
    # we are in a valid boundaries
    movl (%rax),%r10d
    # we valdiated that we are in valid boundaries of the source_array
    lea 4(%rax),%r11
    movl (%r11),%r11d
    cmpl %r11d,%r10d
    jl .insertInInc_HW1
    jmp .insertInDec_HW1

.emptyDecArray_HW1:
    # inc cannot be empty
    lea -4(%rbx),%r10
    movl (%r10),%r10d # last inc 
    cmpl (%rax),%r10d
    jg .insertInDec_HW1
    # inc < arr[i] check the next element
    lea 4(%rax),%r11 # get the next element in the source array
    movl (%r11),%r11d
    cmpl (%rax),%r11d
    jg .insertInInc_HW1
    jmp .insertInDec_HW1

.exit:
    xor %rax,%rax # stam instruction
    
