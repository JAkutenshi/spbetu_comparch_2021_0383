ASSUME CS:CODE, DS:DATA, SS:STACK

STACK    SEGMENT  STACK
          DW 1024 DUP(?)
STACK    ENDS

DATA SEGMENT
        KEEP_CS DW 0 ; для хранения сегмента
        KEEP_IP DW 0 ; и смещения вектора прерывания
        NUM DW 0
        MESSAGE DB 2 DUP(?)

DATA ENDS


CODE      SEGMENT

GetInt PROC
    push DX
    push CX

    xor     cx, cx ; cx - количество цифр
    mov     bx, 10 ; основание системы счисления
gi2:
    xor     dx,dx
    div     bx ; деление числа на основание сс и сохранение остатка в стеке
    push    dx
    inc     cx;
    test    ax, ax ; проверка на 0
    jnz     gi2
; Вывод
    mov     ah, 02h
gi3:
    pop     dx
    add     dl, '0' ; перевод цифры в символ
    int     21h
    loop    gi3 ; переход, пока сх != 0
    
    POP CX
    POP DX
    ret
 
GetInt endp


SUBR_INT PROC FAR
        JMP start_proc
        
        save_SP DW 0000h
        save_SS DW 0000h
        INT_STACK DB 40 DUP(0)
start_proc:

    MOV save_SP, SP
    MOV save_SS, SS
    MOV SP, SEG INT_STACK
    MOV SS, SP
    MOV SP, offset start_proc
    PUSH AX    ; сохранение изменяемых регистров
    PUSH CX
    PUSH DX
    
    mov AH, 00H
    int 1AH
    
    mov AX, CX
    call GetInt
    mov AX, DX
    call GetInt
    
    POP  DX
    POP  CX
    POP  AX   ; восстановление регистров
    MOV  SS, save_SS
    MOV  SP, save_SP
    MOV  AL, 20H
    
    OUT  20H,AL
       
    iret
    
SUBR_INT ENDP


Main      PROC  FAR

        push  DS       ;\  Сохранение адреса начала PSP в стеке
        sub   AX,AX    ; > для последующего восстановления по
        push  AX       ;/  команде ret, завершающей процедуру.
        mov   AX,DATA             ; Загрузка сегментного
        mov   DS,AX               ; регистра данных.

        MOV AH, 35H ; функция получения вектора
        MOV AL, 60H ; номер вектора
        INT 21H ; возвращает текущее значение вектора прерывания
        MOV KEEP_IP, BX ; запоминание смещения
        MOV KEEP_CS, ES ; и сегмента вектора прерывания

        PUSH DS
        MOV DX, OFFSET SUBR_INT ; смещение для процедуры в DX
        MOV AX, SEG SUBR_INT ; сегмент процедуры
        MOV DS, AX ; помещаем в DS
        MOV AH, 25H ; функция установки вектора
        MOV AL, 60H ; номер вектора
        INT 21H ; меняем прерывание
        POP DS
        
        int 60H; вызов измененного прерывания

        CLI
        PUSH DS
        MOV DX, KEEP_IP
        MOV AX, KEEP_CS
        MOV DS, AX
        MOV AH, 25H
        MOV AL, 60H
        INT 21H ; восстанавливаем старый вектор прерывания
        POP DS
        STI

        RET
Main      ENDP
CODE      ENDS
    END Main 
