section .data
    msg db "El resultado de la resta es: ", 0

section .bss
    res resb 6  ; Espacio para almacenar el resultado como cadena

section .text
    global _start

_start:
    ; Cargar los números en registros de 16 bits
    mov ax, 1000h  ; Primer número (4096 en decimal)
    mov bx, 500h   ; Segundo número (1280 en decimal)
    mov cx, 200h   ; Tercer número (512 en decimal)

    ; Realizar la resta: ax - bx - cx
    sub ax, bx      ; ax = ax - bx
    sub ax, cx      ; ax = ax - cx

    ; Convertir el resultado a cadena
    mov si, res     ; Dirección de la cadena
    call PrintInt

    ; Mostrar el mensaje
    mov edx, msg
    call PrintString

    ; Mostrar el resultado
    mov edx, res
    call PrintString

    ; Salir del programa
    mov eax, 1       ; sys_exit
    xor ebx, ebx     ; código de salida 0
    int 0x80         ; llamada al sistema

; Función para imprimir una cadena de caracteres
PrintString:
    ; Entrada: EDX = dirección de la cadena
    ; Salida: imprime la cadena en la consola
    mov eax, 4       ; sys_write
    mov ebx, 1       ; descriptor de archivo (stdout)
    mov ecx, edx     ; dirección de la cadena
    mov edx, [ecx-4] ; longitud de la cadena
    int 0x80         ; llamada al sistema
    ret

; Función para convertir un número entero a cadena y almacenarlo en [SI]
PrintInt:
    ; Entrada: AX = número a convertir
    ; Salida: [SI] = cadena con el número
    ; (Implementación simplificada; se puede mejorar para manejar números negativos y más de 10 dígitos)
    add al, '0'      ; convertir el número a carácter ASCII
    mov [si], al     ; almacenar el carácter en la cadena
    ret
