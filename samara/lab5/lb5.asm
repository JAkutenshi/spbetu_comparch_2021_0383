DATA SEGMENT
        KEEP_CS DW 0 ; для хранения сегмента
        KEEP_IP DW 0 ; и смещения вектора прерывания
        HELLO   DB 'Hello World!',10,13,'$' 
DATA ENDS

AStack    SEGMENT  STACK
          DW 512 DUP(?)    ;
AStack    ENDS


CODE      SEGMENT
          ASSUME CS:Code, DS:DATA, SS:AStack

SUBR_INT PROC FAR
        jmp start_proc

        ss_int dw 0
	    sp_int dw 0
        int_stack  DW 20 DUP(?)

start_proc:
    mov ss_int, ss
	mov sp_int, sp

    push dx
	push cx
	push bx
	push ax
	push ax

	mov al, 0
print_msg:
    MOV   AH,9
    MOV   DX, OFFSET HELLO
	int   21h  ; Вызов функции DOS по прерыванию

delay_count:
    pop cx
	dec cl
	jz ending
	push cx

	cmp al, 0   ;al - текущая задержка
	je one

	shl al, 1
	jmp start

one: 
    inc al

start:
    mov bl, al  ;bl - отсчет секунд, bh - текущий номер секунды
	mov  ah, 2ch
	int  21h 
	mov bh, dh

Delay:
	nop
	mov  ah, 2ch
	int  21h 
	cmp dh, bh
	je Delay

    mov  bh, dh      
	dec  bl   
	jnz Delay
	jmp print_msg

ending:
	pop ax
	pop bx
	pop cx
	pop dx
	
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
		
		mov al, 5
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