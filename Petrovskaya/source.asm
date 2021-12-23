;var____6,8,1
;Data input and processing through debugger
;Instead of multiply in f1 and f2 use ariphmetic slides and possibly ADD
;No procedurs are to be used in f1 and f2
;Code size should be minimal - change original functons if needed

;integers a, b, i and k are typed in by user while debugging. Use different variations
; find i1 = f1(a,b,i) and i2 = f2(a,b,i)
; find resulting function res = f3(i1, i2, k)

;       / 2 * (i + 1) - 4 ,if a > b		=> 2*i -2
; f1 = <
;       \ 5 - 3 * (i + 1) ,if a <= b		=> 2 - 3*i
;
;       / -(6 * i + 8)    ,if a > b		=> - 8 - 6*i
; f2 = <
;       \ 9 - 3 * (i - 1) ,if a <= b		=> 12 - 3*i
;
;	/ min(i1, i2)     ,if k = 0 
; f3 = <
;	\ max(i1, i2)     ,if (k = 0) = false

;			PROG:


AStack SEGMENT STACK
	DW 12 DUP(?) ;DUP - declares an array of 12 unitialized(=?) WORDS(DW=define words) = 2 bytes
				 ;thus DW 12 DUP(?) is a declaration of (12*2=)24 bytes and they`re nor initialized
AStack ENDS


DATA	SEGMENT
a	DW	0
b	DW 	0
i	DW 	0
k	DW	0
i1	DW  	0
i2	DW 	0
DATA	ENDS

CODE	SEGMENT 
	ASSUME CS:CODE, DS:DATA ,SS:AStack

Main	PROC FAR

PUSH DS 			;write ds into stack
SUB AX, AX			;write a 0
PUSH AX 			;write ax into stack  => Basically, stack initialization
MOV AX, DATA			;move adress of
MOV DS, AX			;DATA into DS

			;f1 & f2
					;multiply only by shifting so use SHL or SHR
					;shift left 1 => x2
					;shift left 2 => x4
					;shift left 3 => x8
	MOV CX, i
	ADD CX, CX			;in f1 i will be multiplied by 2 or 3 either way
	MOV BX, b
	CMP a, BX			;if a <= b jump to f1sec
	JLE f1sec
					;we go here if a > b
	MOV AX, CX			;AX = 2i, f2: if a > b => - 8 - 6*i
	ADD CX, -2			;CX = 2*i -2, f1 done
	ADD AX, i			;AX = 3i
	SHL AX, 1			;AX = 6i
	NEG AX				
	ADD AX, -8			;AX = - 8 - 6i, f2 done

	JMP f12save

	f1sec:				;f2 = 12 - 3*i
		ADD CX, i		;now CX = 3i
		NEG CX			;now CX = -3i
		MOV AX, CX		;AX = -3i
		ADD AX, 12
		ADD CX, 2		
		JMP f12save
	f12save:
		MOV i1, CX
		MOV i2, AX		;save f1 & f2 results into i1 & i2
	
			;f3 and resulting function
	MOV CX, i1
	CMP CX, i2 	;check if i1 <= i2, if true -> jump
	JLE other
	MOV CX, i2	;i2 is min in CX
	MOV AX, i1	;i1 is max in AX
		other:
		;MOV CX, i1
		;MOV AX, i2
		
	MOV BX, k
	CMP BX, 0 
	JZ fin	;JumpZero check if ZF = 0, if k /= 0 continue here, otherwise jump
	MOV CX, AX 	;get max into CX
	
	jmp fin	; CX has min by default, if k == 0 then res = min
			;CX NOW HAS RESULT
			
	fin: RET		;return to DOS
Main	ENDP
CODE ENDS
END Main

