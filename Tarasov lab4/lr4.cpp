#include <iostream>
#include <fstream>
#include <stdio.h>

char instring[81];
char outstring[161];

int main() {

    FILE* fout;

    std::cout << "Author - Tarasov Konstantin" << std::endl;
    std::cout << "9th variant" << std::endl;
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

            cmp al, '8'
            je case_a
            cmp al, '9'
            je case_b

            stosb                 
            jmp loop_string

            case_a :
        mov ax, '01'
            stosw
            jmp loop_string

            case_b :
        mov ax, '11'
            stosw
            jmp loop_string

            loop_end :
    }

    std::cout << outstring;

    fopen_s(&fout, "output.txt", "w");
    fputs(outstring, fout);

    return 0;
}