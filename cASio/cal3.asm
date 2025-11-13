		inp equ 64 ; input maximum size
section .text
global _start
getnum:
		xor rax, rax
		mov dl, [rdi]
		mov sil, dl
		sub sil, '-'
		jnz .pos
	.loop: inc rdi
	.pos:
		mov dl, [rdi]
		sub dl, '0'
		jc .end0
		imul rax, 10
		add rax, rdx
		jmp .loop
	.end0:
		test sil, sil
		jnz .end
		neg rax
	.end: ret
_start:
		enter inp, 0
		xor rax, rax
		xor rdi, rdi
		mov rsi, rbp
		mov rdx, inp
		syscall
		mov rdi, rbp
		call getnum
		push rax
		mov cl, [rdi]
		inc rdi
		call getnum
		mov rbx, rax
		pop rax
		cmp cl, '+'
		je .add
		cmp cl, '-'
		je .sub
		xor rdx, rdx
		cmp cl, '*'
		je .mul
		; setg cl
		idiv rbx
		; test cl, cl
		cmovl rax, rdx ; cmovz
		jmp print
	.mul: imul rbx
		jmp print
	.add: add rax, rbx
		jmp print
	.sub: sub rax, rbx	
print:
		xor rcx, rcx
		lea rsi, [rbp + inp]
		dec rsi
		mov r8, 10
		test rax, rax
		sets bl
		jns .loop
		neg rax
	.loop:
		xor rdx, rdx
		idiv r8
		add dl, '0'
		mov [rsi], dl
		dec rsi
		inc rcx
		test rax, rax
		jnz .loop
		test bl, bl
		jz .out
		mov byte [rsi], '-'
		inc rcx
		dec rsi
	.out:
		mov rax, 1
		mov rdi, 1
		mov rdx, rcx
		syscall
		mov rax, 60
		syscall
