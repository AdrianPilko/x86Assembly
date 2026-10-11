; Simple example program to compute the
; sum of squares from 1 to n.
; from book https://www.cl72.org/120introAssem/assembly-language64-ubuntu.pdf
; **********************************************
; Data declarations

extern printf
section .data
; -----
; Define constants
	SUCCESS equ 0 ; Successful operation
	SYS_exit equ 60 ; call code for terminate
; Define Data.
	n dd 10
	sumOfSquares dq 0
; *******************************************************
section .text

	format_str db "%d`n"

global _start
_start:
; -----
; Compute sum of squares from 1 to n (inclusive).
; Approach:
; for (i=1; i<=n; i++)
; sumOfSquares += i^2;
	mov rbx, 1 ; i
	mov ecx, dword [n]
sumLoop:
	mov rax, rbx ; get i
	mul rax ; i^2
	add qword [sumOfSquares], rax
	inc rbx
	loop sumLoop
; -----
; Done, terminate program.
last:
	mov rdi, format_str
	; rdx already has the result
	call printf
	mov rax, SYS_exit ; call code for exit
	mov rdi, SUCCESS ; exit with success
	syscall
