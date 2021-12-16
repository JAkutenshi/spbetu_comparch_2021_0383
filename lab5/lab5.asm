stack segment stack
	dw 6 dup(?)
stack ends
data segment
	keep_seg dw 0
	keep_offset dw 0
data ends

code segment
	assume ds:data, cs:code, ss:stack
	
	

interrupt proc far
  push ax; 
  push dx; save reg
  push bx; save reg
     

    mov      bx,270    
    mov      ax,34DDh
    mov      dx,12h    
    cmp      dx,bx      
    jnb      Done      
    div      bx        
    mov      bx,ax     
    in       al,61h    
    or       al,3       
    out      61h,al    
    mov      al,00000110b   
                        
    mov      dx,43h    
    out      dx,al     
    dec      dx    
    mov      al,bl      
    out      dx,al      
    mov      al,bh      
    out      dx,al     
Done:
  
pop bx
pop dx
pop ax	
	
iret
interrupt endp
	
	
	main proc far
		push ds
		sub ax, ax
		push ax
		
		mov ax, data
		mov ds, ax
		
		
		mov ax, 351ch ; 35 - get vec(bx = offset, es = seg), 1ch - ?vec
		int 21h ;
		
		mov keep_offset, bx ; save vec
		mov keep_seg, es

		cli
		push ds
		mov dx, offset interrupt ;
		mov ax, seg interrupt    ;
		mov ds, ax
		
		mov ax, 251ch ; 25 - set(offset = dx, seg = ds), 1ch - ?vec
		int 21h
		
		pop ds
		sti


looper:
		
            	mov ah, 1h ; 1h - get char
		int 21h
		cmp al, '1'
		je next
		jmp looper
next:

    push    ax  ; 
    in  al,61h  ; 
    and al,not 3; turn off 0,1 bit 
    out 61h,al  ; 
    pop ax  ; 
		
		


		cli
		push ds
		
		mov dx, keep_offset
		mov ax, keep_seg
		mov ds, ax
		
		mov ah, 25h ; 25h - set(25 - set(offset = dx, seg = ds))
		mov al, 1ch; 1ch - ?vec
		int 21h ; 
		
		pop ds
		sti
	
	
		ret
	main endp
code ends
end main