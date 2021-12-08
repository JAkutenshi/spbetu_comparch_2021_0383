#include<iostream>
#include<stdio.h>
#include<Windows.h>

char instr[81];
char outstr[81];

//059 AB ab ZY zy АЮ аб ЯЮ яю + -*///\\#%#@^

int main() {


    fgets(instr, 81, stdin);
    //14) Исключение латинских букв и цифр, введенных во входной строке при формировании выходной строки.
    __asm {
        push ds
        pop es
        mov esi, offset instr
        mov edi, offset outstr
        cycle :
            lodsb; загрузить символ в AL
            // не устраивает 48 - 57, 65 - 90, 97 - 122

            cmp al, 48  ; 0
            jge step1    ; прыжок если первый >=
            stosb
            jmp check

            step1 :
            cmp al, 57  ; 9
            jbe check   ; прыжок если первый <=
            cmp al, 65  ; A
            jge step2
            stosb
            jmp check

            step2 :
            cmp al, 90  ; Z
            jbe check
            cmp al, 97  ; a
            jge step3
            stosb
            jmp check

            step3 :
            cmp al, 122 ; z
            jbe check
            stosb
            jmp check

            check :
            mov  ecx, '\0'
            cmp  ecx, [esi]
            je   lexit  ; выход из цикла, если текущий символ завершающий
            jmp  cycle
            lexit :
    }

    std::cout << outstr;

    FILE* fout;
    fopen_s(&fout, "output.txt", "w");
    fputs(outstr, fout);
    fclose(fout);
    return 0;
}