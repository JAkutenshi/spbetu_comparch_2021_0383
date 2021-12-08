; Стек  программы
AStack SEGMENT  STACK
           DW 12 DUP(?)
AStack  ENDS
;Данные программы
DATA SEGMENT
    ;Директивы описания данных
    a     DW 10
    b     DW 5
    i     DW 5
    k     DW 4
    i1    DW 0
    i2    DW 0
    res   DW 0


DATA      ENDS

; Код программы
CODE SEGMENT
           ASSUME CS:CODE, DS:DATA, SS:AStack
      
; Головная процедура
Main PROC  FAR
    push   ds
    sub    ax, ax
    push   ax
    mov    ax, DATA
    mov    ds, ax
    
    mov    ax, i ; ax = i
    shl    ax, 1 ; ax = 2i

    mov    bx, b
    cmp    a, bx
    jle    less_equal
         
    ; a > b
    ; f1
    mov    cx, 15
    sub    cx, ax
    mov    i1, cx

    ; f3
    shl    ax, 1 ; ax = 4i
    mov    cx, 7
    sub    cx, ax
    mov    i2, cx

    jmp    fin
        
    ; a <= b
    less_equal:
    ; f1
    add    ax, 1 ; ax = 3i
    mov    cx, ax
    add    cx, 4
    mov    i1, cx

    ; f3
    shl    ax, 1 ; ax = 6i
    mov    cx, 8
    sub    cx, ax
    mov    i2, cx
      
    ; f2
    fin:   
    mov    bx, k
    mov    cx, i1
    mov    ax, i2

    cmp    bx, 0
    jl     negk

    sub    cx, ax

    cmp    cx, 0
    jge    abs_skip
    neg    cx
    abs_skip:

    mov    res, cx
    jmp    result

    negk:
    mov    dx, 10
    sub    dx, ax

    cmp    dx, cx
    jg     max
    mov    res, cx
    jmp    result

    max:
    mov    res, dx


    result:
    ret
Main ENDP
CODE      ENDS
END Main 