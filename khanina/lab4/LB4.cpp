#include<iostream>
#include<stdio.h>

char instr[81];
char outstr[81];

int main() {

    fgets(instr, 81, stdin);

    __asm {
        push ds
        pop es
        mov esi, offset instr
        mov edi, offset outstr
        continue:
        lodsb; загрузить символ в AL

        cmp al, 32 ; пробел
        jne next ; jne - переход если не равно
        stosb
        jmp check

        next: cmp al, 65 ; принадлежит A-Z
        jb check ; jb - переход если первый меньше
        cmp al, 90
        ja next1
        stosb
        jmp check            

        next1: cmp al, 97 ; принадлежит a - z
        jb check
        cmp al, 122
        ja next2
        stosb
        jmp check

        next2: cmp al, 128 ; принадлежит A - П
        jb check
        cmp al, 175
        ja next3
        stosb
        jmp check

        next3: cmp al, 224 ; принадлежит р - ё
        cmp al, 224
        jb check
        cmp al, 241
        ja check
        stosb
        ja check

        check:
        mov  ecx, '\0'
        cmp  ecx, [esi]
        je   lexit ; выход из цикла, если текущий символ завершающий
        jmp  continue
        lexit :
    }

    std::cout << outstr;

    FILE* fout;
    fopen_s(&fout, "output.txt", "w");
    fputs(outstr, fout);

    return 0;
 }