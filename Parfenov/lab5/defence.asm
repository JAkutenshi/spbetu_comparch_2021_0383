
          ASSUME CS:Code, DS:DATA, SS:AStack
DATA SEGMENT
        KEEP_CS DW 0 ; для хранения сегмента
        KEEP_IP DW 0 ; и смещения вектора прерывания
		TMP1 DW 0
		TMP2 DW 0
		TMP3 DW 0
        size1 DB 10
        string DB 30 dup(0), 10, 13, '$'
		MESEND   DB 'End!',10,13,'$'

DATA ENDS


AStack    SEGMENT  STACK
          DW 12 DUP(?)    ; �⢮����� 12 ᫮� ������
AStack    ENDS



CODE      SEGMENT




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


    WORK_TIME:
	LOOP WORK_TIME

    mov ah,9h
    mov dx, offset string
    int 21h

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
        MOV AL, 08h ; номер вектора
        INT 21H ; возвращает текущее значение вектора прерывания
        MOV KEEP_IP, BX ; запоминание смещения
        MOV KEEP_CS, ES ; и сегмента вектора прерывания

        mov cx, 10

        lea bx,string
        mov ah, 1
        n1:

        int 21h
        mov [bx],al
        inc bx
        loop n1

        PUSH DS
        MOV DX, OFFSET SUBR_INT ; смещение для процедуры в DX
        MOV AX, SEG SUBR_INT ; сегмент процедуры
        MOV DS, AX ; помещаем в DS
        MOV AH, 25H ; функция установки вектора
        MOV AL, 08H ; номер вектора
        INT 21H ; меняем прерывание
        POP DS

        sub cx, cx

        esc1:
        mov ah, 10h
        int 16h
        cmp al, 27


        jne esc1


        CLI
        PUSH DS
        MOV DX, KEEP_IP
        MOV AX, KEEP_CS
        MOV DS, AX
        MOV AH, 25H
        MOV AL, 08H
        INT 21H ; восстанавливаем старый вектор прерывания
        POP DS
        STI

        RET
Main      ENDP
CODE      ENDS
          END Main 