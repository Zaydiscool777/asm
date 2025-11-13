; the abbreviation uod. means "with user as optimally directed"
section .data
	num1 dq 0
	num2 dq 0
	op db 0
section .bss
	inp resb 64
section .text
global _start

; input:
; rdi = string pointer
; rsi = store output
; output:
; rdi = rax
; rax = string pointer to after number OR end of string
; register uses:
; rax = current value
; si = is sign negative (0 = -, else = +)
; rdi = current string pointer
; dl = current character
; rsi = memory to save to (later)
getnum:
	enter 0, 0
	push rsi ; this is stored for later
	xor rax, rax
	xor rsi, rsi
	; .sign:
		movzx dx, byte [rdi]
		mov si, dx ; uod, no need to check
		sub si, '-'
		test si, si ; same at start of .end0...
		jnz .pos ; maybe use + for positive?
	.loop:
		inc rdi
	.pos:
		mov dl, [rdi]
		sub dl, '0'
		jc .end0 ; uod: *+,-./0123456789
		imul rax, 10 ; note: if i turn *10->*16: 0123456789:;<=>?
		add rax, rdx
		jmp .loop
	.end0:
		test si, si ; same before .loop...
		jnz .end ; difference is where we jump
		neg rax
	.end:
		pop rsi
		mov [rsi], rax
		mov rax, rdi
		leave
		ret

_start:
	mov rax, 0
	xor rdi, rdi
	mov rsi, inp
	mov rdx, 64
	syscall
	
	mov rdi, inp
	mov rsi, num1
	call getnum

	mov rdi, rax ; ?
	mov al, [rdi]
	mov [op], al
	inc rdi

	mov rsi, num2
	call getnum
cal: ; debug
	mov rax, [num1]
	mov rbx, [num2]
	cmp byte [op], '+'
	je .add
	cmp byte [op], '-'
	je .sub
	
	xor rdx, rdx
	jl .mul ; again, uod: *+,-./0123456789
		idiv rbx
		jmp .done
	.mul:
		imul rbx
		jmp .done
	.add:
		add rax, rbx
		jmp .done
	.sub:
		sub rax, rbx
		; jmp .done
	
.done:
	mov rdi, rax ; exit
	mov rax, 60
	syscall
