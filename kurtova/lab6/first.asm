.586p
.MODEL FLAT, C
.CODE

PUBLIC C first
first PROC C num: dword, N: dword, res: dword, xmin: dword

push esi
push edi

mov edi, num
mov ecx, N					; Необходимо для работы loop - итерация по массиву
mov esi, res				; Промежуточный массив

for_additional_res:
	mov eax, [edi]			; Берем очередной элемент из num
	sub eax, xmin			; Найдём индекс ячейки, соответствующей числу в промежуточном массиве
	mov ebx, [esi + 4*eax]	; Находим ячейку с этим индексом в промежуточном массиве и помещаем её в ebx
	inc ebx					; Увеличиваем значение на 1
	mov [esi + 4*eax], ebx	; Кладём новое значение обратно в промежуточный массив
	add edi, 4				; Переходим к следующему элементу в массиве num
	loop for_additional_res

pop edi
pop esi
ret
first ENDP
END