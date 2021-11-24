AStack SEGMENT  STACK
    DW 12 DUP(?)
AStack  ENDS
;Данные программы
DATA      SEGMENT
;Директивы описания данных
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
	  
; Головная процедура
Main      PROC  FAR
      push  DS
      sub   AX,AX
      push  AX
      mov   AX,DATA
      mov   DS,AX
	  mov   CX, 0

	  mov a, 1
      mov b, 2
      mov i, 2
      mov k, 1
	  
	  mov cx, i
	  mov ax, cx
	  shl cx, 1
	  mov bx, b    ;
	  cmp a, bx    ; сравнение a и b
	  jle f1second
		neg cx
		add cx, 15
		mov i1, cx
		shl cx, 1
		add cx, -33
		mov i2, cx
	  f1second:
		add cx, ax
		add cx, 4
		mov i1, cx
		shl cx, 1
		add cx, -18
		mov i2, cx
	  
	  ;рассчет res
	  mov bx, k
	  cmp bx, 0
	  jne resSecond
	    mov bx, i1
		cmp bx, i2
		jl max1
		  mov cx, i2
		  jmp MainFinal
		max1:
		  mov cx, bx
		  jmp MainFinal
	  resSecond:
	    mov bx, i1
		cmp bx, i2
		jl max2
		  mov cx, bx
		  jmp MainFinal
		max2:
		  mov cx, i2
		  jmp MainFinal
	  MainFinal:           ; в cx лежит значение res
      ret
Main      ENDP
CODE      ENDS
END Main 