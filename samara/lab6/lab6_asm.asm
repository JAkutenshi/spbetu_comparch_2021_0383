.586
.MODEL FLAT, C
.CODE

FUNC PROC C NumRanDat:dword, Xi:dword, NInt:dword, LGrInt:dword, result:dword
    push eax
    push ebx
    push ecx
    push esi
    push edi

    mov ecx, NumRanDat
    mov esi, Xi
    mov edi, LGrInt     ; левые границы
    mov eax, 0      ; eax - индекс текущего числа
    
    loop1:
    	mov ebx, 0      ; ebx - индекс текущего интервала
    	brders:
 	    	cmp ebx, NInt
    		jge boarders_end
    		push eax
	    	mov eax, [esi+4*eax]
	    	cmp eax, [edi+4*ebx]
	    	pop eax
	    	jl boarders_end
    		inc ebx
	    	jmp brders
	    	
	    boarders_end:
	        dec ebx     ; -1
	        cmp ebx, -1
	        je skip
	        mov edi, result
	        push eax
	        mov eax, [edi+4*ebx]
	        inc eax
	        mov [edi+4*ebx], eax
	        pop eax
	        mov edi, LGrInt
	    skip:
	        inc eax     ; eax++
        loop loop1  ;cx != 0

    pop ebx
    pop eax
    pop edi
    pop esi
    pop ecx
    ret
FUNC ENDP
END