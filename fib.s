; --------------------------------------------------------------------------------
; fib_print.asm - Calculates and prints the first 1,000,000 Fibonacci numbers
; Assemble: yasm -f elf64 fib_print.asm -o fib_print.o
; Link:     ld fib_print.o -o fib_print
; Run:      ./fib_print
; --------------------------------------------------------------------------------

global _start

section .data
    MAX_DIGITS  equ 210000          ; Max decimal digits for F(1,000,000)
    TARGET_FIB  equ 1000         ; Total iterations
    ;TARGET_FIB  equ 1000000         ; Total iterations
    newline     db 10               ; Newline character for printing

section .bss
    ; Arrays store digits backwards: index 0 is the least significant digit (ones place)
    ; Each byte contains a raw decimal value from 0 to 9.
    fib_n2      resb MAX_DIGITS      ; F(n-2)
    fib_n1      resb MAX_DIGITS      ; F(n-1)
    fib_curr    resb MAX_DIGITS      ; F(n)

    ; Reverse buffer for printing digits in the correct left-to-right order
    print_buf   resb MAX_DIGITS

    current_len resq 1              ; Dynamic digit count (tracks how many digits to process/print)

section .text
_start:
    ; --- Handle F(0) = 0 ---
    mov byte [fib_n2], 0
    ; Print "0\n"
    mov byte [print_buf], '0'
    mov rax, 1                      ; sys_write
    mov rdi, 1                      ; stdout
    mov rsi, print_buf
    mov rdx, 1
    syscall
    mov rax, 1                      ; sys_write newline
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall

    ; --- Handle F(1) = 1 ---
    mov byte [fib_n1], 1
    ; Print "1\n"
    mov byte [print_buf], '1'
    mov rax, 1                      ; sys_write
    mov rdi, 1                      ; stdout
    mov rsi, print_buf
    mov rdx, 1
    syscall
    mov rax, 1                      ; sys_write newline
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall

    ; --- Loop Initialization ---
    mov qword [current_len], 1      ; Start with 1 digit
    mov r12, 2                      ; r12 = current iteration counter (n)

.fib_loop:
    ; --- Base-10 Arbitrary-Precision Addition ---
    xor rbx, rbx                    ; Index pointer = 0
    xor dl, dl                      ; dl will hold our 'carry' (0 or 1)
    mov rcx, [current_len]          ; Loop only through active digits

.add_loop:
    mov al, [fib_n1 + rbx]          ; Get digit from F(n-1)
    add al, [fib_n2 + rbx]          ; Add digit from F(n-2)
    add al, dl                      ; Add carry from previous column
    
    ; Manual base-10 carry adjustment (simulating a decimal 'adc')
    cmp al, 10
    jae .carry_generated
    xor dl, dl                      ; No carry
    jmp .store_digit

.carry_generated:
    sub al, 10                      ; Keep only the ones place digit
    mov dl, 1                       ; Set carry to 1

.store_digit:
    mov [fib_curr + rbx], al        ; Save digit in F(n)
    inc rbx
    loop .add_loop

    ; --- Handle Final Carry Spill ---
    cmp dl, 0
    je .no_overflow
    mov [fib_curr + rbx], dl        ; Store final carry
    inc qword [current_len]         ; Expand digit length

.no_overflow:
    ; --- Print Current Fibonacci Number ---
    ; Digits are stored backwards (index 0 = ones place). 
    ; We must flip them into print_buf and convert to ASCII ('0' - '9') to print correctly.
    mov rcx, [current_len]          ; Total digits to convert
    mov rsi, rcx                    ; Use rsi to index print_buf from left to right
    dec rsi                         ; Destination offset = length - 1
    xor rbx, rbx                    ; Source offset = 0

.format_loop:
    mov al, [fib_curr + rbx]
    add al, '0'                     ; Convert raw 0-9 value to ASCII character
    mov [print_buf + rsi], al       ; Place in print buffer
    inc rbx
    dec rsi                         ; Fill buffer backwards (resulting in forward text)
    loop .format_loop

    ; Fast Linux Syscall to Print the Number String
    mov rax, 1                      ; sys_write
    mov rdi, 1                      ; stdout
    mov rsi, print_buf              ; Address of character string
    mov rdx, [current_len]          ; String length
    syscall

    ; Print Newline
    mov rax, 1                      ; sys_write
    mov rdi, 1                      ; stdout
    mov rsi, newline
    mov rdx, 1
    syscall

    ; --- Shift Buffers for Next Iteration ---
    ; F(n-2) = F(n-1)  and  F(n-1) = F(curr)
    mov rcx, [current_len]
    xor rbx, rbx

.shift_loop:
    mov al, [fib_n1 + rbx]
    mov [fib_n2 + rbx], al
    
    mov dl, [fib_curr + rbx]
    mov [fib_n1 + rbx], dl
    
    inc rbx
    loop .shift_loop

    ; --- Loop Condition ---
    inc r12
    cmp r12, TARGET_FIB
    jle .fib_loop                   ; Repeat until F(1,000,000) is reached

    ; --- Graceful Exit ---
    mov rax, 60                     ; sys_exit
    xor rdi, rdi                    ; Return 0
    syscall

