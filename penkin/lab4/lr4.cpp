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
		lodsb; в al очередной символ

			cmp al, 'A'; является ли введённый символ 'A'
			jne skip1
			mov al, '1'
			mov ah, '0'
			stosw
			jmp final
			skip1:

			cmp al, 'B'; является ли введённый символ 'B'
			jne skip2
			mov al, '1'
			mov ah, '1'
			stosw
			jmp final
			skip2:

			cmp al, 'C'; является ли введённый символ 'C'
			jne skip3
			mov al, '1'
			mov ah, '2'
			stosw
			jmp final
			skip3:

			cmp al, 'D'; является ли введённый символ 'D'
			jne skip4
			mov al, '1'
			mov ah, '3'
			stosw
			jmp final
			skip4:

			cmp al, 'E'; является ли введённый символ 'E'
			jne skip5
			mov al, '1'
			mov ah, '4'
			stosw
			jmp final
			skip5:

			cmp al, 'F'; является ли введённый символ 'F'
			jne skip6
			mov al, '1'
			mov ah, '5'
			stosw
			jmp final
			skip6:

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