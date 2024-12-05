.386
.model flat, c
.code

; Прототип функции
; void calculate(int a, int b, int* x)
calculate PROC
    ; Параметры:
    ; [esp + 4] = a
    ; [esp + 8] = b
    ; [esp + 12] = адрес x

    mov eax, [esp + 4] ; Загружаем a в eax
    mov ebx, [esp + 8] ; Загружаем b в ebx
    mov ecx, [esp + 12] ; Адрес x в ecx

    cmp eax, ebx       ; Сравниваем a и b
    jl less_than       ; Если a < b
    je equal           ; Если a == b
    jg greater_than    ; Если a > b

less_than:
    add eax, 12        ; a + 12
    cdq                ; Расширяем знак для деления
    mov ebx, 5         ; 5 в ebx
    idiv ebx           ; eax / 5
    mov [ecx], eax     ; Сохраняем результат в x
    ret

equal:
    mov eax, 210       ; x = 210
    mov [ecx], eax     ; Сохраняем результат в x
    ret

greater_than:
    cdq                ; Расширяем знак для деления
    idiv ebx           ; eax / b
    sub eax, 21        ; (a / b) - 21
    mov [ecx], eax     ; Сохраняем результат в x
    ret

calculate ENDP
END
