.586
.MODEL FLAT, C 
.CODE
FUNC PROC C array:dword, array_size:dword, left_borders:dword, intervals_size:dword, result:dword, sum_array:dword
push ecx
push esi
push edi
push eax
push ebx;  

mov ecx, array_size
mov esi, array
mov edi, left_borders
mov eax, 0;   
cycle:                    
	mov ebx, 0    
	borders:      
 		cmp ebx, intervals_size ;     
		jge borders_extra_exit
		push eax
		mov eax, [esi+4*eax]
		cmp eax, [edi+4*ebx]
		jl borders_exit
		push edi
		mov edi, sum_array
		cmp eax,0
		jge abs
		neg eax
		abs:
			add eax, [edi+4*ebx]
			mov [edi+4*ebx], eax
			pop edi
			pop eax

		inc ebx
		jmp borders
	borders_exit:
	pop eax
	borders_extra_exit:
	dec ebx         

	cmp ebx, -1        
	je skip
	mov edi, result
	push eax
	mov eax, [edi+4*ebx]
	inc eax
	mov [edi+4*ebx], eax
	pop eax
	mov edi, left_borders
	skip:
	inc eax       
loop cycle

pop ebx 
pop eax
pop edi
pop esi
pop ecx
ret
FUNC ENDP
END
