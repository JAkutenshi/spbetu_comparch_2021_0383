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
    JMP start
    KEEP_SS DW 0
    KEEP_SP DW 0
    KEEP_AX DW 0
	IStack DW 30 DUP(?)
	
sound PROC
    MOV CX, 1000
	MOV AL, 10110110b ; 0B6H
	OUT 43H, AL ; Код для установления канала 2 таймера-счетчика на работу в качестве делителя частоты см. методу
	MOV AX, CX ; Заносим в AX высоту звука
	OUT 42H, AL
	MOV AL, AH
	OUT 42H, AL ; Заносим поочередно 2 байта в порт 42h(регистр канала 2)
	IN AL, 61H ; генерация звука путём сдвига диффузора туда-обратно
	MOV AH, AL
	OR AL, 3
	OUT 61H, AL
	SUB CX, CX

	WHILE_SOUND:
	NOP
	LOOP WHILE_SOUND ; Цикл, пока динамик работает

	MOV AL, AH
	OUT 61H, AL
    
    RET
sound ENDP

start:
    MOV KEEP_SP, SP
    MOV KEEP_AX, AX
    MOV AX, SS
    MOV KEEP_SS, AX
    MOV AX, KEEP_AX
    MOV SP, OFFSET start
    MOV SS, AX

    PUSH AX    ; сохранение изменяемых регистров
    PUSH DX 
 ;---------------------------------------------
    INT 21h ; вызов прерывания ms-dos
	CALL sound
 ;-----------------------------
	
    pop DX 
    pop AX 
    MOV  KEEP_AX, AX
    MOV SP, KEEP_SP
    MOV AX, KEEP_SS
    MOV SS, AX
    MOV AX, KEEP_AX

    MOV al,20h
    OUT 20h,al
    IRET
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
    MOV ah, 0
    INT 16h
    CMP al, 3  ;код символа после нажатия 
    JNE ctrl_c

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