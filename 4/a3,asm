CODESG SEGMENT PARA 'CODE'
    BEGIN PROC FAR
        ASSUME CS:CODESG, SS:STACKSG, DS:DATASG, ES:DATASG
        PUSH DS
        
        SUB AX, AX
        
        PUSH AX
        
        MOV AX, DATASG
        
        MOV DS, AX
        
        MOV ES, AX
        
        
        ; input message: enter c
        
        MOV AX, 0900H
        
        LEA DX, MESSAGE1
        
        INT 21H
        
        
        ; input c
        
        CALL INPUT_NUMBER
        
        MOV AX, BIN_VALUE
        
        MOV NUMBER_C, AX
        
        
        CALL COUT_ENDL
        
        
        ; input message: enter d
        
        MOV AX, 0900H
        
        LEA DX, MESSAGE2
        
        INT 21H
        
        
        ; input d
        
        CALL INPUT_NUMBER
        
        MOV AX, BIN_VALUE
        
        MOV NUMBER_D, AX
        
        CALL COUT_ENDL
        
        
        ; input message: enter array
        
        MOV AX, 0900H
        
        LEA DX, MESSAGE_ARR
        
        INT 21H
        
        
        CALL COUT_ENDL
        
        
        MOV CX, bN ; 5
        
        XOR BX, BX
        
        
    INP:
        
        CALL INPUT_NUMBER
        
        MOV AX, BIN_VALUE
        
        CALL COUT_ENDL
        
        MOV NUMBERS[BX], AX
        
        INC BX
        
        INC BX
        
        
        LOOP INP
        
        
        MOV CX, bN
        
        CALL LAB4
        
        MOV AX, 0900H
        LEA DX, RESULT_MESSAGE ; Added message before the result
        INT 21H
        
        LEA SI, RESULT + RESULT_SIZE - 1 ; Point to the end of the buffer
        CALL BIN_TO_ASCII
        
        MOV AX, 0900H
        LEA DX, RESULT
        INT 21H
        
    EXIT:
        MOV AX, 4C00H
        INT 21H
        RET
    BEGIN ENDP
    
    LAB4 PROC NEAR
        PUSH AX
        PUSH BX
        PUSH CX
        PUSH SI
        PUSH DI
    
        MOV AX, 1          ; Initialize AX with 1 for multiplication
        MOV SI, 0          ; Initialize SI as the array index
        MOV CX, bN         ; Set the number of elements to process
    
    DO_LOOP:
        MOV BX, NUMBERS[SI] ; Load the current array element into BX
    
        ; Check if BX is in the range [NUMBER_C, NUMBER_D]
        CMP BX, NUMBER_C
        JL NEXT_ELEMENT
        CMP BX, NUMBER_D
        JG NEXT_ELEMENT
        CMP BX, 0
        JL NEXT_ELEMENT
    
        MUL BX              ; Multiply AX by BX. Result in DX:AX
        ; Overflow check can be added here if necessary
        ; For simplicity, assuming no overflow occurs
    
        ; Store the result back in AX
        ; If overflow needs to be handled, consider using DX
    
    NEXT_ELEMENT:
        ADD SI, 2           ; Move to the next array element (WORD size)
        LOOP DO_LOOP        ; Repeat the loop until CX=0
    
        MOV BIN_VALUE, AX   ; Store the multiplication result in BIN_VALUE
    
        POP DI
        POP SI
        POP CX
        POP BX
        POP AX
        RET
    LAB4 ENDP
    
    
    COUT_ENDL PROC NEAR
        PUSH AX
        PUSH DX
        
        MOV AH, 09
        LEA DX, ENDLINE
        INT 21H
        
        POP DX
        POP AX
        RET
    COUT_ENDL ENDP
    
    
    INPUT_NUMBER PROC NEAR
        PUSH AX
        PUSH BX
        PUSH CX
        PUSH DX
        PUSH DI
        PUSH SI
    
        JMP NORMAL
    
    MESSAGE_ERROR_LABEL:
        CALL COUT_ENDL
        MOV AX, 0900H
        LEA DX, INPUT_ERROR_MESSAGE
        INT 21H
        ; Exit the program on error
        JMP EXIT
    
    NORMAL:
        MOV MULT10, 1
        MOV BIN_VALUE, 0
        MOV AX, 0A00H
        LEA DX, IPARAM
        INT 21H
    
        LEA SI, FIELD - 1
        MOV BH, 0
        MOV BL, ASCLEN
    
        CALL IS_NUMBER
        ; If IS_NUMBER detects an error, it jumps to EXIT
    
        CALL ASCII_TO_BIN
    
        POP SI
        POP DI
        POP DX
        POP CX
        POP BX
        POP AX
        RET
    INPUT_NUMBER ENDP
    
    
    ASCII_TO_BIN PROC NEAR
        PUSH AX
        PUSH BX
        PUSH CX
        PUSH DX
        PUSH DI
        PUSH SI
    
        MOV CX, 10
        MOV DX, BX ; SAVE LEN TO DX
        MOV BX, 1
    
        MOV AL, [SI + BX]
        MOV BX, DX
        XOR DX, DX
        MOV DI, BX ; DI = BX
    
        CMP AL, '-' ; Check if the input is negative
        JE NEGATIVE_INPUT
        JMP CONVERT_POSITIVE
    
    NEGATIVE_INPUT:
        ; Exit the program if a negative number is entered
        JMP EXIT
    
    CONVERT_POSITIVE:
        MOV AL, [SI + BX]
        AND AX, 000FH
        MUL MULT10
        ADD BIN_VALUE, AX
        MOV AX, MULT10
        MUL CX
        MOV MULT10, AX
        DEC BX
        DEC DI
        JNZ CONVERT_POSITIVE
    
        CMP BX, DI ; IF BX == DI
        JE END_B ; NO MINUS
    
        ; ELSE MINUS (Not used as negatives are handled above)
        MOV AX, BIN_VALUE
        NEG AX
        MOV BIN_VALUE, AX
    
    END_B:
        POP SI
        POP DI
        POP DX
        POP CX
        POP BX
        POP AX
        RET
    ASCII_TO_BIN ENDP
    
    
    IS_NUMBER PROC NEAR
        PUSH AX
        PUSH BX
        PUSH CX
        PUSH DX
        PUSH DI
        PUSH SI
    
        MOV CX, BX ; SAVE LEN IN CX
        MOV BX, 1 ; BX = 1
        MOV AL, [SI + BX] ; AL = first character
    
        CMP AL, '-' ; Check if the first character is a minus sign
        JNE IS_NUM
        ; If negative numbers are not allowed, exit
        JMP EXIT
    
    IS_NUM:
        MOV BX, CX ; LEN in BX
    CHECK_LOOP:
        MOV AL, [SI + BX]
        CMP AL, '0'
        JB ERROR_HANDLER
        CMP AL, '9'
        JA ERROR_HANDLER
        DEC BX
        DEC CX
        JNZ CHECK_LOOP
        JMP BRANCHI
    
    ERROR_HANDLER:
        ; Invalid character detected, exit program
        JMP EXIT
    
    BRANCHI:
        POP SI
        POP DI
        POP DX
        POP CX
        POP BX
        POP AX
        RET
    IS_NUMBER ENDP
    
    
    BIN_TO_ASCII PROC NEAR
        PUSH AX
        PUSH BX
        PUSH CX
        PUSH DX
        PUSH SI
        PUSH DI
    
        MOV CX, 10
        LEA SI, RESULT + RESULT_SIZE - 2 ; Start from the end -2 to leave space for sign and '$'
        MOV BYTE PTR [SI+1], '$' ; Null-terminate the string
        MOV AX, BIN_VALUE
        JS negative ; Check for negative number
    
    positive:
        XOR DX, DX
        DIV CX
        ADD DL, '0'
        MOV [SI], DL
        DEC SI
        TEST AX, AX
        JNZ positive
        JMP end_conversion
    
    negative:
        NEG AX
        MOV BYTE PTR [SI], '-' ; Add minus sign
        DEC SI
        JMP positive
        
    end_conversion:
        POP DI
        POP SI
        POP DX
        POP CX
        POP BX
        POP AX
        RET
    BIN_TO_ASCII ENDP
    
    
    CODESG ENDS
    
    ;---------------END CODE---------------
    
    
    ;-----------------STACK-----------------
    
    STACKSG SEGMENT PARA STACK 'STACK'
        DW 128 DUP(?) ; Increased stack size
    STACKSG ENDS
    ;---------------END STACK---------------
    
    
    ;-----------------DATA-----------------
    
    DATASG SEGMENT PARA 'DATA'
    
    INPUT_ERROR_MESSAGE DB 'INCORRECT INPUT. PROGRAM TERMINATING.$'
    
    bN DW 5 ; Number of elements
    
    NUMBER_C DW 0
    
    NUMBER_D DW 0
    
    MESSAGE1 DB 'ENTER C: $'
    
    MESSAGE2 DB 'ENTER D: $'
    
    MESSAGE_ARR DB 'ENTER 5 ELEMENTS: $'
    
    NUMBERS DW 5 DUP(0)
    
    IPARAM LABEL BYTE
    
    MAXLEN DB 20
    
    ASCLEN DB ?
    
    FIELD DB 20 DUP (' ')
    
    MULT10 DW 1
    
    BIN_VALUE DW 0
    
    ENDLINE DB 13, 10, '$'
    
    RESULT_MESSAGE DB 'Result: $' ; Message before the result
    RESULT_SIZE EQU 10 ; Define the size of the result buffer
    RESULT DB RESULT_SIZE DUP(' ') ; Increased size of the result buffer
    
    DATASG ENDS
    
    ;---------------END DATA---------------
    
    
    END BEGIN
