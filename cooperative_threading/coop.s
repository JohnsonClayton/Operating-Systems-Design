	.file	"coop.c"
	.text
	.comm	stack,12800,32
	.comm	regs,160,32
	.comm	mainRegs,80,32
	.globl	thread_count
	.bss
	.align 4
	.type	thread_count, @object
	.size	thread_count, 4
thread_count:
	.zero	4
	.globl	stack_size
	.align 4
	.type	stack_size, @object
	.size	stack_size, 4
stack_size:
	.zero	4
	.section	.rodata
.LC0:
	.string	"Main 1 says Hello"
	.text
	.globl	main1
	.type	main1, @function
main1:
.LFB5:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movl	%edi, -4(%rbp)
.L2:
	leaq	.LC0(%rip), %rdi
	call	puts@PLT
	movl	-4(%rbp), %eax
	movl	%eax, %edi
	movl	$0, %eax
	call	shareCPU
	jmp	.L2
	.cfi_endproc
.LFE5:
	.size	main1, .-main1
	.section	.rodata
.LC1:
	.string	"Main 2 says Hello"
	.text
	.globl	main2
	.type	main2, @function
main2:
.LFB6:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movl	%edi, -4(%rbp)
.L4:
	leaq	.LC1(%rip), %rdi
	call	puts@PLT
	movl	-4(%rbp), %eax
	movl	%eax, %edi
	movl	$0, %eax
	call	shareCPU
	jmp	.L4
	.cfi_endproc
.LFE6:
	.size	main2, .-main2
	.globl	shareCPU
	.type	shareCPU, @function
shareCPU:
.LFB7:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%edi, -4(%rbp)
	cmpl	$0, -4(%rbp)
	jne	.L6
#APP
# 56 "coop.c" 1
	mov %rax, regs(%rip)
	mov %rbx, 8+regs(%rip)
	mov %rcx, 16+regs(%rip)
	mov %rdx, 24+regs(%rip)
	mov %rdi, 32+regs(%rip)
	mov %rsi, 40+regs(%rip)
	movl $0, 48+regs(%rip)
	mov %rbp, 56+regs(%rip)
	mov %rsp, 64+regs(%rip)
	
# 0 "" 2
# 65 "coop.c" 1
	lea (%rip), %rax
	add $50, %rax
	mov %rax, 72+regs(%rip)
	
# 0 "" 2
# 69 "coop.c" 1
	mov stack_size(%rip), %rdx #This is where I initialize the loop!
	mov %rsp, %rax
	mov (%rsp), %rbx
	mov 6400+stack(%rip), %rcx
	saveloop1:
	mov %rbx, %rcx #This is the top of the loop
	add $2, %rcx
	add $2, %rsp
	add $2, %rdx
	cmp %rsp, %rbp
	jnc saveloop1
	mov %rdx, stack_size(%rip)
	mov %rax, %rsp
	
# 0 "" 2
# 85 "coop.c" 1
	mov 80+regs(%rip), %rax
	mov 80+regs(%rip), %rbx
	mov 96+regs(%rip), %rcx
	mov 104+regs(%rip), %rdx
	mov 112+regs(%rip), %rdi
	mov 120+regs(%rip), %rsi
	mov 128+regs(%rip), %rbp
	mov 136+regs(%rip), %rbp
	mov 144+regs(%rip), %rsp
	
# 0 "" 2
# 96 "coop.c" 1
	mov stack_size(%rip), %rdx
	mov stack(%rip), %rbx
	add %rdx, %rbx
	restoreloop1:
	mov %rbx, %rcx
	push %rcx
	sub $2, %rbx
	sub $2, %rdx
	cmp $0, %rdx
	jnz restoreloop1
	
# 0 "" 2
# 108 "coop.c" 1
	mov 152+regs(%rip), %rax
	push %rax
	leave
	ret
	
# 0 "" 2
#NO_APP
	jmp	.L8
.L6:
#APP
# 115 "coop.c" 1
	mov %rax, 80+regs(%rip)
	mov %rbx, 88+regs(%rip)
	mov %rcx, 96+regs(%rip)
	mov %rdx, 104+regs(%rip)
	mov %rdi, 112+regs(%rip)
	mov %rsi, 120+regs(%rip)
	movl $0, 128+regs(%rip)
	mov %rbp, 136+regs(%rip)
	mov %rsp, 144+regs(%rip)
	
# 0 "" 2
# 124 "coop.c" 1
	lea (%rip), %rax
	add $50, %rax
	mov %rax, 152+regs(%rip)
	
# 0 "" 2
# 128 "coop.c" 1
	mov stack_size(%rip), %rdx #This is where I initialize the loop!
	mov %rsp, %rax
	mov (%rsp), %rbx
	mov stack(%rip), %rcx
	saveloop2:
	mov %rbx, %rcx #This is the top of the loop
	add $2, %rcx
	add $2, %rsp
	add $2, %rdx
	cmp %rsp, %rbp
	jnc saveloop2
	mov %rdx, stack_size(%rip)
	mov %rax, %rsp
	
# 0 "" 2
# 144 "coop.c" 1
	mov regs(%rip), %rax
	mov 8+regs(%rip), %rbx
	mov 16+regs(%rip), %rcx
	mov 24+regs(%rip), %rdx
	mov 32+regs(%rip), %rdi
	mov 40+regs(%rip), %rsi
	mov 48+regs(%rip), %rbp
	mov 56+regs(%rip), %rbp
	mov 64+regs(%rip), %rsp
	
# 0 "" 2
# 155 "coop.c" 1
	mov stack_size(%rip), %rdx
	mov 6400+stack(%rip), %rbx
	add %rdx, %rbx
	restoreloop2:
	mov (%rbx), %rcx
	push %rcx
	sub $2, %rbx
	sub $2, %rdx
	cmp $0, %rdx
	jnz restoreloop2
	
# 0 "" 2
# 167 "coop.c" 1
	mov 72+regs(%rip), %rax
	push %rax
	leave
	ret
	
# 0 "" 2
#NO_APP
.L8:
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE7:
	.size	shareCPU, .-shareCPU
	.section	.rodata
.LC2:
	.string	"Entering startThread #%d\n"
	.text
	.globl	startThread
	.type	startThread, @function
startThread:
.LFB8:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	subq	$40, %rsp
	.cfi_offset 3, -24
	movq	%rdi, -40(%rbp)
	movl	thread_count(%rip), %eax
	addl	$1, %eax
	movl	%eax, %esi
	leaq	.LC2(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	movl	$0, -28(%rbp)
	jmp	.L10
.L11:
	movl	thread_count(%rip), %ebx
	movl	$8, %edi
	call	malloc@PLT
	movq	%rax, %rsi
	movl	-28(%rbp), %eax
	movslq	%eax, %rcx
	movslq	%ebx, %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	leaq	0(,%rax,4), %rdx
	addq	%rdx, %rax
	salq	$5, %rax
	addq	%rcx, %rax
	leaq	0(,%rax,8), %rdx
	leaq	stack(%rip), %rax
	movq	%rsi, (%rdx,%rax)
	addl	$1, -28(%rbp)
.L10:
	cmpl	$799, -28(%rbp)
	jle	.L11
	movl	$0, -24(%rbp)
	jmp	.L12
.L13:
	movl	thread_count(%rip), %ebx
	movl	$8, %edi
	call	malloc@PLT
	movq	%rax, %rsi
	movl	-24(%rbp), %eax
	movslq	%eax, %rcx
	movslq	%ebx, %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	addq	%rax, %rax
	addq	%rcx, %rax
	leaq	0(,%rax,8), %rdx
	leaq	regs(%rip), %rax
	movq	%rsi, (%rdx,%rax)
	addl	$1, -24(%rbp)
.L12:
	cmpl	$9, -24(%rbp)
	jle	.L13
#APP
# 193 "coop.c" 1
	mov %rax, 80+regs(%rip)
	mov %rbx, 88+regs(%rip)
	mov %rcx, 96+regs(%rip)
	mov %rdx, 104+regs(%rip)
	mov %rdi, 112+regs(%rip)
	mov %rsi, 120+regs(%rip)
	movl $0, 128+regs(%rip)
	mov %rbp, 136+regs(%rip)
	mov %rsp, 144+regs(%rip)
	
# 0 "" 2
# 202 "coop.c" 1
	lea (%rip), %rax
	add $101, %rax
	mov %rax, 152+regs(%rip)
	
# 0 "" 2
# 207 "coop.c" 1
	mov stack_size(%rip), %rdx #This is where I initialize the loop!
	mov %rsp, %rax
	mov (%rsp), %rbx
	mov stack(%rip), %rcx
	saveloopStart:
	mov %rbx, %rcx #This is the top of the loop
	add $2, %rcx
	add $2, %rsp
	add $2, %rdx
	cmp %rsp, %rbp
	jnc saveloopStart
	mov %rdx, stack_size(%rip)
	mov %rax, %rsp
	
# 0 "" 2
#NO_APP
	movl	thread_count(%rip), %eax
	movl	%eax, -20(%rbp)
	movl	thread_count(%rip), %eax
	addl	$1, %eax
	movl	%eax, thread_count(%rip)
	movq	-40(%rbp), %rax
	movl	-20(%rbp), %edx
	movslq	%edx, %rdx
	movq	%rdx, %rdi
	call	*%rax
	nop
	addq	$40, %rsp
	popq	%rbx
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE8:
	.size	startThread, .-startThread
	.globl	main
	.type	main, @function
main:
.LFB9:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	leaq	main1(%rip), %rdi
	call	startThread
	leaq	main2(%rip), %rdi
	call	startThread
	movl	$0, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE9:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 7.3.0-27ubuntu1~18.04) 7.3.0"
	.section	.note.GNU-stack,"",@progbits
