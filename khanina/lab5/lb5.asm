AStack  SEGMENT STACK
    DB 1024 DUP(?)
AStack  ENDS

DATA    SEGMENT
    KEEP_CS DW 0    ;хранение сегмента
    KEEP_IP DW 0    ;хранение смещения вектора прерывания
DATA    ENDS

CODE    SEGMENT
    ASSUME CS:CODE, DS:DATA, SS:AStack

my_int PROC FAR
    jmp start
    KEEP_SS DW 0
    KEEP_SP DW 0
    KEEP_AX DW 0
	IStack DW 30 DUP(?)
	
hours proc
    mov al,ch
    call two_digit
    ret
hours endp
 
minutes proc
    mov al,cl
    call two_digit
    ret
minutes endp
 
seconds proc
    mov al,dh
    call two_digit
    ret
seconds endp
 
colon proc
    mov ah,2
    mov dl,':'
    int 21h
    ret
colon endp
 
two_digit proc  ;Процедура вывода двузначного числа.
    push dx
        aam 
        add ax,3030h 
        mov dl,ah 
        mov dh,al 
        mov ah,02 
        int 21h 
        mov dl,dh 
        int 21h
    pop dx
    ret
two_digit endp

start:
    MOV KEEP_SP, SP
    MOV KEEP_AX, AX
    MOV AX, SS
    MOV KEEP_SS, AX
    MOV AX, KEEP_AX
    MOV SP, OFFSET start
    MOV SS, AX

    push AX    ; сохранение изменяемых регистров
    push DX 
 ;---------------------------------------------
	push ax     
    mov ah, 2ch   ; помещаем код функции 2ch - получить сис время
    int 21h ; вызов прерывания ms-dos
    pop ax 
	call hours
	call colon
	call minutes
	call colon
	call seconds
 ;-----------------------------
	
    pop DX 
    pop AX 
    MOV  KEEP_AX, AX
    MOV SP, KEEP_SP
    MOV AX, KEEP_SS
    MOV SS, AX
    MOV AX, KEEP_AX

    mov al,20h
    out 20h,al
    iret
my_int ENDP

MAIN PROC FAR
    MOV AX, DATA
    MOV DS, AX  ; сохраняем вектор прерывания
    MOV AH, 35H ; функция получения вектора
	MOV AL, 23H ; номер нужного вектора
	INT 21H
	MOV KEEP_IP, BX ; запоминание смещения
	MOV KEEP_CS, ES ; и сегмента вектора прерывания

    PUSH DS
    MOV DX, OFFSET my_int ; смещение для процедуры в DX
    MOV AX, SEG my_int ; сегмент процедуры
    MOV DS, AX; помещаем в DS
    MOV AH, 25H; функция установки вектора
    MOV AL, 23H; номер вектора
    INT 21H; меняем прерывание
    POP DS

ctrl_c:
    mov ah, 0
    int 16h
    cmp al, 3  ;код символа после нажатия 
    jne ctrl_c

    INT 23H

    CLI
    PUSH DS
    MOV DX, KEEP_IP
    MOV AX, KEEP_CS
    MOV DS, AX
    MOV AH, 25H
    MOV AL, 23H
    INT 21H
    ; восстанавливаем старый вектор прерывания
    POP DS
    STI

    MOV AH, 4CH
    INT 21H

MAIN ENDP
CODE ENDS
END MAIN