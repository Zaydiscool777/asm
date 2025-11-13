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
		idiv rbx
		cmovl rax, rdx ; intel, so eflags stay :)
		jmp print
	.mul: imul rbx
		jmp print
	.add: add rax, rbx
		jmp print
	.sub: sub rax, rbx	
print:
		mov byte [rbp + inp-1], 10
		mov rcx, 1
		lea rsi, [rbp + inp-2]
		test rax, rax
		sets bl
		mov r9, rbx
		jns .loop
		neg rax
	.loop:
		; search: Granlund–Montgomery’s algorithm
		mov r8, rax
		mov rdx, 0xCCCC_CCCC_CCCC_CCCD ; 8/10
		mul rdx
		mov rbx, rdx
		shr rbx, 3
		
		mov rax, r8
		mov rdx, rbx
		shl rdx, 3
		lea rdx, [rdx + rbx * 2]
		; shr rdx, 3
		sub rax, rdx
		mov rdx, rbx
		xchg rax, rdx
		
		add dl, '0'
		mov [rsi], dl
		dec rsi
		inc rcx
		test rax, rax
		jnz .loop
		
		mov rbx, r9
		test bl, bl
		jz .out
		mov byte [rsi], '-'
		inc rcx
		dec rsi
	.out:
		inc rsi
		mov rax, 1
		mov rdi, 1
		mov rdx, rcx
		syscall
		mov rax, 60
		syscall
