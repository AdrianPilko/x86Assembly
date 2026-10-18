section .bss
    buffer resb 1       ; Reserve 1 byte for the character input

section .text
    global _start

_start:
.read_char:
    ; 1. Read a character from stdin (System Call: sys_read)
    mov rax, 0          ; syscall number for sys_read (0)
    mov rdi, 0          ; file descriptor: stdin (0)
    mov rsi, buffer     ; pointer to the buffer storing the character
    mov rdx, 1          ; number of bytes to read (1)
    syscall

    ; If rax <= 0 (EOF or error), exit the program
    cmp rax, 0
    jle .exit

    ; 2. Write the character to stdout (System Call: sys_write)
    mov rax, 1          ; syscall number for sys_write (1)
    mov rdi, 1          ; file descriptor: stdout (1)
    mov rsi, buffer     ; pointer to the buffer containing the character
    mov rdx, 1          ; number of bytes to write (1)
    syscall

    ; Check if the user pressed 'Enter' (Line Feed: 0x0A / 10) to stop echoing
    mov al, [buffer]
    cmp al, 0x0A
    je .exit

    jmp .read_char      ; Loop back to read the next character

.exit:
    ; 3. Terminate the program cleanly (System Call: sys_exit)
    mov rax, 60         ; syscall number for sys_exit (60)
    mov rdi, 0          ; exit code 0 (Success)
    syscall

