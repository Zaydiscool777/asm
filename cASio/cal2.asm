section .text
global _start
getnum:
		xor rax, rax
		xor rsi, rsi
		xor rdx, rdx
		mov dl, [rdi]
		mov si, dx
		sub si, '-'
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
		test si, si
		jnz .end
		neg rax
	.end: ret
_start:
		inp equ 64
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
		jl .mul
		idiv rbx
		jmp .done
	.mul: imul rbx
		jmp .done
	.add: add rax, rbx
		jmp .done
	.sub: sub rax, rbx	
	.done:
		mov rdi, rax
		mov rax, 60
		syscall
