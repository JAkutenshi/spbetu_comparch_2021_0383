DOSSEG

.MODEL SMALL

.STACK 100h

.DATA

keep_cs dw 0
keep_ip dw 0

.CODE

; номер вектора прерывания
vector_n db 08h

; функция-обработчик прерывания
; void interruption();
interfunction proc far

    ; сохраняем регистры
    push ax
    push bx
    push cx
    push dx

    ; выводим звук
    mov cx, 100 ; частота
    in al, 61h ; получаем значение из управляющего регистра порта B PPI (контроллера 8255)
    or al, 3 ; устанавливаем биты 0 и 1 (включить спикер и использовать 2-й канал для генерации импульсов спикера)
    out 61h, al ; выводим значение в управляющий регистр
    mov al, 10110110b ; управляющее слово таймера
    out 43h, al ; выводим значение в порт таймера
    mov dx, 12h
    mov ax, 34ddh ; DX:AX = 1193181 - частота работы таймера
    div cx ; значение счётчика таймера AX = DX:AX / CX
    out 42h, al ; выводим младший байт счетчика во 2-й канал таймера
    mov al, ah
    out 42h, al ; выводим старший байт

    ; разрешение обработки прерываний с более низкими уровнями, чем только что обработанное
    mov al, 20h
    out 20h, al

    ; восстанавливаем регистры
    pop dx
    pop cx
    pop bx
    pop ax

    iret

interfunction endp

disable_sound proc near
    push ax
    in al, 61h
    and al, not 3
    out 61h, al
    pop ax
    ret
disable_sound endp

main proc far

    mov ax, @data
    mov ds, ax

    ; сохраняем функцию прерывания
    mov ah, 35h ; функция получения вектора
    mov al, vector_n ; номер вектора
    int 21h
    mov keep_ip, bx ; запоминание смещения
    mov keep_cs, es ; запоминание вектора прерывания

    ; устанавливаем нашу функцию прерывания
    push ds
    mov dx, offset interfunction
    mov ax, seg interfunction
    mov ds, ax
    mov ah, 25h ; функция установки вектора
    mov al, vector_n
    int 21h
    pop ds

    ; ждём нажатия клавиши
    mov ah, 0
    int 16h

    ; возвращаем сохранённую функцию прерывания
    cli
    push ds
    mov dx, keep_ip
    mov ax, keep_cs
    mov ds, ax
    mov ah, 25h ; функция установки вектора
    mov al, vector_n
    int 21h
    pop ds
    sti

    ; выключаем звук
    call disable_sound

    ; выход из программы
    mov ah, 4ch
    xor al, al
    int 21h

main endp

end main
