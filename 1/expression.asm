.code
Make_Any PROC
    ; rcx - b (первый параметр)
    ; rdx - c (второй параметр)
    ; r8  - a (третий параметр)

    ; Шаг 1: b * c
    mov rax, rcx           ; rax = b
    imul rax, rdx          ; rax = b * c
    mov r9, rax            ; сохраняем результат в r9
    mov rax, 0             ; очищаем rax для следующей операции

    ; Шаг 2: 8 / a
    mov rax, 8             ; rax = 8
    mov rbx, r8            ; rbx = a (a находится в r8)
    xor rdx, rdx           ; очищаем rdx (для безопасного деления)
    div rbx                ; rax = 8 / a, остаток в rdx (не используется)

    sub r9, rax            ; r9 = (b * c) - (8 / a)

    ; Шаг 4: сохраняем результат в rax
    mov rax, r9            ; результат в rax
    mov r10, rax           ; сохраняем результат в r10

    add rcx, 31            ; rcx = 31 + b
    sub rcx, 1
    div rcx


    ret
Make_Any ENDP

end
