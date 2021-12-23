Astack SEGMENT STACK
    DW  1024    DUP(?)
Astack ENDS
;перед выполнением прерывания нужно сохранить в стек значение CS::IP, чтобы к ней обратиться в последствии
;а в cs::ip записать адрес программы обработки прерывания
DATA SEGMENT
    KEEP_CS DW 0
    KEEP_IP DW 0

DATA ENDS



CODE SEGMENT
ASSUME CS:CODE, DS:DATA, SS:Astack

;вектор прерывания это программа по обработке прерывания
;ее адрес состоит из 4 байт, в первых двух хранится значение IP, а во вторых - CS

print_cmos PROC FAR
    
        out        70h,al               ; послать AL в индексный порт CMOS
        in         al,71h               ; прочитать данные
    mov cl, 128 ;будем проверять через значение в cx
	print:
    push ax
    and al, cl
    cmp al,0
    je zero

    mov al, '1'
    jmp continue

    zero:
    mov al, 48
    continue:
    int 29h 
	pop ax
    shr cl, 1
	cmp cl, 1 
    jge print
    jmp end
    end:
    ret
print_cmos endp

MY_INT PROC FAR
    push ax
    push bx
    push cx
    mov al, 08h
    out 70h, al
    in al, 71h
    
    mov al, 4h

    call print_cmos

    mov al, ';'
    int 29h

    mov al, 2h

    call print_cmos

    mov al, ';'
    int 29h

    mov al, 0h

    call print_cmos
    pop cx
    pop bx
    pop ax  


    mov al, 20H
    out 20H, al
    iret

MY_INT ENDP

MAIN PROC FAR
    push ds
    sub ax, ax
    push ax
    mov ax, DATA
    mov ds, ax
    
    ; записывание текущего вектора прерывания
    mov ah, 35H ;функция получения вектора
    mov al, 1CH;номер вектора
    int 21h
    mov KEEP_IP, bx; запоминания смещения
    mov KEEP_CS, es; и сегмента вектора прерывания

    ; установка нового вектора прерывания
    push ds
    mov dx, OFFSET MY_INT;смещения для процедуры в DX
    mov ax, SEG MY_INT; сегмент процедуры
    mov ds, ax; помещаем сегмент процедуры в ds
    mov ah, 25H; функция установки вектора
    mov al, 60H; номер вектора
    int 21H; меняем прерывание
    pop ds
    
    int 60H

    CLI
    push ds
    mov dx, KEEP_IP
    mov ax, KEEP_CS
    mov ds, ax
    mov ah, 25H
    mov al, 1CH
    int 21H; восстанавливаем старый вектор прерывания
    pop ds
    sti


MAIN ENDP
CODE ENDS
    END MAIN










