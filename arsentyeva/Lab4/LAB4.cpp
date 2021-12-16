#include <iostream>
#include <fstream>
#include <cstdio>

char in_str[81];
char out_str[161];

//0 - 48, 9 - 57, A - 65, Z - 90, a - 97, z - 122,

int main() {
    system("chcp 1251");
    std::cout << "The Latin letters entered in the input line will be replaced by the \
numbers corresponding to their alphabetical number represented in the hexadecimal CC, \
and the rest of the characters of the input line will be sent directly to the output line.";
    std::cout << '\n' << "Arsentieva Daria, 0383" << '\n';
    std::cout << "Please, enter a line.." << '\n';
    std::fgets(in_str, 81, stdin);
    in_str[strlen(in_str) - 1] = '\0';
    __asm {
        push ds
        pop es
        mov esi, offset in_str
        mov edi, offset out_str
        l :
        lodsb
            cmp al, 'Z'; проверка на то, что 'A' <= al <= 'Z'
            jg skip1
            cmp al, 'A'
            jl skip1
            mov cl, al
            sub cl, 17; -65 + 48 - убрали разницу между 0 и A
            cmp al, 'K'; K - 75, проверка на то, что 0 <= al <= 9
            jl ret1
            cmp al, 'Q'; Q - 81, проверка на то, что 16 <= al <= 25
            jl case3
            jmp case4

            skip1 :
        cmp al, 'z'; проверка на то, что 'a' <= al <= 'z'
            jg skip2
            cmp al, 'a'
            jl skip2
            mov cl, al
            sub cl, 49; -97 + 48 - убрали разницу между 0 и a
            cmp al, 'k'; k - 107, проверка на то, что 0 <= al <= 9
            jl ret1
            cmp al, 'q'; q - 113, проверка на то, что 16 <= al <= 25
            jl case3
            jmp case4

            case3 :
        mov cl, al
            sub cl, 10; 10 <= al <= 15
            jmp ret1
            case4 :
        mov al, 49; '1' - 49
            stosb
            sub cl, 16
            jmp ret1
            ret1 :
        mov al, cl
            stosb
            jmp final
            skip2 :
            stosb; Если очередной символ не удовлетворяет усл.редактирования - записываем байт в строку
            final:
        mov  ecx, '\0'
            cmp  ecx, [esi]; проверка на конец строки
            je   lExit; Если достигнут конец строки - выходим из цикла
            jmp l
            lExit :
    };
    std::cout << out_str;
    FILE* f;
    fopen_s(&f, "output.txt", "w");
    if (f) {
        fwrite(out_str, sizeof(char), strlen(out_str), f);
        fclose(f);
    }
    return 0;
}
