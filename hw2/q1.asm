.global _start, sod
.section .text
_start:
  leaq A, %rdi
  call sod
  movq %rax, buf    # buff = mul of all tree vals
  leaq buf, %rsi    # %rsi = buff address (what for?)
  movl $1, %eax
  movl $1, %edi
  movl $1, %edx
  syscall           # call sys_write (write buff value to stdout (screen))
  movq $60, %rax    
  movq $0, %edi
  syscall           # call sys_exit
sod: 
  pushq %rbp
  movq %rsp, %rbp
  subq $32, %rsp            # allocate space of 4 quads (but 24 is enough! for alignment purposes ...)
  movq %rdi, -24(%rbp)      # quads[2] = %rdi (address of current node)
  cmpq $0, -24(%rbp)
  jne .L2
  movl $1, %eax
  jmp .L3                   # return if quads[2] == null
.L2:
  movq -24(%rbp), %rax      # %rax = quads[2]
  movq 4(%rax), %rax        # %rax = (*quads[2]).first_son
  movq %rax, %rdi           # %rdi = (*quads[2]).first_son
  call sod                  # call sod for first son
  movl %eax, -4(%rbp)       # quads[0] = ret val of sod on first son
  movq -24(%rbp), %rax      # %rax = "curr node" address
  movq 12(%rax), %rax       # %rax = (*quads[2]).second_son
  movq %rax, %rdi           # %rdi = (*quads[2]).second_son
  call sod                  # call sod for second son
  movl %eax, -8(%rbp)       # quads[0.5] = ret val of sod on second son
  movl -4(%rbp), %eax       # %eax = quads[0]
  imull -8(%rbp), %eax      # %eax = quads[0] (32 bits) * quads[0.5] (32 bits)
  movl %eax, -12(%rbp)      # quads[1] = %eax
  movq -24(%rbp), %rax      # %rax = quads[2]
  movl (%rax), %eax         # %eax = curr_node.val ((quads[2]*).val)
  imull -12(%rbp), %eax     # %eax = curr_node.val * quads[1] (previous mul result)
  movl %eax, %edx           # %edx = %eax (previous mul result)
  movq -24(%rbp), %rax      # %rax = current node address (to ...)
  movl %edx, (%rax)         # curr_node.val = mul of subtree vals (including current node val (root of subtree)) what for??
  movq -24(%rbp), %rax      # %rax = curr node address
  movl (%rax), %eax         # returned value is the mul of subtree ... but why all three previous lines, is not movl %edx, %eax enough?
.L3:
  leave
   ret



.section .data
buf:		.______ 0
A:		.int 5
		.quad B
		.quad C
B:		.int 5
		.quad D
		.quad E
C:		.int 5
		.quad 0
		.quad G
D:		.int 3
		.quad 0
		.quad 0
E:		.int 2
		.quad F
		.quad 0
F:		.int 1
		.quad 0
		.quad 0
G:		.int 6
		.quad 0
		.quad 0

