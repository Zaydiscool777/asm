section .data
	list1:
dq 10, 20, 30, 40, 50, 0
	list2:
dq 3, 69, 34, 222, 45, 75, 54, 34, 44, 33, 22, 11, 0
	list3:
dq 4, 8, 15, 16, 23, 42, 0
section .text
global _start
	_start:
push list1
call max
add rsp, 8
push list2
call max
add rsp, 8
push list3
call max
add rsp, 8
mov rdi, rax ; exit with last max
mov rax, 60
syscall

; rbx: current val
; rax: eventual max
; rdi: pointer to list, such that [rdi] = rbx
global max:function
	max:
enter 0, 0
mov rdi, [rbp + 16]
mov rax, [rdi]
	max_loop:
mov rbx, [rdi]
add rdi, 8
cmp rbx, 0
je max_exit
cmp rax, rbx
jge max_loop
mov rax, rbx
jmp max_loop
	max_exit:
leave
ret
