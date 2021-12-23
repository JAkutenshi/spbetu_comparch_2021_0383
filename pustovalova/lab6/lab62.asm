.586p
.MODEL FLAT, C
.CODE
PUBLIC C lab62
lab62 PROC C array: dword, array_size: dword, xmin: dword, borders: dword, intN: dword, result: dword

push esi
push edi
push ebp

mov edi, array
mov esi, borders
mov ecx, intN


borders_loop:
    mov eax, [esi]
    sub eax, xmin
    mov [esi], eax
    add esi, 4
    loop borders_loop

mov esi, borders
mov ecx, intN
mov ebx, 0
mov eax, [esi]

for_start:
    push ecx
    mov ecx, eax
    push esi
    mov esi, result

    for_array:
        cmp ecx, 0
        je end_for
        mov eax, [edi]
        add [esi + 4*ebx], eax
        add edi, 4
        loop for_array

end_for:
    pop esi
    inc ebx
    mov eax, [esi]
    add esi, 4
    sub eax, [esi]
    neg eax
    pop ecx
    loop for_start

mov esi, result
mov ecx, intN
mov eax, 0

fin_loop:
    add eax, [esi]
    add esi, 4
    loop fin_loop

mov esi, result
sub eax, array_size
neg eax

add [esi + 4*ebx], eax

pop ebp
pop edi
pop esi

ret
lab62 ENDP
END 
