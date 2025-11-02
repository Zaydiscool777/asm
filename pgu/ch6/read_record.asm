	%include "record_def.asm"
	%include "linux.asm"
	st_write_buffer equ 16
	st_filedes equ 24
section .text
global read_record:function
read_record:
	enter 0, 0
	; ... filedes buffloc RET [RBP]
	mov rax, s_read
	mov rdi, [rbp + st_filedes]
	mov rsi, [rbp + st_write_buffer]
	mov rdx, rec_size
	syscall
	leave
	ret
