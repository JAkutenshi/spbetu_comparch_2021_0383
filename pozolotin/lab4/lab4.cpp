#include <iostream>
#include <stdio.h>

// A B C D E F G H I J K L M N O P Q R S T U V W X Y Z

char s[81];
char outstr[161];

char num[54] = { '1' ,  ' ', '2', ' ', '3', ' ', '4', ' ', '5', ' ',
                 '6', ' ', '7', ' ', '8', ' ', '9', ' ', '1', '0',
                 '1', '1', '1', '2', '1', '3', '1', '4', '1', '5',
                 '1', '6', '1', '7', '1', '8', '1', '9', '2', '0',
                 '2', '1', '2', '2', '2', '3', '2', '4', '2', '5',
                 '2', '6', '2', '7'
};

// unsigned char end_str = '\0';

int main()
{
    fgets(s, 81, stdin);
    s[strlen(s) - 1] = '\0';
    __asm {
    push ds
    pop es
    mov esi, offset s
    mov edi, offset outstr
    L :
    lodsb; в al очередной символ

    cmp al, 'A'
    jl skip
    cmp al, 'J'
    jl replace

    cmp al, 'J'
    jl skip
    cmp al, 'Z'
    jle replace1


    skip:
    stosb; кладем в выходную строку байт из al

    jmp final

    replace:

    mov ebx, 0
    mov bl, al
    sub ebx, 65
    shl ebx, 1

    mov al, [num][ebx]

    stosb
    jmp final

    replace1:

    mov ebx, 0
    mov bl, al
    sub ebx, 65
    shl ebx, 1

    mov ah, [num][ebx + 1]
    mov al, [num][ebx]

    stosw
    jmp final






    final:
    mov  ecx, '\0'
    cmp  ecx, [esi]
    je   LExit; выход из цикла, если текущий символ завершающий
    jmp  L
    LExit :
    };
    std::cout << outstr;
    FILE* f;
    fopen_s(&f, "out.txt", "w");
    fwrite(outstr, sizeof(char), strlen(outstr), f);
    return 0;
}