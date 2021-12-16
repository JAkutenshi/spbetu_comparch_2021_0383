DATA SEGMENT
        KEEP_CS DW 0 ; для хранения сегмента
        KEEP_IP DW 0 ; и смещения вектора прерывания
		TMP1 DW 0
		TMP2 DW 0
		TMP3 DW 0
        HELLO   DB 'Hi there!',10,13,'$'
		MESEND   DB 'End!',10,13,'$'

DATA ENDS


AStack    SEGMENT  STACK
          DW 12 DUP(?)
AStack    ENDS



CODE      SEGMENT
          ASSUME CS:Code, DS:DATA, SS:AStack

SUBR_INT PROC FAR
        jmp start_proc

        ST_SS DW 0000
        ST_AX DW 0000
        ST_SP DW 0000
        IStack DW 30 DUP(?)
start_proc:

    mov ST_SP, SP
	mov ST_AX, AX
	mov AX, SS
	mov ST_SS, AX
	mov AX, IStack
	mov SS, AX
	mov AX, ST_AX
	push ax
	push ds
	
	MOV   DX, OFFSET HELLO
	MOV   AH,9
	metka:
	int   21h  ; Вызов функции DOS по прерыванию
	loop metka ; Вывод сообщения заданное число раз

	mov di,32
	mov ah,0
	int 1Ah
	mov bx,dx; счетчик с момента сброса
Delay:
	mov ah,0
	int 1Ah
	sub dx,bx
	cmp di,dx
	ja Delay;переход,если больше
	
	MOV DX, OFFSET MESEND ;Выводсообщенияозавершении обработчика
	MOV AH,9
	int 21h
	pop dx
    pop ax
	mov ST_AX,AX
	mov AX,ST_SS
	mov SS,AX
	mov SP,ST_SP
	mov AX,ST_AX
	mov al,20h
	out 20h,al
       
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
		
		mov cx, 10
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