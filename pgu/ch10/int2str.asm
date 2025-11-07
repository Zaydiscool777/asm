section .data
section .text
global int2str:function
int2str:
	; rax holds current input integer
	; [rbp - 32] points to buffer to hold string
	; rcx is index into buffer
	enter 32, 0 ; 9223372036854775807NULL = 21 bytes
	mov rax, rdi
	mov rbx, 10
	xor rcx, rcx
.getdigit:
	xor rdx, rdx ; clear rdx for div
	div rbx
	; rax is quotient, rdx is remainder
	add dx, '0' ; convert to ASCII
	push dx ; FILO
	inc rcx
	test rax, rax
	jnz .getdigit
;.endgetdigit:
	mov rdx, rbp
	sub rdx, 32 ; point to buffer start
.poploop:
	pop ax
	mov [rdx], al
	inc rdx
	loop .poploop ; DEC then check
.end:
	mov byte [rdx], 0
	mov rax, rbp
	sub rax, 32 ; return pointer to string
	leave
	ret
