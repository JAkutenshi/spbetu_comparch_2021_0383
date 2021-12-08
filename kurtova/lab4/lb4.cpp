//Вариант 8
//Преобразование введенных во входной строке шестнадцатиричных цифр в десятичную СС, 
//остальные символы входной строки передаются в выходную строку непосредственно.

#include<iostream>
#include<stdio.h>

char instring[81];
char outstring[161];

int main() {
    
    fgets(instring, 81, stdin);

    __asm {
        push ds
        pop es
        mov esi, offset instring
        mov edi, offset outstring

        loop_string :
            lodsb                //Загрузка символа из строки в al
            cmp al, '\0'
            je loop_end          //Если встречен конец строки, выходим из цикла

            cmp al, 'A'
            je case_a
            cmp al, 'B'
            je case_b
            cmp al, 'C'
            je case_c
            cmp al, 'D'
            je case_d
            cmp al, 'E'
            je case_e
            cmp al, 'F'
            je case_f

            stosb                 //Если не является ни одним из данных символов, то записываем символ и переходим в начало цикла
            jmp loop_string

            case_a :
            mov ax, '01'
            stosw
            jmp loop_string

            case_b :
            mov ax, '11'
            stosw
            jmp loop_string

            case_c :
            mov ax, '21'
            stosw
            jmp loop_string

            case_d :
            mov ax, '31'
            stosw
            jmp loop_string

            case_e :
            mov ax, '41'
            stosw
            jmp loop_string

            case_f :
            mov ax, '51'
            stosw
            jmp loop_string

            loop_end :
    }

    std::cout << outstring;

    FILE* fout;
    fopen_s(&fout, "output.txt", "w");
    fputs(outstring, fout);

    return 0;
}
