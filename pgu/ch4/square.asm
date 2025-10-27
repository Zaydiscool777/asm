section .text
global _start
	_start:
push 13
call square
add rsp, 8
mov rdi, rax ; exit
mov rax, 60
syscall

global square:function
	square:
enter 0, 0
mov rax, [rbp + 16] ; ... in RET [RBP]
imul rax, rax
leave
ret
