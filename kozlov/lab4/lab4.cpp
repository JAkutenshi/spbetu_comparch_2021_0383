#include <iostream>
#include <fstream>

char instr[81];
char outstr[161];

int main()
{
    std::cout << "Hi, I'm Timofey Kozlov - the author of this program" << std::endl;
    std::cout << "Processing by 4th variant" << std::endl;
    std::cout << "Please, enter a string" << std::endl;
    fgets(instr, 81, stdin);
    instr[strlen(instr) - 1] = '\0';
    __asm 
    {
        push ds
        pop es
        mov esi, offset instr
        mov edi, offset outstr
        while:
        lodsb; в al очередной символ

            cmp al, 'Z'; проверка на то, что 'A' <= al <= 'Z'
            jg skip1
            cmp al, 'A'
            jl skip1
            add al, 32
            stosb
            jmp final
            skip1:

            cmp al, '7'; роверка на то, что '0' <= al <= '7'
            jg skip2
            cmp al, '0'
            jl skip2
            mov cl, '7'
            sub cl, al
            mov al, '0'
            add al, cl
            stosb
            jmp final
            skip2:

            stosb; Если очередной символ не удовлетворяет усл. редактирования - записываем байт в строку

            final:
            mov  ecx, '\0'
            cmp  ecx, [esi] ; проверка на конец строки
            je   whileExit; Если достигнут конец строки - выходим из цикла
            jmp  while
            whileExit :
    };
    std::cout << outstr;
    std::ofstream out("output.txt");
    out << outstr;
    return 0;
}
