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
      shl cx, 1 ; cx = 2i
      mov ax, cx
      add ax, i ; ax = 3i
      mov bx, b
      cmp a, bx
      
      ; a>b
      jle f2f6
        sub cx, 2
        mov i2, cx
        shl cx, 1
        neg cx
        sub cx, 7
        mov i1, cx
        jmp final
        
      ; a<=b
      f2f6:
        mov cx, ax
        sub cx, 2
        neg cx
        mov i2, cx
        neg cx
        shl cx, 1
        sub cx, 6
        mov i1, cx
      
      ; рассчет f5
      final:
      mov ax, i1
      cmp ax, 0
      jge gr1
      neg ax
      gr1:
      mov bx, k
      cmp bx, 0
      je f5second
      mov cx, i2
      cmp cx, 0
      jge gr2
      neg cx
      gr2:
      add cx, ax
      jmp MainFinal
      f5second:
      cmp ax, 6
      jge min
      mov cx, ax    ; |i1| < 6
      jmp MainFinal
      min:
      mov cx, 6     ; |i1| >= 6
      jmp MainFinal
      MainFinal:
      ret
      
Main      ENDP
CODE      ENDS
END Main
