section .text
global _start
	_start:
push 3
push 2
call power ; 2^3
add rsp, 16
push rax
push 2
push 5
call power ; 5^2
pop rbx
add rax, rbx
mov rdi, rax ; exit
mov rax, 60
syscall

; ... exp base RET RBP [res ]
global power:function
	power:
push rbp ; enter 8, 0
mov rbp, rsp
sub rsp, 8 ; [rbp - 8] is local variable
; note: [rbp - 8] for steady, [rsp + 8] for fast.
mov rbx, [rbp + 16]
mov rcx, [rbp + 24]
mov rax, 1
	power_loop:
cmp rcx, 0
je power_end
dec rcx
imul rax, rbx
jmp power_loop
	power_end:
mov rsp, rbp ; leave, then ret
pop rbp
ret
