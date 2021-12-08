/*Write a prog to process char info, following function realization is a must:
* - initialization in C (or other lang): title table output with kind of transformation and *autor of the prog
* - Char string input size <= Nmax(=80) from keyboard to the chosen memory location(in C); *if string size > Nmax - other chars are to be ignored
* - Transformation of the original string and write the result in the output string in ASM
* - Output of the result char string to the screen and write in file (in C)
* put the ASM part of prog using in-line
* DONT touch input string or change it
* when transforming using string commands is a must
* Transform VAR 1: Form result string from numbers and russian letters ONLY*/

/**PROG:**/

#include <iostream>
#include <fstream>

char s[81];
char outstr[81];

int main() {
	system("chcp 1251"); //so the russian chars are available
						 //by default CMD has cp866 encoding while .txt files have cp1251 encoding (at least in Win)
						 //thus it`s easier to change encoding in CMD so .txt outfile doesn`t get gibberish data

	std::cout << "Var 1: Form result string from numbers and russian letters ONLY" << std::endl;
	std::cout << "Petrovskaya Evgeniya, 0383" << std::endl;

	fgets(s, 81, stdin);
	s[strlen(s) - 1] = '\0';

	__asm {
		PUSH DS
		POP ES								; ES = DS, stack empty 
		MOV ESI, OFFSET s					; put start of the s string into ESI
		MOV EDI, OFFSET outstr				; put start of the outsrt into EDI

		MOV ECX, '\0'
		Lp :								; loop start
			CMP ECX, [ESI]					; check if EOL is reached
			JE stop							; if so - exit

			LODSB							; load byte at address DS:SI into AL, in x86 uses ESI
				; check for 0 - 9
			CMP AL, '0'						; check if AL >= '0' if not - jmp to next check
			JB Acheck
			CMP AL, '9'						; check if AL <= '9' if not - jmp to next check
			JA Acheck
			JMP write						; if '0' <= AL <= '9' - write it into outsting

				; check for A - я			Also let`s mark that in cp1251 letters А-я have 192-255 numbers unlike in cp866
			Acheck :
				CMP AL, 192					; check if AL >= 'А' if not - jmp to next loop iteraton
				JB Lp
				CMP AL, 255					; check if AL <= 'я' if not - jmp to next loop iteraton
				JA Lp
				JMP write					; if 'А' <= AL <= 'я' - write it into outsting

			write :
				STOSB						; by default save AL into address DS:DI, in x86 uses EDI

			JMP Lp							; next loop iteration

		stop :
	};

	std::cout << outstr;
	std::ofstream out("output.txt");
	out << outstr;

	return 0;
}
