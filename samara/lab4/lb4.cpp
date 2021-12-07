#include<Windows.h>
#include<cstdio>
#include<cstdlib>

//Формирование номера введенной русской буквы по алфавиту и номера позиции его первого вхождения во входной строке и выдача их на экран
int main() {
	SetConsoleCP(1251);
	SetConsoleOutputCP(1251);

	const int N = 80;
	char c;
	char* str = (char*)calloc(N, sizeof(char));
	int i = 0;

	printf("Автор: Самара Р.Д. \nЗадание: Формирование номера введенной русской буквы по алфавиту и номера позиции его первого вхождения во входной строке и выдача их на экран\n");
	printf("Введите строку: ");

	while ((c = getchar()) != '\n') {
		//if ((c >= -64 && c <= -1) || c == -72 || c == -88)	//-72 == ё, -88 == Ё
			str[i++] = c;
	}
	char* str1 = (char*)calloc(i * 3, sizeof(char));

	__asm {
		mov esi, str // в si(индекс источника) пометим адрес str
		mov edi, str1 // di(индекс приемника)
		mov ecx, i // ecx - счётчик массива, i - длина строки
		for:
			lodsb // кладём байт из si в al
			stosb // из al в di
			mov c, 1 // счётчик первого вхождения встроку
			mov edx, esi // адрес строки
			mov bl, al // сохраняем текущий символ
				
			cmp bl, 'ё'
			je russian
			cmp bl, 'Ё'
			je russian
			cmp bl, 'А'
			jl next
			jge russian
			cmp bl, 'я'
			jg next
			jle russian
		next: 
			loop for
		russian:
			mov esi, str //начало поиска с самого начала исходной строки
			lodsb // считывание символа из str
		while:
			cmp al, bl //сравнение символов
			je equal // равны
			lodsb // считывание символа
			inc c // с += 1
			jmp while
		equal:
			mov al, c // запись номера первого вхождения
			stosb // пересылаем номер первого вхождения в di
			mov esi, edx // пересылаем начало строки в si
			mov al, bl //берём текущий символ из bx

			cmp al, 'ё' // проверка на ё
			jne ex1 // если != - переход на ex1
			add al, 46 // смещение для ё
		ex1:
			cmp al, 'Ё' // на Ё
			jne ex2
			add al, 30
		ex2:
			add al, 1 // добавочное смещение на 1
			cmp al, 'а' // сравнение с буквой а
			jge little // переход к прописным буквам
			cmp al, 'Е' //проверка на буквы после Е (т.к Ё и ё в диапазоне от -64 до 0 отсутствуют)
			jbe ex3
			add al, 1 // доп. смещение для букв после Е
		ex3:
			sub al, 'А' //смещение для заглавной
			jmp end
		little :
			cmp al, 'е' //проверка на буквы после е
			jbe lab2
			add al, 1 // допсмещение для букв после е
			lab2 :
			sub al, 'а' //смещение для прописной
		end:
			stosb // загрузка числа в строку
			loop for	//cx != 0
	}
	int n = i;
	FILE* fout;
	fopen_s(&fout, "output.txt", "w");
	int nmbr;
	int already[33] = {0};
	for (int i = 0; i < 3 * n; i += 3) {
		if (((str1[i] < 0) && (str1[i] > -65) || str1[i] == -72 || str1[i] == -88)) {
			if (str1[i] <= -33) {	//заглавные
				if(str1[i] == -72)	//ё
					nmbr = str1[i] + 80;
				else if(str1[i] == -88)
					nmbr = str1[i] + 96;
				else
					nmbr = str1[i] + 65;
			}
			else{
				nmbr = str1[i] + 33;
			}
			if (already[nmbr] == 0) {
				already[nmbr] = 1;
				fprintf(fout, "Символ строки: '%c', номер первого вхождения: %d, номер буквы в алфавите: %d.\n", str1[i], str1[i + 1], str1[i + 2]);
				printf("Символ строки: '%c', номер первого вхождения: %d, номер буквы в алфавите: %d.\n", str1[i], str1[i + 1], str1[i + 2]);
			}
		}
	}
	fclose(fout);
	return 0;
}

//ЁёдбвЩгдЫ1234 ABCdE fghij Щёбв .;'.