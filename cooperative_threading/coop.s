	.file	"coop.c"
	.text
	.comm	stack,16,16
	.comm	regs,160,32
	.comm	mainRegs,80,32
	.globl	thread_count
	.bss
	.align 4
	.type	thread_count, @object
	.size	thread_count, 4
thread_count:
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
	.section	.rodata
.LC2:
	.string	"Reload the main regs!"
	.text
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
	subq	$32, %rsp
	movl	%edi, -20(%rbp)
	movl	thread_count(%rip), %eax
	cmpl	$1, %eax
	jne	.L6
	leaq	.LC2(%rip), %rdi
	call	puts@PLT
	jmp	.L7
.L6:
	cmpl	$0, -20(%rbp)
	jne	.L8
#APP
# 62 "coop.c" 1
	mov %rax, regs(%rip)
	mov %rbx, 8+regs(%rip)
	mov %rcx, 16+regs(%rip)
	mov %rdx, 24+regs(%rip)
	mov %rdi, 32+regs(%rip)
	mov %rsi, 40+regs(%rip)
	movl $0, 48+regs(%rip)
	mov %rbp, 56+regs(%rip)
	
# 0 "" 2
# 70 "coop.c" 1
	lea (%rip), %rax
	push %rax
	mov %rsp, 64+regs(%rip)
	
# 0 "" 2
#NO_APP
	jmp	.L7
.L8:
#APP
# 101 "coop.c" 1
	push (%rip)
	
# 0 "" 2
# 102 "coop.c" 1
	mov %rax, 80+regs(%rip)
	mov %rbx, 88+regs(%rip)
	mov %rcx, 96+regs(%rip)
	mov %rdx, 104+regs(%rip)
	mov %rdi, 112+regs(%rip)
	mov %rsi, 120+regs(%rip)
	movl $0, 128+regs(%rip)
	mov %rbp, 136+regs(%rip)
	mov %rsp, 144+regs(%rip)
	movl $0, 152+regs(%rip)
	
# 0 "" 2
# 116 "coop.c" 1
	mov regs(%rip), %rax
	mov 8+regs(%rip), %rbx
	mov 16+regs(%rip), %rcx
	mov 24+regs(%rip), %rdx
	mov 32+regs(%rip), %rdi
	mov 40+regs(%rip), %rsi
	mov 48+regs(%rip), %rbp
	mov 56+regs(%rip), %rbp
	mov 64+regs(%rip), %rsp
	mov 72+regs(%rip), %rsp
	
# 0 "" 2
# 126 "coop.c" 1
	pop (%rip)
	
# 0 "" 2
#NO_APP
.L7:
	movl	$0, -4(%rbp)
	cmpl	$0, -20(%rbp)
	jne	.L10
	movl	$1, -4(%rbp)
.L10:
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE7:
	.size	shareCPU, .-shareCPU
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
	movl	thread_count(%rip), %ebx
	movl	$6400, %edi
	call	malloc@PLT
	movq	%rax, %rcx
	movslq	%ebx, %rax
	leaq	0(,%rax,8), %rdx
	leaq	stack(%rip), %rax
	movq	%rcx, (%rdx,%rax)
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
# 177 "coop.c" 1
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
# 189 "coop.c" 1
	lea (%rip), %rax
	mov %rax, 72+regs(%rip)
	
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