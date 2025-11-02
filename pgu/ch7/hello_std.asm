section .note.GNU-stack noalloc noexec nowrite progbits ; because ld
section .data
msg db "hello, world!", 10, 0
section .text
extern printf
extern exit
global main
	main:
mov al, 0 ; amount of floats?
mov rdi, msg ; in word #1
call printf
mov rdi, 0
call exit
