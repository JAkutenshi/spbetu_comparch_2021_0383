data segment
    seconds  db 120
    delay    db 0
    
    keep_cs dw 0  
    keep_ip dw 0 
data ends

astack segment stack
    dw 512 dup(0)
astack ends

code segment
    assume cs:code, ss:astack, ds:data
sound_start proc near
	push	ax
	
	mov     al, 10110110b    ;цепочка для командного регистра 8253
	out     43h, al          ;посылаем в регистр

	mov     ax, bx


	out     42h, al          ;посылаем младший байт 
	mov     al, ah           ;посылаем в регистр 
	out     42h, al          ;посылаем старший байт


  
	in      al,61h          ;Получить состояние динамика
	or      al,03h          ;Установить бит
	out     61h,al          ;Включить динамик
  
  
	pop	ax
  ret
sound_start endp

sound_end proc near
	push	ax
  
 
	in      al,61h          ;Получить состояние динамика
	and     al,0fch         ;Установить бит
	out     61h,al          ;Выключить динамик
 

	pop	ax
	ret
sound_end endp


proc_delay proc near
push	ax
push 	dx
delaying:   
; получаем системное время
  mov  ah, 2ch
  int  21h ; 
 
  cmp  dh, seconds ; сравниваем текущие секунды с secodns
  je   delaying
  mov  seconds, dh ; сохраняем секунды
  dec  delay   ; вычитаем 1 из задерки
  jnz  delaying  ; если задержка не равна 0, повторяем 

pop	dx
pop	ax

ret 
proc_delay endp

proc_r proc near 
	push bx
	push cx

	mov bx, 20000		
	call sound_start

	mov delay, ah
	call proc_delay
	call sound_end

	pop cx
	pop bx

	iret;
proc_r endp

subr_int proc near
	; устанавливаем новый вектор перрывания 

  mov al,60h ; номер вектора
  mov ah,25h ; функция установки вектора
  push ds
  mov dx, offset proc_r ; смещение дял процедуры в dx
  mov ax, seg proc_r ; сегмент  процедуры
  mov ds, ax ; перемещаем в ds
  mov ax, 2560h ; функция установки флага(25) и номер вектора (60)
  int 21h ; меняем прерывание
  pop ds
  ret
subr_int endp

main proc far
  mov  ax, ds ; загрузка сегментного 
  mov  ds, ax ; регистра данных


  mov  ah, 35h  ; функция получения вектора
  mov  al, 60h ; номер вектора 
  int  21h ; возвращает текущее значение вектора прерывания
  mov  keep_ip, bx ; запоминание смещения
  mov  keep_cs, es ; и сегмента вектора прерывания



  call subr_int 
  mov ah, 10; устанавливается задержка
  int 60h;

	; востанавливаем старый вектор прерывания 

  cli ; отключение аппартаных прерываний
  push ds
  mov  dx, keep_ip
  mov  ax, keep_cs
  mov  ds, ax
  mov  ah, 25h ; функция установки вектора
  mov  al, 1ch ; номер вектора
  int  21h          
  pop  ds
  sti  ; установка прерываний 


  mov ax, 4c00h ; завершение программы
  int 21h

main endp;
code ends
end main 