/*	Clayton Johnson - CSCI 470
 *		Cooperative Threading Assignment
 *
 *
 *
 */
#include <stdio.h>
#include <stdlib.h>

void* regs[2];
void* stack[2];
__uint64_t mainRegs[10];

int thread_count = 0;
int first_time[2] = {1, 1};

void saveRegisters(void *regs) {
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

void restoreRegisters(void *regs) {
	//Comment in locations of vars and w/e
	/*
	 *	pushq %rbp
	 *	movq %rsp, %rbp
	 *	movq %rdi, -8(%rbp)	#regs
	 */
	
	//Load Registers
	asm(	"mov 16(%rdi), %rcx\n\t"
		"mov 24(%rdi), %rdx\n\t"
		"mov 32(%rdi), %rdi\n\t"
		"mov 40(%rdi), %rsi\n\t"
		"mov 48(%rdi), %rsp\n\t"
		"mov 56(%rdi), %rbp\n\t"
		"pop %rbp\n\t"
		"pop %rax\n\t" 			//Ret addy
		"mov 64(%rdi), %rax\n\t" 	//Replacing addy
		"push %rax\n\t"			//Pushing back onto stack in order
		"push %rbp\n\t"
		"mov (%rdi), %rax\n\t"
		"mov 8(%rdi), %rbx\n\t"); //The rip comes back here (understandably) but it needs to show up on the other side of the ret. Maybe pop rbp, pop rax, move rax to mem, push rax, push rbp

	//	popq %rbp
	//	ret
}

void startThreadASM(__uint64_t mainRegs[], void *ptr, void *regs, void *stack) {
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
	asm(	"call saveRegisters\n\t"
		"mov stack(%rip), %rbp\n\t"
		"incl thread_count(%rip)\n\t"
		"mov thread_count(%rip), %rdi\n\t"	//Moves thread_counter for first argument of *ptr
		"call *%rsi\n\t");			//Calls the main[1|2] function
	
}

void startThread(void *ptr) {
	//To be completed by student
	regs[thread_count] = malloc(10*sizeof(__uint8_t)*8);		//regs[thread] holds the memory location of the space	?
	stack[thread_count] = malloc(64000*sizeof(__uint8_t)*8);	//stack[thread] holds the memory location of space	?
	//startThreadASM(mainRegs, ptr, regs+(80*((thread_count+1)%2)), stack+(64000*((thread_count+1)%2)));
	if(thread_count==0) {
		startThreadASM(mainRegs, ptr, regs, stack);
	} else {
		startThreadASM(mainRegs, ptr, regs[1], stack[1]);
	}
}

void shareCPU(int thread) {
	//Comment in asm info I may need
	//	----nooooo -> Control flow of exec by branching
	//	Based on which thread called it, save its regs (give save the offset since you give memory addy)
	//	Restore regs from provided addy
	thread=thread-1;
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
	}
}

void* main1(int whoami) {
	while(1) {
		puts("Main 1 says Hello!");
		shareCPU(whoami);
	}
}

void* main2(int whoami) {
	while(1) {
		puts("Main 2 says Hello!");
		shareCPU(whoami);
	}
}

int main() {
	startThread(main1);
	startThread(main2);
	puts("main reached");
	return 0;
}
