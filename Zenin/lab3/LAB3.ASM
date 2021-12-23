AStack SEGMENT STACK
    DW 12 DUP(?)
AStack ENDS


DATA SEGMENT
    input DB 10, 10 DUP ('$')
    sign DB 0
    len DB 0
    temp DB 0
    a DW 0
    b DW 0
    i DW 0
    k DW 0
    res1 DW 0
    res2 DW 0
    res3 DW 0
DATA ENDS


CODE SEGMENT
    ASSUME CS:CODE,  DS:DATA, SS:AStack

    
     Read PROC NEAR

        mov sign, 0             ;sign value initializer
        mov len, 0              ;number length value initializer
        mov di, 2               ;number of the first element in input, itterator
        mov bh, 0               ;init
        mov cx, 0
        mov ax, 0
        mov dx, OFFSET input    ;wrtiting offset to input string into dx
        mov ah, 0Ah             ;reading user input and writing it to "input" string
        int 21h                 ;interruption
        
        cmp input[di], 2Dh      ;comparing first symbol of input with dash symbol

        mov dx, 0               ;init
        
        jnz counting             ;checking a==b statement
        mov sign, 1             ;if first sybmol is dash -> sign changes to 1
        add di, 1               ;proceed to next sybol in input
        jmp counting            ;jumping to counting part

        counting:
            cmp input[di], 24h
            jz processing
            add di, 1
            jmp counting
        
        processing:
            mov len, di
            mov di, 2
            
            cmp sign, 1
            jnz skip
            add di, 1
            skip:

            mov bh, len
            sub bh, 4
            sub bh, sign        ;finding amount of digits of the absolute number
            jz finalcalc

            jmp itter
    
        itter:
            mov temp, bh
            mov ax, 0
            mov dx, 0
            mov al, input[di]
            sub al, 30h
        power:
            mov dx, ax
        mult10:
            SHL ax, 1
            SHL ax, 1
            SHL ax, 1
            add ax, dx
            add ax, dx
            sub temp, 1
            cmp temp, 0
            jnz power
        add cx, ax
        add di, 1
        sub bh, 1
        cmp bh, 0
        jnz itter

        finalcalc:
        mov ax, 0
        mov al, input[di]
        sub al, 30h
        add cx, ax

        cmp sign, 1
        jnz skip2
        neg cx
        skip2:

        mov di, 2           ;input buffer clear
        mov dx, 10
        clear:
        mov input[di], 24h
        add di, 1
        sub dx, 1
        jnz clear
        
        ret
    Read ENDP


    Main PROC FAR
        push  DS
        sub   AX,AX
        push  AX
        mov   AX,DATA
        mov   DS,AX
        mov   CX, 0

        Call Read
        mov a, cx
        Call Read
        mov b, cx
        Call Read
        mov i, cx
        Call Read
        mov k, cx


        mov cx, i
        add cx, i       ;cx = 2i
        
        mov ax, a
        mov bx, b
        cmp ax, bx
        jle less
        
        
        mov ax, 15      ;f1.1
        sub ax, cx      ;
        mov res1, ax    ;f1.1
        
        mov ax, i       ;f4.1
        shl ax, 1       ;
        shl ax, 1       ;
        add ax, cx      ;
        sub ax, 4       ;
        neg ax          ;
        mov res2, ax    ;f4.1

        jmp f3
        
        less:

        mov ax, i       ;f1.2
        SHL ax, 1       ;
        add ax, i       ;
        add ax, 4       ;
        mov res1, ax    ;f1.2
        
        mov ax, res1    ;f4.2
        sub ax, 2       ;
        mov res2, ax    ;f4.2

        
        f3:
        mov cx, k
        cmp cx, 0
        jnz f32

        mov cx, res1
        add cx, res2
        cmp cx, 0
        jnl finale
        
        neg cx
        jmp finale

        f32:
        mov ax, res1
        mov bx, res2
        cmp ax, bx
        jle f321
        mov cx, res2
        jmp finale

        f321:
        mov cx, res1


        finale:
        mov ah,4Ch
        int 21h

    Main ENDP
    CODE ENDS
END Main