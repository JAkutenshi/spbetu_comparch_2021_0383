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
	  
	  ;3.4.2
	  ;вычисление f3 и f4
	  mov cx, i
	  mov ax, cx
	  add ax, cx ; 2i
	  mov bx, b
	  cmp a, bx ;сравнение а и b
	  jg f34 	;a<=b
	  	add cx, ax   ;3i
	  	add cx, 6
	  	mov i2, cx   ;3i + 6 
	  	neg cx
	  	shl cx, 1 	;-6i - 12
	  	add cx, 20
	  	mov i1, cx   ;8 -6*i
	  	jmp final
	  	
	  f34: ;при a>b
	  	mov cx, ax
	  	neg cx	;-2i
	  	shl cx, 1 ;-4i
	  	add cx, 7
	  	mov i1, cx	;7 - 4*i
	  	shl cx, 1	;-8i+14
	  	add cx, ax	;-6i+14
	  	add cx, -10
	  	mov i2, cx	;-6*i + 4
	  
	  final: ;вычисление f2
	  mov ax, i1
	  mov cx, i2
	  neg cx
	  mov bx, k
	  cmp bx, 0
	  jge f2
	  	add cx, 10	;max(i1,10-i2), при k<0
	  	cmp cx, ax
	  	jg step1
	  	  mov cx, ax	;если ах было > cx
	  	  jmp MainFinal
	  	step1:
	  	  jmp MainFinal
	  	
	  f2:	;|i1 - i2| , при k>=0
	  	add cx, ax
	  	cmp cx, 0
	  	jg step2
	      neg cx
	  	step2:	  	
	  MainFinal:           ; в cx лежит значение функции f2
      ret
Main      ENDP
CODE      ENDS
END Main 
