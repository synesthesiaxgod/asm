.model small, c
.stack 100h
.data
    Extrn a:word, b:word, result:word
.code
public calculate_x
calculate_x proc far
    mov ax, a        ; Загружаем a в AX
    cmp ax, b        ; Сравнить a и b
    jl less          ; Если a < b, перейти в less
    jg greater       ; Если a > b, перейти в greater
    je equal         ; Если a == b, перейти в equal

less:
    mov ax, a        ; AX = a
    add ax, 12       ; AX = a + 12
    mov bx, 5        ; BX = 5
    xor dx, dx       ; Обнуляем DX перед делением
    div bx           ; AX = (a + 12) / 5
    jmp store_result ; Переход на сохранение результата

greater:
    cmp b, 0         ; Проверяем b на 0 (деление на ноль)
    je DivisionByZero; Если b == 0, перейти на обработку

    mov ax, a        ; AX = a
    xor dx, dx       ; Обнуляем DX перед делением
    mov bx, b        ; BX = b
    div bx           ; AX = a / b
    cmp ax, 21       ; Сравнить результат деления с 21
    jb DivisionByZero; Если результат меньше 21, установить 0
    sub ax, 21       ; AX = a / b - 21
    jmp store_result ; Переход на сохранение результата

DivisionByZero:
    mov ax, 0        ; Устанавливаем AX в 0 при делении на ноль
    jmp store_result

equal:
    mov ax, 210      ; Если a == b, результат 210

store_result:
    mov result, ax   ; Сохраняем результат в переменную result
    ret
calculate_x endp
end
