/*
 *	Clayton Johnson - Cooperative Threading Assignment
 *	Operating Systems Design
 *	2/26/2019 - Spring 
 *
 * 	Task			|	Progress
 * 	======================================================
 * 	Build Context Switch	|	Not started
 * 	 - Save registers	| 	 - IP/Done
 * 	 - Restore saved regs	|	 - Not started
 * 	 - Redirect Execution	| 	 - Not started
 * 	 - Keep track of threads|	 - Done
 * 	 - Kick off thread	|	Not started
 *
 */

#include <stdio.h>
#include <stdlib.h>

//typdef void (*funPtr)(int);

void* stack[2];
void* regs[2];
__uint64_t mainRegs[10];
int thread_count = 0;

void main1(int whoami) {
	while(1) {
		printf("Main 1 says Hello\n");
		shareCPU(whoami);
	}
}

void main2(int whoami) {
	while(1) {
		printf("Main 2 says Hello\n");
		shareCPU(whoami);
	}
}


void shareCPU(int thread) {
	//To be completed by student
	
	//Save current thread regs then load new thread regs
	asm(	"mov %rax, regs(%rip)\n\t"
		"mov %rbx, 8+regs(%rip)\n\t"
		"mov %rcx, 16+regs(%rip)\n\t"
		"mov %rdx, 24+regs(%rip)\n\t"
		"mov %rdi, 32+regs(%rip)\n\t"
		"mov %rsi, 40+regs(%rip)\n\t"
		"movl $0, 48+regs(%rip)\n\t"
		"mov %rbp, 56+regs(%rip)\n\t"
		"mov %rsp, 64+regs(%rip)\n\t"
		"movl $0, 72+regs(%rip)\n\t"); // Moving rip makes it upset

	/*asm(	"mov %rax, stack(%rip)\n\t"
		"mov %rbx, 8+stack(%rip)\n\t"
		"mov %rcx, 16+stack(%rip)\n\t"
		"mov %rdx, 24+stack(%rip)\n\t"
		"mov %rdi, 32+stack(%rip)\n\t"
		"mov %rsi, 40+stack(%rip)\n\t"
		"movl $0, 48+stack(%rip)\n\t"
		"mov %rbp, 56+stack(%rip)\n\t"
		"mov %rsp, 64+stack(%rip)\n\t"
		"movl $0, 72+stack(%rip)\n\t"); // Moving rip makes it upset*/

	int nextThread = 0;
	if(thread == 0) {
		nextThread = 1;
	}

}

void startThread(void* ptr) {
	//To be completed by student
	
	//main1(1);
	//main2(2);
	
	//Kick off thread passed in
	
	//Save main registers
	//	- Find where they are and save to mainRegs
	//shareCPU(1);	
	
	asm(	"mov %rax, mainRegs(%rip)\n\t"
		"mov %rbx, 8+mainRegs(%rip)\n\t"
		"mov %rcx, 16+mainRegs(%rip)\n\t"
		"mov %rdx, 24+mainRegs(%rip)\n\t"
		"mov %rdi, 32+mainRegs(%rip)\n\t"
		"mov %rsi, 40+mainRegs(%rip)\n\t"
		"movl $0, 48+mainRegs(%rip)\n\t"
		"mov %rbp, 56+mainRegs(%rip)\n\t"
		"mov %rsp, 64+mainRegs(%rip)\n\t"
		"movl $0, 72+mainRegs(%rip)\n\t"); // Moving rip makes it upset

	
	//Create space for new thread to be saved
	stack[thread_count] = malloc(6400*sizeof(__uint8_t)); // 64k stack
	regs[thread_count] = malloc(10*sizeof(__uint8_t)*8); // 10 regs

	//int test = 1234;
	//mainRegs[0] = test;
	//mainRegs[1] = 5678;
	
	int thread = thread_count;
	thread_count++;
	((void (*)(void*))ptr)(thread); //Casting hell, I feel like I'm running a play here

}

int main() {
	startThread(main1);
	startThread(main2);
	return 0;
}
