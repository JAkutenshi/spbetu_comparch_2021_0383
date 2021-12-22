ASSUME CS:CODE, DS:DATA, SS:STACK

STACK    SEGMENT  STACK
          DW 1024 DUP(?)
STACK    ENDS

DATA SEGMENT
        KEEP_CS DW 0
        KEEP_IP DW 0
        NUM DW 0
        MESSAGE DB 2 DUP(?)

DATA ENDS


CODE      SEGMENT

getInt PROC
    push dx
    push cx

    xor cx, cx
    mov bx, 10

    L1:
    xor dx, dx
    div bx
    push dx
    inc cx
    test ax, ax
    jnz L1

    mov ah, 02h

    L2:
    pop dx
    add dl, '0'
    int 21h
    loop L2

    pop cx
    pop dx

    ret
getInt ENDP


SUBR_INT PROC FAR

    jmp start_proc

    save_SP DW 0000h
    save_SS DW 0000h
    INT_STACK DB 40 DUP(0)

start_proc:
    MOV save_SP, SP
    MOV save_SS, SS
    MOV SP, SEG INT_STACK
    MOV SS, SP
    MOV SP, offset start_proc
    PUSH AX
    PUSH CX
    PUSH DX

    mov AH, 00H
    int 1AH

    mov ax, cx
    call getInt
    mov ax, dx
    call getInt

    pop dx
    pop cx
    pop ax
    mov ss, save_SS
    mov sp, save_SP
    mov al, 20H

    out 20H, al

    iret

SUBR_INT ENDP


Main PROC FAR
    push  DS
    sub   AX,AX
    push  AX
    mov   AX,DATA
    mov   DS,AX
    MOV AH, 35H
    MOV AL, 60H
    INT 21H
    MOV KEEP_IP, BX
    MOV KEEP_CS, ES

    PUSH DS
    MOV DX, OFFSET SUBR_INT
    MOV AX, SEG SUBR_INT
    MOV DS, AX
    MOV AH, 25H
    MOV AL, 60H
    INT 21H
    POP DS

    int 60H

    CLI
    PUSH DS
    MOV DX, KEEP_IP
    MOV AX, KEEP_CS
    MOV DS, AX
    MOV AH, 25H
    MOV AL, 60H
    INT 21H
    POP DS
    STI

    RET
Main      ENDP
CODE      ENDS
    END Main