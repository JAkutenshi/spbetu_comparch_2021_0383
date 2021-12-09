#include<iostream>
#include<stdio.h>
#include<fstream>
#include<Windows.h>

char instr[81];
char outstr[81];



char rus[26] = { '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�' };



int main() {


    fgets(instr, 81, stdin);
    //17) �������������� ��������� ���� � �������
    __asm {
        push ds
        pop es
        mov esi, offset instr
        mov edi, offset outstr
        cycle :
            lodsb;
            // 65 - 90, 97 - 122

            cmp al, 65
            jge step1
            stosb
            jmp check

            step1 :
                cmp al, 90
                jle engUpper
                cmp al, 97
                jge step2
                stosb
                jmp check

            step2 :
                cmp al, 122
                jle engLow
                stosb
                jmp check

            engUpper :
                mov ebx, 0
                mov bl, al
                sub ebx, 65
                mov al,[rus][ebx]
                stosb
                jmp check

            engLow:
                mov ebx, 0
                mov bl, al
                sub ebx, 65
                mov al,[rus][ebx]
                add al, 32
                stosb
                jmp check


            check :
                mov  ecx, '\0'
                cmp  ecx, [esi]
                je   lexit
            jmp  cycle
            lexit :
    }

    std::cout << outstr <<std::endl;

    FILE* fout;
    fopen_s(&fout, "output.txt", "w");
    fputs(outstr, fout);
    fclose(fout);


    return 0;
}