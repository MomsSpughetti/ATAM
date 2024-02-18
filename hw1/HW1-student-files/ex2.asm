.global _start

.section .text
_start:
    movq $vertices,%rax 
    movb $0,(circle)
    movq (%rax),%rbx
    test %rbx,%rbx 
    jz .exit # DAG beofen rek

.whileSelfLoopCheck:
    movq (%rax),%rbx # rbx gets the node which is an array of nodes
    jmp .checkSelfLoop

.endWhileCheck:
    lea 8(%rax),%rax
    movq (%rax),%rdx
    test %rdx,%rdx 
    jz .noSelfLoops
    jmp .whileSelfLoopCheck


.checkSelfLoop:
    # rbx has the node
    movq (%rbx),%rcx
    test %rcx,%rcx
    jz .endWhileCheck
    cmpq (%rax),%rcx
    jz .cyclicGraph
    lea 8(%rbx),%rbx
    jmp .checkSelfLoop
    
.noSelfLoops:
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
    lea 8(%rax),%rax
    movq (%rax),%rbx 
    test %rbx,%rbx
    jnz .buildInDegree


# at this point we have built the in-degree registers

.sort:  
    jmp .findOrigin # put the origin in rax



.buildInDegreeForRegRbxNodeAdjancets:
    # rbx is an  array of pointers (effective address)
    movq (%rbx),%rcx
    xor %rdx,%rdx #  gets the index of the node that rcx contains
    jmp .findIndex # puts the index in a reg rdx 

.endbuildInDegreeForRegRbxNodeAdjancetsLoopCheck:
    lea 8(%rbx),%rbx # get the next adjacent
    movq (%rbx),%rcx
    test %rcx,%rcx
    jnz .buildInDegree
    jmp endBuildIndegreeLoopcheck

    



.findIndex: 
    movq vertices(,%rdx,8), %rdi # rdi is a temp reg that is used to check if the it contains the value of rcx
    cmpq %rdi,%rcx
    je .incSpecificReg
    inc %rdx
    jmp .findIndex




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





.decSpecificReg:




.finalCheck:
    test %r8 ,%r8
    jnz .cyclicGraph
    test %r9,%r9
    jnz .cyclicGraph
    test %r10,%r10
    jnz .cyclicGraph
    test %r11,%r11
    jnz .cyclicGraph
    test %r12,%r12
    jnz .cyclicGraph
    test %r13,%r13
    jnz .cyclicGraph
    test %r14,%r14
    jnz .cyclicGraph
    test %r15,%r15
    jnz .cyclicGraph
.exit:
    xor %rax,%rax

