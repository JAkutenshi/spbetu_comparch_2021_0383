; Стек  программы
AStack SEGMENT  STACK
    DW 12 DUP(?)
AStack  ENDS
;Данные программы
DATA      SEGMENT
;Директивы описания данных
string DB    15, 15 DUP('$')
sign   DB    1
a      DW    2
b      DW    1
i      DW    3
k      DW    -1
i1     DW    0
i2     DW    0

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
	  
	 
	  ;вычисление f1 и f7
	  mov cx, i
	  mov ax, cx
	  shl cx, 1
	  mov bx, b    ;
	  cmp a, bx    ; сравнение a и b
	  jle f1f7second
		neg cx
		add cx, 15
		mov i1, cx
		shl cx, 1
		add cx, -25
		jmp f1f7final
	  f1f7second:
		add cx, ax
		add cx, 4
		mov i1, cx
		neg cx
		add cx, 14
	  f1f7final:
	  mov i2, cx
	  
	  
	  ;рассчет f6
	  mov bx, k
	  cmp bx, 0
	  jl f6Second

		mov cx, i2
		cmp cx, 0
		jge skip2     ;модуль i2
			neg cx
			mov i2, cx
		skip2:

	    mov bx, i2
		cmp bx, 7
		jl max1
		  mov cx, bx       ; |i2| >= 7
		  jmp MainFinal
		max1:
		  mov cx, 7        ; |i2| < 7
		  jmp MainFinal
	  f6Second:
	    mov cx, i2
		neg cx
		add cx, i1
		cmp cx, 0
		jge skip1
			neg cx
		skip1:

	  MainFinal:           ; в cx лежит значение функции f7
      ret
Main      ENDP
CODE      ENDS
END Main 