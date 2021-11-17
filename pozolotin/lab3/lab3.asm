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

	  mov a, 3
	  mov b, 5
	  mov i, 1
	  mov k, 2

	  ;f1&f2
	  mov cx, i
	  shl cx, 1 ; cx = 2*i
	  mov ax, cx ; ax = 2*i
	  mov bx, b

	  cmp a, bx ; сравнение a и b
	  jle f1f2
		neg cx ; a > b   -2i
		add cx, cx ; -2i + -2i
		add cx, 20 ; -4i + 20
		mov i1, cx ; i1 = -4i + 20


		mov i2, cx ; -4i + 20
		sub i2, ax ; -4i + 20 - 2i
		sub i2, 16 ; i2 = -6i + 4
		jmp f1f2End

	  f1f2: ; a <= b
		add cx, i ; cx = 3i
		mov ax, cx
		add cx, cx ; cx = 6i
		neg cx ; -6i
		mov i1, cx ;
		add i1, 6 ; i1 = -6i + 6

		add ax, 6
		mov i2, ax ; i2 = 3i + 6
	  f1f2End:

	  ;f4
	  mov cx, i1 ; cx = i1


	  cmp cx, 0
	  jge module ; cx < 0
		neg cx
	  module: ; cx = |i1|

	  mov ax, i2

	  cmp ax, 0
	  jge module1 ; ax < 0
		neg ax
	  module1: ; ax = |i2|


	  mov bx, k


	  cmp bx, 0 ; сравнение k и 0 id 83
	  jge f4 ;k < 0
		add cx, ax
		jmp MainEnd
	  f4:        ; k >= 0
		mov bx, 6 ;
			cmp cx, bx
			jge max ; cx < bx
			  mov cx, bx
			max:




	  MainEnd: ; в cx лежит значение функции f4
      ret
Main      ENDP
CODE      ENDS
END Main