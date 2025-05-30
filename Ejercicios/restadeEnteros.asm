section .data
    msg db "El resultado de la resta es: ", 0
    msg_len equ $ - msg

section .bss
    res resb 6      ; Suficiente para "65535" + null (máximo 5 dígitos + terminador nulo)

section .text
    global _start

_start:
    ; Cargar números
    mov ax, 1000h   ; 4096
    mov bx, 500h    ; 1280
    mov cx, 200h    ; 512

    ; Resta
    sub ax, bx      ; AX = 4096 - 1280 = 2816
    sub ax, cx      ; AX = 2816 - 512  = 2304

    ; Convertir número a cadena
    mov si, res     ; dirección donde guardar el número convertido
    call PrintInt

    ; Mostrar mensaje
    mov eax, 4
    mov ebx, 1
    mov ecx, msg
    mov edx, msg_len
    int 0x80

    ; Mostrar resultado
    ; Primero calculamos la longitud de la cadena (hasta null)
    mov ecx, res
    call StrLen
    mov edx, eax        ; longitud del número convertido
    mov eax, 4
    mov ebx, 1
    mov ecx, res
    int 0x80

    ; Salir
    mov eax, 1
    xor ebx, ebx
    int 0x80

; ---------------------------
; Función: PrintInt
; Entrada: AX = número
; Salida: cadena decimal en [SI], terminada en null
PrintInt:
    push ax
    push bx
    push cx
    push dx
    push si

    mov cx, 0          ; contador de dígitos
    mov bx, 10         ; divisor para obtener cada dígito

    ; Si AX es cero, guardar '0' directamente
    cmp ax, 0
    jne .convert
    mov byte [si], '0'
    inc si
    jmp .done

.convert:
    mov dx, 0
.reverse_loop:
    xor dx, dx
    div bx            ; AX / 10 → AX = cociente, DX = resto
    add dl, '0'       ; convierte resto a ASCII
    push dx           ; guarda el carácter en la pila
    inc cx
    cmp ax, 0
    jne .reverse_loop

.write_digits:
    pop dx
    mov [si], dl
    inc si
    loop .write_digits

.done:
    mov byte [si], 0  ; terminador nulo

    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret

; ---------------------------
; Función: StrLen
; Entrada: ECX = dirección de cadena terminada en 0
; Salida: EAX = longitud (sin contar el terminador)
StrLen:
    push ecx
    push eax

    xor eax, eax
.next_char:
    cmp byte [ecx], 0
    je .done
    inc ecx
    inc eax
    jmp .next_char

.done:
    pop eax
    pop ecx
    ret
