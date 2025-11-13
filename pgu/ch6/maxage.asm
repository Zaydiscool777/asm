%include "record_def.asm"
%include "linux.asm"
extern read_record
section .data
filename:
	db "records.dat", 0
section .bss
	record_buff resb rec_size
section .text
global _start
_start:
	enter 0, 0
	mov rax, s_open
	mov rdi, filename
	mov rsi, o_rdonly
	mov rdx, 0o666
	syscall
	mov rbx, rax ; input file descriptor
	xor ecx, ecx ; max age counter
	xor esi, esi
.loop:
	push rcx
	push rbx
	push record_buff
	call read_record
	add rsp, 16
	pop rcx
	cmp rax, rec_size
	jne .done
	mov esi, [record_buff + rec_age]
	cmp esi, ecx
	jle .loop
	mov ecx, esi
	jmp .loop
.done:
	push rcx
	mov rax, s_close
	mov rdi, rbx
	syscall
	mov rax, s_exit
	pop rdi
	syscall
