#include <iostream>
#include <stdio.h>

char s[81];
char outstr[81];

int main() {
	fgets(s, 81, stdin);
	s[strlen(s) - 1] = '\0';

	__asm {
		push ds
		pop es
		mov esi, offset s
		mov edi, offset outstr

		L:
		lodsb
			cmp al, 'z'
			jg skip2

			cmp al, '0'
			jl skip2

			cmp al, '9'
			jl final

			cmp al, 'A'
			jl skip2

			cmp al, 'Z'
			jl final

			cmp al, 'a'
			jge final

			skip2:
			stosb;

			final:
				mov  ecx, '\0'
				cmp  ecx, [esi]
				je   LExit;
				jmp L
			LExit:
	}

	std::cout << outstr;
	FILE* f;
	fopen_s(&f, "out.txt", "w");

	if(f)
		fwrite(outstr, sizeof(char), strlen(outstr), f);

	return 0;
}