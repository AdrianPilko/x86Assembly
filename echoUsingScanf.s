section .data
    ; Format strings for scanf and printf
    ; %s reads a white-space delimited string, %[^\n] reads an entire line
    fmt_in  db "%127[^\n]", 0    ; Limit input to 127 bytes to prevent buffer overflow
    fmt_out db "%s", 10, 0      ; Prints the string followed by a newline (10)

section .bss
    buffer resb 128             ; Reserve 128 bytes of memory for the string

section .text
    global main
    extern printf
    extern scanf

_start:
    ; 1. Setup the stack frame (Aligns stack to 16 bytes for C function calls)
    push rbp
    mov rbp, rsp

    ; 2. Call scanf(fmt_in, buffer)
    mov rdi, fmt_in             ; 1st argument: format string
    mov rsi, buffer             ; 2nd argument: address of our buffer
    mov rax, 0                  ; 0 floating-point arguments
    call scanf

    ; Check if scanf successfully read something (returns > 0)
    cmp rax, 0
    jle _exit

    ; 3. Call printf(fmt_out, buffer)
    mov rdi, fmt_out            ; 1st argument: format string
    mov rsi, buffer             ; 2nd argument: address of our buffer
    mov rax, 0                  ; 0 floating-point arguments
    call printf

_exit:
    ; 4. Restore stack frame and exit
    mov rax, 0                  ; Return status 0 (Success)
    mov rsp, rbp
    pop rbp
    ret

