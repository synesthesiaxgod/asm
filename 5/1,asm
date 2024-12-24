section .data
    msg_a db "Введите a (использовать '.' перед дробной частью)", 62, 10, 13, 0
    len_a equ $ - msg_a
    msg_b db "Введите b (использовать '.' перед дробной частью)", 62, 10, 13, 0
    len_b equ $ - msg_b
    msg_c db "Введите c (целое число)", 62, 10, 13, 0
    len_c equ $ - msg_c
    msg_out db "Результат", 62, 10, 13, 0
    len_out equ $ - msg_out
    msg_error db "Ошибка при введении числа С", 10, 13, 0
    len_error equ $ - msg_error
    ;dec_sep db ".", 0  ; разделитель
    dec_sep equ '.'
    plus_one  equ '1'; '1',0
    zero equ '0'; '0',0
    float_const dq 0.1   ; чисто костыль
    A dq 0.0
    B dq 0.0
    C dq 0
    C8 dq 8.0
    C31 dq 31.0
    Num dq 0.0
    Den dq 0.0
    Res dq 0.0


section .bss
    ;buffer_a resb 10       ; буферы для строк
    ;buffer_b resb 10
    ;buffer_c resb 10
    buffer resb 20
    buffer_out resb 20

    ;A resq 1

section .text
    global _start

_start:
    ;---------------- Вывод сообщения a
    mov eax, 4             ; syscall номер для sys_write
    mov ebx, 1             ; stdout
    mov ecx, msg_a        ; адрес результата
    mov edx, len_a        ; количество байт для вывода
    int 0x80               ; вызов ядра
    ;----------------
    ; Ввод числа a
    mov eax, 3          ; syscall номер для sys_read
    mov ebx, 0          ; stdin
    lea ecx, buffer     ; адрес буфера
    mov edx, 20         ; максимальное количество байт для чтения
    int 0x80            ; вызов ядра

    xor eax, eax        ; очищаем все регистры
    xor ebx, ebx
    xor ecx, ecx
    xor edx, edx
    xor edi, edi

    mov edi, A
    mov esi, buffer     ; указываем на буфер для ввода
    call atof

    xor edi, edi
    xor esi, esi

    ;---------------- Вывод сообщения b
    mov eax, 4             ; syscall номер для sys_write
    mov ebx, 1             ; stdout
    mov ecx, msg_b        ; адрес результата
    mov edx, len_b        ; количество байт для вывода
    int 0x80               ; вызов ядра
    ;----------------
    ; Ввод числа b
    mov eax, 3          ; syscall номер для sys_read
    mov ebx, 0          ; stdin
    lea ecx, buffer     ; адрес буфера
    mov edx, 20         ; максимальное количество байт для чтения
    int 0x80            ; вызов ядра

    mov edi, B
    mov esi, buffer     ; указываем на буфер для ввода
    call atof

    xor edi, edi
    xor esi, esi


    ;---------------- Вывод сообщения c
    mov eax, 4             ; syscall номер для sys_write
    mov ebx, 1             ; stdout
    mov ecx, msg_c        ; адрес результата
    mov edx, len_c        ; количество байт для вывода
    int 0x80               ; вызов ядра
    ;----------------
    ; Ввод числа b
    mov eax, 3          ; syscall номер для sys_read
    mov ebx, 0          ; stdin
    lea ecx, buffer     ; адрес буфера
    mov edx, 6          ; максимальное количество байт для чтения
    int 0x80            ; вызов ядра

    ; Превращение ввода в 8-битное число
    xor ecx, ecx        ; очищаем ECX для хранилища числа
    mov esi, buffer     ; указываем на буфер для ввода
    mov bl, byte [esi] ; загружаем первый символ
    xor edx, edx        ; обнуляем edx
    xor dl, dl
    mov dl, 0

    ; Проверка на знак
    cmp bl, '-'         ; если первый символ знак '-'
    jne .convert_input_c_us    ; если нет, начинаем конвертацию
    inc esi ; пропускаем знак, если число отрицательное

   .convert_input_c_us:
    movzx eax, byte [esi] ; загружаем текущий символ
    cmp al, 10          ; проверяем на конец строки (символ '\n' имеет код 10)
    je .store_result_c_us      ; если '\n', завершаем
    sub al, 30h         ; преобразование ASCII в число
    imul ecx, ecx, 10    ; сдвигаем влево
    add ecx, eax        ; добавляем текущую цифру
    inc esi             ; переходим к следующему символу
    jmp .convert_input_c_us   ; повторяем
   .store_result_c_us:
    ; Проверка, чтобы не превышать 16-битный диапазон
    cmp ecx, 65535             ; максимальное значение 65535 (16-бит)
    jge error_exit           ; если больше 65535, идем в ошибку
    cmp ecx, -65536            ; минимальное значение 0 (16-бит)
    jle error_exit           ; если меньше 0, идем в ошибку
    ; Проверяем знак
    cmp bl, '-' ; если первый символ '-'
    jne .save_positive_c_us
    je .save_negative_c_us       ; если отрицательное, переходим сюда
   .save_positive_c_us:
    mov [C], cx       ; сохраняем результат как 8-битное число (cl)
    jmp .calc

   .save_negative_c_us:
    neg cx
    mov [C], cx      ; сохраняем результат как отрицательное 16-битное число

   .calc:
    xor eax, eax
    xor ebx, ebx
    xor ecx, ecx
    xor edx, edx

;==========================================================================================
; ВЫЧИСЛЕНИЕ ВЫРАЖЕНИЯ
;==========================================================================================

    ; (c * b - 8/a)
    ; c * b
    lea eax, [C]
    lea ebx, [B]
    fild qword [eax]
    fld qword [ebx]  ; st0 = B, st1 = c
    fmulp st1, st0             ;  Умножаем значение в st1 стеке FPU на st0 , st0 - pop

    xor eax, eax
    xor ebx, ebx

    lea eax, [A]
    lea ebx, [C8]
    fld qword [eax]
    fld qword [ebx]           ; st0 = 8, st1 = a, st2 = c*b
    fdivp st1, st0             ; st0 = a / 8 , st2 = c*b
    fsubp st1, st0             ; st0 = a / 8 - c*b

    xor eax, eax
    xor ebx, ebx

    lea eax, [Num]
    fstp qword [eax]

    xor eax, eax

    ;(b + a - 1)
    lea eax, [C31]
    lea ebx, [B]
    fld qword [eax]
    fld qword [ebx]  ; st0 = c31, st1 = b
    faddp st1, st0   ; st0 = c31 + b
    fld1             ; st0 = 1 , st1 = c31 + b
    fsubp st1, st0   ; st0 = 31 + b - 1

    xor eax, eax
    xor ebx, ebx

    lea eax, [Den]
    fstp qword [eax]

    xor eax, eax

    ; (c * 3 + a * 54) / (b + a -1)
    lea eax, [Num]
    lea ebx, [Den]
    fld qword [eax]
    fld qword [ebx]  ; st0 = den, st1 = num
    fdivp st1, st0   ; st0 = num / den

    xor eax, eax
    xor ebx, ebx

    lea eax, [Res]
    fstp qword [eax]

    xor eax, eax

   .end_calc:


;==========================================================================================
; КОНЕЦ ВЫЧИСЛЕНИЯ ВЫРАЖЕНИЯ
;==========================================================================================




    xor eax, eax        ; очищаем все регистры
    xor ebx, ebx
    xor ecx, ecx
    xor edx, edx
    xor edi, edi
    xor esi, esi

    ; Завершение программы

  ; A_test dq -1.3    <--- с этим работает
    lea eax, [Res]
    mov edx, 3
    lea esi, [buffer_out]
    call FLOAT_to_STR

    ;---------------- Вывод сообщения о результате
    mov eax, 4             ; syscall номер для sys_write
    mov ebx, 1             ; stdout
    mov ecx, msg_out        ; адрес результата
    mov edx, len_out        ; количество байт для вывода
    int 0x80               ; вызов ядра
    ;----------------

    mov eax, 4             ; syscall номер для sys_write
    mov ebx, 1             ; stdout
    lea ecx, [buffer_out]    ; адрес результата
    mov edx, 20        ; количество байт для вывода
    int 0x80               ; вызов ядра

    mov eax, 1                      ; системный вызов sys_exit
    xor ebx, ebx                    ; код возврата 0
    int 0x80                        ; вызвать ядро

;================================================================

atof:
; IN EDI - ADR PER
;    ESI - ADR STR
    pushad       ; в стеке будут сохраняться 32 - битные регистры
    finit        ; устанавливает контекст FPU в его значение по умолчанию

    xor ebp, ebp
    cmp byte [esi], '-'
    jnz .local_m_1
    inc esi
    inc ebp
   .local_m_1:
    xchg edi, esi
    call GetZSLength ;получаем длину строки. после этой функции в eax содержится длина строки
    xchg edi, esi

    dec eax

    mov ecx, eax
    mov edx, eax

    mov ebx, 10

    fldz     ; загружаем в st0 значение 0
    xor eax, eax
    push eax  ; [esp] - temp value ; сохранение 0 на стеке
   .repeat:
    cmp byte [esi], dec_sep
    je .continue
   .local_m_2:
    mov [esp], ebx
    fimul dword [esp]             ; Умножаем значение в стеке FPU на 10.

    mov al, byte [esi]             ; Загружаем текущий символ в AL.
    sub al, '0'                           ; Преобразуем символ в цифру.
    mov [esp], eax                           ; Сохраняем цифру на стеке.
    fiadd dword [esp]                           ;  Добавляем цифру к значению в стеке FPU.

   .continue:                             ;  Метка для продолжения цикла.
    dec ecx                               ; Уменьшаем счетчик символов.
    inc esi                             ; Переходим к следующему символу.
    cmp ecx, 0                            ; Сравниваем счетчик с нулем.
    jnz .repeat                           ;  Если счетчик не равен нулю, повторяем цикл.

   .endrepeat:
    xchg esi, edi             ; Меняем местами значения ESI и EDI.
    mov al, dec_sep             ; Загружаем десятичный разделитель в AL.
    mov ecx, edx             ; Копируем длину строки в ECX.
    sub edi, edx             ; Восстанавливаем указатель EDI на начало строки.
    repnz scasb             ; Ищем десятичный разделитель в строке. В ECX останется количество символов после разделителя.
    cmp ecx, 0             ; Сравниваем ECX с нулем.
    jz .end             ;Если разделитель не найден, переходим к метке .end.
    mov dword [esp], 10             ;Загружаем значение 10 на стек.
   .rep:             ; Начало цикла деления на 10.
    ;mov dword [esp], 10
    fidiv dword [esp]             ; Делим значение в стеке FPU на 10.
    loop .rep             ; Повторяем цикл, пока ECX не станет равным нулю.

   .end:             ; Конец обработки десятичной части.
    xor eax, eax             ;  Обнуляем регистр EAX.
    cmp ebp, eax             ;  Сравниваем EBP с нулем.
    je .local_m_3             ;  Если EBP равен нулю, переходим к метке @@ (число положительное).
    fld1             ;  Загружаем 1 в стек FPU.
    fld1             ;  Загружаем еще одну 1 в стек FPU.
    fld1             ;  Загружаем еще одну 1 в стек FPU.
    faddp st1, st0             ;  Складываем два верхних значения в стеке (st0 = 2, st1 = 1).
    fsubp st1, st0             ;  Вычитаем два верхних значения в стеке (st0 = -1).
    fmulp st1, st0             ;  Умножаем значение в стеке FPU на -1.
   .local_m_3:             ;  Метка для положительного числа.
    fstp qword [esi]             ; Сохраняем значение типа double в а
   .error:             ; Метка для обработки ошибки.
    pop eax             ; Удаляем временную переменную со стека.
    popad             ; Восстанавливаем значения всех регистров общего назначения.
    ret             ; Возвращаемся из функции.

GetZSLength:
; get zero-string length
; IN
;       EDI ZS offset
; OUT
;       EAX ZS length

    push ecx        ; Сохраняем значение ECX на стеке
    push esi        ; Сохраняем значение ESI на стеке
    push edi        ; Сохраняем значение EDI на стеке

    cld             ; Очищаем флаг DF (направление обработки строк)
    xor al, al      ; Обнуляем регистр AL (ищем нулевой байт)
    mov ecx, 0FFFFFFFFh ; Загружаем максимальное значение в ECX (для поиска)
    mov esi, edi    ; Копируем значение EDI в ESI (сохраняем начальный адрес строки)
    repne scasb     ; Повторяем поиск нулевого байта в строке
    sub edi, esi    ; Вычитаем начальный адрес из текущего адреса EDI
    mov eax, edi    ; Копируем результат в EAX
    dec eax         ; Уменьшаем EAX на 1 (чтобы исключить нулевой байт)

    pop edi         ; Восстанавливаем значение EDI из стека
    pop esi         ; Восстанавливаем значение ESI из стека
    pop ecx         ; Восстанавливаем значение ECX из стека
    ret             ; Возвращаемся из функции


FLOAT_to_STR:
;converting float value to ZS
;IN
;       EAX – указатель на переменную
;       EDX – точность, количество символов после запятой
;       ESI – указатель на буфер со строкой
    ;plus_one  equ 0031h; '1',0
    ;zero equ 0030h; '0',0

    pushad
    finit

    fld qword [eax]  ;<--- st0 = float value
    fldz
    fcomip st1      ;
    jz .zero      ; if value = 0
    jb .metka1

    xor ebx, ebx
    dec ebx
    push ebx
    fild dword [esp]
    pop ebx
    fxch  ; xchg st0, st1
   ; st0 = float value
    fmul st0, st1      ; st0 = -st0
    mov byte [esi], '-'
    inc esi
   .metka1:

    fld1  ; st0 = 1

    fcomip st1
    jz .one
    jb .normalize
    jmp .translate


   .normalize:
    xor ecx, ecx
    mov eax, 10
    push eax

    fld1
    fxch
   .rep1:

    fidiv dword [esp]
    inc ecx

    fcomi st1
    jb .metka2
    jmp .rep1
   .metka2:
    pop eax

   .translate:
    xchg edx, ecx; edx = digit count before spot
    add ecx, edx ; ecx = digit count before + after spot

    mov eax, 10
    push eax
    fild dword [esp] ; st0 = 10
       ; in dword [esp] temp value  !!!!!!
    fxch      ; st0 = float value
       ; st1 = 10

   .rep2:

    fmul st0, st1
    fld1
    fcmovne st0, st1
    fisttp dword [esp]; trunc st0 and pop it to dword [esp]
    mov al, byte [esp];

    fild dword [esp]  ; st0 = current truncuated digit

    fsubp st1, st0

    add al, 30h ; al from number to char
    mov byte [esi], al
    inc esi
    dec edx
    cmp edx,0
    jnz .metka3
    mov byte [esi], '.'
    inc esi
   .metka3:
    loop .rep2

    pop eax
    jmp .end
   .zero:
    mov byte [esi], '0'
    jmp .end
   .one:
    mov byte [esi], '1'
    jmp .end
   .error:

   .end:
    mov byte [esi], 10
    inc esi
    mov byte [esi], 13
    popad
    ret

error_exit:
    mov eax, 4             ; syscall номер для sys_write
    mov ebx, 1             ; stdout
    mov ecx, msg_error        ; адрес результата
    mov edx, len_error        ; количество байт для вывода
    int 0x80               ; вызов ядра
