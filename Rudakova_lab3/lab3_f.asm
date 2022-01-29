; Стек  программы
AStack SEGMENT  STACK
    DW 12 DUP(?)
AStack  ENDS
;Данные программы
DATA      SEGMENT
;Директивы описания данных
a      DW    2
b      DW    1
i      DW    -2
k      DW    3
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
            
      mov cx, i
      mov ax, cx
      shl cx, 1
      shl cx, 1 ; C = 4i
	  mov bx, b
      cmp a, bx
	  
	  ; a>b
	  jle f27
		mov ax, cx
		add cx, 3
		neg cx
        mov i1, cx
		sub ax, 5
        neg ax
        mov i2, ax
		jmp final
		
	  ; a<b
	  f27:
		sub cx, ax ;3i
		mov ax, cx
		neg cx ;-3i
        sub cx, 10
		mov i2, cx
		mov cx, ax
        add ax, cx ;6i
        sub ax, 10
        mov i2, ax
	  
      ;рассчет f4
	    final:
        mov bx, k
        cmp bx, 0
        jge next
	    mov cx, i1
        sub cx, i2
        cmp cx, 0
        jge skip     
          neg cx
        skip:
	    cmp cx, 2
        jge min
          jmp Fin       ; | | < 2
        min:
          mov cx, 2        ; | | >= 2
          jmp Fin
        next:
		mov ax, i2
		neg ax
        cmp ax, -6 
        jl max
          mov cx, ax      ; |-i2| >= -6
          jmp Fin
        max:
          mov cx, -6        ; |-i2| < -6
          jmp Fin
      Fin:          
      ret
Main      ENDP
CODE      ENDS
END Main