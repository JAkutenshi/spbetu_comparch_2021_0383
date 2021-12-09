#include <stdio.h>
#include <string.h>
#include <cstddef>

char input_str[81];
char output_str[243];

int main(){
    printf("Executed transformation - making up number of inserted latin char in alphabet and the index of its first appearence in insterted string and printing them on the display\n");
    printf("Made by student of 0383 group - Kusmartsev.A.I\n");
    printf("type string\n");

    fgets(input_str, 81, stdin);
    input_str[strlen(input_str) - 1] = '\0';
    char n;
    char m;    
    m = strlen(input_str);
    __asm {
        mov edi, OFFSET output_str
	mov bl, 65	
	mov ecx, 26
	begin:
	mov esi, OFFSET input_str
        mov n, 0
        find_char:
            lodsb
            cmp al, bl
            je add_out
            add bl, 32
            cmp al, bl
            je add_out
            sub bl, 32
            inc n
	    mov al, m
            cmp n, al
            jl find_char
	    jmp next_char

            add_out:
                stosb
                cmp al, 97
                jge make_down
		sub al, 64
		jmp next
                make_down:
                    sub al, 96
                next:
                stosb
                mov al, n
                stosb
		jmp next_char
	next_char:
	inc bl
	loop begin
	mov al, 0
	stosb
    }; 
    FILE* fout;
    fout = fopen("results.txt", "w");
    for(size_t i =0; i < 3*strlen(input_str); i+=3){
	if(output_str[i+1] != 0){    
            printf("char: '%c', place in alphabet - %d, place of first appearence - %d\n", output_str[i], output_str[i+1], output_str[i+2]);
            fprintf(fout, "char: '%c', place in alphabet - %d, place of first appearence - %d\n", output_str[i], output_str[i+1], output_str[i+2]);
	}    
    }  
    return 0;
}
