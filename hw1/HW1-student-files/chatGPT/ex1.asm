.section .data

# Define variables and arrays

unshifted_characters:
                .string "1234567890`-=[];',./"
shifted_characters:
                .string "!@#$%^&*()~_+{}:\"|<>?"

.section .text

_start:
    # Load the input character into %al
    movzb character, %al

    # Check if the character is an uppercase letter
    cmp $'A', %al
    jl check_lower
    cmp $'Z', %al
    jle uppercase
    
check_lower:
    # Check if the character is a lowercase letter
    cmp $'a', %al
    jl check_shifted
    cmp $'z', %al
    jg check_shifted

    # Store the lowercase character into shifted
    add $32, %al
    mov %al, shifted
    jmp end
    
uppercase:
    # shifted = character
    movb %al, shifted
    jmp end
    
check_shifted:
    # Check if the character is shifted, rdi is caller saved
    mov $shifted_characters, %rdi
    call find_character
    test %eax, %eax
    jz check_unshifted

    # Store the shifted character into shifted
    movb %al, shifted
    jmp end
    
check_unshifted:
    # Check if the character is unshifted
    mov $unshifted_characters, %rdi
    call find_character
    test %eax, %eax
    jz not_unshifted

    # Find the corresponding shifted character and store it into shifted
    #RAX (%al) will have the shifted character
    movb %al, shifted
    jmp end
    
not_unshifted:
    # If the character is not unshifted, set shifted to 0xff
    mov $0xff, shifted

end:
    # Exit the program
    mov $60, %rax      # Syscall number for exit
    xor %rdi, %rdi     # Exit code 0
    syscall

# Function to find a character in a string
find_character:
    xor %rax, %rax          # rax = 0
find_character_loop:
    cmpb $0, (%rdi, %rax)   # Compare with null terminator (because .string)
    je find_character_end
    cmpb %al, (%rdi, %rax)  # Compare with current character
    je find_character_found
    inc %rax                # Increment index
    jmp find_character_loop

find_character_found:
    movzbl shifted_characters(%rax), %al # Load the shifted character
    ret

find_character_end:
    mov $0, %rax           # Character not found, set to 0xff
    ret
