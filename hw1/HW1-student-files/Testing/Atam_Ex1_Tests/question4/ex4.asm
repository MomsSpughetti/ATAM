.global _start

.section .text
_start:
#your code here

#plan
# first loop
# find how many bad-elements (smaller than the previous) there are
# if < 1
# return 0
# if 1
#   check if it is almost oola
#   if so => return 1
#   else return 0
# if 0
# search for duplicates
# if found return 2
# else return 3


    movq head(%rip), %rdi       # rdi is pointer to the current node
    movq $0, %rcx               # %rcx is used to store pointer of previous node
    movq $0, %rdx               # %rdx will point to the last bad-element found - used later, when checking if result = 1
    movl $0, %esi               # %esi (4-byte == int) is bad-elements counter
    movq $0, %r9                # %r9 will eventually point to the prev of last bad-elem
    movq $0, %r8                # used to handle unique cases like: ([7,10,8,9]), here %r8 will eventually point to element 7
    movl $0, %r11d              # %r11d (int size) is used to count duplictaes - used later!
    movb $0, result             # store 0 in result (if result is not changed then 0 is the right value)
    testq %rdi, %rdi
    je .result_is_3_HW1

    movq %rdi, %rcx             # update pointer-to-previous-value variable (%rcx)
    movq 8(%rdi), %rdi          # access memory to store next-node's address (8-byte) in %rdi
    testq %rdi, %rdi            # null?
    je .result_is_3_HW1          # only one element is there!

.firstLoop_HW1:
    movq (%rdi), %r10            # %r10 is temp (mem to mem is not possible)
    cmpq %r10, (%rcx)            # (%rcx) prev [>, <, =] (%rdi) curr.data
    jne .not_duplicate_HW1
    inc %r11d                   # duplicates_counter++ because curr.data == prev.data
    jmp .not_bad_element__HW1    # if duplicate, then bad-counter should not increase
.not_duplicate_HW1:
    # next line jl is used instead of jle because duplicate element is not a bad one here!
    jl .not_bad_element__HW1     # if prev (%rcx) > (%rdi) curr.data then a bad-element found
    inc %esi                    # counter++
    movq %rdi, %rdx             # rdx = pointer to bad-element
    movq %rcx, %r9              # set r9 = pointer of prev of the last bad element
.not_bad_element__HW1:
    movq %rdi, %rcx             # update pointer-to-previous-value variable (%rcx)
    movq 8(%rdi), %rdi          # access memory to store next-node's address (8-byte) in %rdi
    testq %rdi, %rdi            # null?
    jne .firstLoop_HW1

    # finished loop 1

    cmpl $2, %esi
    jge .result_found_HW1           # list is `other` (result = 0)

    cmpl $0, %esi               # list is oola?
    je .oola_or_not_yoredet_HW1     

    # got here? then counter = 1, so either result = 1 or result = 0
    # now check if the single bad-element e is removed, will it be oola?
    # divide into situations:
    # (1) e.next = null
    # (2) e.next > e.prev || e.next <= e.prev
    # no need to iterate more, we can use %rdx to access bad-element

    movq 8(%rdx), %rcx          # rcx is used to point to the next element of the bad-element
    testq %rcx, %rcx
    je .result_is_1_HW1          # if next is null then the result is 1 when no dups(why?)
    movq (%rcx), %r10           # %r10 is helper reg, stores bad.next.data
    cmpq %r10, (%r9)            # bad.next.data >= bad.prev.data (increasing)
    jle .result_is_1_HW1          # oola! => result = 1
    movq head(%rip), %rdi           # reset pointer to point to the first element
    jmp .find_prev_of_prev_of_the_bad_element_HW1   #, without this, [5, 2, 3] will be checked, but it is not increasing (1 removed not 5)



.oola_or_not_yoredet_HW1:    # got here? then it's either result = 3 or result = 2
    cmpl $0, %r11d
    je .result_is_3_HW1          # if no duplicates then it is oola!
    movb $2, result             # else, it is not yoredet => result = 2
    jmp .result_found_HW1

.result_is_3_HW1:
    movb $3, result
    jmp .result_found_HW1

.find_prev_of_prev_of_the_bad_element_HW1:
    cmpq %rdi, %r9              # if the current node is the prev_of_bad node (%r9) then prev_of_prev is already in %r8 => stop loop
    je .handle_unique_case_HW1
    movq %rdi, %r8
    movq 8(%rdi), %rdi
    jmp .find_prev_of_prev_of_the_bad_element_HW1


.handle_unique_case_HW1:        # cases like: [5, 1, 2 ,3] or [7, 10, 8, 9]
    testq %r8, %r8              # in case prev_of_bad os first node => %r8 is null
    je .result_is_1_HW1         # 2nd element is the last bad element hence 2nd < 3rd => when removing first element we get increasing array
    movq (%r8), %r11            # %r11 now has value of prev_of_prev_of_bad
    cmpq %r11, (%rdx)           # check if the array is increasing when removing prev_of_bad
    jl .result_found_HW1

.result_is_1_HW1:
    movb $1, result

.result_found_HW1:              # if got here then result is found

/*

bug:
        [5, 1, 2, 3] => result = 1 but returns result = 0
question:
        [4, 4, 4, 1] => result = ? [0/1]
*/