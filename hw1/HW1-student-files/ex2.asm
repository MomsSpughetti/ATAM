.global _start

.section .text
_start:
    movq $vertices,%rax 
    movb $0,(circle)

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
    






.cyclicGraph:
    movb $1,(circle)
    jmp .exit



.exit:
    xor %rax,%rax

