#include <iostream>

char in[81];
char out[81];


int main()
{
    setlocale(LC_ALL, "cp866");

    std::fgets(in, 81, stdin);
    in[std::strlen(in) - 1] = '\0';
    __asm {
        push ds
        pop es
        mov esi, offset in
        mov edi, offset out
        l :
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

            skip3:; À - ï
            cmp al, 128
            jb final
            cmp al, 175
            ja skip4
            stosb
            jmp final

            skip4:; ð - ¸
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
    printf("%s\n", out);
    return 0;
}