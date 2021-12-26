global count

section .text

; for (int i = 0; i < intervalCount; ++i) {
;     for (int j = 0; j < numsCount; ++j) {
;         if (nums[j] >= borders[i] && nums[j] < borders[i+1]) {
;             ++result[i];
;         }
;     }
; }
count:
%define nums [ebp+8]
%define numsCount [ebp+12]
%define borders [ebp+16]
%define intervalCount [ebp+20]
%define result [ebp+24]

    push ebp
    mov ebp, esp

    push dword 0 ; int i = 0
    push dword 0 ; int j = 0

%define i [ebp-4]
%define j [ebp-8]

    push ebx

count.for_i:

    ; if i >= intervalCount then exit
    mov eax, intervalCount
    cmp i, eax
    jge count.for_i.exit

    mov dword j, 0 ; j = 0 before for_j

    ; result[i] = 0
    mov edx, result
    mov ecx, i
    mov [edx+4*ecx], dword 0

    count.for_i.for_j:

        ; if j >= numsCount then exit
        mov eax, numsCount
        cmp j, eax
        jge count.for_i.for_j.exit

        ; eax = nums[j]
        mov edx, nums
        mov ecx, j
        mov eax, [edx+4*ecx]

        ; ebx = borders[i]
        mov edx, borders
        mov ecx, i
        mov ebx, [edx+4*ecx]

        ; if nums[j] < borders[i] then next iteration
        cmp eax, ebx
        jl count.for_i.for_j.end_iteration

        ; ebx = borders[i+1]
        ;mov edx, borders ; <<-- borders already in edx
        ;mov ecx, i ; <<-- i already in ecx
        inc ecx
        mov ebx, [edx+4*ecx]

        ; if nums[j] >= borders[i] then next iteration
        cmp eax, ebx
        jge count.for_i.for_j.end_iteration

        ; ++result[i]
        mov edx, result
        ;mov ecx, i ; <<-- i+1 already in ecx
        dec ecx     ; then just decrement ecx
        inc dword [edx+4*ecx]

        count.for_i.for_j.end_iteration:

        inc dword j; ++j

        jmp count.for_i.for_j

    count.for_i.for_j.exit:

count.for_i.end_iteration:

    inc dword i ; ++i

    jmp count.for_i

count.for_i.exit:

    pop ebx
    mov esp, ebp
    pop ebp

    ret
