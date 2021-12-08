#include <iostream>

using namespace std;

char input[81];
int num = -1; //счётчик-номер буквы в алфавите
int arr[26] = { 0 }; //массив номеров позиций первого вхождения буквы латинского алфавита во входной строке
int len;

int main() {
    system("chcp 1251 > nul");
    setlocale(LC_CTYPE, "rus");
    cout << "Автор: Рудакова Юлия ст.гр.0383 \nФормирование номера введенной латинской буквы по алфавиту и номера позиции его первого вхождения во входной строке и выдача их на экран.\nВведите строку: ";

    cin.getline(input, 81);  //входная строка
    len = strlen(input);     //длина входной строки
    __asm {
        push ds
        pop es

        mov al, 'a'
        dec al
        cycle ://перебор букв алфавита
        mov edi, offset input     //устанавливаем в edi смещение на входную строку
            mov ecx, len
            cmp al, 'Z'
            je label
            inc al
            label ://поиск в строке
        inc num
            repne scasb        //посимвольный поиск во входной строке, он повторится такое количество раз, сколько во входной строке символов
            has_symbol_check ://проверка символа
        cmp ecx, 0
            jne get_index    //если символ встретился
            dec edi
            cmp ES : [edi] , al //проверка вдруг последний символ и есть искомый
            je get_index
            jmp last_iteration_check
            get_index ://если символ встретился
        mov ebx, len
            sub ebx, ecx //ebx теперь содержит индекс первого вхождения
            mov esi, num
            mov ES : arr[esi * 4], ebx   //положили в массив индекс первого вхождения
            jmp last_iteration_check
            last_iteration_check ://вызов проверки следующего символа алфавита
        cmp al, 'z'
            je the_end
            jne cycle

            the_end :
    };
    int flag = 0;
    for (int i = 0; i < 26; i++) {
        if (arr[i] != 0) {
            cout << i + 1 << ' ' << arr[i] << endl;
            flag = 1;
        }
    }
    if (flag == 0)
        cout << "Буквы латинского алфавита отсутствуют в введенной строке.";
    return 0;
}