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

	std::cout << "Лабораторную работу выполнил студент группы 0383 Коротков А.В. \n" <<
				  "Вариант 5 \n" <<
				  "Задание: Преобразование всех строчных латинских букв входной строки в заглавные, а  " <<
		          "десятичных цифр в инверсные, остальные символы входной строки передаются в выходную " <<
		          "строку непосредственно\n";

	std::cout << "Входная строка: ";
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

		// 'a' <= al <= 'z'
		cmp al, 'a'
		jl not_lowercase
		cmp al, 'z'
		jg not_lowercase

		sub al, 0x20
		stosb
		jmp loop_string
		not_lowercase:

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

	std::cout << "Выходная строка: ";
	std::cout << out;

	std::ofstream fs("output.txt");
	if (!fs.is_open()) {
		std::cerr << "Не удалось записать результат преобразования в файл\n";
	}

	fs << out;
	fs.close();
	return 0;
}