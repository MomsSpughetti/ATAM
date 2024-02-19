.global _start

.section .text
_start:
    movb $-1,(circle)
    movq $vertices,%rax
    movq (%rax),%rax
    test %rax,%rax
    jz .exit_HW1
    # at this line we have validated that there is no self loops (normalCode)
    movq $vertices,%rax 
    # each of the registers (r8-r15) has the in-degree of the vertics[i] respictevly
    # init secion r8-15 %rsi to zero 
    xor %r8,%r8 
    xor %r9,%r9
    xor %r10,%r10
    xor %r11,%r11
    xor %r12,%r12
    xor %r13,%r13
    xor %r14,%r14
    xor %r15,%r15
    xor %rsi,%rsi # this reg well save the num of the vertices(size)

.buildInDegree_HW1:
    movq (%rax),%rbx # rbx pointer to a node
    inc %rsi
    jmp .buildInDegreeForRegRbxNodeAdjancets_HW1

.endBuildIndegreeLoopcheck_HW1:
    lea 8(%rax), %rax # get the next node
    movq (%rax),%rbx 
    test %rbx,%rbx
    jnz .buildInDegree_HW1


# at this point we have built the in-degree registers
    xor %rax,%rax # saves the counter of the sort
.sort_HW1:  
    xor %rdx,%rdx # rdx gets the index of the origin if existed
    jmp .findOrigin_HW1


.endOfSort_HW1:
    inc %rax
    cmpq %rax,%rsi
    je .finalCheck_HW1
    jmp .sort_HW1



.buildInDegreeForRegRbxNodeAdjancets_HW1:
    # rbx is an  array of pointers (effective address)
    movq (%rbx),%rcx # get the current node in the adjacents array
    test %rcx ,%rcx 
    jz .endBuildIndegreeLoopcheck_HW1
    xor %rdx,%rdx #  gets the index of the node that rcx contains
    jmp .findIndexAndInc_HW1 # puts the index in a reg rdx and increase specific register

.endbuildInDegreeForRegRbxNodeAdjancetsLoopCheck_HW1:
    lea 8(%rbx),%rbx # get the next adjacent
    movq (%rbx),%rcx
    test %rcx,%rcx # testing if we have reached the end of the array.
    jnz .buildInDegreeForRegRbxNodeAdjancets_HW1
    jmp .endBuildIndegreeLoopcheck_HW1

    



.findIndexAndInc_HW1: 
    movq vertices(,%rdx,8), %rdi # rdi is a temp reg that is used to check if the it contains the value of rcx
    cmpq %rdi,%rcx
    je .incSpecificReg_HW1
    inc %rdx
    jmp .findIndexAndInc_HW1




.cyclicGraph_HW1:
    movb $1,(circle)
    jmp .exit_HW1


.incSpecificReg_HW1:
    cmpq $0,%rdx
    je .incR8_HW1
    cmpq $1,%rdx
    je .incR9_HW1
    cmpq $2,%rdx
    je .incR10_HW1
    cmpq $3,%rdx
    je .incR11_HW1
    cmpq $4,%rdx
    je .incR12_HW1
    cmpq $5,%rdx
    je .incR13_HW1
    cmpq $6,%rdx
    je .incR14_HW1
    cmpq $7,%rdx
    je .incR15_HW1


.incR8_HW1:
    inc %r8
    jmp .endbuildInDegreeForRegRbxNodeAdjancetsLoopCheck_HW1
.incR9_HW1:
    inc %r9
    jmp .endbuildInDegreeForRegRbxNodeAdjancetsLoopCheck_HW1
.incR10_HW1:
    inc %r10
    jmp .endbuildInDegreeForRegRbxNodeAdjancetsLoopCheck_HW1
.incR11_HW1:
    inc %r11
    jmp .endbuildInDegreeForRegRbxNodeAdjancetsLoopCheck_HW1
.incR12_HW1:
    inc %r12
    jmp .endbuildInDegreeForRegRbxNodeAdjancetsLoopCheck_HW1
.incR13_HW1:
    inc %r13
    jmp .endbuildInDegreeForRegRbxNodeAdjancetsLoopCheck_HW1
.incR14_HW1:
    inc %r14
    jmp .endbuildInDegreeForRegRbxNodeAdjancetsLoopCheck_HW1
.incR15_HW1:
    inc %r15
    jmp .endbuildInDegreeForRegRbxNodeAdjancetsLoopCheck_HW1



.findOrigin_HW1:
.checkR8Origin_HW1:
    test %r8,%r8 
    jnz .checkR9Origin_HW1
    movq $0 , %rdx
    cmpq $0, %rsi
    jg .removeOrigin_HW1
.checkR9Origin_HW1:
    test %r9,%r9
    jnz .checkR10Origin_HW1
    movq $1 , %rdx
    cmpq $1, %rsi
    jg .removeOrigin_HW1
.checkR10Origin_HW1:
    test %r10,%r10
    jnz .checkR11Origin_HW1
    movq $2 , %rdx
    cmpq $2, %rsi
    jg .removeOrigin_HW1
.checkR11Origin_HW1:
    test %r11,%r11
    jnz .checkR12Origin_HW1
    movq $3 , %rdx
    cmpq $3, %rsi
    jg .removeOrigin_HW1
.checkR12Origin_HW1:
    test %r12,%r12
    jnz .checkR13Origin_HW1
    movq $4 , %rdx
    cmpq $4, %rsi
    jg .removeOrigin_HW1
.checkR13Origin_HW1:
    test %r13,%r13
    jnz .checkR14Origin_HW1
    movq $5 , %rdx
    cmpq $5, %rsi
    jg .removeOrigin_HW1
.checkR14Origin_HW1:
    test %r14,%r14
    jnz .checkR15Origin_HW1
    movq $6 , %rdx
    cmpq $6, %rsi
    jg .removeOrigin_HW1
.checkR15Origin_HW1:
    test %r15,%r15
    jnz  .cyclicGraph_HW1
    movq $7 , %rdx
    cmpq $7, %rsi
    jg .removeOrigin_HW1
    # at we have reached to this line then there is no origins the grpah is cyclic
    jmp .cyclicGraph_HW1
.removeOrigin_HW1:
    # Rdx has the index of the origin
    movq vertices(,%rdx,8),%rbx # rbx has the adjacents of the the origin
    jmp .setMinusSpecficRegister_HW1
.removeOriginComplete_HW1:
    xor %rdx,%rdx 
    jmp .decAdjacentsOfOrigin_HW1


.setMinusSpecficRegister_HW1:
    cmpq $0,%rdx
    je .setR8_HW1
    cmpq $1,%rdx
    je .setR9_HW1
    cmpq $2,%rdx
    je .setR10_HW1
    cmpq $3,%rdx
    je .setR11_HW1
    cmpq $4,%rdx
    je .setR12_HW1
    cmpq $5,%rdx
    je .setR13_HW1
    cmpq $6,%rdx
    je .setR14_HW1
    cmpq $7,%rdx
    je .setR15_HW1

.setR8_HW1:
    movq $-1,%r8
    jmp .removeOriginComplete_HW1
.setR9_HW1:
    movq $-1,%r9
    jmp .removeOriginComplete_HW1
.setR10_HW1:
    movq $-1,%r10
    jmp .removeOriginComplete_HW1
.setR11_HW1:
    movq $-1,%r11
    jmp .removeOriginComplete_HW1
.setR12_HW1:
    movq $-1,%r12
    jmp .removeOriginComplete_HW1
.setR13_HW1:
    movq $-1,%r13
    jmp .removeOriginComplete_HW1
.setR14_HW1:
    movq $-1,%r14
    jmp .removeOriginComplete_HW1
.setR15_HW1:
    movq $-1,%r15
    jmp .removeOriginComplete_HW1
.decAdjacentsOfOrigin_HW1:
    # rbx has the adjacents of the the origin
    movq (%rbx),%rcx # the first adjacent
    xor %rdx,%rdx
    test %rcx ,%rcx 
    jnz .findIndexAndDec_HW1
    jmp .endOfSort_HW1
.endDecAdjacentsOfOriginLoopCheck_HW1:
    lea 8(%rbx),%rbx
    jmp .decAdjacentsOfOrigin_HW1

.findIndexAndDec_HW1:
    movq vertices(,%rdx,8), %rdi # rdi is a temp reg that is used to check if the it contains the value of rcx
    cmpq %rdi,%rcx
    je .decSpecificReg_HW1
    inc %rdx
    jmp .findIndexAndDec_HW1

.decSpecificReg_HW1:
    cmpq $0,%rdx
    je .decR8_HW1
    cmpq $1,%rdx
    je .decR9_HW1
    cmpq $2,%rdx
    je .decR10_HW1
    cmpq $3,%rdx
    je .decR11_HW1
    cmpq $4,%rdx
    je .decR12_HW1
    cmpq $5,%rdx
    je .decR13_HW1
    cmpq $6,%rdx
    je .decR14_HW1
    cmpq $7,%rdx
    je .decR15_HW1



.decR8_HW1:
    dec %r8
    jmp .endDecAdjacentsOfOriginLoopCheck_HW1
.decR9_HW1:
    dec %r9
    jmp .endDecAdjacentsOfOriginLoopCheck_HW1
.decR10_HW1:
    dec %r10
    jmp .endDecAdjacentsOfOriginLoopCheck_HW1   
.decR11_HW1:
    dec %r11
    jmp .endDecAdjacentsOfOriginLoopCheck_HW1
.decR12_HW1:
    dec %r12
    jmp .endDecAdjacentsOfOriginLoopCheck_HW1
.decR13_HW1:
    dec %r13
    jmp .endDecAdjacentsOfOriginLoopCheck_HW1
.decR14_HW1:
    dec %r14
    jmp .endDecAdjacentsOfOriginLoopCheck_HW1
.decR15_HW1:
    dec %r15
    jmp .endDecAdjacentsOfOriginLoopCheck_HW1
.finalCheck_HW1:
    cmpq $0,%r8
    jg .cyclicGraph_HW1
    cmpq $0,%r9
    jg .cyclicGraph_HW1
    cmpq $0,%r10
    jg .cyclicGraph_HW1
    cmpq $0,%r11
    jg .cyclicGraph_HW1
    cmpq $0,%r12
    jg .cyclicGraph_HW1
    cmpq $0,%r13
    jg .cyclicGraph_HW1
    cmpq $0,%r14
    jg .cyclicGraph_HW1
    cmpq $0,%r15
    jg .cyclicGraph_HW1
.exit_HW1:
    xor %rax,%rax

