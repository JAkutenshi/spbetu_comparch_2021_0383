.586
.MODEL FLAT, C
.CODE
func PROC C nums:dword, randNumCount:dword, leftBorders:dword, result:dword, intervalCount:dword

	push eax
	push ebx
	push ecx
	push edx
	push esi
	push edi

	mov ecx, randNumCount ; кол-во чисел
	mov esi, nums ; сгенерированные числа
	mov edi, leftBorders ; левые границы

	mov edx, 0 ; индекс текущего числа
	next:
	mov ebx, [esi+4*edx] ; текущее число
	cmp ebx, [edi] ; крайняя левая граница
	jl continue

	mov eax, 0 ; индекс интервала
	searchInterval:
		cmp ebx, [edi+4*eax] ; число с границей
		jl endSearch	
		cmp eax, intervalCount
		je endSearch
		inc eax
		jmp searchInterval

    endSearch:
    mov edi, result
    mov ebx, [edi+4*eax]
    inc ebx
    mov [edi+4*eax], ebx ; кладем &&&
    mov edi, leftBorders ; в еди лежат границы

	continue:
	inc edx
	loop next

	pop edi
	pop esi
	pop edx
	pop ecx
	pop ebx
	pop eax
	ret
func ENDP
END