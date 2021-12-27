DOSSEG

.MODEL SMalL

.STaCK 100h

.DaTa

keep_cs dw 0
keep_ip dw 0

; номер вектора прерывания
vector_n db 08h

.CODE

; функция-обработчик прерывания
; void interruption();
interfunction proc far

     jmp interfunction_start

interfunction_keep_ss dw 0
interfunction_keep_sp dw 0
interfunction_stack db 40 dup('#')
interfunction_stack_end:

interfunction_start:

    ; сохраняем стек
    mov interfunction_keep_ss, ss
    mov interfunction_keep_sp, sp

    ; устанавливаем новый стек
    mov sp, seg interfunction_stack_end
    mov ss, sp
    mov sp, offset interfunction_stack_end

    ; сохраняем регистры
    push ax
    push bx
    push cx
    push dx

            ;<действия по обработке прерывания>
    mov ax, 8000 ; частота звука
    mov cx, ax
    mov al, 10110110b
    out 43h, al ; код для установления канала 2 таймера-счетчика на работу в качестве делителя частоты
    mov ax, cx ; заносим в ax высоту звука
    out 42h, al
    mov al, ah
    out 42h, al ; заносим поочередно 2 байта в порт 42h
    in al, 61h
    mov ah, al
    or al, 3
    out 61h, al ; установление битов 0 и 1 в единицу
    xor cx, cx ; cx = 0
    loop $ ; цикл, пока динамик работает
    mov al, ah
    out 61h, al ; выключение динамика (изначальное значение порта 61h)
            ;<конец действий по обработке прерывания>

    ; разрешение обработки прерываний с более низкими уровнями, чем только что обработанное
    mov al, 20h
    out 20h, al

    ; восстанавливаем регистры
    pop dx
    pop cx
    pop bx
    pop ax

    ; восстанавливаем стек
    mov sp, interfunction_keep_sp
    mov ss, interfunction_keep_ss

    iret

interfunction endp

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
    cli
    mov bh, vector_n ; в bh номер вектора
    push ds
    mov dx, offset interfunction
    mov ax, seg interfunction
    mov ds, ax
    mov ah, 25h ; функция установки вектора
    mov al, bh ; номер вектора
    int 21h
    pop ds
    sti

    ; ждём нажатия клавиши
    mov ah, 1
    int 21h

    ; возвращаем сохранённую функцию прерывания
    cli
    mov bh, vector_n ; в bh номер вектора
    push ds
    mov dx, keep_ip
    mov ax, keep_cs
    mov ds, ax
    mov ah, 25h ; функция установки вектора
    mov al, bh ; номер вектора
    int 21h
    pop ds
    sti

    ; выход из программы
    mov ah, 4ch
    xor al, al
    int 21h

main endp

end main
