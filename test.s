.intel_syntax noprefix
.global _start

.data
    my_byte: .byte 245              # The single byte to print (0 to 255)

.bss
    # Allocate a small buffer in memory to hold the converted text string.
    # A max 8-bit unsigned integer takes 3 digits + 1 newline character = 4 bytes.
    .lcomm buffer, 4                 

.text
_start:
    # 1. Load the byte into AX for division
    movzx ax, byte ptr [rip + my_byte]

    # 2. Point RDI to the END of our buffer (building the string backward)
    lea rdi, [rip + buffer + 3]     # Position for the last digit slot
    mov byte ptr [rdi], 10          # Store ASCII newline character ('\n')
    
    mov cx, 10                      # Divisor is always 10

.Lconversion_loop:
    dec rdi                         # Move buffer pointer back 1 space
    xor dx, dx                      # Clear DX before 16-bit division (DX:AX)
    div cx                          # Divide DX:AX by 10. Quotient -> AX, Remainder -> DX
    
    add dl, '0'                     # Convert the remainder digit to its ASCII character
    mov [rdi], dl                   # Store the ASCII character in the buffer
    
    test ax, ax                     # Check if the quotient is 0
    jnz .Lconversion_loop           # If not 0, loop to extract the next digit

    # 3. Calculate string length for sys_write
    # RDI now points to the very first digit character. 
    # Length = (End of buffer address + 4) - Current RDI pointer
    lea rsi, [rip + buffer + 4]
    sub rsi, rdi                    # RSI now contains the total character count
    mov rdx, rsi                    # RDX = Count argument for sys_write
    
    mov rsi, rdi                    # RSI = Buffer pointer argument for sys_write

    # 4. Invoke sys_write (syscall 1)
    mov rax, 1                      # System call number 1 is sys_write
    mov rdi, 1                      # File descriptor 1 is stdout
    syscall                         # Trigger Linux kernel context switch

    # 5. Invoke sys_exit (syscall 60)
    mov rax, 60                     # System call number 60 is sys_exit
    xor rdi, rdi                    # Exit code 0
    syscall                         # Trigger Linux kernel context switch

