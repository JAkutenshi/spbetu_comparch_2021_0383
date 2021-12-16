;------------2nd module

.586p
.MODEL FLAT, C
.CODE
PUBLIC C module_2

module_2 PROC C x: dword, arr_size: dword, left_border: dword, interval_cnt: dword, result: dword

PUSH EDI
PUSH ESI
PUSH EBX
PUSH ECX
PUSH EAX
push ebp

MOV ECX, arr_size		;get arr_size into ECX
MOV ESI, x 				;get start of the x into ESI
MOV EDI, left_border	;get start of the interval arr into EDI
MOV EAX, 0				;index of curr value (x)

lp_x:								;loop for x arr with gen nums
	MOV EBX, 0						;index of start interval
	lp_borders:						;loop to search the inteval for the curr x
		CMP EBX, interval_cnt		;if in the end of interval arr - exit loop
		JE lp_b_end
		PUSH EAX					;save EAX = index of curr val
		MOV EAX, [ESI + EAX * 4]	;get curr x value into EAX
		CMP EAX, [EDI + EBX * 4]	;get curr interval left_border value and CMP with EAX
									;if EAX < curr left border -> jmp to write 
		POP EAX						;restore EAX
		JL lp_b_end					;jump if < curr left border of interval
		JG check_last_right

		INC EBX						;interval index + 1
		JMP lp_borders				

		check_last_right:
			INC EBX
			CMP EBX, interval_cnt
			JE trash
			JMP lp_borders


	lp_b_end:

	DEC EBX							;turn curr left border into right border (basically, get the interval we seek for)
	CMP EBX, 0
	JL trash						;if index < 0 -> trash

	MOV EDI, result 				;get start of the result arr into EDI
	PUSH EAX						;save EAX = index of curr val
	MOV EAX, [EDI + 4 * EBX]		;get x counter val in the result by the index of the interval
	INC EAX							;x counter + 1
	MOV [EDI + 4 * EBX], EAX		;update counter
	POP EAX
	MOV EDI, left_border			;get start of interval arr

	trash:
	INC EAX				;index of curr val + 1

LOOP lp_x

pop ebp
POP EAX
POP ECX
POP EBX
POP ESI
POP EDI

RET
module_2 ENDP
END 
