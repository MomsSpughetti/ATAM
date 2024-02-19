.global _start

.section .text
_start:
#your code here

# legal forms are:
# $129
# $0x12F
# $0127
# $0b111
# assumptions:
# if there is a constant then it is the first op
# after the form's "magic header" there is at most 3 letters or chars or whatever
# form's "magic header" are always Small
# In hexa, the letters A-F will always be capital
# after the legal op1, comes ',', and not space
# 

# Input:
# labelse: 
#   command (.asciz): will point to the command of form: <instruction> op1, op2 (or maybe + ', op3')
#   legal (.byte - you should change), 
#   integer (.int - you should update if legal is updated to value 1)

# plan:
# iterate over the string (remember: String is considered an array of char, so do not bother with little indian stuff)
# search for the fist $ apperance
# if not found then legal = 0
# idea: if a char ',' is found before a '$' is found, then this indicates that there is no constant in the op1 hence legal = 0
# if a '$' is found then switch('$'.next):
# case 0:
#   switch ('0'.next):
#       case 0(null):
#           goto zero_constant_in_dicemal_HW1
#       case x (small):
#           check if the next for is of this form NNN, wher N is {0-9} U {A, B, C, D, E, F}
#           should make a label called check_NNNC_form_hex_HW1
#       case 'b':
#           goto check_NNNC_form_binary_HW1
#       case else:
#           goto check_NNNC_form_octal_HW1
# case '1'-'9':
#   goto check_NNC_form_decimal_HW1
# case else:
#           goto not_legal_HW1


    movq $command, %rdi             # Load the address of the command string
    movb $0, %r8b                   # Use %r8b as a $_found flag - used to enhance performance
    movq $0, %rcx                   # Use %ecx as index of current char
    movq $0, %rdx                   # Use %edx to calculate the number and save it eventually in integer label
    movq $0, %rsi                   # use esi to calculate the number
    movq $0, %rax
    movq $0, %r9                    # Used to store the number chars
                                    # e.g., 0x1F:
                                    # the ls-byte store 15
                                    # the 2nd ls-byte will store 1
                                    # the 3rd ls-byte will store 0
                                    # plan:
                                    #
                                    # x = %r9 ls-byte
                                    # shift left r11 <%r10>*<0> times => r11 = 2^<%r10>
                                    # %edx += x
                                    #
                                    # x = %r9 2nd ls-byte
                                    # shift left r11 <%r10>*<1> times => r11 = 2^<%r10>
                                    # %edx += x
                                    #
                                    # x = %r9 3rd ls-byte
                                    # shift left r11 <%r10>*<%r8b> times => r11 = 2^<%r10>
                                    # %edx += x
                                    
                                    #
    movq $0, %r10                   # %r10 will contain the basis at some point
    
    jmp .search_string_HW1               # Jump to start searching the string

.search_string_HW1:
    xorq %rcx, %rcx                 # Initialize counter to 0

.loop_HW1:
    movb (%rdi, %rcx), %al          # Load the next character from the string into eax (1 byte => al)
    testb %al, %al                   # Check for null terminator
    je .no_constant_in_op1_HW1                    # If null terminator, end loop
    cmpb $',', %al                  # Check for comma
    je .comma_found_HW1              # If comma found, set found_comma flag
    cmpb $'$', %al                  # Check for dollar sign
    je .check_magic_header_HW1      # $ is found => check '$'.next
    inc %ecx                        # index++ => prepare to check next char
    jmp .loop_HW1


.check_magic_header_HW1:
    inc %ecx                        # index++ => prepare to get '$'.next
    movb (%rdi, %rcx), %al          # Load the '$'.next character into %rax
    testb %al, %al                  # check if '$'.next == null
    je .no_constant_in_op1_HW1
    cmpb $'0', %al
    je .check_zero_next_HW1
    cmpb $'1', %al
    jl .no_constant_in_op1_HW1
    cmpb $'9', %al
    jg .no_constant_in_op1_HW1
    jmp .check_NNC_form_decimal_HW1 #got here? then we know $[1-9] is in op1 => check if legal decimal

.check_zero_next_HW1:
    inc %ecx                        # index++ => prepare to get next '0'.next
    movb (%rdi, %rcx), %al          # Load the '0'.next character into %rax
    testb %al, %al                  # check if '0'.next == null
    je .no_constant_in_op1_HW1
    cmp $',', %al
    je .zero_decimal_found_HW1
    cmpb $'x', %al
    je .check_NNNC_form_hex_HW1     # seems hex => check if legal hex
    cmpb $'b', %al
    je .check_NNNC_form_binary_HW1   # seems binary => check if legal binary
    jmp .check_NNNC_form_octal_HW1  # else, since we have $0 till now, check if it is octal
    

.found_comma_before_dollar_HW1:
    movb $0, legal
    jmp .end


# ----------------- Hex check
.check_NNNC_form_hex_HW1:
    xorb %r8b, %r8b                 # %r8b = 0 => prepare for using in next loop
    addq %rcx, %rdi                 # now %rdi points to 'x'
    movb $4, %r10b                  # now %r10 has the power that: 2^power = basis
    xorq %rax, %rax                 # clear rax for next use

.check_hex_and_store_loop_HW1:
    # here we use %r8b to know how far are we from 0x, since it is no longer used


    shlq $8, %r9                    # allocate ls-byte
    cmp $0, %r8b
    je .resume_loop_HW1
    addq %rax, %r9                   # %rax is all zeros but the ls-byte


.resume_loop_HW1:
    inc %r8b                        # %r8b ++ see previous notes 
    movb (%rdi, %r8), %al          # load the char in index number ($r8b - 1) of array {...}, when '0x{...},'
    testb %al, %al                  # check if current char is null-terminator
    je .no_constant_in_op1_HW1      # since comma is still not found
    cmpb $',', %al
    je .comma_found_HW1
    
    cmpb $4, %r8b
    je .no_constant_in_op1_HW1      # comma not found yet => constant length is more than 3 chars => illegal

    cmpb $'F', %al
    jg .no_constant_in_op1_HW1      # because before finding a comma, we found illegal char in hex constant
    cmp $'A', %al
    jl .hex_check_is_char_in_al_0_to_9_HW1       # call label that checks 1 - 9 (hint '0' = 45)
    #got here? then it must be in {A, .., F}
    subb $55, %al                   # explaination: A to F are sequential is ascii, A is 10 in hex, 'A' is $65 in hex => 'A' - 65 + 10 = 10
    jmp .check_hex_and_store_loop_HW1


.hex_check_is_char_in_al_0_to_9_HW1:
    cmp $'9', %al
    jg .no_constant_in_op1_HW1      # illegal since not in {A, B, C, D, E, F, 0, 1, ..., 9}
    cmp $'0', %al
    jl .no_constant_in_op1_HW1      # illegal since not in {A, B, C, D, E, F, 0, 1, ..., 9}
    subb $48, %al                   # char is in {0, 1, .., 9} => convert it to its decimal and store in %al
    jmp .check_hex_and_store_loop_HW1


# ----------------- Octal check
.check_NNNC_form_octal_HW1:
    xorb %r8b, %r8b                 # %r8b = 0 => prepare for using in next loop
    lea -1(%rdi, %rcx), %rdi                 # now %rdi points to '0' in '$0'
    movb $3, %r10b                  # now %r10 has the power that: 2^power = basis
    xorq %rax, %rax                 # clear rax for next use

.check_octal_and_store_loop_HW1:
    # '$0'.next character into %rax is loaded in %al
    # here we use %r8b to know how far are we from $0, since it is no longer used


    shlq $8, %r9                    # allocate ls-byte
    cmp $0, %r8b
    je .resume_loop_octal_HW1
    addq %rax, %r9                   # %rax is all zeros but the ls-byte


.resume_loop_octal_HW1:
    inc %r8b                        # %r8b ++ see previous notes 
    movb (%rdi, %r8), %al          # load the char in index number ($r8b - 1) of array {...}, when '$0{...},'
    testb %al, %al                  # check if current char is null-terminator
    je .no_constant_in_op1_HW1      # since comma is still not found
    cmpb $',', %al
    je .comma_found_HW1

    cmpb $4, %r8b
    je .no_constant_in_op1_HW1      # comma not found yet => constant length is more than 3 chars => illegal

    # check if curr char is in {0, 1, .., 7}
    cmp $'7', %al
    jg .no_constant_in_op1_HW1      # illegal since not in {0, 1, ..., 7}
    cmp $'0', %al
    jl .no_constant_in_op1_HW1      # illegal since not in {0, 1, ..., 7}
    subb $48, %al                   # char is in {0, 1, .., 7} => convert it to its decimal and store in %al
    jmp .check_octal_and_store_loop_HW1


# ----------------- decimal check
.check_NNC_form_decimal_HW1:

    xorb %r8b, %r8b                 # %r8b = 0 => prepare for using in next loop
    lea -1(%rdi, %rcx), %rdi                 # now %rdi points to '$'
    movb $10, %r10b                  # no words
    xorq %rax, %rax                 # clear rax for next use

.check_decimal_and_store_loop_HW1:
    # '$0b'.next character into %rax is loaded in %al
    # here we use %r8b to know how far are we from $0, since it is no longer used

    shlq $8, %r9                    # allocate ls-byte
    cmp $0, %r8b
    je .resume_loop_decimal_2_HW1
    addq %rax, %r9                   # %rax is all zeros but the ls-byte


.resume_loop_decimal_2_HW1:
    inc %r8b                        # %r8b ++ see previous notes 
    movb (%rdi, %r8), %al          # load the char in index number ($r8b - 1) of array {...}, when '$0{...},'
    testb %al, %al                  # check if current char is null-terminator
    je .no_constant_in_op1_HW1      # since comma is still not found
    cmpb $',', %al
    je .comma_found_HW1
    
    cmpb $4, %r8b
    je .no_constant_in_op1_HW1      # comma not found yet => constant length is more than 3 chars => illegal

    # check if curr char is in {0, 1, .., 9}
    cmp $'9', %al
    jg .no_constant_in_op1_HW1      # illegal since not in {0, 1, ..., 9}
    cmp $'0', %al                   # note: if first char after $ was 0, then we would be in NNN
    jl .no_constant_in_op1_HW1      # illegal since not in {0, 1, ..., 9}
    subb $48, %al                   # char is in {0, 1, ..., 9} => convert it to its decimal and store in %al
    jmp .check_decimal_and_store_loop_HW1


# ----------------- binary check
.check_NNNC_form_binary_HW1:

    xorb %r8b, %r8b                 # %r8b = 0 => prepare for using in next loop
    addq %rcx, %rdi                 # now %rdi points to 'b' in '$0'
    movb $1, %r10b                  # now %r10 has the power that: 2^power = basis
    xorq %rax, %rax                 # clear rax for next use

.check_binary_and_store_loop_HW1:
    # '$0b'.next character into %rax is loaded in %al
    # here we use %r8b to know how far are we from $0, since it is no longer used

    shlq $8, %r9                    # allocate ls-byte
    cmp $0, %r8b
    je .resume_loop_binary_HW1
    addq %rax, %r9                   # %rax is all zeros but the ls-byte

.resume_loop_binary_HW1:

    inc %r8b                        # %r8b ++ see previous notes 
    movb (%rdi, %r8), %al          # load the char in index number ($r8b - 1) of array {...}, when '$0{...},'
    testb %al, %al                  # check if current char is null-terminator
    je .no_constant_in_op1_HW1      # since comma is still not found
    cmpb $',', %al
    je .comma_found_HW1
    
    cmpb $4, %r8b
    je .no_constant_in_op1_HW1      # comma not found yet => constant length is more than 3 chars => illegal

    # check if curr char is in {0, 1}
    cmp $'1', %al
    jg .no_constant_in_op1_HW1      # illegal since not in {0, 1}
    cmp $'0', %al
    jl .no_constant_in_op1_HW1      # illegal since not in {0, 1}
    subb $48, %al                   # char is in {0, 1} => convert it to its decimal and store in %al
    jmp .check_binary_and_store_loop_HW1





.convert_to_decimal_after_finding_a_valid_const_HW1:
    # note that e.g. in 0b100, 1 is the msb
    # if got here then we have a valid constant, number of chars of this const is %r8b -1. e.g., 0x11 => %r8b - 1 = 2
    cmpb $1, %r8b                 
    je .found_Constant_HW1
    movzbl %r9b, %r11d              # reset %r11d
    cmpl $10, %r10d                 # decimal in a string to decimal!
    je .decimal_convert_HW1
    shll %cl, %r11d                # e.g., %r10 = 4 (hex) => convert number (0-F) in %r11b to decimal from hex
    addl %r10d, %ecx                # ecx"++" (e.g., in hex, ecx = 0*4, 1*4, 2*4) => here ecx is how much to shift (2 to the power ?)
    jmp .pass_decimal_HW1
.decimal_convert_HW1:
    imul %ecx, %r11d                # convert to decimal (*10, *100 ...)
    imul %r10d, %ecx                #%r10 = 10 (decimal), %ecx = 1, 10, 100
.pass_decimal_HW1:
    addl %r11d, %edx                # %edx += %r11d
    shrq $8, %r9                   # now the 2nd ms-byte of our number is in the first ls-byte of %r9
    dec %r8b
    jmp .convert_to_decimal_after_finding_a_valid_const_HW1


.zero_decimal_found_HW1:
    movb $1, legal
    jmp .end

.comma_found_HW1:
    # preparation if the const was valid, to go to conversion label
    xorq %rcx, %rcx                 # %rcx not used anymore, will be used in next label
    cmp $10, %r10d                  # since decimal is not power of 2, it needs a VIP handling
    jne .not_decimal_HW1            # I am tired, I hate this, this is not how it should be, duck atam
    movq $1, %rcx                   # shit, a decimal , aaaaaaaaaaaaaaaaaaaa
.not_decimal_HW1:
    cmp $1, %r8b                    # enough since '<= 4' was checked
    jg .convert_to_decimal_after_finding_a_valid_const_HW1
    jmp .no_constant_in_op1_HW1


.found_Constant_HW1:
    movb $1, legal
    movl %edx, integer              # store value in decimal form (stored in %edx) in integer label
    jmp .end

.no_constant_in_op1_HW1:
    movb $0, legal
    movl $0, integer

.end:
