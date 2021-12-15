AStack SEGMENT  STACK
    DW 12 DUP(?)
AStack  ENDS
;Данные программы
DATA      SEGMENT
;Директивы описания данных
a      DW    0
b      DW    0
i      DW    0
k      DW    13
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
	  
	  mov a, 5
	  mov b, 3
	  mov i, 8
	  mov k, -2

	  ;f1&f2
	  mov cx, i
	  shl cx, 1 ; cx = 2*i
	  mov ax, cx ; ax = 2*i
	  mov bx, b

	  cmp a, bx ; сравнение a и b
	  jle f1f2
		neg cx ; a > b
		add cx, 15
		mov i1, cx
		
		mov i2, cx
		sub i2, ax
		add i2, 5
		jmp f1f2End
		
	  f1f2: ; a <= b
		add cx, i ; cx = 3i
		mov i1, cx 
		add i1, 4
		
		neg cx
		add cx, cx
		add cx, 6
		mov i2, cx
	  f1f2End:  
	  
	  ;f4
	  mov cx, i1
	  sub cx, i2
	  cmp cx, 0
	  jge module
	    neg cx
	  module: ; cx = |i1 - i2|
	  
	  mov bx, k
	  cmp bx, 0 ; сравнение k и 0
	  jge f4
	    mov bx, 2 ; k < 0
		cmp cx, bx
		jl min
		  mov cx, 2
		  jmp MainEnd
		min:
		  jmp MainEnd
	  f4:        ; k >= 0
	  mov cx, i2
	  neg cx
	  mov bx, -6
	  cmp bx, cx
	  jge max
		mov cx, bx
	  max:
	  MainEnd: ; в cx лежит значение функции f4
      ret
Main      ENDP
CODE      ENDS
END Main