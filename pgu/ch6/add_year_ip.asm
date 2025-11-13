%include "record_def.asm"
%include "linux.asm"
extern read_record
extern write_record
section .data
filename:
	db "records.dat", 0
section .bss
fdinout:
	resq 1
record_buff:
	resb rec_size
section .text
global _start
_start:
	enter 0, 0
	mov rax, s_open
	mov rdi, filename
	mov rsi, o_rdwr
	mov rdx, 0o666
	syscall
	mov rbx, rax ; inplace file descriptor
mod_loop:
	push rbx ; rbx <-> fdinout
	push record_buff
	call read_record
	add rsp, 16
	cmp rax, rec_size
	jne done_reading
	mov rsi, [record_buff + rec_age]
	inc rsi
	mov [record_buff + rec_age], rsi
	; move backwards via lseek
	mov rax, s_lseek
	mov rdi, rbx
	mov rsi, -rec_size
	mov rdx, 1 ; SEEK_CUR
	syscall

	push rbx
	push record_buff
	call write_record
	add rsp, 16
	jmp mod_loop
done_reading:
	mov rax, s_close
	mov rdi, rbx
	syscall
	mov rax, s_exit
	mov rdi, 0
	syscall
