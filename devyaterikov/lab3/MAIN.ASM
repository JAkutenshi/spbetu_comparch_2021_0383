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
      
          mov a, 1
          mov b, -1
          mov i, 4
          mov k, 1
          
	  ;f1&f3
	  mov cx, i
	  shl cx, 1 ; cx = 2*i
	  mov ax, cx
	  mov bx, b

	  cmp a, bx ; сравнение a и b
	  jle f1f3
		neg cx ; a > b
		add cx, 15
		mov i1, cx
		
		shl ax, 1
		neg ax
		add ax, 7
		mov i2, ax
		jmp f1f3End
		
	  f1f3: ; a <= b
		add cx, i
		mov i1, cx
		add i1, 4
		
		shl cx, 1
		neg cx
		add cx, 8
		mov i2, cx
	  f1f3End:  
	  
	  ;f2
	  mov ax, i1
	  mov cx, i2
	  neg cx
	  mov bx, k
	  
	  cmp bx, 0
	  jge f2
	  	add cx, 10 ; k < 0
	  	cmp ax, cx
	  	jge MainEnd
	  		mov ax, cx	
	  	jmp MainEnd
	  f2: ; k >= 0
	  	add ax, cx
	  	cmp ax, 0
	  	jge MainEnd
	  		neg ax
	  MainEnd: ; в ax лежит значение функции f2
      ret
Main      ENDP
CODE      ENDS
END Main
