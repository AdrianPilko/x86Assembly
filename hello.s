.global _start
.intel_syntax noprefix

_start:

   // clean exit
   // set the return code, zero is success
   mov rdi,0   
   // syscall
   mov rax,60
   syscall
