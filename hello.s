.global _start
.intel_syntax noprefix

_start:
   
   // print hello world!!
  
   // syscall number
   mov rax, 1
   // output channel - stdout
   mov rdi, 1
   // load the text lea - load effective address
   lea rsi, [hello_text]
   // number of characters (inclduing the null terminator)
   mov rdx, 14 
   syscall
   
   // clean exit
   // set the return code, zero is success
   mov rdi,0   
   // syscall
   mov rax,60
   syscall

hello_text:
   .asciz "Hello, World!\n"

