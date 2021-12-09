#include <iostream>
#include <fstream>
#include <stdio.h>
#include <windows.h>

char in[81];
char out[81];

int main()
{
    SetConsoleCP(1251);
    SetConsoleOutputCP(1251);

    std::cout << "String: ";
    std::cin.getline(in, 81);

    __asm {
        push ds
        pop es
        mov esi, offset in
        mov edi, offset out


        loop_string :
        lodsb

        cmp al, '\0'
        je end

        // 'A' <= al <= 'Z'
        cmp al, 'A'
        jl not_uppercase
        cmp al, 'Z'
        jg not_uppercase

        add al, 0x20
        stosb
        jmp loop_string
        not_uppercase:

        // '0' <= al <= '9'
        cmp al, '0'
        jl not_digit
        cmp al, '9'
        jg not_digit

        mov dl, al
        mov al, '9'
        sub al, dl
        add al, '0'
        stosb
        jmp loop_string
        not_digit:

        stosb
        jmp loop_string

        end:
    }

    std::cout << "Result: ";
    std::cout << out;

    std::ofstream fs("output.txt");
    if (!fs.is_open()) {
        std::cerr << "Error\n";
    }

    fs << out;
    fs.close();
    return 0;
}