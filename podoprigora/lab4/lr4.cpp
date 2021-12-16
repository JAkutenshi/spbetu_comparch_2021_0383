#include <iostream>
#include <stdio.h>

char s[81];
char outstr[161];

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
			lodsb ; в al очередной символ

			cmp al, '8'; является ли введённый символ '8'
			jne skip1
				mov al, '1'
				mov ah, '0'
				stosw
				jmp final
			skip1:

			cmp al, '9'; является ли введённый символ '9'
			jne skip2
				mov ah, '1'
				mov al, '1'
				stosw
				jmp final
				skip2:

			stosb; кладем в выходную строку байт из al

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