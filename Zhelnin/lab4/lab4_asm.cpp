#include <iostream>
#include <stdio.h>
#include <windows.h>

char s[81];
char outstr[161];

int main()
{
	SetConsoleCP(1251);
	SetConsoleOutputCP(1251);  // чтобы на вход и выход смотрело по ср1251
	fgets(s, 81, stdin);
	s[strlen(s) - 1] = '\0';
	__asm {
		push ds
		pop es
		mov esi, offset s
		mov edi, offset outstr
		L :
		lodsb //кладЄм символ в al

			cmp al, 192
			jl nouppercase
			cmp al, 223
			jg nouppercase
			//сдвигаем на 32 бита чтобы сделать прописными
			add al, 32
			stosb
			jmp final

			nouppercase: //если не прописные, то провер€ем ещЄ дл€ ® и переходим к цифрам

		cmp al, '®'
			jne noe
			mov al, 'Є'

			noe :

			cmp al, 48
			jl zeroseven
			cmp al, 55
			jg zeroseven
			//формула така€: х лежит в al, x-48 - разница от 0, 
			//55-(x-48) - число в которое надо инвертировать
			//(55 - (x - 48)) - x Ч разница между x и числом, в которое надо инвертировать => прибавл€ем к x
			// x + ((55 - (x - 48)) - x) = 103 - x
			neg al       
			add al, 103
			stosb
			jmp final

			zeroseven:

		stosb // кладем в выходную строку байт из al

			final:
		mov  ecx, '\0'
			cmp  ecx, [esi]
			je   LExit // выход из цикла, если текущий символ завершающий
			jmp  L
			LExit :
	};
	std::cout << outstr;
	FILE* f;
	fopen_s(&f, "out.txt", "w");
	fwrite(outstr, sizeof(char), strlen(outstr), f);
	return 0;
}