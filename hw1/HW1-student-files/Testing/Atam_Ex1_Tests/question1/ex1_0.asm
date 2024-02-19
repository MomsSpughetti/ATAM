.global _start

.section .text

_start:
    #your code here

    #get the char, rdx is caller-saved reg
    movb character, %dl

    cmp $90, %dl
    jg .isLowerCase_HW1     #   check if lowercase
    cmp $65, %dl
    jl .non_abc_HW1         #   character is non_abc => check other possibilities
    movb %dl, shifted       #   character is uppercase => shifted = character



.isLowerCase_HW1:
    cmp $97, %dl
    jl .non_abc_HW1     #   character is non_abc => check other possibilities
    cmp $122, %dl
    jg .non_abc_HW1     #   character is non_abc => check other possibilities
    subb $32, %dl        #   character is lowerCase => 
    movb %dl, shifted   #   save its uppercase to shifted
    jmp .Exit

.non_abc_HW1:
    # shifted
    cmpb $'!', %dl             # Compare with '!'
    je .Excalmation_mark_HW1
    cmpb $'@', %dl             # Compare with '@'
    je .At_sign_HW1
    cmpb $'#', %dl             # Compare with '#'
    je .Number_sign_HW1
    cmpb $'$', %dl             # Compare with '$'
    je .Dollar_sign_HW1
    cmpb $'%', %dl             # Compare with '%'
    je .Percent_sign_HW1
    cmpb $'^', %dl             # Compare with '^'
    je .Caret_HW1
    cmpb $'&', %dl             # Compare with '&'
    je .Ampersand_HW1
    cmpb $'*', %dl             # Compare with '*'
    je .Asterisk_HW1
    cmpb $'(', %dl            # Compare with '('
    je .Left_round_bracket_HW1
    cmpb $')', %dl             # Compare with ')'
    je .Right_round_bracket_HW1
    cmpb $'~', %dl             # Compare with '~'
    je .Tilde_HW1
    cmpb $'_', %dl             # Compare with '_'
    je .Underscore_HW1
    cmpb $'+', %dl             # Compare with '+'
    je .Plus_sign_HW1
    cmpb $'{', %dl            # Compare with '{'
    je .Curly_braces_open_HW1
    cmpb $'}', %dl             # Compare with '}'
    je .Curly_braces_close_HW1
    cmpb $':', %dl             # Compare with ':'
    je .Colon_HW1
    cmpb $'"', %dl             # Compare with '"'
    je .Quotation_mark_HW1
    cmpb $'|', %dl             # Compare with '|'
    je .Vertical_bar_HW1
    cmpb $'<', %dl             # Compare with '<'
    je .Less_than_sign_HW1
    cmpb $'>', %dl             # Compare with '>'
    je .Greater_than_sign_HW1
    cmpb $'?', %dl             # Compare with '?'
    je .Question_mark_HW1

    # unshifted to be shifted
    cmpb $'1', %dl             # Compare with '1'
    je .Excalmation_mark_HW1
    cmpb $'2', %dl             # Compare with '2'
    je .At_sign_HW1
    cmpb $'3', %dl             # Compare with '3'
    je .Number_sign_HW1
    cmpb $'4', %dl             # Compare with '4'
    je .Dollar_sign_HW1
    cmpb $'5', %dl             # Compare with '5'
    je .Percent_sign_HW1
    cmpb $'6', %dl             # Compare with '6'
    je .Caret_HW1
    cmpb $'7', %dl             # Compare with '7'
    je .Ampersand_HW1
    cmpb $'8', %dl             # Compare with '8'
    je .Asterisk_HW1
    cmpb $'9', %dl             # Compare with '9'
    je .Left_round_bracket_HW1
    cmpb $'0', %dl             # Compare with '0'
    je .Right_round_bracket_HW1
    cmpb $'`', %dl             # Compare with '`'
    je .Tilde_HW1
    cmpb $'-', %dl             # Compare with '-'
    je .Underscore_HW1
    cmpb $'=', %dl             # Compare with '='
    je .Plus_sign_HW1
    cmpb $'[', %dl             # Compare with '['
    je .Curly_braces_open_HW1
    cmpb $']', %dl             # Compare with ']'
    je .Curly_braces_close_HW1
    cmpb $';', %dl             # Compare with ';'
    je .Colon_HW1
    cmpb $'\'', %dl            # Compare with '\''
    je .Quotation_mark_HW1
    cmpb $'\\', %dl            # Compare with '\'
    je .Vertical_bar_HW1
    cmpb $',', %dl             # Compare with ','
    je .Less_than_sign_HW1
    cmpb $'.', %dl             # Compare with '.'
    je .Greater_than_sign_HW1
    cmpb $'/', %dl             # Compare with '/'
    je .Question_mark_HW1

    jmp .invalid_HW1


.Excalmation_mark_HW1:
    movb $33, %dl    # ASCII code for '!'
    jmp .Exit

.Quotation_mark_HW1:
    movb $34, %dl    # ASCII code for '"'
    jmp .Exit

.Number_sign_HW1:
    movb $35, %dl    # ASCII code for '#'
    jmp .Exit

.Dollar_sign_HW1:
    movb $36, %dl    # ASCII code for '$'
    jmp .Exit

.Percent_sign_HW1:
    movb $37, %dl    # ASCII code for '%'
    jmp .Exit

.Ampersand_HW1:
    movb $38, %dl    # ASCII code for '&'
    jmp .Exit

.Apostrophe_HW1:
    movb $39, %dl    # ASCII code for '''
    jmp .Exit

.Left_round_bracket_HW1:
    movb $40, %dl    # ASCII code for '('
    jmp .Exit

.Right_round_bracket_HW1:
    movb $41, %dl    # ASCII code for ')'
    jmp .Exit

.Asterisk_HW1:
    movb $42, %dl    # ASCII code for '*'
    jmp .Exit

.Plus_sign_HW1:
    movb $43, %dl    # ASCII code for '+'
    jmp .Exit

.Comma_HW1:
    movb $44, %dl    # ASCII code for ','
    jmp .Exit

.Hyphen_HW1:
    movb $45, %dl    # ASCII code for '-'
    jmp .Exit

.Full_stop_HW1:
    movb $46, %dl    # ASCII code for '.'
    jmp .Exit

.Slash_HW1:
    movb $47, %dl    # ASCII code for '/'
    jmp .Exit

.Number_zero_HW1:
    movb $48, %dl    # ASCII code for '0'
    jmp .Exit

.Number_one_HW1:
    movb $49, %dl    # ASCII code for '1'
    jmp .Exit

.Number_two_HW1:
    movb $50, %dl    # ASCII code for '2'
    jmp .Exit

.Number_three_HW1:
    movb $51, %dl    # ASCII code for '3'
    jmp .Exit

.Number_four_HW1:
    movb $52, %dl    # ASCII code for '4'
    jmp .Exit

.Number_five_HW1:
    movb $53, %dl    # ASCII code for '5'
    jmp .Exit

.Number_six_HW1:
    movb $54, %dl    # ASCII code for '6'
    jmp .Exit

.Number_seven_HW1:
    movb $55, %dl    # ASCII code for '7'
    jmp .Exit

.Number_eight_HW1:
    movb $56, %dl    # ASCII code for '8'
    jmp .Exit

.Number_nine_HW1:
    movb $57, %dl    # ASCII code for '9'
    jmp .Exit

.Colon_HW1:
    movb $58, %dl    # ASCII code for ':'
    jmp .Exit

.Semicolon_HW1:
    movb $59, %dl    # ASCII code for ';'
    jmp .Exit

.Less_than_sign_HW1:
    movb $60, %dl    # ASCII code for '<'
    jmp .Exit

.Equals_sign_HW1:
    movb $61, %dl    # ASCII code for '='
    jmp .Exit

.Greater_than_sign_HW1:
    movb $62, %dl    # ASCII code for '>'
    jmp .Exit

.Question_mark_HW1:
    movb $63, %dl    # ASCII code for '?'
    jmp .Exit

.At_sign_HW1:
    movb $64, %dl    # ASCII code for '@'
    jmp .Exit

.Left_square_bracket_HW1:
    movb $91, %dl    # ASCII code for '['
    jmp .Exit

.Backslash_HW1:
    movb $92, %dl    # ASCII code for '\'
    jmp .Exit

.Right_square_bracket_HW1:
    movb $93, %dl    # ASCII code for ']'
    jmp .Exit

.Caret_HW1:
    movb $94, %dl    # ASCII code for '^'
    jmp .Exit

.Underscore_HW1:
    movb $95, %dl    # ASCII code for '_'
    jmp .Exit

.Grave_accent_HW1:
    movb $96, %dl    # ASCII code for '`'
    jmp .Exit

.Curly_braces_open_HW1:
    movb $123, %dl   # ASCII code for '{'
    jmp .Exit

.Vertical_bar_HW1:
    movb $124, %dl   # ASCII code for '|'
    jmp .Exit

.Curly_braces_close_HW1:
    movb $125, %dl   # ASCII code for '}'
    jmp .Exit

.Tilde_HW1:
    movb $126, %dl   # ASCII code for '~'
    jmp .Exit

.invalid_HW1:
    movb $0xff, shifted

.Exit:
    movb %dl, shifted
    