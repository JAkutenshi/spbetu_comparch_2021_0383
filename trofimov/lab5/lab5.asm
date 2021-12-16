stack SEGMENT stack
	dw 1024 DUP (?)
stack ENDS

data      SEGMENT
	keep_cs dw 0 ;  сегмент
    keep_ip dw 0 ;  прерывание
data      ENDS

code      SEGMENT
    assume cs:code, ds:data, ss:stack


interrupt_func  PROC far
	jmp start
	spec_sp dw 0000h
	spec_ss dw 0000h
	SPEC_STACK db 40 DUP(0)

start:
	mov spec_sp, sp
	mov spec_ss, ss
	mov sp, SEG SPEC_STACK
	mov ss, sp
	mov sp, offset start
	push ax  
	push cx
		
    ;обработка прерывания
	mov cx, ax
	mov al, 10110110b ; 0B6H
	out 43h, al 
	mov ax, cx ; высота звука
	out 42h, al
	mov al, ah
	out 42h, al 
	in al, 61h ; генерация звука
	mov ah, al
	or al, 3
	out 61h, al
	sub cx, cx
	sound_wait:
		nop
		loop sound_wait
	mov al, ah
	out 61h, al ; выключение динамика
            
	; восстановление регистров
	pop cx
	pop ax   
	mov ss, spec_ss
	mov sp, spec_sp
	mov al, 20h
	out 20h, al
	iret
interrupt_func  ENDP

Main	PROC  far
	; текущий вектор прерывания
	mov  ah, 35h;функция получения вектора
	mov  al, 23h;номер вектора
	int  21h
	mov  keep_ip, bx;запоминание смещения
	mov  keep_cs, es;запоминание сегмента
	
	;установка вектора прерывания
	push ds
	mov  dx, offset interrupt_func  
	mov  ax, seg interrupt_func    
	mov  ds, ax          
	mov  ah, 25h         ; функция установки вектора
	mov  al, 23h         ; номер вектора
	int  21h 
	pop  ds
	
	;ожидание нажатия ctrl+c
	ctrl_c:
    	mov ah, 0
    	int 16h
    	cmp al, 3 
    	jne ctrl_c
	
	mov ax, 3000 ; частота звука
	int 23h
	

	; восстановление изначального прерывания
	cli ; сброс if
	push ds
	mov  dx, keep_ip
	mov  ax, keep_cs
	mov  ds, ax
	mov  ah, 25h
	mov  al, 23h
	int  21h ; восстанавливаем вектор
	pop  ds
	sti ; разрешаем аппаратные прерывания
	
	mov ah, 4ch                          
	int 21h
Main      ENDP
code ENDS
	END Main 
