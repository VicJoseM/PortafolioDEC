section .data
    msg_cociente db "Cociente: ", 0
    msg_cociente_len equ $ - msg_cociente

    msg_residuo db "Residuo: ", 0
    msg_residuo_len equ $ - msg_residuo

    newline db 0xA
    newline_len equ $ - newline

section .bss
    buffer resb 12     ; Suficiente para 10 dígitos + signo + null

section .text
    global _start

_start:
    ; Dividir 100 entre 7
    mov eax, 100       ; Dividendo
    mov ebx, 7         ; Divisor
    cdq                ; Extiende EAX a EDX:EAX (signo)
    idiv ebx           ; EAX = cociente (14), EDX = residuo (2)

    ; Guardar resultados
    push eax           ; Guardar cociente
    push edx           ; Guardar residuo

    ; Imprimir "Cociente: "
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_cociente
    mov edx, msg_cociente_len
    int 0x80

    ; Imprimir valor del cociente
    pop eax            ; Recuperar cociente
    mov edi, buffer
    call PrintInt
    call PrintBuffer

    ; Salto de línea
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, newline_len
    int 0x80

    ; Imprimir "Residuo: "
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_residuo
    mov edx, msg_residuo_len
    int 0x80

    ; Imprimir valor del residuo
    pop eax            ; Recuperar residuo
    mov edi, buffer
    call PrintInt
    call PrintBuffer

    ; Salto de línea
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, newline_len
    int 0x80

    ; Salir del programa
    mov eax, 1
    xor ebx, ebx
    int 0x80

; ------------------------------------------------
; PrintInt: convierte EAX en cadena decimal
; Entrada: EAX = número, EDI = buffer destino
; Salida: buffer en EDI con cadena null-terminada
PrintInt:
    push eax
    push ecx
    push edx
    push edi

    mov ecx, 0        ; contador de dígitos
    mov ebx, 10       ; divisor base 10
    cmp eax, 0
    jne .convert
    mov byte [edi], '0'
    inc edi
    jmp .done

.convert:
    xor edx, edx
.next_digit:
    xor edx, edx
    div ebx           ; EAX / 10 → EAX = cociente, EDX = resto
    add dl, '0'       ; convertir dígito a ASCII
    push dx
    inc ecx
    test eax, eax
    jnz .next_digit

.write_digits:
    pop dx
    mov [edi], dl
    inc edi
    loop .write_digits

.done:
    mov byte [edi], 0 ; terminador nulo

    pop edi
    pop edx
    pop ecx
    pop eax
    ret

; ------------------------------------------------
; PrintBuffer: imprime cadena null-terminada en [buffer]
; Entrada: EDI = dirección de la cadena
PrintBuffer:
    push eax
    push ebx
    push ecx
    push edx

    mov ecx, edi
    call StrLen
    mov edx, eax
    mov eax, 4
    mov ebx, 1
    int 0x80

    pop edx
    pop ecx
    pop ebx
    pop eax
    ret

; ------------------------------------------------
; StrLen: calcula longitud de cadena null-terminada
; Entrada: ECX = dirección de cadena
; Salida: EAX = longitud
StrLen:
    push ecx
    xor eax, eax
.loop:
    cmp byte [ecx + eax], 0
    je .end
    inc eax
    jmp .loop
.end:
    pop ecx
    ret
