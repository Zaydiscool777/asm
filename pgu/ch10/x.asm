section .data
	testint dq 890342
section .text
	extern int2str:function
	global _start
_start:
	mov rdi, [testint]
	call int2str
	mov rsi, rax
	mov rax, 1
	mov rdi, 1 ; fd = stdout
	mov rdx, 10
	syscall
	mov rax, 60
	xor rdi, rdi
	syscall
