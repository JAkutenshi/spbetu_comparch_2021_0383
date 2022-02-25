.586p
.MODEL FLAT, C
.CODE
PUBLIC C two
two PROC C array: dword, array_size: dword, xmin: dword, borders: dword, intN: dword, result: dword

push esi
push edi
push ebp

mov edi, array  
mov esi, borders  
mov ecx, intN  


for_borders:  
	mov eax, [esi]   
	sub eax, xmin
	mov [esi], eax
	add esi, 4
	loop for_borders

mov esi, borders
mov ecx, intN
mov ebx, 0
mov eax, [esi]

for_l:
	push ecx  
	mov ecx, eax 
	push esi  
	mov esi, result 

    for_arr:
		cmp ecx, 0 
		je end_for
        mov eax, [edi]
        add [esi + 4*ebx], eax
        add edi, 4
        loop for_arr

end_for:
    pop esi
    inc ebx 
	mov eax, [esi]
	add esi, 4
	sub eax, [esi]
	neg eax  
	pop ecx
	loop for_l

mov esi, result
mov ecx, intN
mov eax, 0

fin_for: 
	add eax, [esi]
	add esi, 4
	loop fin_for

mov esi, result
sub eax, array_size
neg eax

add [esi + 4*ebx], eax

pop ebp
pop edi
pop esi

ret
two ENDP
END  