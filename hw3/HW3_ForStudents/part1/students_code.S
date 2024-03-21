.global get_element_from_matrix, inner_prod, matrix_multiplication

get_element_from_matrix:
	# system V conventions:
	# save the callee-saved: rbx, rsp, rbp, r12, r13, r14, r15
	# caller-saved: rax, rdi, rsi, rdx, rcx, r8, r9, r10, r11 (params += rax, r10, r11)
	# params: rdi, rsi, rdx, rcx, r8, r9

	# plan:
	# params: (mat addr, n, row, col):
	#	n: number of columns, why is it needed here?
	# return value: mat_a[row][col]

	# 1: calc the addr of the line <row>
	# in that row go to <col> element
	# now we need n! => to know how long is a step (line) when trying to get to the <row> line
	# each element is 4-byte long
	# little indian does not have effects on arrays!

	# are next 3 lines needed?
	xor %rax, %rax
	# movl %esi, %esi
	# movl %edx, %edx
	# movl %ecx, %ecx

	imul %rsi, %rdx		# rdx = n * row
	imul $4, %rdx		# rdx = n * row * |int|
	imul $4, %rcx
	addq %rcx, %rdx		# rdx = offset to element
	addq %rdx, %rdi		# rdi = element addr
	movl (%rdi), %eax	# return element val (int)
	ret

inner_prod:
	# params:
	#	%rdi -> mat_a
	#	%rsi -> mat_B
	#	%rdx -> row_a
	#	%rcx -> col_b
	#	%r8 -> max_col_a
	#	%r9 -> max_col_b
	# goal -> row_a * col_B

	# plan:

	# save callee-saved
	# pushq %rbp
	# movq %rsp, %rbp
	cmpq $0, %r8
	jbe .done
	pushq %r12		# used as sum variable
	xor %r12,%r12

	# allocate space for 2 int numbers in stack
	# subq $64, %rsp
	xor %r11, %r11		# represents current col (for a), and current row (for b)


	.loop_on_all_related_elements:
	# r10 = 0
	xor %r10, %r10

	# save caller-saved regs
	pushq %rdi
	pushq %rsi
	pushq %rdx
	pushq %rcx
	# what about r8, r9, r10, r11? called does not change them

	# update paramas to pass

	# rdi is ready
	movq %r8, %rsi		# rsi -> max_col_a
	# rdx is ready
	movq %r11, %rcx		# rcx = current column to get the element from (regarding row_a)

	# call get_element_from_matrix on mat_a
	call get_element_from_matrix

	# retreive regs
	popq %rcx
	popq %rdx
	popq %rsi
	popq %rdi

	# add returned value to r10
	addq %rax, %r10
	
	# save caller-saved regs
	pushq %rdi
	pushq %rsi
	pushq %rdx
	pushq %rcx

	# update paramas to pass

	movq %rsi, %rdi		# rdi -> max_b
	movq %r9, %rsi		# rsi -> max_col_b
	movq %r11, %rdx		# rdx = current row to get the element from (regarding col_b)
	# rcx is ready

	# call one more time on mat_b
	call get_element_from_matrix

	# retreive regs
	popq %rcx
	popq %rdx
	popq %rsi
	popq %rdi

	# multiply returned val by val in r10
	imul %rax, %r10

	# add value in r10 to r12
	addq %r10, %r12

	# repeat max_col_a times
	inc %r11
	cmpq %r8, %r11	
	jb .loop_on_all_related_elements

	# return value in r12
	.done:
	movq %r12, %rax
	# leave # movq %rbp, %rsp popq %rbp
	popq %r12
	ret

matrix_multiplication:
	# params:
	#	%rdi -> res
	#	%rsi -> mat_a
	#	%rdx -> mat_b
	#	%rcx -> m
	#	%r8 -> n
	#	%r9 -> p
	#	(%rsp) -> q

	# callee-saved
	# none

	# initialize
	xor %r10, %r10	# will have q value
	# plan: use rcx/r9 as the curr row/col

	# mov q to a reg
	movq 8(%rsp), %r10


	.loop1_rows:
	movq %r10, %r9	# r9 will be like j in nested-loops ... starts each time with number of cols (q)
	dec %rcx		# zero-based counting

	.loop2_cols:
	dec %r9		# zero-based counting

	# step 1 - get res[%rcx][%r9] value

	# caller-saved: rax, rdi, rsi, rdx, rcx, r8, r9, r10, r11
	pushq %rdi
	pushq %rsi
	pushq %rdx
	pushq %rcx
	pushq %r8
	pushq %r9
	pushq %r10
	pushq %r11
	
	# prepare params:
	#	%rdi -> mat_a
	#	%rsi -> mat_b
	#	%rdx -> row_a
	#	%rcx -> col_b
	#	%r8  -> max_col_a
	#	%r9  -> max_col_B

	movq %rsi, %rdi
	movq %rdx, %rsi
	movq %rcx, %rdx
	movq %r9, %rcx
	# r8 has correct value
	movq %r10, %r9

	# call:
	call inner_prod

	# restore regs:
	popq %r11
	popq %r10
	popq %r9
	popq %r8
	popq %rcx
	popq %rdx
	popq %rsi
	popq %rdi

	# save it in res

	# caller-saved
	pushq %rdi
	pushq %rsi
	pushq %rdx
	pushq %rcx
	pushq %r8
	pushq %r9
	pushq %r10
	pushq %r11

	# params:
	# %rdi -> res addr
	# %rsi -> number of columns (q = %r10)
	# %rdx -> row
	# %rcx -> col
	# %r8  -> val

	# rdi has correct value
	movq %r10, %rsi
	movq %rcx, %rdx
	movq %r9, %rcx
	movq %rax, %r8	# multiplication result - returned value of previous call

	# call:
	call set_element_in_matrix

	# restore regs:
	popq %r11
	popq %r10
	popq %r9
	popq %r8
	popq %rcx
	popq %rdx
	popq %rsi
	popq %rdi


	cmpq $0, %r9
	ja .loop2_cols


	cmpq $0, %rcx
	ja .loop1_rows

	ret

