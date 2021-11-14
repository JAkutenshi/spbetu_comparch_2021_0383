

EOFLine  EQU  '$'



ASSUME CS:CODE, SS:AStack

AStack    SEGMENT  STACK
          DW 12 DUP(?)
AStack    ENDS



DATA      SEGMENT
a   DW  9
b   DW  6
i   DW  8
k   DW  -1
i1  DW  0
i2  DW  0
res DW  0


DATA      ENDS

CODE      SEGMENT
  ASSUME CS:CODE, DS:DATA, SS:AStack

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
          mov bx, b
          cmp a, bx
          ; Система f1, f1s - при a <= b
          jle f12
            ; вычисление i1 при a > b
            neg cx
            add cx, 15
            mov i1, cx
            ; вычисление i2 при a > b
            shl cx, 1
            sub cx, ax
            sub cx, ax
            sub cx, 38
            mov i2, cx
            jmp takeModule
          f12: ; a <= b
            ; вычисление i1 при a <= b
            add cx, ax
            add cx, 4
            mov i1, cx
            ; вычисление i2  при a <= b
            neg cx
            add cx, 16
            mov i2, cx

          takeModule:
          ; взятие модуля от i1
          cmp i1, 0
          jg skip1
              mov cx, i1
              neg cx
              mov i1, cx
          skip1:
          cmp k, 0

          ; Вычисление res = f3, f3s при k < 0
          jl f3s

            cmp i1, 6
            jg first_bigger

            mov res, 6
            jmp Mainend

            first_bigger:
              mov cx, i1
              mov res, cx
              jmp Mainend
          f3s: ; k < 0
          cmp i2, 0
          jg skip2
            mov cx, i2
            neg cx
            mov i2, cx
          skip2:
             mov cx, i1
             add cx, i2
             mov res, cx
          Mainend:
          ret

Main      ENDP
CODE      ENDS
          END Main
