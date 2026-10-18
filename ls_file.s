.intel_syntax noprefix

.section .rodata
   ls_text:
      .asciz "list file:\n"
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
   
   // syscall number
   mov rax, 1
   // output channel - stdout
   mov rdi, 1
   // load the text lea - load effective address
   lea rsi, [ls_text]
   // number of characters (inclduing the null terminator)
   mov rdx, 13
   syscall

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
   // clean exit
   // set the return code, zero is success
   mov rdi,0
   // syscall
   mov rax,60
   syscall

