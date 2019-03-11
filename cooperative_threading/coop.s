	.file	"coop.c"
	.text
	.comm	regs,16,16
	.comm	stack,16,16
	.comm	mainRegs,80,32
	.globl	thread_count
	.bss
	.align 4
	.type	thread_count, @object
	.size	thread_count, 4
thread_count:
	.zero	4
	.globl	first_time
	.data
	.align 8
	.type	first_time, @object
	.size	first_time, 8
first_time:
	.long	1
	.long	1
	.text
	.globl	saveRegisters
	.type	saveRegisters, @function
saveRegisters:
.LFB5:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -8(%rbp)
#APP
# 26 "coop.c" 1
	mov %rax, (%rdi)
	mov %rbx, 8(%rdi)
	mov %rcx, 16(%rdi)
	mov %rdx, 24(%rdi)
	mov %rdi, 32(%rdi)
	mov %rsi, 40(%rdi)
	mov %rsp, 48(%rdi)
	mov %rbp, 56(%rdi)
	lea (%rip), %rax
	mov %rax, 64(%rdi)
	
# 0 "" 2
#NO_APP
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE5:
	.size	saveRegisters, .-saveRegisters
	.globl	restoreRegisters
	.type	restoreRegisters, @function
restoreRegisters:
.LFB6:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -8(%rbp)
#APP
# 49 "coop.c" 1
	mov (%rdi), %rax
	mov 8(%rdi), %rbx
	mov 16(%rdi), %rcx
	mov 24(%rdi), %rdx
	mov 32(%rdi), %rdi
	mov 40(%rdi), %rsi
	mov 48(%rdi), %rsp
	mov 56(%rdi), %rbp
	
# 0 "" 2
#NO_APP
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE6:
	.size	restoreRegisters, .-restoreRegisters
	.globl	startThreadASM
	.type	startThreadASM, @function
startThreadASM:
.LFB7:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	%rdx, -24(%rbp)
	movq	%rcx, -32(%rbp)
#APP
# 73 "coop.c" 1
	call saveRegisters
	mov stack(%rip), %rbp
	incl thread_count(%rip)
	mov thread_count(%rip), %rdi
	call *%rsi
	
# 0 "" 2
#NO_APP
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE7:
	.size	startThreadASM, .-startThreadASM
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
	subq	$24, %rsp
	.cfi_offset 3, -24
	movq	%rdi, -24(%rbp)
	movl	thread_count(%rip), %ebx
	movl	$80, %edi
	call	malloc@PLT
	movq	%rax, %rcx
	movslq	%ebx, %rax
	leaq	0(,%rax,8), %rdx
	leaq	regs(%rip), %rax
	movq	%rcx, (%rdx,%rax)
	movl	thread_count(%rip), %ebx
	movl	$51200, %edi
	call	malloc@PLT
	movq	%rax, %rcx
	movslq	%ebx, %rax
	leaq	0(,%rax,8), %rdx
	leaq	stack(%rip), %rax
	movq	%rcx, (%rdx,%rax)
	movl	thread_count(%rip), %eax
	leal	1(%rax), %edx
	movl	%edx, %eax
	sarl	$31, %eax
	shrl	$31, %eax
	addl	%eax, %edx
	andl	$1, %edx
	subl	%eax, %edx
	movl	%edx, %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	leaq	0(,%rax,4), %rdx
	addq	%rdx, %rax
	salq	$11, %rax
	movq	%rax, %rdx
	leaq	stack(%rip), %rax
	leaq	(%rdx,%rax), %rcx
	movl	thread_count(%rip), %eax
	leal	1(%rax), %edx
	movl	%edx, %eax
	sarl	$31, %eax
	shrl	$31, %eax
	addl	%eax, %edx
	andl	$1, %edx
	subl	%eax, %edx
	movl	%edx, %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	salq	$7, %rax
	movq	%rax, %rdx
	leaq	regs(%rip), %rax
	addq	%rax, %rdx
	movq	-24(%rbp), %rax
	movq	%rax, %rsi
	leaq	mainRegs(%rip), %rdi
	call	startThreadASM
	nop
	addq	$24, %rsp
	popq	%rbx
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE8:
	.size	startThread, .-startThread
	.globl	shareCPU
	.type	shareCPU, @function
shareCPU:
.LFB9:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$8, %rsp
	movl	%edi, -4(%rbp)
	movl	-4(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rdx
	leaq	first_time(%rip), %rax
	movl	(%rdx,%rax), %eax
	testl	%eax, %eax
	je	.L6
	movl	-4(%rbp), %eax
	leal	1(%rax), %edx
	movl	%edx, %eax
	sarl	$31, %eax
	shrl	$31, %eax
	addl	%eax, %edx
	andl	$1, %edx
	subl	%eax, %edx
	movl	%edx, %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	salq	$7, %rax
	movq	%rax, %rdx
	leaq	regs(%rip), %rax
	addq	%rdx, %rax
	movq	%rax, %rdi
	call	saveRegisters
	leaq	mainRegs(%rip), %rdi
	call	restoreRegisters
	movl	-4(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rdx
	leaq	first_time(%rip), %rax
	movl	$0, (%rdx,%rax)
	jmp	.L9
.L6:
	cmpl	$0, -4(%rbp)
	jne	.L8
	movq	regs(%rip), %rax
	movq	%rax, %rdi
	call	saveRegisters
	movq	8+regs(%rip), %rax
	movq	%rax, %rdi
	call	restoreRegisters
	movl	$1, -4(%rbp)
	jmp	.L9
.L8:
	movq	8+regs(%rip), %rax
	movq	%rax, %rdi
	call	saveRegisters
	leaq	regs(%rip), %rdi
	call	restoreRegisters
	movl	$0, -4(%rbp)
.L9:
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE9:
	.size	shareCPU, .-shareCPU
	.section	.rodata
.LC0:
	.string	"Main 1 says Hello!"
	.text
	.globl	main1
	.type	main1, @function
main1:
.LFB10:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movl	%edi, -4(%rbp)
.L11:
	leaq	.LC0(%rip), %rdi
	call	puts@PLT
	movl	-4(%rbp), %eax
	movl	%eax, %edi
	call	shareCPU
	jmp	.L11
	.cfi_endproc
.LFE10:
	.size	main1, .-main1
	.section	.rodata
.LC1:
	.string	"Main 2 says Hello!"
	.text
	.globl	main2
	.type	main2, @function
main2:
.LFB11:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movl	%edi, -4(%rbp)
.L13:
	leaq	.LC1(%rip), %rdi
	call	puts@PLT
	movl	-4(%rbp), %eax
	movl	%eax, %edi
	call	shareCPU
	jmp	.L13
	.cfi_endproc
.LFE11:
	.size	main2, .-main2
	.section	.rodata
.LC2:
	.string	"main reached"
	.text
	.globl	main
	.type	main, @function
main:
.LFB12:
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
	leaq	.LC2(%rip), %rdi
	call	puts@PLT
	movl	$0, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE12:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 7.3.0-27ubuntu1~18.04) 7.3.0"
	.section	.note.GNU-stack,"",@progbits
