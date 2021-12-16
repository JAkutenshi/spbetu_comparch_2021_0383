#include "stdafx.h"
#include <iostream>
#include <cstdlib>
#include <fstream>

using namespace std;

char in[81];
char out[81];

int main(){
    system("chcp 1251 > nul");
    setlocale(LC_CTYPE, "rus");
    cout << "Smirnov Ivan gr.0383" << endl;
	cout << "Variant 15" << endl;
	cout << "Deleting digits and russian symbols" << endl;
	cout << "Enter the string to process (81 symbols or less):" << endl;
    ofstream file;
    file.open("C:\\Users\\hippo\\Desktop\\output.txt");
    cin.getline(in, 81);
    __asm {
        mov esi, offset in
        mov edi, offset out

        loop_start:
            lodsb
            cmp al, '\0' 
            je loop_finish

            cmp al, '¨' 
				je loop_start
			cmp al, '¸'
				je loop_start
            cmp al, 'À'
				jl check_if_digit
            cmp al, 'ÿ'
				jg check_if_digit
            jmp loop_start

        check_if_digit:
            cmp al, '0'
				jl write_passed
            cmp al, '9'
				jg write_passed
            jmp loop_start

        write_passed:
            stosb
			jmp loop_start

        loop_finish:
    };
    cout << out;
    file << out;
    file.close();
	system("pause");
    return 0;
}