; Стек  программы
AStack SEGMENT  STACK
    DW 12 DUP(?)
AStack  ENDS
;Данные программы
DATA      SEGMENT
;Директивы описания данных
a      DW    2
b      DW    1
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
	  
	  	  
	  ;вычисление f4
	  mov cx, i
      mov ax, cx
	  shl ax, 1
	  add ax, cx  ; в ax = 3i
      mov bx, b
	  cmp a, bx

	  jle ifless
        shl ax, 1
		mov cx, ax
		sub ax, 4
		neg ax
		mov i1, ax
        add cx, 8
		neg cx
		mov i2, cx
        jmp finfun

	    ifless:   
		mov cx, ax
		add ax, 6
		mov i1, ax
		mov ax, cx
		mov cx, 12
		sub cx, ax
		mov i2, cx
	  
	  ;рассчет f3
	  finfun:
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
	    jge MainFinal     ;модуль i1 + i2
	      neg cx
		  jmp MainFinal
		
	  MainFinal:           ; в cx лежит значение функции f3
      ret
Main      ENDP
CODE      ENDS
END Main