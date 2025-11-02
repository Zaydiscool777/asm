section .text
global strlen:function
	strlen:
enter 0, 0
mov rax, 0 ; cx and ax are swapped because... optimization!
mov rdi, [rbp + 16] ; get pointer to string
	strlen_loop:
mov cl, [rdi + rax]
cmp cl, 0
je strlen_end
inc rax
jmp strlen_loop
	strlen_end:
leave
ret
