; Стек  программы
AStack SEGMENT  STACK
    DW 12 DUP(?)
AStack  ENDS
;Данные программы
DATA      SEGMENT
;Директивы описания данных
a      DW    6
b      DW    4
i      DW    3
k      DW    -2
i1     DW    0
i2     DW    0
T      DW    0

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
            
      mov cx, i
      mov ax, cx
      shl cx, 1
      shl cx, 1 ; C = 4i
	  mov T, cx ; T = 4i
	  add T, ax
      add T, ax ; T = 6i
	  mov bx, b
      cmp a, bx
	  
	  ; a>b
	  jle f83less
		mov ax, cx
        mov cx, 7
        sub cx, ax
        mov i1, cx
		add T, 8
        neg T
		mov cx, T
        mov i2, cx
		jmp final
		
	  ; a<b
	  f83less: 	  
        mov ax, T
        mov cx, 8
        sub cx, ax
		mov i1, cx
		mov cx, i
        add cx, -1
        mov ax, cx
        shl cx, 1
        shl cx, 1
        sub cx, ax
        neg cx
        add cx, 9
        mov i2, cx
	  
      ;рассчет f6
	  final:
      mov bx, k
      cmp bx, 0
      jl f6Second
        mov bx, ax
        cmp bx, 7
		mov cx, i2
        cmp cx, 0
        jge skip2     
          neg cx
          mov ax, cx
        skip2:
        jl max1
          mov cx, bx       ; |i2| >= 7
          jmp MainFinal
        max1:
          mov cx, 7        ; |i2| < 7
          jmp MainFinal
        f6Second:
        mov cx, i1
        sub cx, i2
        cmp cx, 0
        jge MainFinal
            neg cx
            jmp MainFinal
      MainFinal:          
      ret
Main      ENDP
CODE      ENDS
END Main