.model small, c
.stack 100h
.data
Extrn aaaS:byte, bbbS:byte, cccS:byte, result:word
.code
Public Lab1S
Lab1S proc far
    mov al, bbbS          
    cbw                   
    imul cccS             
    mov dx, ax           ; dx = b * c
    mov al, 8              ; AL = 8
    cbw                    ; Расширение AL -> AX (знаковое расширение)
    mov cl, aaaS           ; CL = aaaS (делитель)
    mov ch, 0              ; Расширяем CL до 16 бит (CX = aaaS)
    cmp ax, cx             ; Сравниваем AX с CX
    jg Continue            ; Если AX > CX, продолжаем (переходим к idiv)
    je Equal               ; Если AX = CX, то результат деления будет 1
    mov ax, 0              ; Если AX < CX, записываем 0 в AX
    jmp Done               ; Переход к завершению
Equal:
    mov ax, 1              ; Если AX = CX, записываем 1 в AX
    jmp Done               ; Переход к завершению
Continue:
    idiv aaaS
    jmp Done             ; Деление AX / CX
Done:
    mov bx, ax         ; bx = 8 / a
    mov ax, dx
    sub ax, bx
    mov bx, ax         ; BX = chisl
    mov al, bbbS
    cbw
    add ax, 30
    mov cx, ax          ; CX = znam
    
    mov ax, bx
    cwd 
    idiv cx
    
    mov result, ax
    
    ret
Lab1S endp
end
