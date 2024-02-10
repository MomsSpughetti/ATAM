char shifted = 0;
char character = 'a';

char shifted_characters[] = {
    '!', '@', '#', '$', '%', '^', '&', '*', '(', ')',
    '~', '_', '+', '{', '}', ':', '"', '|', '<', '>', '?'
};

char unshifted_characters[] = {
    '1', '2', '3', '4', '5', '6', '7', '8', '9', '0',
    '`', '-', '=', '[', ']', ';', '\'', '\\', ',', '.', '/'
};



int shifted_symbol(char c){
    for (int i = 0; i < 21; i++)
    {
        if(shifted_characters[i] == c){
            return 1;
        }
    }
    return 0;
}

int unshifted_symbol(char c){
    for (int i = 0; i < 21; i++)
    {
        if(unshifted_characters[i] == c){
            return 1;
        }
    }
    return 0;
}

char get_shifted(char c){
    for (int i = 0; i < 21; i++)
    {
        if(unshifted_characters[i] == c){
            return shifted_characters[i];
        }
    }
    return c;
}

int main(){
    if(65 <= character && character <= 90){
        shifted = character + 32;
    } else if (97 <= character && character <= 122)
    {
        shifted = character;
    } else if (shifted_symbol(character))
    {
        shifted = character;
    } else if (unshifted_symbol(character))
    {
        shifted = get_shifted(character);
    } else {
        shifted = 0xff;
    }
    
    
    return 0;
}


