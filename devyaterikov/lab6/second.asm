.586p
.MODEL FLAT, C
.CODE
PUBLIC C second
second PROC C first_res: dword, N: dword, xmin: dword, borders: dword, Nint: dword, res: dword

push esi
push edi
push ebp

mov edi, first_res  
mov esi, borders  
mov ecx, Nint  

for_borders:  
	mov eax, [esi]				; Достаём очередную границу интервала
	sub eax, xmin				; Находим индекс границы в промежуточном массиве
	mov [esi], eax				; Кладём обратно
	add esi, 4					; Переходим к следующему элементу
	loop for_borders

mov esi, borders
mov ecx, Nint
mov ebx, 0						; Счётчик
mov eax, [esi]					; Первый элемент обновленного borders 

for_start:
	push ecx					; Сохраним значение ecx		
	mov ecx, eax				; Поместим в ecx значение индекса границы
	push esi					; Сохраним esi
	mov esi, res				; Будем работать с массивом res

    for_array:
		cmp ecx, 0
		je for_end				; Если достигли конца границы, выходим из цикла
        mov eax, [edi]			; Берём лежащее в промежуточном массиве количество элементов
        add [esi + 4*ebx], eax	; Добавляем к результату для данного интервала
        add edi, 4				; Переходим к следующему
        loop for_array

for_end:
    pop esi						; Возвращаемся к массиву borders
    inc ebx						; Увеличиваем счётчик
	mov eax, [esi]
	add esi, 4
	sub eax, [esi]				; Из предыдущего значения borders вычитаем следующий - получаем длину очередного интервала * -1
	neg eax						; Делаем значение положительным
	pop ecx						; Возвращаемся к итератору Nint
	loop for_start

mov esi, res
mov ecx, Nint
mov eax, 0

final_for:						; Считаем количество чисел, которые не были обработаны
	add eax, [esi]
	add esi, 4
	loop final_for

mov esi, res
sub eax, N
neg eax

add [esi + 4*ebx], eax			; Помещаем это количество в последнюю ячейку результата

pop ebp
pop edi
pop esi

ret
second ENDP
END