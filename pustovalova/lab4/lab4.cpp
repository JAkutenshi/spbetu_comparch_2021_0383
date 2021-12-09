#include <iostream>
#include <fstream>
#include <stdio.h>

char instring[81];
char outstring[324];

int main() {

    FILE* fout;

    std::cout << "Author: Pustovalova Ekaterina, gr.0383" << std::endl;
    std::cout << "11th variant" << std::endl;
    std::cout << "Convert the decimal digits entered in the input string to binary." << std::endl;
    std::cout << "Enter the string:" << std::endl;

    fgets(instring, 81, stdin);

    _asm {
        push ds
        pop es
        mov esi, offset instring
        mov edi, offset outstring

        loop_string :
        lodsb
            cmp al, '\0'
            je loop_end

            cmp al, '2'
            je Two
            cmp al, '3'
            je Three
            cmp al, '4'
            je Four
            cmp al, '5'
            je Five
            cmp al, '6'
            je Six
            cmp al, '7'
            je Seven
            cmp al, '8'
            je Eight
            cmp al, '9'
            je Nine

            stosb
            jmp loop_string

        Two:
            mov ax, '1'
            stosb
            mov ax, '0'
            stosb
            jmp loop_string

        Three:
            mov ax, '1'
            stosb
            mov ax, '1'
            stosb
            jmp loop_string
        Four:
            mov ax, '1'
            stosb
            mov ax, '0'
            stosb
            mov ax, '0'
            stosb
            jmp loop_string
        Five:
            mov ax, '1'
            stosb
            mov ax, '0'
            stosb
            mov ax, '1'
            stosb
            jmp loop_string
        Six:
            mov ax, '1'
            stosb
            mov ax, '1'
            stosb
            mov ax, '0'
            stosb
            jmp loop_string
        Seven:
            mov ax, '1'
            stosb
            mov ax, '1'
            stosb
            mov ax, '1'
            stosb
            jmp loop_string
        Eight:
            mov ax, '1'
            stosb
            mov ax, '0'
            stosb
            mov ax, '0'
            stosb
            mov ax, '0'
            stosb
            jmp loop_string
        Nine:
            mov ax, '1'
            stosb
            mov ax, '0'
            stosb
            mov ax, '0'
            stosb
            mov ax, '1'
            stosb
            jmp loop_string
            
            loop_end :
    }

    std::cout << outstring;

    fopen_s(&fout, "output.txt", "w");
    fputs(outstring, fout);

    return 0;
}
