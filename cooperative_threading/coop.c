/*	Clayton Johnson - CSCI 470
 *		Cooperative Threading Assignment
 *
 *
 *
 */
#include <stdio.h>
#include <stdlib.h>

typedef void (*funPtr)();

__uint64_t* regs[2];
__uint8_t* stack[2];
__uint64_t mainRegs[10];

int thread_count = 0;
int first_time[2] = {1, 1};
int starting_thread = 0;
int times_shared = 0;
int thread = 0;

void outputRestoredRegisters(__uint64_t *rbp, __uint64_t *rsp) {
	printf("\tRegisters restored\t: \n\t\trbp : %p\n\t\trsp : %p\n", rbp, rsp);
}

void outputSavedRegisters(__uint64_t *rbp, __uint64_t *rsp) {
	printf("\tRegisters saved\t: \n\t\trbp : %p\n\t\trsp : %p\n", rbp, rsp);
}

void saveRegisters(__uint64_t *regs) {
	//Comment in locations of vars and where they should go
	/*
	 *	pushq %rbp
	 *	movq %rsp, %rbp
	 *	movq %rdi, -8(%rbp)	#regs
	 */
	
	//Save Registers
	asm(	"mov %rax, (%rdi)\n\t"
		"mov %rbx, 8(%rdi)\n\t"
		"mov %rcx, 16(%rdi)\n\t"
		"mov %rdx, 24(%rdi)\n\t"
		"mov %rdi, 32(%rdi)\n\t"
		"mov %rsi, 40(%rdi)\n\t"
		"mov %rsp, 48(%rdi)\n\t"
		"mov %rbp, 56(%rdi)\n\t");
		//"lea (%rip), %rax\n\t"
		//"add $8, %rax\n\t"
		//"mov %rax, 64(%rdi)\n\t");
	//Call outputSavedRegisters after moving regs into appropriate order
	asm(	"mov %rbp, %rdi\n\t"
		"mov %rsp, %rsi\n\t"
		"call outputSavedRegisters\n\t");
	//Move one I changed back just in case

	//	pop %rbp
	//	ret	
}

void restoreRegisters(__uint64_t *regs) {
	//Comment in locations of vars and w/e
	/*
	 *	pushq %rbp
	 *	movq %rsp, %rbp
	 *	movq %rdi, -8(%rbp)	#regs
	 */
	
	//Load Registers
	asm(	"mov %rdi, %rax\n\t"
		"mov 8(%rdi), %rbx\n\t"
		"mov 24(%rdi), %rdx\n\t"
		"mov 32(%rdi), %rdi\n\t"
		"mov 40(%rdi), %rsi\n\t"
		"mov 48(%rdi), %rsp\n\t"
		"mov 56(%rdi), %rbp\n\t"
		"push %rax\n\t");
	//Move all these into rdi, rsi, etc to call outputRegs
	asm( 	"mov %rbp, %rdi\n\t"
		"mov %rsp, %rsi\n\t"
		"call outputRestoredRegisters\n\t");
	//Move all the save regs back because we just shredded them
	asm(	"pop %rdi\n\t"
		"mov (%rdi), %rax\n\t"
		"mov 8(%rdi), %rbx\n\t"
		"mov 16(%rdi), %rcx\n\t"
		"mov 24(%rdi), %rdx\n\t"
		"mov 32(%rdi), %rdi\n\t"
		"mov 40(%rdi), %rsi\n\t"
		"mov 48(%rdi), %rsp\n\t"
		"mov 56(%rdi), %rbp\n\t");


	//	popq %rbp
	//	ret
}

void startThreadASM(__uint8_t *stack) {
	//Comment in the locations of each variable and be clear
/*
 *	push %rbp
 *	movq %rsp, %rbp
 *	movq %rdi, -8(%rbp)	# stack
 *
 */
	asm("mov %rdi, %rbp\n\t");
	
}

void startThread(funPtr ptr) {
	//To be completed by student
	regs[thread_count] = malloc(10*sizeof(__uint64_t)*8);
	//stack[thread_count] = malloc(64000*sizeof(__uint8_t)*8+64000*sizeof(__uint8_t)*8);
	stack[thread_count] = malloc(64000*sizeof(__uint8_t)*8) + 64000*sizeof(__uint8_t)*8;

	printf("Starting thread_count %d:\n\tregs[%d] \t: %p\n\tstack[%d] \t: %p\n", thread_count, thread_count, regs[thread_count], thread_count, stack[thread_count]);

	starting_thread=1;
	if(thread_count==0) {
		startThreadASM(stack[thread_count]);
		saveRegisters(mainRegs);
	} else {
		startThreadASM(stack[thread_count]);
		saveRegisters(mainRegs);
	}
	thread_count++;
	ptr();
	starting_thread=0;
}

void shareCPU() {
	//Comment in asm info I may need
	times_shared++;

	printf("\tSave \t=> %p \t(regs[%d])\n", regs[thread], thread);
	saveRegisters(regs[thread]);
	if(times_shared <= 1) {
		if(thread==0) thread=1;
		else thread=0;
		printf("\tLoad \t=> %p \t(mainRegs)\n", mainRegs);
		restoreRegisters(mainRegs);
	} else {
		if(thread==0) thread=1;
		else thread=0;

		printf("\tLoad \t=> %p \t(regs[%d])\n", regs[thread], thread);
		restoreRegisters(regs[thread]);
	}	
}

void* main1() {
	//while(1) {
	for(int i=0; i < 5; i++) {
		puts("Main 1 says Hello!");
		shareCPU();
	}
}

void* main2() {
	//while(1) {
	for(int i = 0; i < 5; i++) {
		puts("Main 2 says Hello!");
		shareCPU();
	}
}

int main() {
	startThread(main1);
	startThread(main2);
	puts("main reached");
	return 0;
}
