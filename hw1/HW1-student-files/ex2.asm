.global _start

.section .text
_start:
    movb $-1,(circle)
    movq $vertices,%rax
    movq (%rax),%rax
    test %rax,%rax
    jz .exit
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

.buildInDegree:
    movq (%rax),%rbx # rbx pointer to a node
    inc %rsi
    jmp .buildInDegreeForRegRbxNodeAdjancets

.endBuildIndegreeLoopcheck:
    lea 8(%rax), %rax # get the next node
    movq (%rax),%rbx 
    test %rbx,%rbx
    jnz .buildInDegree


# at this point we have built the in-degree registers
    xor %rax,%rax # saves the counter of the sort
.sort:  
    xor %rdx,%rdx # rdx gets the index of the origin if existed
    jmp .findOrigin 


.endOfSort:
    inc %rax
    cmpq %rax,%rsi
    je .finalCheck
    jmp .sort


.buildInDegreeForRegRbxNodeAdjancets:
    # rbx is an  array of pointers (effective address)
    movq (%rbx),%rcx # get the current node in the adjacents array
    test %rcx ,%rcx 
    jz .endBuildIndegreeLoopcheck
    xor %rdx,%rdx #  gets the index of the node that rcx contains
    jmp .findIndexAndInc # puts the index in a reg rdx and increase specific register

.endbuildInDegreeForRegRbxNodeAdjancetsLoopCheck:
    lea 8(%rbx),%rbx # get the next adjacent
    movq (%rbx),%rcx
    test %rcx,%rcx # testing if we have reached the end of the array.
    jnz .buildInDegreeForRegRbxNodeAdjancets
    jmp .endBuildIndegreeLoopcheck

    



.findIndexAndInc: 
    movq vertices(,%rdx,8), %rdi # rdi is a temp reg that is used to check if the it contains the value of rcx
    cmpq %rdi,%rcx
    je .incSpecificReg
    inc %rdx
    jmp .findIndexAndInc




.cyclicGraph:
    movb $1,(circle)
    jmp .exit


.incSpecificReg:
    cmpq $0,%rdx
    je .incR8
    cmpq $1,%rdx
    je .incR9
    cmpq $2,%rdx
    je .incR10
    cmpq $3,%rdx
    je .incR11
    cmpq $4,%rdx
    je .incR12
    cmpq $5,%rdx
    je .incR13
    cmpq $6,%rdx
    je .incR14
    cmpq $7,%rdx
    je .incR15


.incR8:
    inc %r8
    jmp .endbuildInDegreeForRegRbxNodeAdjancetsLoopCheck
.incR9:
    inc %r9
    jmp .endbuildInDegreeForRegRbxNodeAdjancetsLoopCheck
.incR10:
    inc %r10
    jmp .endbuildInDegreeForRegRbxNodeAdjancetsLoopCheck
.incR11:
    inc %r11
    jmp .endbuildInDegreeForRegRbxNodeAdjancetsLoopCheck
.incR12:
    inc %r12
    jmp .endbuildInDegreeForRegRbxNodeAdjancetsLoopCheck
.incR13:
    inc %r13
    jmp .endbuildInDegreeForRegRbxNodeAdjancetsLoopCheck
.incR14:
    inc %r14
    jmp .endbuildInDegreeForRegRbxNodeAdjancetsLoopCheck
.incR15:
    inc %r15
    jmp .endbuildInDegreeForRegRbxNodeAdjancetsLoopCheck



.findOrigin:
.checkR8Origin:
    test %r8,%r8 
    jnz .checkR9Origin
    movq $0 , %rdx
    cmpq $0, %rsi
    jg .removeOrigin
.checkR9Origin:
    test %r9,%r9
    jnz .checkR10Origin
    movq $1 , %rdx
    cmpq $1, %rsi
    jg .removeOrigin
.checkR10Origin:
    test %r10,%r10
    jnz .checkR11Origin
    movq $2 , %rdx
    cmpq $2, %rsi
    jg .removeOrigin
.checkR11Origin:
    test %r11,%r11
    jnz .checkR12Origin
    movq $3 , %rdx
    cmpq $3, %rsi
    jg .removeOrigin
.checkR12Origin:
    test %r8,%r8
    jnz .checkR13Origin
    movq $4 , %rdx
    cmpq $4, %rsi
    jg .removeOrigin
.checkR13Origin:
    test %r13,%r13
    jnz .checkR14Origin
    movq $5 , %rdx
    cmpq $5, %rsi
    jg .removeOrigin
.checkR14Origin:
    test %r14,%r14
    jnz .checkR15Origin
    movq $6 , %rdx
    cmpq $6, %rsi
    jg .removeOrigin
.checkR15Origin:
    test %r15,%r15
    jnz  .cyclicGraph
    movq $7 , %rdx
    cmpq $7, %rsi
    jg .removeOrigin
    # at we have reached to this line then there is no origins the grpah is cyclic
    jmp .cyclicGraph
.removeOrigin:
    # Rdx has the index of the origin
    movq vertices(,%rdx,8),%rbx # rbx has the adjacents of the the origin
    jmp .setMinusSpecficRegister
.removeOriginComplete:
    xor %rdx,%rdx 
    jmp .decAdjacentsOfOrigin


.setMinusSpecficRegister:
    cmpq $0,%rdx
    je .setR8
    cmpq $1,%rdx
    je .setR9
    cmpq $2,%rdx
    je .setR10
    cmpq $3,%rdx
    je .setR11
    cmpq $4,%rdx
    je .setR12
    cmpq $5,%rdx
    je .setR13
    cmpq $6,%rdx
    je .setR14
    cmpq $7,%rdx
    je .setR15

.setR8:
    movq $-1,%r8
    jmp .removeOriginComplete
.setR9:
    movq $-1,%r9
    jmp .removeOriginComplete
.setR10:
    movq $-1,%r10
    jmp .removeOriginComplete
.setR11:
    movq $-1,%r11
    jmp .removeOriginComplete
.setR12:
    movq $-1,%r12
    jmp .removeOriginComplete
.setR13:
    movq $-1,%r13
    jmp .removeOriginComplete
.setR14:
    movq $-1,%r14
    jmp .removeOriginComplete
.setR15:
    movq $-1,%r15
    jmp .removeOriginComplete
.decAdjacentsOfOrigin:
    # rbx has the adjacents of the the origin
    movq (%rbx),%rcx # the first adjacent
    xor %rdx,%rdx
    test %rcx ,%rcx 
    jnz .findIndexAndDec
    jmp .endOfSort
.endDecAdjacentsOfOriginLoopCheck:
    lea 8(%rbx),%rbx
    jmp .decAdjacentsOfOrigin

.findIndexAndDec:
    movq vertices(,%rdx,8), %rdi # rdi is a temp reg that is used to check if the it contains the value of rcx
    cmpq %rdi,%rcx
    je .decSpecificReg
    inc %rdx
    jmp .findIndexAndDec

.decSpecificReg:
    cmpq $0,%rdx
    je .decR8
    cmpq $1,%rdx
    je .decR9
    cmpq $2,%rdx
    je .decR10
    cmpq $3,%rdx
    je .decR11
    cmpq $4,%rdx
    je .decR12
    cmpq $5,%rdx
    je .decR13
    cmpq $6,%rdx
    je .decR14
    cmpq $7,%rdx
    je .decR15



.decR8:
    dec %r8
    jmp .endDecAdjacentsOfOriginLoopCheck
.decR9:
    dec %r9
    jmp .endDecAdjacentsOfOriginLoopCheck
.decR10:
    dec %r10
    jmp .endDecAdjacentsOfOriginLoopCheck   
.decR11:
    dec %r11
    jmp .endDecAdjacentsOfOriginLoopCheck
.decR12:
    dec %r12
    jmp .endDecAdjacentsOfOriginLoopCheck
.decR13:
    dec %r13
    jmp .endDecAdjacentsOfOriginLoopCheck
.decR14:
    dec %r14
    jmp .endDecAdjacentsOfOriginLoopCheck
.decR15:
    dec %r15
    jmp .endDecAdjacentsOfOriginLoopCheck
.finalCheck:
    cmpq $0,%r8
    jg .cyclicGraph
    cmpq $0,%r9
    jg .cyclicGraph
    cmpq $0,%r10
    jg .cyclicGraph
    cmpq $0,%r11
    jg .cyclicGraph
    cmpq $0,%r12
    jg .cyclicGraph
    cmpq $0,%r13
    jg .cyclicGraph
    cmpq $0,%r14
    jg .cyclicGraph
    cmpq $0,%r15
    jg .cyclicGraph
.exit:
    xor %rax,%rax

