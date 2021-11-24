;───────┼───────┼──────────────────────────────────────────┤
;       │ vec1  │  18,17,16,15,11,12,13,14                 │
;   6   │ vec2  │  30,40,-30,-40,10,20,-10,-20             │
;       │ matr  │  -4,-3,1,2,-2,-1,3,4,5,6,7,8,-8,-7,-6,-5 │
;───────┼───────┼──────────────────────────────────────────┤
;
;
; Программа изучения режимов адресации процессора IntelX86
EOL EQU '$'
ind  EQU   2
n1   EQU  500
n2   EQU  -50

; Стек  программы
AStack SEGMENT  STACK
    DW 12 DUP(?)
AStack  ENDS
;Данные программы
DATA      SEGMENT
;Директивы описания данных
mem1      DW    0
mem2      DW    0
mem3      DW    0
vec1      DB    18,17,16,15,11,12,13,14
vec2      DB    30,40,-30,-40,10,20,-10,-20
matr      DB    -4,-3,1,2,-2,-1,3,4,5,6,7,8,-8,-7,-6,-5
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

;  ПРОВЕРКА РЕЖИМОВ АДРЕСАЦИИ НА УРОВНЕ СМЕЩЕНИЙ
;  Регистровая адресация
        mov  ax,n1
        mov  cx,ax
        mov  bl,EOL
        mov  bh,n2
;  Прямая   адресация
        mov  mem2,n2
        mov  bx,OFFSET vec1
        mov  mem1,ax
;  Косвенная адресация
        mov  al,[bx]
        ;mov  mem3,[bx] -> lab2.asm(54): error A2052: Improper operand type -> 
        	;Инструкция MOV пересылает один байт или слово только между регистрами или регистром и памятью
        	;и НЕ может передавать данные между двумя адресами памяти
;  Базированная адресация
        mov  al,[bx]+3
        mov  cx,3[bx]
;  Индексная адресация
        mov  di,ind
        mov  al,vec2[di]
        ;mov  cx,vec2[di] -> lab2.asm(61): warning A4031: Operand types must match ->
        	;Размеры операндов не совпадают, CX - регистр размера 2 байт, vec2[di] - ячейка памяти размера 1 байт
;  Адресация с базированием и индексированием
        mov  bx,3
        mov  al,matr[bx][di]
        ;mov  cx,matr[bx][di] lab2.asm(65): warning A4031: Operand types must match ->
        	;Размеры операндов не совпадают, CX - регистр размера 2 байт, matr[bx*4][di] - ячейка памяти размера 1 байт
        ;mov  ax,matr[bx*4][di] lab2.asm(66): error A2055: Illegal register value ->
        	;Недопустимое значение регистра, попытка расширения 16-разрядного регистра

;  ПРОВЕРКА РЕЖИМОВ АДРЕСАЦИИ С УЧЕТОМ СЕГМЕНТОВ
;  Переопределение сегмента
;  ------ вариант 1
        mov  ax, SEG vec2
        mov  es, ax
        mov  ax, es:[bx]
        mov  ax, 0
;  ------ вариант 2
        mov  es, ax
        push ds
        pop  es
        mov  cx, es:[bx-1]
        xchg cx,ax
;  ------ вариант 3
        mov  di,ind
        mov  es:[bx+di],ax
;  ------ вариант 4
        mov  bp,sp
        ;mov  ax,matr[bp+bx] lab2.asm(86): error A2046: Multiple base registers -> 
        	;Попытка использовать несколько базовых регистров одновременно
        ;mov  ax,matr[bp+di+si] lab2.asm(87): error A2047: Multiple index registers ->
        	;Попытка использовать несколько индексных регистров одновременно
;  Использование сегмента стека
        push  mem1
        push  mem2
        mov   bp,sp
        mov   dx,[bp]+2
        ret   2
Main      ENDP
CODE      ENDS
END Main

