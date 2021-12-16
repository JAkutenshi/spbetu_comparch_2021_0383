AStack SEGMENT STACK
    DW 1024 DUP(?) 
AStack ENDS
DATA SEGMENT
  KEEP_CS DW 0 ; для хранения сегмента
  KEEP_IP DW 0 ; и смещения вектора прерывания

DATA ENDS
CODE SEGMENT
ASSUME CS:CODE, DS:DATA, SS:AStack
SUBR_INT PROC FAR ; звуковое прерывание от таймера
  jmp h_start
  save_ss dw 0000h
  save_sp dw 0000h
  ind_stack dw 512 DUP(?)
  h_start:


    mov save_ss, SS
    mov save_sp, sp
    mov sp, seg ind_stack
    mov ss, sp
    mov sp, OFFSET h_start
    PUSH CX ; сохранение изменяемых регистров
    PUSH AX

  MOV AL, 10110110b 	;цепочка для командного регистра 8253
  out 43h, al
  MOV AX, 500      ;высота звука
  OUT 42H, AL ;таймер 
  
  MOV AH, AL
  OUT 42H, AL 
  IN AL,61H ; получаем состояние динамика
  OR AL, 00000011b 
  OUT 61H, AL ; включается динамик
        
  mov cx, bx ;
  l: 
  NOP
  NOP
  NOP
  sub cx, 1
  cmp cx, 0
  jnz l ;играется звук, пока не закончится цикл
  
  
  MOV AL, AH
  OUT 61H, AL ;динамик выключается

  POP AX ;восстановление регистров
  POP CX
    mov ss, save_ss
  mov sp, save_sp
  MOV AL, 20H
  OUT 20H,AL ;вывод на порт
  IRET
  SUBR_INT ENDP

Main PROC FAR
  MOV AH, 35H ; функция получения вектора
  MOV AL, 08h ; номер вектора прерывания в соответствии с заданием
  INT 21H ; реализуется процедура прерывания
  MOV KEEP_IP, BX ; запоминание смещения
  MOV KEEP_CS, ES ; и сегмента вектора прерывания
  MOV BX, 1500 ; длительность звучания
  PUSH DS
  MOV DX, OFFSET SUBR_INT ; смещение для процедуры в DX
  MOV AX, SEG SUBR_INT ; сегмент процедуры
  MOV DS, AX ; помещаем в DS
  MOV AH, 25H ; функция установки вектора?
  MOV AL, 08h ; номер вектора
  INT 21H ; меняем прерывание
  POP DS

  mov ah, 0h
  int 16h

endInput:
  CLI ; Сброс флага прерываний IF - 0
  PUSH DS
  MOV DX, KEEP_IP
  MOV AX, KEEP_CS
  MOV DS, AX
  MOV AH, 25H
  MOV AL, 08h ;
  INT 21H ; восстанавливаем старый вектор прерывания
  POP DS
  STI
  MOV AH, 4Ch
  INT 21h
Main ENDP
CODE ENDS
END Main