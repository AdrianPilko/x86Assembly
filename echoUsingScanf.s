.global main
.section .data
    # %99s limits the input to 99 characters to prevent buffer overflow
    format_in:  .asciz "%99s"       
    format_out: .asciz "%s\n"

.section .bss
    .lcomm buffer, 100               # Reserve 100 bytes for the input string

.text
main:
    # 1. Align the stack and save frame pointer
    pushq %rbp
    movq %rsp, %rbp

    # 2. Call scanf(format_in, buffer)
    # ABI requires: %rdi = 1st arg, %rsi = 2nd arg
    leaq format_in(%rip), %rdi       # Load address of the input format string
    leaq buffer(%rip), %rsi          # Load address of the buffer
    movq $0, %rax                    # printf/scanf need %rax=0 for no vector registers
    call scanf

    # 3. Call printf(format_out, buffer)
    # ABI requires: %rdi = 1st arg, %rsi = 2nd arg
    leaq format_out(%rip), %rdi      # Load address of the output format string
    leaq buffer(%rip), %rsi          # Load address of the buffer
    movq $0, %rax                    # No vector registers used
    call printf

    # 4. Clean up stack and return 0
    movq $0, %rax                    # Return value 0
    movq %rbp, %rsp
    popq %rbp
    ret

