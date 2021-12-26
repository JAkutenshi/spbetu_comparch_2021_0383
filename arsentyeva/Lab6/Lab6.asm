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
    mov edi, LGrInt
    mov eax, 0      ; индекс текущего числа
    
    l:
    	mov ebx, 0      ; индекс текущего интервала
    	boarders:
 	    	cmp ebx, NInt
    		jge boarders_exit
    		push eax
	    	mov eax, [esi+4*eax]
	    	cmp eax, [edi+4*ebx]
	    	pop eax
	    	jl boarders_exit
    		inc ebx
	    	jmp boarders
	    	
	    boarders_exit:
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
	        inc eax     ; +1
    loop l

    pop ebx
    pop eax
    pop edi
    pop esi
    pop ecx
    ret
FUNC ENDP
END

