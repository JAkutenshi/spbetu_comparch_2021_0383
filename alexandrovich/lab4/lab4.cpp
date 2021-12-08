#include <iostream>
#include <stdio.h>
#include <clocale>

char s[81];
char outstr[161];

int main()
{
	setlocale(LC_ALL, "cp866");
	std::cout << "Numbers and cyrillic only\nAlexandrovich Valeria\n";
	fgets(s, 81, stdin);
	s[strlen(s) - 1] = '\0';
	__asm {
		push ds
		pop es
		mov esi, offset s
		mov edi, offset outstr
		L :
		lodsb; в al очередной символ
			cmp al, 32; space
			jne skip1
			stosb
			jmp final

			skip1:; 0 - 9
			cmp al, 48
			jb final
			cmp al, 57
			ja skip2
			stosb
			jmp final

			skip2:; А - п
			cmp al, 128
			jb final
			cmp al, 175
			ja skip3
			stosb
			jmp final

			skip3:; р - ё
			cmp al, 224
			jb final
			cmp al, 241
			ja final
			stosb
			ja final

			final:
		mov  ecx, '\0'
			cmp  ecx, [esi]
			je   LExit;
		jmp  L
			LExit :
	};

	std::cout << outstr;
	FILE* f;
	fopen_s(&f, "out.txt", "w");
	fwrite(outstr, sizeof(char), strlen(outstr), f);
	return 0;
}