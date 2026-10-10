.global main
.text

main:
    # 1. Read input from stdin (sys_read)
    movq $0, %rax       # sys_read system call number
    movq $0, %rdi       # file descriptor 0 (stdin)
    leaq buffer, %rsi   # pointer to the input buffer
    movq $100, %rdx     # maximum number of bytes to read
    syscall             # invoke Linux kernel

    # The actual number of bytes read is now stored in %rax
    movq %rax, %rbx     # save the byte count into %rbx for the next step

    # 2. Echo the input back to stdout (sys_write)
    movq $1, %rax       # sys_write system call number
    movq $1, %rdi       # file descriptor 1 (stdout)
    leaq buffer, %rsi   # pointer to the input buffer
    movq %rbx, %rdx     # length of bytes to write (what sys_read returned)
    syscall             # invoke Linux kernel

    # 3. Exit safely
    movq $0, %rax       # return code 0
    ret

.section .bss
.lcomm buffer, 100       # reserve 100 bytes for the input string

