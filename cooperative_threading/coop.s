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
# 31 "coop.c" 1
	mov %rax, (%rdi)
	mov %rbx, 8(%rdi)
	mov %rcx, 16(%rdi)
	mov %rdx, 24(%rdi)
	mov %rdi, 32(%rdi)
	mov %rsi, 40(%rdi)
	mov %rsp, 48(%rdi)
	mov %rbp, 56(%rdi)
	lea (%rip), %rax
	add $8, %rax
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
# 56 "coop.c" 1
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
#APP
# 86 "coop.c" 1
	mov %rcx, %rbp
	
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
	movl	$1024000, %edi
	call	malloc@PLT
	movq	%rax, %rcx
	movslq	%ebx, %rax
	leaq	0(,%rax,8), %rdx
	leaq	stack(%rip), %rax
	movq	%rcx, (%rdx,%rax)
	movl	$1, starting_thread(%rip)
	movl	thread_count(%rip), %eax
	testl	%eax, %eax
	jne	.L5
	movq	stack(%rip), %rax
	movq	%rax, %rdi
	call	startThreadASM
	leaq	mainRegs(%rip), %rdi
	call	saveRegisters
	jmp	.L6
.L5:
	movq	8+stack(%rip), %rax
	movq	%rax, %rdi
	call	startThreadASM
	leaq	mainRegs(%rip), %rdi
	call	saveRegisters
.L6:
	movl	thread_count(%rip), %eax
	addl	$1, %eax
	movl	%eax, thread_count(%rip)
	movq	-24(%rbp), %rdx
	movl	$0, %eax
	call	*%rdx
	movl	$0, starting_thread(%rip)
	nop
	addq	$24, %rsp
	popq	%rbx
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE8:
	.size	startThread, .-startThread
	.section	.rodata
.LC0:
	.string	"Before saving... thread=%d\n"
.LC1:
	.string	"Started thread up!"
.LC2:
	.string	"else reached!"
	.text
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
	movl	times_shared(%rip), %eax
	addl	$1, %eax
	movl	%eax, times_shared(%rip)
	movl	thread(%rip), %eax
	movl	%eax, %esi
	leaq	.LC0(%rip), %rdi
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
	leaq	.LC1(%rip), %rdi
	call	puts@PLT
	movl	thread(%rip), %eax
	testl	%eax, %eax
	jne	.L9
	movl	$1, thread(%rip)
	jmp	.L10
.L9:
	movl	$0, thread(%rip)
.L10:
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
	leaq	.LC2(%rip), %rdi
	call	puts@PLT
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
.LFE9:
	.size	shareCPU, .-shareCPU
	.section	.rodata
.LC3:
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
.L16:
	leaq	.LC3(%rip), %rdi
	call	puts@PLT
	movl	$0, %eax
	call	shareCPU
	jmp	.L16
	.cfi_endproc
.LFE10:
	.size	main1, .-main1
	.section	.rodata
.LC4:
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
.L18:
	leaq	.LC4(%rip), %rdi
	call	puts@PLT
	movl	$0, %eax
	call	shareCPU
	jmp	.L18
	.cfi_endproc
.LFE11:
	.size	main2, .-main2
	.section	.rodata
.LC5:
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
	leaq	.LC5(%rip), %rdi
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
