	%include "linux.asm"
section .data
nl:
	db 10, 0
section .text
global writenl:function
writenl:
	enter 0, 0
	mov rax, s_write
	mov rdi, [rbp + 16] ; file descriptor
	mov rsi, [rel nl] ; rip-relative, but why []?
	mov rdx, 1
	syscall
	leave
	ret
