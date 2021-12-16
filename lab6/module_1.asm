;------------1st module

.586p								;directive for correct translation of 32-bit commands (pentium cpu)
.MODEL FLAT, C
.CODE
PUBLIC C module_1

module_1 PROC C x: dword, arr_size: dword, result: dword, xmin: dword

PUSH EDI							;save initial vals
PUSH ESI
push ebp

MOV EDI, x
MOV ESI, result
MOV ECX, arr_size

lp:
	MOV EAX, [EDI] 					;put into EAX addr of next element
	SUB EAX, xmin 					;get its index
	sub eax, 1
	MOV EBX, [ESI + 4 * EAX]		;put the addr of result arr + index into EBX
	INC EBX 						;curr index + 1
	MOV [ESI + 4 * EAX], EBX 		;put the result into the arr
	ADD EDI, 4 						;next element
	LOOP lp 						;loop (decr the ECX value, if ECX > 0 -> loop)

pop ebp
POP ESI
POP EDI

RET
module_1 ENDP
END
