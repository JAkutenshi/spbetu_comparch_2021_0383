; Стек  программы
AStack SEGMENT  STACK
    DW 12 DUP(?)
AStack  ENDS
;Данные программы
DATA      SEGMENT
;Директивы описания данных
a      DW    1
b      DW    2
i      DW    3
k      DW    0
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
	  
		;вычисление f2 и f8
	  mov cx, i		
	  mov ax, cx
	  mov bx, b
	  cmp a, bx    ; сравнение a и b
	  jle fsecond	;a > b
		shl cx, 1
		shl cx, 1
		add cx, 3
		neg cx
		mov i1, cx
		sub cx, ax
		sub cx, ax
		add cx, -5
		mov i2, cx
		jmp finfun
	  fsecond:		;a <= b
		shl cx, 1
		add cx, ax
		neg cx
		add cx, 12
		mov i2, cx
		shl cx, 1
		neg cx
		add cx, 14
		mov i1, cx 
		mov cx, i2
		
	finfun:
		;вычисление f3
		;mov cx, i2
		mov bx, k
		cmp bx, 0
		je f3Second ; k != 0
		cmp cx, i1
		jle min1
		mov cx, i1        ; i2 <= i1
		jmp MainFinal
	min1:
		jmp MainFinal

	f3Second:  ; k = 0
		add cx, i1
		cmp cx, 0
	    jge MainFinal     ; |i1 + i2|
	    neg cx
		jmp MainFinal
		
	  MainFinal:   ; в cx лежит значение функции f3
      ret
Main      ENDP
CODE      ENDS
END Main 