.globl my_ili_handler
.extern what_to_do, old_ili_handler

.text
.align 4, 0x90

my_ili_handler:
  ####### Some smart student's code here #######
  pushq %rdx
  pushq %rcx
  pushq %rax
  pushq %rbx
  pushq %rsp
  pushq %rsi
  pushq %rbp
  pushq %r15
  pushq %r14
  pushq %r13
  pushq %r12
  pushq %r11
  pushq %r10
  pushq %r9
  pushq %r8
  
  movq $0, %rdi
  movq $0, %rax
  movq $0, %rbx
  movq $0, %rcx

  movq 120(%rsp), %rbx
  movq (%rbx), %rbx
  cmpb $0x0F, %bl
  je .twoBytesOpcode 

  movq $1,%r15
  mov %bl, %cl
  mov %rcx, %rdi
  call what_to_do
  test %rax,%rax
  je .noChangesToBeDone    
  jmp .modifiedHandler

.twoBytesOpcode:
  movq $2,%r15
  movb %bh, %cl
  mov  %rcx, %rdi
  call what_to_do
  test %rax,%rax
  je .noChangesToBeDone



.modifiedHandler:
  addq %r15,120 (%rsp)
  movq %rax,%rdi
  popq %r8
  popq %r9
  popq %r10
  popq %r11
  popq %r12
  popq %r13
  popq %r14
  popq %r15
  popq %rbp
  popq %rsi
  popq %rsp
  popq %rbx
  popq %rax
  popq %rcx
  popq %rdx
  jmp .endOfAssmbly

.noChangesToBeDone:
  popq %r8
  popq %r9
  popq %r10
  popq %r11
  popq %r12
  popq %r13
  popq %r14
  popq %r15
  popq %rbp
  popq %rsi
  popq %rsp
  popq %rbx
  popq %rax
  popq %rcx
  popq %rdx
  jmp * old_ili_handler
.endOfAssmbly:
  iretq
