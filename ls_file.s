.intel_syntax noprefix

.section .rodata
   CRchar:
      .asciz "\n"
   ls_text_dev:
      .asciz "device id:\n"
    // hoping that linux syscall allows relative paths :D
   ls_filename:
    //  .asciz "/home/adrianp/GitHub/x86Assembly/ls_stat.s"
    .string "/etc/passwd"
.section .bss
   // reserve space for the lstat buffer return "structure"
   .lcomm statbuff, 48

// using https://chromium.googlesource.com/chromiumos/docs/+/master/constants/syscalls.md for reference on syscalls
// this might be wrong as just noticed that this isn't the version of linux/kernel I'm on!
// so might be better to use the header files from kernel.org
.section .text
   .globl _start

_start:
   // syscall number for lstat
   mov rax, 6
   // for now, just ls the hard coded filename
   lea rdi, [rip + ls_filename]
   
   // the output goes into the second arg struct __old_kernel_stat *statbuf   
   // so presumably need to allocate memeory for that size
   lea rsi,[rip + statbuff]
   syscall                       

   //  Check the result of the system call (returned in RAX)
   cmp rax, 0
   jl syscall_failed 
   jp syscall_ok
 
syscall_failed:
   // clean exit
   // set the return code, 1 is fail
   mov rdi,1
   // syscall
   mov rax,60
   syscall

syscall_ok:

   // print out device id
   // dev_t is 64bits on 64bit systems
   mov rax, 1
   mov rdi, 1
   lea rsi, [rip + ls_text_dev]
   mov rdx, 14
   syscall

   mov rax, [rip+statbuff]

   callq _printByte

   callq printCR
   
   // clean exit
   // set the return code, zero is success
   mov rdi,0
   // syscall
   mov rax,60
   syscall


printCR:
   mov rax, 1
   mov rdi, 1
   lea rsi, [rip + CRchar]
   mov rdx, 2
   syscall
   ret
