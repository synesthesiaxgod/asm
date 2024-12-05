.586
.MODEL FLAT, C

.CODE
calculate_expression_asm PROC
    ; Входные параметры: a, b, c
    ; [ESP+4] = a
    ; [ESP+8] = b
    ; [ESP+12] = c

    mov eax, DWORD PTR [esp+8]  ; eax = b
    imul eax, DWORD PTR [esp+12] ; eax = b * c

    mov ebx, DWORD PTR [esp+4] ; ebx = a
    cdq                       ; Расширение знака для деления
    idiv ebx                  ; eax = 8 / a

    sub eax, ebx              ; eax = b * c - (8 / a)

    ; Деление на знаменатель
    mov ebx, 31
    add ebx, DWORD PTR [esp+8] ; ebx = 31 + b
    sub ebx, 1                ; ebx = 31 + b - 1

    cdq                       ; Расширение знака для деления
    idiv ebx                  ; eax = (numerator) / (denominator)

    ret
calculate_expression_asm ENDP
END
