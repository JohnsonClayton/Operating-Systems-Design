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
	.globl	starting_thread
	.bss
	.align 4
	.type	starting_thread, @object
	.size	starting_thread, 4
starting_thread:
	.zero	4
	.globl	times_shared
	.align 4
	.type	times_shared, @object
	.size	times_shared, 4
times_shared:
	.zero	4
	.globl	thread
	.align 4
	.type	thread, @object
	.size	thread, 4
thread:
	.zero	4
	.section	.rodata
	.align 8
.LC0:
	.string	"\tRegisters restored\t: \n\t\trbp : %p\n\t\trsp : %p\n"
	.text
	.globl	outputRestoredRegisters
	.type	outputRestoredRegisters, @function
outputRestoredRegisters:
.LFB5:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	-16(%rbp), %rdx
	movq	-8(%rbp), %rax
	movq	%rax, %rsi
	leaq	.LC0(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE5:
	.size	outputRestoredRegisters, .-outputRestoredRegisters
	.section	.rodata
	.align 8
.LC1:
	.string	"\tRegisters saved\t: \n\t\trbp : %p\n\t\trsp : %p\n"
	.text
	.globl	outputSavedRegisters
	.type	outputSavedRegisters, @function
outputSavedRegisters:
.LFB6:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	-16(%rbp), %rdx
	movq	-8(%rbp), %rax
	movq	%rax, %rsi
	leaq	.LC1(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE6:
	.size	outputSavedRegisters, .-outputSavedRegisters
	.globl	saveRegisters
	.type	saveRegisters, @function
saveRegisters:
.LFB7:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -8(%rbp)
#APP
# 39 "coop.c" 1
	mov %rax, (%rdi)
	mov %rbx, 8(%rdi)
	mov %rcx, 16(%rdi)
	mov %rdx, 24(%rdi)
	mov %rdi, 32(%rdi)
	mov %rsi, 40(%rdi)
	mov %rsp, 48(%rdi)
	mov %rbp, 56(%rdi)
	
# 0 "" 2
# 51 "coop.c" 1
	mov %rbp, %rdi
	mov %rsp, %rsi
	call outputSavedRegisters
	
# 0 "" 2
#NO_APP
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE7:
	.size	saveRegisters, .-saveRegisters
	.globl	restoreRegisters
	.type	restoreRegisters, @function
restoreRegisters:
.LFB8:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -8(%rbp)
#APP
# 68 "coop.c" 1
	mov %rdi, %rax
	mov 8(%rdi), %rbx
	mov 24(%rdi), %rdx
	mov 32(%rdi), %rdi
	mov 40(%rdi), %rsi
	mov 48(%rdi), %rsp
	mov 56(%rdi), %rbp
	push %rax
	
# 0 "" 2
# 77 "coop.c" 1
	mov %rbp, %rdi
	mov %rsp, %rsi
	call outputRestoredRegisters
	
# 0 "" 2
# 81 "coop.c" 1
	pop %rdi
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
.LFE8:
	.size	restoreRegisters, .-restoreRegisters
	.globl	startThreadASM
	.type	startThreadASM, @function
startThreadASM:
.LFB9:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
#APP
# 105 "coop.c" 1
	mov %rdi, %rsp
	
# 0 "" 2
#NO_APP
	movq	-16(%rbp), %rdx
	movl	$0, %eax
	call	*%rdx
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE9:
	.size	startThreadASM, .-startThreadASM
	.section	.rodata
	.align 8
.LC2:
	.string	"Starting thread_count %d:\n\tregs[%d] \t: %p\n\tstack[%d] \t: %p\n"
	.text
	.globl	startThread
	.type	startThread, @function
startThread:
.LFB10:
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
	movl	$1, starting_thread(%rip)
	leaq	mainRegs(%rip), %rdi
	call	saveRegisters
	movl	thread_count(%rip), %ebx
	movl	$640, %edi
	call	malloc@PLT
	movq	%rax, %rcx
	movslq	%ebx, %rax
	leaq	0(,%rax,8), %rdx
	leaq	regs(%rip), %rax
	movq	%rcx, (%rdx,%rax)
	movl	$512000, %edi
	call	malloc@PLT
	movq	%rax, %rdx
	movl	thread_count(%rip), %eax
	leaq	512000(%rdx), %rcx
	cltq
	leaq	0(,%rax,8), %rdx
	leaq	stack(%rip), %rax
	movq	%rcx, (%rdx,%rax)
	movl	thread_count(%rip), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	leaq	stack(%rip), %rax
	movq	(%rdx,%rax), %rdi
	movl	thread_count(%rip), %esi
	movl	thread_count(%rip), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	leaq	regs(%rip), %rax
	movq	(%rdx,%rax), %rcx
	movl	thread_count(%rip), %edx
	movl	thread_count(%rip), %eax
	movq	%rdi, %r9
	movl	%esi, %r8d
	movl	%eax, %esi
	leaq	.LC2(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	movl	thread_count(%rip), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	leaq	stack(%rip), %rax
	movq	(%rdx,%rax), %rax
	movq	-24(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	startThreadASM
	movl	thread_count(%rip), %eax
	addl	$1, %eax
	movl	%eax, thread_count(%rip)
	movl	$0, starting_thread(%rip)
	nop
	addq	$24, %rsp
	popq	%rbx
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE10:
	.size	startThread, .-startThread
	.section	.rodata
.LC3:
	.string	"\tSave \t=> %p \t(regs[%d])\n"
.LC4:
	.string	"\tLoad \t=> %p \t(mainRegs)\n"
.LC5:
	.string	"\tLoad \t=> %p \t(regs[%d])\n"
	.text
	.globl	shareCPU
	.type	shareCPU, @function
shareCPU:
.LFB11:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	times_shared(%rip), %eax
	addl	$1, %eax
	movl	%eax, times_shared(%rip)
	movl	thread(%rip), %edx
	movl	thread(%rip), %eax
	cltq
	leaq	0(,%rax,8), %rcx
	leaq	regs(%rip), %rax
	movq	(%rcx,%rax), %rax
	movq	%rax, %rsi
	leaq	.LC3(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	movl	thread(%rip), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	leaq	regs(%rip), %rax
	movq	(%rdx,%rax), %rax
	movq	%rax, %rdi
	call	saveRegisters
	movl	times_shared(%rip), %eax
	cmpl	$1, %eax
	jg	.L8
	movl	thread(%rip), %eax
	testl	%eax, %eax
	jne	.L9
	movl	$1, thread(%rip)
	jmp	.L10
.L9:
	movl	$0, thread(%rip)
.L10:
	leaq	mainRegs(%rip), %rsi
	leaq	.LC4(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	leaq	mainRegs(%rip), %rdi
	call	restoreRegisters
	jmp	.L14
.L8:
	movl	thread(%rip), %eax
	testl	%eax, %eax
	jne	.L12
	movl	$1, thread(%rip)
	jmp	.L13
.L12:
	movl	$0, thread(%rip)
.L13:
	movl	thread(%rip), %edx
	movl	thread(%rip), %eax
	cltq
	leaq	0(,%rax,8), %rcx
	leaq	regs(%rip), %rax
	movq	(%rcx,%rax), %rax
	movq	%rax, %rsi
	leaq	.LC5(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	movl	thread(%rip), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	leaq	regs(%rip), %rax
	movq	(%rdx,%rax), %rax
	movq	%rax, %rdi
	call	restoreRegisters
.L14:
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE11:
	.size	shareCPU, .-shareCPU
	.section	.rodata
.LC6:
	.string	"Main 1 says Hello!"
	.text
	.globl	main1
	.type	main1, @function
main1:
.LFB12:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movl	$0, -4(%rbp)
	jmp	.L16
.L17:
	leaq	.LC6(%rip), %rdi
	call	puts@PLT
	movl	$0, %eax
	call	shareCPU
	addl	$1, -4(%rbp)
.L16:
	cmpl	$4, -4(%rbp)
	jle	.L17
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE12:
	.size	main1, .-main1
	.section	.rodata
.LC7:
	.string	"Main 2 says Hello!"
	.text
	.globl	main2
	.type	main2, @function
main2:
.LFB13:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movl	$0, -4(%rbp)
	jmp	.L19
.L20:
	leaq	.LC7(%rip), %rdi
	call	puts@PLT
	movl	$0, %eax
	call	shareCPU
	addl	$1, -4(%rbp)
.L19:
	cmpl	$4, -4(%rbp)
	jle	.L20
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE13:
	.size	main2, .-main2
	.section	.rodata
.LC8:
	.string	"main reached"
	.text
	.globl	main
	.type	main, @function
main:
.LFB14:
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
	leaq	.LC8(%rip), %rdi
	call	puts@PLT
	movl	$0, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE14:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 7.3.0-27ubuntu1~18.04) 7.3.0"
	.section	.note.GNU-stack,"",@progbits
