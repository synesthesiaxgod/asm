.model small, c
.stack 100h
.data
Extrn aaaS:word, bbbS:word, cccS:word, result:word
.code
public Lab1S
Lab1S proc far
    mov ax, bbbS      ; AX = b
    mul cccS        ; DX:AX = b * c (unsigned)

    push dx           ; Сохраняем старшее слово (DX)
    push ax           ; Сохраняем младшее слово (AX)

    mov ax, 8         ; AX = 8
    xor dx, dx      ; Очищаем DX
    div aaaS       ; AX = 8 / a (unsigned)  ;Возможен INT 0 если a == 0
    
    pop bx        ; младшее слово b * c в BX
    pop cx        ; старшее слово b * c в CX
    
    sub bx, ax   ;BX = младшее слово b*c - 8/a
    sbb cx, 0    ;CX = старшее слово b*c - перенос (0 или 1)
    
    mov ax, bx ;Переносим младшее слово результата в AX для деления
    mov dx, cx ;Переносим старшее слово результата в DX для деления

    mov bx, bbbS
    add bx, 30
    jz DivisionByZero ; Проверка деления на ноль
    div bx    ; DX:AX / BX
                jmp continue

    DivisionByZero:
                mov ax, 0; устанавливаем результат деления на ноль в 0
    continue:

    mov result, ax

    ret
Lab1S endp
end
