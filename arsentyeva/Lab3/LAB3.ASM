; Стек  программы
AStack    SEGMENT  STACK
          DW 12 DUP('!')    ; Отводится 12 слов памяти
AStack    ENDS

; Данные программы
DATA      SEGMENT

;  Директивы описания данных
a      DW    15
b      DW    15
i      DW    8
k      DW    -110
i1     DW    0
i2     DW    0
DATA      ENDS

; Код программы
CODE      SEGMENT
          ASSUME CS:CODE, DS:DATA, SS:AStack

; Головная процедура
Main      PROC  FAR
          push  DS       ;\  Сохранение адреса начала PSP в стеке
          sub   AX,AX    ; > для последующего восстановления по
          push  AX       ;/  команде ret, завершающей процедуру.
          mov   AX,DATA   ; Загрузка сегментного
          mov   DS,AX     ; регистра данных.
          
          ;вычисление функций
          mov cx, i
          shl cx, 1
          add cx, i
          mov ax, cx     ; ax = 3i
          mov cx, b 
          cmp a, cx       ; сравниваем значения a и b
          jle LessEqual     ; если a <= b, то тогда переходим к f4second
              mov cx, 4     ; вычисление f4
              sub cx, ax
              sub cx, ax
              mov i1, cx
              mov cx, 5     ; вычисление f7
              sub cx, ax
              sub cx, i
              mov i2, cx
              jmp F2
          LessEqual:  
              mov cx, 6     ; вычисление f4
              add cx, ax
              mov i1, cx
              mov cx, 10    ; вычисление f7
              sub cx, ax
              mov i2, cx

          F2:    ; рассчет f2 , cx = i2
          neg cx
          cmp k, 0
          jge GreaterEqual
              add cx, 10
              cmp i1, cx
              jl MainExit  
              mov cx, i1    ; |i1| >= 10-i2
	          jmp MainExit
          GreaterEqual:
              add cx, i1
              cmp cx, 0
              jge MainExit
	          neg cx
	          jmp MainExit
          MainExit:    ; в cx лежит значение функции f2
              ret      ; Выход в DOS по команде, находящейся в 1-ом слове PSP.

Main      ENDP
CODE      ENDS
          END Main
