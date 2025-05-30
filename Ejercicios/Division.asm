section .data
    msg_cociente db 'Cociente: ', 0
    msg_residuo  db 'Residuo: ', 0
    newline      db 0xA, 0

section .bss
    cociente resd 1
    residuo  resd 1

section .text
    global _start

_start:
    ; Cargar el dividendo y divisor
    mov eax, 100      ; Dividendo
    mov ebx, 7        ; Divisor

    ; Preparar para la división
    cdq               ; Extiende EAX a EDX:EAX para la división
    idiv ebx          ; EAX = cociente, EDX = residuo

    ; Almacenar los resultados
    mov [cociente], eax
    mov [residuo], edx

    ; Mostrar "Cociente: "
    mov edx, msg_cociente
    call PrintString

    ; Mostrar el cociente
    mov eax, [cociente]
    call PrintInt

    ; Salto de línea
    mov edx, newline
    call PrintString

    ; Mostrar "Residuo: "
    mov edx, msg_residuo
    call PrintString

    ; Mostrar el residuo
    mov eax, [residuo]
    call PrintInt

    ; Salto de línea
    mov edx, newline
    call PrintString

    ; Salir del programa
    mov eax, 1        ; sys_exit
    xor ebx, ebx      ; código de salida 0
    int 0x80          ; llamada al sistema

; Función para imprimir una cadena
PrintString:
    ; Entrada: EDX = dirección de la cadena
    mov eax, 4        ; sys_write
    mov ebx, 1        ; descriptor de archivo (stdout)
    mov ecx, edx      ; dirección de la cadena
    mov edx, [ecx-4]  ; longitud de la cadena
    int 0x80          ; llamada al sistema
    ret

; Función para imprimir un número entero
PrintInt:
    
    add eax, '0'      ; convertir el número a carácter ASCII
    mov [esp-1], al   ; almacenar el carácter en la pila
    mov eax, 4        ; sys_write
    mov ebx, 1        ; descriptor de archivo (stdout)
    lea ecx, [esp-1]  ; dirección del carácter en la pila
    mov edx, 1        ; longitud del carácter
    int 0x80          ; llamada al sistema
    ret
