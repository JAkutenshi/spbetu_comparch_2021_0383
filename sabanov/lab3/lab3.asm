DOSSEG
.MODEL SMALL
.STACK 100h

.DATA

a   DW    1
b   DW    2
i   DW    3
i1  DW    0
i2  DW    0
k   DW    4

.CODE

abs PROC NEAR
@abs:
    neg ax
    js @abs
    ret
abs ENDP

max PROC NEAR

    cmp ax, dx
    jnl max_exit

    mov ax, dx

max_exit:
    ret
max ENDP

Main PROC FAR
    mov ax, @data
    mov ds, ax

;f1(int a, int b, int i) {
;    if (a > b)
;        return -(4*i + 3);
;    return 6*i - 10;
;}
;return in ax

    mov ax, i
    mov bx, a
    mov cx, b
    cmp bx, cx
    jng f1_2

    mov bx, 4
    mul bx
    add ax, 3
    neg ax
    jmp f1_exit

f1_2:
    mov bx, 6
    mul bx
    sub ax, 10

f1_exit:
    mov i1, ax

;f2(int a, int b, int i) {
;    int c = 3*(i+2);
;    if (a > b)
;        return -2*c;
;    return c;
;}
;return in ax

    mov ax, i
    add ax, 2
    mov bx, 3
    mul bx

    mov bx, a
    mov cx, b
    cmp bx, cx
    jg f2_exit

    mov bx, -2
    imul bx

f2_exit:
    mov i2, ax

;f3(int i1, int i2, int k) {
;    if (k < 0)
;        return |i1| + |i2|;
;    return max(|i1|, 6);
;}
;return in ax

    mov ax, i1
    call abs

    cmp word ptr k, 0
    jnl f3_2

    mov bx, ax
    mov ax, i2
    call abs
    add ax, bx
    jmp f3_exit

f3_2:
    mov bx, 6
    cmp ax, bx
    jnl f3_exit

    ; |i1| < 6
    mov ax, bx

f3_exit:

    ; f3(i1,i2,k) in ax

    mov ah, 4ch
    int 21h
Main ENDP
END Main
