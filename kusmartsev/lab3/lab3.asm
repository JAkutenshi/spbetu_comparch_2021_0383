Astack SEGMENT STACK
	DW 12 DUP(?)
Astack ENDS

DATA SEGMENT
a	DW	0
b	DW 	0
i 	DW	0
k	DW 	0
i1	DW 	0
i2	DW 	0
res  	DW 	0

DATA ENDS

CODE SEGMENT  
	ASSUME CS:CODE, DS:DATA, SS:AStack
Main 	PROC 	FAR
	push ds
	sub ax, ax
	mov ax, DATA
	mov ds, ax
		mov a, 2
 		mov b, 1
		mov i, 4
		mov k, 0
	mov cx, i
	shl cx, 1
	shl cx, 1
	mov ax, cx; ax = cx = 4i
	mov bx, b 
	cmp a, bx
	jle f1
		;a>b
		;i1
		neg ax
        sub ax, 3
        mov cx, ax
		mov i1, cx
        ; cx = -4i - 3
		;i2
        mov ax, i
        shl ax, 1
        sub cx, ax
        sub cx, 5
		mov i2, cx
		jmp f1end
	f1:	;a<=b
        ;i2
		sub ax, i
        neg ax
        mov cx, ax
        add cx, 12
		mov i2, cx
        ;i1
        neg ax
        shl ax, 1
        mov cx, ax
        sub cx, 10
        ;cx = 6i - 10 
        ;ax = 2i
		mov i1, cx
						
	f1end:
		mov bx, i2
		cmp k, 0
		je f2
		; k != 0
			cmp i1, bx
			jle f3
				;i1 > i2
				mov ax, i2
				jmp AllEnd	
			
			f3:	;i1 <= i2
				mov ax, i1
				jmp AllEnd	

		f2: ;k==0
			add bx, i1
			cmp bx, 0
			jle f4
				; i1+i2 > 0					
                mov ax, bx
				jmp AllEnd
			f4: ;i1+i2 <= 0					
				neg bx
                mov ax, bx
	AllEnd:
		mov res, ax
		ret
Main ENDP
CODE ENDS
END Main


