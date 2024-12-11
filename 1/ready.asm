; MakeAny16.asm
; Компилируется с использованием MASM для 16-битной архитектуры

.386
.model flat, c
.stack 4096

PUBLIC Make_Any

.data
; Здесь можно определить глобальные данные, если необходимо

.code

Make_Any PROC
    ; Входные параметры по соглашению cdecl:
    ; b - [ebp + 8]
    ; c - [ebp + 12]
    ; a - [ebp + 16]

    push    ebp             ; Сохраняем базовый указатель
    mov     ebp, esp        ; Устанавливаем новый базовый указатель
    push    ebx             ; Сохраняем регистр EBX
    push    esi             ; Сохраняем регистр ESI
    push    edi             ; Сохраняем регистр EDI

    ; Получение параметров из стека
    mov     ecx, [ebp + 8]  ; ecx = b
    mov     edx, [ebp + 12] ; edx = c
    mov     ebx, [ebp + 16] ; ebx = a

    ; Шаг 1: temp1 = b * c
    mov     ax, cx          ; ax = b
    imul    ax, dx          ; ax = b * c
    mov     si, ax          ; si = temp1

    ; Шаг 2: temp2 = 8 / a (беззнаковое деление)
    mov     ax, 8           ; ax = 8
    xor     dx, dx          ; очищаем dx перед делением
    div     bx              ; ax = 8 / a, dx = 8 % a
    mov     di, ax          ; di = temp2

    ; Шаг 3: temp3 = temp1 - temp2
    sub     si, di          ; si = temp1 - temp2

    ; Шаг 4: result = temp3 / (30 + b)
    mov     ax, si          ; ax = temp3
    xor     dx, dx          ; очищаем dx перед делением
    add     cx, 30          ; cx = 30 + b
    div     cx              ; ax = temp3 / (30 + b), dx = temp3 % (30 + b)

    ; Восстанавливаем регистры
    pop     edi             ; Восстанавливаем EDI
    pop     esi             ; Восстанавливаем ESI
    pop     ebx             ; Восстанавливаем EBX
    pop     ebp             ; Восстанавливаем EBP

    ret              ; Очищаем стек (3 параметра * 4 байта)
Make_Any ENDP

END
