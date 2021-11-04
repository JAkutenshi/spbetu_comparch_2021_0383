; Стек  программы
AStack SEGMENT  STACK
    DW 12 DUP(?)
AStack  ENDS
;Данные программы
DATA      SEGMENT
;Директивы описания данных
a      DW    -6
b      DW    -2
i      DW    5
k      DW    -10
i1     DW    0
i2     DW    0
tmp	   DW    0

DATA      ENDS

; Код программы
CODE      SEGMENT
      ASSUME CS:CODE, DS:DATA, SS:AStack
	  
; Головная процедура
Main      PROC  FAR
      push  DS
      sub   AX,AX
      push  AX
      mov   AX,DATA
      mov   DS,AX
	  mov   CX, 0
	  	  
	  ;вычисление f2
	  mov cx, i
	  mov ax, cx
	  shl cx, 1
	  shl cx, 1
	  mov bx, b    ;
	  mov tmp cx
	  cmp a, bx    ; сравнение a и b
	  jle f2second
		add cx, 3
		neg cx
		jmp f2final
	  f2second:
		add cx, ax
		add cx, ax
		add cx, -10
	  f2final:
	  mov i1, cx
	  
	  ;вычисление f3
	  mov cx, tmp
	  jle f3second
	    mov ax, cx
		mov cx, 7
		sub cx, ax
		jmp f3final
	  f3second:       
	    add cx, ax
		add cx, ax
		mov ax, cx
		mov cx, 8
		sub cx, ax
	  f3final:
	  mov i2, cx
	  
	  mov cx, i2
	  cmp cx, 0
	  jge skip2     ;модуль i2
	    neg cx
		mov i2, cx
	  skip2:
	  
	  ;рассчет f8
	  mov bx, k
	  cmp bx, 0
	  jl f8Second
	    mov bx, i2
		sub bx, 3
		cmp bx, 4
		jl max1
		  mov cx, bx       ; |i1| >= 4
		  jmp MainFinal
		max1:
		  mov cx, 4        ; |i1| < 4
		  jmp MainFinal
	  f8Second:
	  mov cx, i1
	  cmp cx, 0
	  jge skip1     ;модуль i1
	    neg cx
		mov i1, cx
	  skip1:
	    mov cx, i1
		sub cx, i2
	  MainFinal:           ; в cx лежит значение функции f8
      ret
Main      ENDP
CODE      ENDS
END Main