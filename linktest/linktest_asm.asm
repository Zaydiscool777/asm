section .note.GNU-stack noalloc noexec nowrite progbits
section .text
global ducr:function
	ducr:
enter 0, 0
mov rax, rdi
add rax, 2
leave
ret
