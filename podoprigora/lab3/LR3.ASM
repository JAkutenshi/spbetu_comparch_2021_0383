; Стек  программы
AStack SEGMENT  STACK
    DW 12 DUP(?)
AStack  ENDS
;Данные программы
DATA      SEGMENT
;Директивы описания данных
string DB    15, 15 DUP('$')
sign   DB    1
a      DW    0
b      DW    0
i      DW    0
k      DW    0
i1     DW    0
i2     DW    0

DATA      ENDS

; Код программы
CODE      SEGMENT
      ASSUME CS:CODE, DS:DATA, SS:AStack
	  
Read      PROC NEAR
      mov  dx, OFFSET string
	  mov  ah, 0Ah
	  int  21h
	  mov  di, 2
	  cmp  string[2], 45   ;проверка, введён ли минус
	  jne  positive
	    mov  al, -1
		mov  di, 3         ;индекс первой цифры в string, если введён минус
	    jmp  EndOfIf
	  positive:
	    mov  al, 1
	  EndOfIf:
	  mov  sign, al        ; в sign храниться знак числа
	  mov  cx, 0
	  ; цикл формирования числа и сохранения его в cx
	  L:                   
		mov  ax, cx         ;>
	    SHL  cx, 1          ;>>
		SHL  cx, 1          ;>>> умножение на 10
		SHL  cx, 1          ;>>>
		add  cx, ax         ;>>
		add  cx, ax         ;>
		mov  al, string[di] ;  
		sub  al, 30h        ;  занесение в ax числа, состоящего из очередной цифры введённого числа
		mov  ah, 0          ;
	    add  cx, ax
		
		mov  al, string[1]
		mov  ah, 0
		add  ax, 1  ; в ax сохраняется индекс последнего символа в строке
		cmp  di, ax   
		je   LExit   ; выход из цикла, если текущая обработанная цифра последняя 
		  inc  di
		  jmp  L
	  LExit:
	  cmp sign, -1
      jne final
	    neg cx         ; изменение знака числа
	  final:
      ret 
Read ENDP


; Головная процедура
Main      PROC  FAR
      push  DS
      sub   AX,AX
      push  AX
      mov   AX,DATA
      mov   DS,AX
	  mov   CX, 0
	  
	  ;считывание a, b, i, k
      Call  Read
	  mov a, cx
	  Call  Read
	  mov b, cx
	  Call  Read
	  mov i, cx
	  Call  Read
	  mov k, cx
	  
	  ;вычисление f2
	  mov cx, i
	  mov ax, cx
	  shl cx, 1
	  shl cx, 1
	  mov bx, b    ;
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
	  
	  ;вычисление f4
	  mov cx, i
	  cmp a, bx
	  jle f4second
	    shl cx, 1
		mov ax, cx
		shl cx, 1
		add cx, ax
		add cx, -4
		neg cx
		jmp f4final
	  f4second:       
	    add cx, 2
		mov ax, cx
		shl cx, 1
		add cx, ax
	  f4final:
	  mov i2, cx
	  
	  mov cx, i1
	  cmp cx, 0
	  jge skip1     ;модуль i1
	    neg cx
		mov i1, cx
	  skip1:
	  
	  mov cx, i2
	  cmp cx, 0
	  jge skip2     ;модуль i2
	    neg cx
		mov i2, cx
	  skip2:
	  
	  ;рассчет f7
	  mov bx, k
	  cmp bx, 0
	  jl f7Second
	    mov bx, i1
		cmp bx, 6
		jl max1
		  mov cx, bx       ; |i1| >= 6
		  jmp MainFinal
		max1:
		  mov cx, 6        ; |i1| < 6
		  jmp MainFinal
	  f7Second:
	    mov cx, i1
		add cx, i2
	  MainFinal:           ; в cx лежит значение функции f7
      ret
Main      ENDP
CODE      ENDS
END Main