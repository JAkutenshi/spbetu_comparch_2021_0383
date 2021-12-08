#include <iostream>

char instring[81];
char outstring[81];


int main()
{
    setlocale(LC_ALL, "cp866");

    std::fgets(instring, 81, stdin);
    instring[std::strlen(instring) - 1] = '\0';
    __asm {
        push ds
        pop es
        mov esi, offset instring
        mov edi, offset outstring
        l:
        lodsb

            cmp al, 32; space
            jne skip1
            stosb
            jmp final

            skip1:; A - Z
            cmp al, 65
            jb final
            cmp al, 90
            ja skip2
            stosb
            jmp final

            skip2:; a - z
            cmp al, 97
            jb final
            cmp al, 122
            ja skip3
            stosb
            jmp final

            skip3:; А - п
            cmp al, 128
            jb final
            cmp al, 175
            ja skip4
            stosb
            jmp final

            skip4:;р - ё
        cmp al, 224
            jb final
            cmp al, 241
            ja final
            stosb
            ja final


            final:
        mov  ecx, '\0'
            cmp  ecx, [esi]
            je   LExit;
        jmp  l
            LExit :
    };
    FILE* f;
    fopen_s(&f, "output.txt", "w");
    setlocale(LC_ALL, "cp866");
    fwrite(outstring, sizeof(char), std::strlen(outstring), f);
    return 0;
}

