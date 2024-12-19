.MODEL small
.STACK 100h

.DATA
    ; Строки приглашений для ввода
    promptA      DB 'Введите a: $'
    promptB      DB 13,10,'Введите b: $'
    promptC      DB 13,10,'Введите c: $'
    resultMsg    DB 13,10,'Результат: $'

    ; Буферы для ввода (структура DOS 0Ah: размер, длина, данные)
    bufferA      DB 6          ; Максимум 5 символов
                DB ?          ; Фактическое количество символов
                DB 5 dup(0)   ; Буфер для символов

    bufferB      DB 6
                DB ?
                DB 5 dup(0)

    bufferC      DB 6
                DB ?
                DB 5 dup(0)

    ; Переменные для хранения чисел
    numA         DW ?
    numB         DW ?
    numC         DW ?
    result       DW ?

    ; Буфер для строки результата
    numStr       DB 6 dup('?'), '$' ; '00000$' или по необходимости

.CODE
MAIN PROC
    ; Инициализация сегмента данных
    mov ax, @DATA
    mov ds, ax

    ; Запрос и ввод a
    lea dx, promptA
    mov ah, 09h
    int 21h

    lea dx, bufferA
    mov ah, 0Ah
    int 21h

    ; Конвертация введенной строки a в число
    lea si, bufferA + 2   ; Указатель на первые символы ввода
    call StrToNum
    mov numA, ax

    ; Запрос и ввод b
    lea dx, promptB
    mov ah, 09h
    int 21h

    lea dx, bufferB
    mov ah, 0Ah
    int 21h

    ; Конвертация введенной строки b в число
    lea si, bufferB + 2
    call StrToNum
    mov numB, ax

    ; Запрос и ввод c
    lea dx, promptC
    mov ah, 09h
    int 21h

    lea dx, bufferC
    mov ah, 0Ah
    int 21h

    ; Конвертация введенной строки c в число
    lea si, bufferC + 2
    call StrToNum
    mov numC, ax

    ; Вызов процедуры вычислений Lab1S
    call Lab1S

    ; Вывод результата
    lea dx, resultMsg
    mov ah, 09h
    int 21h

    mov ax, result
    call NumToStr

    lea dx, numStr
    mov ah, 09h
    int 21h

    ; Завершение программы
    mov ah, 4Ch
    int 21h
MAIN ENDP

; Процедура Lab1S: Выполняет вычисления на основе введенных a, b, c
Lab1S PROC
    ; AX = b
    mov ax, numB
    mul numC          ; DX:AX = b * c (беззнаковое умножение)

    push dx           ; Сохранение старшего слова (DX)
    push ax           ; Сохранение младшего слова (AX)

    mov ax, 8         ; AX = 8
    xor dx, dx        ; Очистка DX

    mov bx, numA
    cmp bx, 0
    je DivisionByZero ; Проверка деления на ноль

    div bx            ; AX = 8 / a (беззнаковое деление)

    ; Восстановление b * c
    pop bx            ; Восстановление младшего слова b * c
    pop cx            ; Восстановление старшего слова b * c

    sub bx, ax        ; BX = младшее слово b*c - (8 / a)
    sbb cx, 0         ; CX = старшее слово b*c - перенос

    ; Подготовка для деления (DX:AX уже содержит результат)
    mov ax, bx        ; AX = результат (младшее слово)
    mov dx, cx        ; DX = результат (старшее слово)

    ; Изменение делителя с b на (30 + b)
    mov bx, numB      ; Загрузка b в BX
    add bx, 30        ; Добавление 30 к b
    cmp bx, 0
    je DivisionByZero ; Проверка деления на ноль после добавления

    div bx            ; Деление DX:AX на (b + 30)

    jmp Continue

DivisionByZero:
    mov ax, 0         ; Установка результата в 0 при делении на ноль

Continue:
    mov result, ax
    ret
Lab1S ENDP

; Процедура StrToNum: Конвертирует строку в число
; Вход: DS:SI указывает на строку
; Выход: AX = число
StrToNum PROC
    xor ax, ax         ; Инициализация AX
    xor bx, bx         ; Инициализация BX

StrToNumLoop:
    mov bl, [si]       ; Чтение текущего символа
    cmp bl, 13         ; Проверка на символ возврата каретки (CR)
    je StrToNumEnd
    cmp bl, '0'
    jb StrToNumEnd
    cmp bl, '9'
    ja StrToNumEnd
    sub bl, '0'        ; Конвертация символа в цифру

    ; AX = AX * 10 + bl
    mov cx, 10
    mul cx             ; DX:AX = AX * 10
    add ax, bx         ; AX = AX + текущая цифра

    inc si             ; Переход к следующему символу
    jmp StrToNumLoop

StrToNumEnd:
    ret
StrToNum ENDP

; Процедура NumToStr: Конвертирует число в строку
; Вход: AX = число
; Выход: строка в numStr, завершенная '$'
NumToStr PROC
    lea di, numStr     ; Указатель на начало буфера строки
    mov cx, 0
    cmp ax, 0
    jne NumToStrLoop
    mov byte ptr [di], '0'      ; Если число 0, устанавливаем '0'
    mov byte ptr [di+1], '$'
    ret

NumToStrLoop:
    ; Извлечение цифр и помещение их в стек
push_digits:
    xor dx, dx
    mov bx, 10
    div bx             ; AX = AX / 10, DX = AX mod 10
    push dx            ; Сохранение остатка (цифры)
    inc cx
    cmp ax, 0
    jne push_digits

    ; Извлечение цифр из стека и запись в строку
pop_digits:
    pop dx
    add dl, '0'        ; Конвертация цифры в символ
    mov [di], dl
    inc di
    dec cx
    jnz pop_digits

    ; Завершение строки символом '$'
    mov byte ptr [di], '$'
    ret
NumToStr ENDP

END MAIN
