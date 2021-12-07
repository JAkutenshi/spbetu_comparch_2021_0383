STACK SEGMENT STACK
	DW 1024 DUP (?)
STACK ENDS

DATA      SEGMENT
	KEEP_CS DW 0 ; для хранения сегмента
    KEEP_IP DW 0 ; и смещения прерывания
DATA      ENDS

CODE      SEGMENT
    ASSUME CS:CODE, DS:DATA, SS:STACK

MY_INT  PROC FAR
	JMP start
	spec_SP DW 0000h
	spec_SS DW 0000h
	SPEC_STACK DB 40 DUP(0)
start:
	MOV spec_SP, SP
	MOV spec_SS, SS
	MOV SP, SEG SPEC_STACK
	MOV SS, SP
	MOV SP, offset start
	PUSH AX    ; сохранение изменяемых регистров
	PUSH CX
		
            ;<действия по обработке прерывания>
	MOV CX, AX
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
	WHILE_TIME:
	NOP
	LOOP WHILE_TIME ; Цикл, пока динамик работает
	MOV AL, AH
	OUT 61H, AL ; Выключение динамика (изначальное значение порта 61h)
            ;<конец действий по обработке прерывания>
	POP  CX
	POP  AX   ; восстановление регистров
	MOV  SS, spec_SS
	MOV  SP, spec_SP
	MOV  AL, 20H
	OUT  20H,AL
	IRET
MY_INT  ENDP

Main	PROC  FAR
	; <Запоминание текущего вектора прерывания>
	MOV  AH, 35H   ; функция получения вектора
	MOV  AL, 23H   ; номер вектора
	INT  21H
	MOV  KEEP_IP, BX  ; запоминание смещения
	MOV  KEEP_CS, ES  ; и сегмента
	
	; <Установка вектора прерывания>
	PUSH DS
	MOV  DX, OFFSET MY_INT ; смещение для процедуры в DX
	MOV  AX, SEG MY_INT    ; сегмент процедуры
	MOV  DS, AX          ; помещаем в DS
	MOV  AH, 25H         ; функция установки вектора
	MOV  AL, 23H         ; номер вектора
	INT  21H             ; меняем прерывание
	POP  DS
	
	ctrl_c:
    mov ah, 0
    int 16h
    cmp al, 3  ;код символа после нажатия 
    jne ctrl_c
	
	mov ax, 1000
	int 23h
	

	; <Восстановление изначального вектора прерывания>
	CLI
	PUSH DS
	MOV  DX, KEEP_IP
	MOV  AX, KEEP_CS
	MOV  DS, AX
	MOV  AH, 25H
	MOV  AL, 23H
	INT  21H          ; восстанавливаем вектор
	POP  DS
	STI
	
	MOV AH, 4Ch                          
	INT 21h
Main      ENDP
CODE ENDS
	END Main 