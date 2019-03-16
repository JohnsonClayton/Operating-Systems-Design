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
		"mov %rbp, 56(%rdi)\n\t"
		"lea (%rip), %rax\n\t"
		"add $8, %rax\n\t"
		"mov %rax, 64(%rdi)\n\t");

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
	asm(	"mov (%rdi), %rax\n\t"
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
 *	movq %rdi, -8(%rbp)	# mainRegs
 *	movq %rsi, -16(%rbp)	# ptr
 *	movq %rdx, -24(%rbp)	# regs
 *	movq %rcx, -32(%rbp)	# stack
 *
 */
	//	Call to save mainRegs
	/*asm(	"call saveRegisters\n\t"
		"mov %rcx, %rbp\n\t"
		"incl thread_count(%rip)\n\t"
		"mov thread_count(%rip), %rdi\n\t"	//Moves thread_counter for first argument of *ptr
		"call *%rsi\n\t");*/	//Calls the main[1|2] function
	asm("mov %rcx, %rbp\n\t");
	
}

void startThread(funPtr ptr) {
	//To be completed by student
	regs[thread_count] = malloc(10*sizeof(__uint8_t)*8);		//regs[thread] holds the memory location of the space	?
	stack[thread_count] = malloc(64000*sizeof(__uint8_t)*8+64000*sizeof(__uint8_t)*8);	//stack[thread] holds the memory location of space	?
	//startThreadASM(mainRegs, ptr, regs+(80*((thread_count+1)%2)), stack+(64000*((thread_count+1)%2)));
	starting_thread=1;
	if(thread_count==0) {
		startThreadASM(stack[0]);
		saveRegisters(mainRegs);
	} else {
		startThreadASM(stack[1]);
		saveRegisters(mainRegs);
	}
	thread_count++;
	ptr();
	starting_thread=0;
}

void shareCPU() {
	//Comment in asm info I may need
	//	----nooooo -> Control flow of exec by branching
	//	Based on which thread called it, save its regs (give save the offset since you give memory addy)
	//	Restore regs from provided addy
	times_shared++;

	printf("Before saving... thread=%d\n", thread);
	saveRegisters(regs[thread]);
	if(times_shared <= 1) {
		puts("Started thread up!");
		if(thread==0) thread=1;
		else thread=0;
		restoreRegisters(mainRegs);
	} else {
		if(thread==0) thread=1;
		else thread=0;
		puts("else reached!");
		restoreRegisters(regs[thread]);
	}	



	/*thread=thread-1;
	//printf("first_time[0] is %d and first_time[1] is %d and thread is %d\n", first_time[0], first_time[1], thread);
	if(first_time[thread]){// || first_time[(thread+1)%2]) { //If this is either thread's first share
		//If this is the first time we've reached this, then load up mainRegs
		//printf("---first_time[0] is %d and first_time[1] is %d and thread is %d\n", first_time[0], first_time[1], thread);
		first_time[thread] = 0;
		if(thread == 0) {
			puts("Save thread 0");
			saveRegisters(regs[0]);
		} else {
			puts("Save thread 1");
			saveRegisters(regs[1]);
		}
		//saveRegisters(regs+(80*((thread+1)%2)));
		if(first_time[thread] || first_time[(thread+1)%2]) {
			puts("Restore main");
			restoreRegisters(mainRegs);
		} else {
			if(thread==0) {
				//puts("Save thread 0");
				//saveRegisters(regs);
				puts("Restore thread 1");
				restoreRegisters(regs[1]);
			} else {
				//puts("Save thread 1");
				//saveRegisters(regs+80);
				puts("Restore thread 0");
				restoreRegisters(regs[0]);
			}
		}
	} else {
		//Otherwise just load up the other regs
		//restoreRegisters(regs+(80*((thread+1)%2)));
		if(thread==0) {
			//puts("Save thread 0");
			//saveRegisters(regs);
			puts("Restore thread 1");
			restoreRegisters(regs[1]);
		} else {
			//puts("Save thread 1");
			//saveRegisters(regs+80);
			puts("Restore thread 0");
			restoreRegisters(regs[0]);
		}
	}*/
}

void* main1() {
	while(1) {
		puts("Main 1 says Hello!");
		shareCPU();
	}
}

void* main2() {
	while(1) {
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
