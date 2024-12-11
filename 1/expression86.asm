; MakeAny32.asm
; Компилируется с использованием MASM для 32-битной архитектуры

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
    mov     eax, ecx        ; eax = b
    imul    eax, edx        ; eax = b * c
    mov     esi, eax        ; esi = temp1

    ; Шаг 2: temp2 = 8 / a (знаковое деление)
    mov     eax, 8          ; eax = 8
    cdq                     ; Расширяем знак из eax в edx:eax
    idiv    ebx             ; eax = 8 / a, edx = 8 % a
    mov     edi, eax        ; edi = temp2

    ; Шаг 3: temp3 = temp1 - temp2
    sub     esi, edi        ; esi = temp1 - temp2

    ; Шаг 4: result = temp3 / (30 + b)
    mov     eax, esi        ; eax = temp3
    cdq                     ; Расширяем знак из eax в edx:eax
    mov     ebx, ecx        ; ebx = b
    add     ebx, 30         ; ebx = 30 + b
    idiv    ebx             ; eax = temp3 / (30 + b), edx = temp3 % (30 + b)

    ; Восстанавливаем регистры
    pop     edi             ; Восстанавливаем EDI
    pop     esi             ; Восстанавливаем ESI
    pop     ebx             ; Восстанавливаем EBX
    pop     ebp             ; Восстанавливаем EBP

    ret              ; Очищаем стек (3 параметра * 4 байта)
Make_Any ENDP

END
