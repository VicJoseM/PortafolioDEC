section .data
    msg db "El resultado es: ", 0xA  ; Mensaje con salto de línea
    msg_len equ $ - msg

section .bss
    res resb 6    ; Para número hasta 65535 + terminador nulo

section .text
    global _start

_start:
    ; Cargar números
    mov al, 5         ; Primer número
    mov bl, 10        ; Segundo número

    ; Multiplicar AL * BL → resultado en AX
    mul bl            ; AX = 50

    ; Convertir resultado en AX a cadena
    mov si, res
    call PrintInt     ; Almacena cadena decimal en [res]

    ; Imprimir mensaje
    mov eax, 4        ; sys_write
    mov ebx, 1        ; stdout
    mov ecx, msg
    mov edx, msg_len
    int 0x80

    ; Calcular longitud de cadena en res
    mov ecx, res
    call StrLen       ; EAX = longitud
    mov edx, eax
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
; Entrada: AX = número a convertir
; Salida: convierte número decimal en [SI]
PrintInt:
    push ax
    push bx
    push cx
    push dx
    push si

    mov cx, 0        ; contador de dígitos
    mov bx, 10       ; divisor

    cmp ax, 0
    jne .convert
    mov byte [si], '0'
    inc si
    jmp .done

.convert:
    xor dx, dx
.reverse_loop:
    xor dx, dx
    div bx          ; AX / 10 → AX = cociente, DX = resto
    add dl, '0'     ; convertir dígito a ASCII
    push dx
    inc cx
    cmp ax, 0
    jne .reverse_loop

.write_digits:
    pop dx
    mov [si], dl
    inc si
    loop .write_digits

.done:
    mov byte [si], 0

    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret

; ---------------------------
; Función: StrLen
; Entrada: ECX = dirección de cadena null-terminada
; Salida: EAX = longitud
StrLen:
    push ecx
    push eax

    xor eax, eax
.loop:
    cmp byte [ecx], 0
    je .end
    inc ecx
    inc eax
    jmp .loop

.end:
    pop eax
    pop ecx
    ret
