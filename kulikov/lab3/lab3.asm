AStack SEGMENT STACK
	DW 12 DUP(?)
AStack ENDS

DATA SEGMENT
a DW 0
b DW 0
i DW 0
k DW 0
i1 DW 0
i2 DW 0
DATA ENDS

; Êîä ïðîãðàììû
CODE SEGMENT

ASSUME CS:CODE, DS:DATA, SS:AStack
; Ãîëîâíàÿ ïðîöåäóðà
Main PROC FAR
	push DS
	sub AX, AX
	push AX

	mov AX, DATA
	mov DX, AX

	mov a, 0
	mov b, 0
	mov i, 0
	mov k, 0

	;bx = 3 * i
	mov bx, i
	shl bx, 1
	add bx, i

	mov cx, a
	cmp cx, b
	jle L1

	;a > b
	;i1 = -(4 * i + 3)
	add bx, i
	add bx, 3
	neg bx
	mov i1, bx

	;i2 = -(6 * i + 8)
	add bx, i
        sub bx, 1
	shl bx, 1
	mov i2, bx

	jmp L2


	;a <= b
	L1:

	;i2 = 9 - 3 * (i - 1)
	neg bx
	add bx, 12
	mov i2, bx

	;i1 = 6 * i - 10
	neg bx
	shl bx, 1
	add bx, 2
	mov i1, bx

	L2:
	cmp k, 0
	jne L3

	;k == 0
	
	mov AX, i1
	add AX, i2
	cmp AX, 0
	jg endmain
	neg AX
	jmp endmain

	;k != 0
	L3:
	mov Ax, i1
	cmp AX, i2
	jle endmain

	mov AX, i2

	endmain:
	ret
Main ENDP
CODE ENDS

END Main
