section .data
    msg db "El resultado es: ", 0

section .bss
    res resb 4

section .text
    global _start

_start:
    ; Cargar los números en los registros
    mov al, 5          ; Primer número (5)
    mov bl, 10         ; Segundo número (10)

    ; Realizar la multiplicación
    mul bl             ; AX = AL * BL

    ; Convertir el resultado a cadena
    mov ecx, res      ; Dirección de la cadena
    call PrintInt

    ; Mostrar el mensaje
    mov edx, msg
    call PrintString

    ; Mostrar el resultado
    mov edx, res
    call PrintString

    ; Salir del programa
    mov eax, 1         ; sys_exit
    xor ebx, ebx       ; código de salida 0
    int 0x80           ; llamada al sistema

; Función para imprimir una cadena de caracteres
PrintString:
    ; Entrada: EDX = dirección de la cadena
    ; Salida: imprime la cadena en la consola
    mov eax, 4         ; sys_write
    mov ebx, 1         ; descriptor de archivo (stdout)
    mov ecx, edx       ; dirección de la cadena
    mov edx, [ecx-4]   ; longitud de la cadena
    int 0x80           ; llamada al sistema
    ret

; Función para imprimir un número entero
PrintInt:
    
    add al, '0'        ; convertir el número a carácter ASCII
    mov [ecx], al      ; almacenar el carácter en la cadena
    ret
