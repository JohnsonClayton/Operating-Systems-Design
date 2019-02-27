	.file	"coop.c"
	.text
	.comm	stack,16,16
	.comm	regs,16,16
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
	movl	%edi, -20(%rbp)
#APP
# 45 "coop.c" 1
	mov %rax, regs(%rip)
	mov %rbx, 8+regs(%rip)
	mov %rcx, 16+regs(%rip)
	mov %rdx, 24+regs(%rip)
	mov %rdi, 32+regs(%rip)
	mov %rsi, 40+regs(%rip)
	movl $0, 48+regs(%rip)
	mov %rbp, 56+regs(%rip)
	mov %rsp, 64+regs(%rip)
	movl $0, 72+regs(%rip)
	
# 0 "" 2
#NO_APP
	movl	$0, -4(%rbp)
	cmpl	$0, -20(%rbp)
	jne	.L7
	movl	$1, -4(%rbp)
.L7:
	nop
	popq	%rbp
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
#APP
# 86 "coop.c" 1
	mov %rax, mainRegs(%rip)
	mov %rbx, 8+mainRegs(%rip)
	mov %rcx, 16+mainRegs(%rip)
	mov %rdx, 24+mainRegs(%rip)
	mov %rdi, 32+mainRegs(%rip)
	mov %rsi, 40+mainRegs(%rip)
	movl $0, 48+mainRegs(%rip)
	mov %rbp, 56+mainRegs(%rip)
	mov %rsp, 64+mainRegs(%rip)
	movl $0, 72+mainRegs(%rip)
	
# 0 "" 2
#NO_APP
	movl	thread_count(%rip), %ebx
	movl	$6400, %edi
	call	malloc@PLT
	movq	%rax, %rcx
	movslq	%ebx, %rax
	leaq	0(,%rax,8), %rdx
	leaq	stack(%rip), %rax
	movq	%rcx, (%rdx,%rax)
	movl	thread_count(%rip), %ebx
	movl	$80, %edi
	call	malloc@PLT
	movq	%rax, %rcx
	movslq	%ebx, %rax
	leaq	0(,%rax,8), %rdx
	leaq	regs(%rip), %rax
	movq	%rcx, (%rdx,%rax)
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
