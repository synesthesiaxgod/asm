.model small, c
.stack 100h
.data
    Extrn a:word, b:word, result:word
.code
public calculate_x
calculate_x proc far
    mov ax, a        ; Загружаем a в AX
    cmp ax, b        ; Сравнить a и b (ЗНАКОВОЕ сравнение)
    jl less          ; Если a < b, перейти в less
    jg greater       ; Если a > b, перейти в greater
    je equal         ; Если a == b, перейти в equal

less:
    mov ax, a        ; AX = a
    add ax, 12       ; AX = a + 12
    mov bx, 5        ; BX = 5
    cwd             ; Расширение знака AX в DX:AX (для idiv)
    idiv bx        ; Знаковое деление
    jmp store_result

greater:
    cmp b, 0
    je DivisionByZero
    mov ax, a
    cwd             ; Расширение знака AX в DX:AX (для idiv)
    mov bx, b
    jz DivisionByZero; проверка на 0 перед div
    idiv bx         ; Знаковое деление
    sub ax, 21       ; Знаковое вычитание
    jmp store_result

DivisionByZero:
    mov ax, 0
    jmp store_result

equal:
    mov ax, 210

store_result:
    mov result, ax
    ret
calculate_x endp
end
