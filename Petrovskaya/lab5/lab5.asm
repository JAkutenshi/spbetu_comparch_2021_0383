;Create your own interruption
;interrupt = proc with certain functions
;By the end of the program make sure to return original vectors of interrupts
;VAR 26 - 4e: 16h - interrupt from keyboard(by pressing a key do E: read and input to screen real-time clock counting from memory CMOS(in BCD format)
;!should use more than 1Kb for stack
		;PROG:

ASSUME CS:CODE, DS:DATA, SS:STACK

STACK SEGMENT STACK
	DW 1024 DUP(?)		;Declare an array of 1024 unitialized Words (2 bytes) for stack
STACK ENDS

DATA	SEGMENT
	KEEP_CS DW 0 		;to store segment
	KEEP_IP DW 0 		;to store interruption vector shift
DATA	ENDS

CODE	SEGMENT

SUBR_INT PROC FAR		;port 70h is for input(stores addr) use it to get CMOS
				;registers, port 71h - to read from them - if not using INT 1Ah
	JMP start
	
	INIT_SS DW 0000h
	INIT_SP DW 0000h
	INT_STACK DB 40 DUP(?)
	
	read_CMOS PROC
		PUSH DX
			;hours
		MOV AL, CH		;in CX=HHMM,
		CALL print_bcd
		CALL colon
			;minutes
		MOV AL, CL
		CALL print_bcd
		CALL colon
			;seconds
		MOV AL, DH		;in DH=SS
		CALL print_bcd
		POP DX
		RET	
	read_CMOS ENDP
	
	colon PROC
		MOV DL, ':'
		MOV AH, 02h
		INT 21H		
		RET
	colon ENDP
		
	print_bcd PROC
		PUSH DX		;save initial registers
		PUSH CX
		MOV CL, 4
		MOV AH, AL		;now al = 43 = ah
		AND AL, 00001111b	;now al = 03 (as it is in BCD, each digit is xxxxb)
		SHR AH, CL		;now ah = 04 => ax = 0403
		ADD AL, '0'		;get ASCII value of '0' + shift in AL
		ADD AH, '0'
		MOV DL, AH		;handle print (DL = to print)
		MOV DH, AL
		MOV AH, 02h
		INT 21h
		MOV DL, DH		;for some reason otherwise DL doesnt change
		INT 21h
		POP CX			;return initial values
		POP DX
		RET
	print_bcd ENDP
	
start:	
;------------------------------<save original registers>	
	MOV INIT_SP, SP
    	MOV INIT_SS, ss
    	mov sp, SEG INT_STACK	;get the segment of the new stack top into SP
    	mov ss, sp		;now SS == top addr of new stack segment
    	PUSH AX		
    	PUSH CX		
    	PUSH DX
    	
;------------------------------<process the interrupt>
	MOV AH, 02H		;read real time from CMOS
	INT 1Ah		;returns CX:DX = clock count
	CALL read_CMOS
	
	POP DX			;restore registers
	POP CX
	POP AX
	MOV ss, INIT_SS
    	MOV SP, INIT_SP
	MOV AL, 20H		;these lines allow to process lower level 
	OUT 20H, AL 		;interrupts than those we worked with
	IRET			;exit from iterrupt
SUBR_INT ENDP


Main	PROC FAR
	PUSH DS		;write into stack
	SUB AX, AX		;write a 0
	PUSH AX		;write ax into stack => stack initialzation
	MOV AX, DATA		;DataSegment initialization
	MOV DS, AX
;-----------<save current vector>
	MOV AH, 35H 		;get curr vector
	MOV AL, 60H		;get curr vector number
	INT 21H
	MOV KEEP_IP, BX	;store the shift
	MOV KEEP_CS, ES 	;store interruption vector segment

;----------<install new interrupt vector>
	PUSH DS
	MOV DX, OFFSET SUBR_INT	;shift fot the proc into DX
	MOV AX, SEG SUBR_INT	;procedure segment we save and
	MOV DS, AX		;put into DS
	MOV AH, 25H		;funtion to install new vector, it stores
				;segment and shift addresses into interrupt
				;vector with chosen number.
	MOV AL, 60H		;new vector number
	INT 21H		;change the interrupt
	POP DS
	
;----------<get key scan-code-(let`s it be 'Q')>
	readkey:
		MOV AH, 0		;by pressing key in AH a BIOS scancode is stored, and in AL - an ASCII symbol
		INT 16H		;interrupt to get the key scancode
		CMP AH, 16		;16 is a scancode of 'Q'
		JNE readkey		;if it`s not 'Q' -> repeat reading, else continue
		
		INT 60H		;call changed interrupt

;-----------restore original interrupt vector-
	CLI				;disable interrupts
	PUSH DS			;save ds
	MOV DX, KEEP_IP		;restore original shift
	MOV AX, KEEP_CS		;restore int vector segment
	MOV DS, AX
	MOV AH, 25H			;to set int vector
	MOV AL, 60H			;vector num
	INT 21H			;restore vector
	POP DS
	STI				;enable interrupts
	MOV AH, 4CH
   	INT 21H
Main ENDP
CODE ENDS
END Main

