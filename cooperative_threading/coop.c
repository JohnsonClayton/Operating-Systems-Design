/*
 *	Clayton Johnson - Cooperative Threading Assignment
 *	Operating Systems Design
 *	2/26/2019 - Spring 
 *
 * 	Task			|	Progress
 * 	======================================================
 * 	Build Context Switch	|	Not started
 * 	 - Save registers	| 	 - IP
 * 	 - Restore saved regs	|	 - Not started
 * 	 - Redirect Execution	| 	 - Not started
 * 	 - Keep track of threads|	 - Done
 * 	Kick off thread		|	Not started
 *
 */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

//typdef void (*funPtr)(int);

void* stack[2];
void* regs[2][10];
//__uint64_t mainRegs[10];
void* mainRegs[10];
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
	
	//regs[0][0] = 1234;
	//regs[0][9] = 5678;
	//regs[1][0] = 1234;
	//regs[1][9] = 5678;

	//Save current thread regs then load new thread regs
		// Save most regs
		// mov %rip, %rax
		// push %rax
		// Save %rsp
	if(thread_count==1) {
		puts("Reload the main regs!");
	}
	else if(thread == 0) {
		
		asm(	"mov %rax, regs(%rip)\n\t"
			"mov %rbx, 8+regs(%rip)\n\t"
			"mov %rcx, 16+regs(%rip)\n\t"
			"mov %rdx, 24+regs(%rip)\n\t"
			"mov %rdi, 32+regs(%rip)\n\t"
			"mov %rsi, 40+regs(%rip)\n\t"
			"movl $0, 48+regs(%rip)\n\t"
			"mov %rbp, 56+regs(%rip)\n\t");
		asm(	"lea (%rip), %rax\n\t"
			"push %rax\n\t"
			"mov %rsp, 64+regs(%rip)\n\t");


		/*asm(	"push (%rip)\n\t");
		//Save thread 0 (current)
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
		//Load up thread 1's stuff (next)
		asm(	"mov regs(%rip), %rax\n\t"
			"mov 80+regs(%rip), %rbx\n\t"
			"mov 96+regs(%rip), %rcx\n\t"
			"mov 104+regs(%rip), %rdx\n\t"
			"mov 112+regs(%rip), %rdi\n\t"
			"mov 120+regs(%rip), %rsi\n\t"
			"mov 128+regs(%rip), %rbp\n\t"
			"mov 136+regs(%rip), %rbp\n\t"
			"mov 144+regs(%rip), %rsp\n\t"
			"mov 152+regs(%rip), %rsp\n\t");
		asm(	"pop (%rip)\n\t");*/
	} else {
		//Save thread 1 (current)
		asm(	"push (%rip)\n\t");
		asm(	"mov %rax, 80+regs(%rip)\n\t"
			"mov %rbx, 88+regs(%rip)\n\t"
			"mov %rcx, 96+regs(%rip)\n\t"
			"mov %rdx, 104+regs(%rip)\n\t"
			"mov %rdi, 112+regs(%rip)\n\t"
			"mov %rsi, 120+regs(%rip)\n\t"
			"movl $0, 128+regs(%rip)\n\t"
			"mov %rbp, 136+regs(%rip)\n\t"
			"mov %rsp, 144+regs(%rip)\n\t"
			"movl $0, 152+regs(%rip)\n\t"); // Moving rip makes it upset
			//While rsp >= rbp, mov (rsp) -> stack(%rip)
				//Offset needs to change every time
		
		//Load up thread 0's stuff (next)
		asm(	"mov regs(%rip), %rax\n\t"
			"mov 8+regs(%rip), %rbx\n\t"
			"mov 16+regs(%rip), %rcx\n\t"
			"mov 24+regs(%rip), %rdx\n\t"
			"mov 32+regs(%rip), %rdi\n\t"
			"mov 40+regs(%rip), %rsi\n\t"
			"mov 48+regs(%rip), %rbp\n\t"
			"mov 56+regs(%rip), %rbp\n\t"
			"mov 64+regs(%rip), %rsp\n\t"
			"mov 72+regs(%rip), %rsp\n\t");
		asm(	"pop (%rip)\n\t");
	}

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
	
	//Create space for new thread to be saved
	stack[thread_count] = malloc(6400*sizeof(__uint8_t)); // 64k stack
	//regs[thread_count] = malloc(10*sizeof(__uint8_t)*8); // 10 regs
	for(int i = 0; i < 10; i++) {
		regs[thread_count][i] = malloc(sizeof(__uint8_t)*8);	
	}
	
	//Kick off thread passed in
	
	//Save main registers
	// - Need to find how to save 
	//asm(	"push (%rip)\n\t");
	/*asm(	"mov %rax, mainRegs(%rip)\n\t"
		"mov %rbx, 8+mainRegs(%rip)\n\t"
		"mov %rcx, 16+mainRegs(%rip)\n\t"
		"mov %rdx, 24+mainRegs(%rip)\n\t"
		"mov %rdi, 32+mainRegs(%rip)\n\t"
		"mov %rsi, 40+mainRegs(%rip)\n\t"
		"movl $0, 48+mainRegs(%rip)\n\t"
		"mov %rbp, 56+mainRegs(%rip)\n\t"
		"mov %rsp, 64+mainRegs(%rip)\n\t"
		"movl $0, 72+mainRegs(%rip)\n\t"); // Moving rip makes it upset*/

	asm(	"mov %rax, regs(%rip)\n\t"
		"mov %rbx, 8+regs(%rip)\n\t"
		"mov %rcx, 16+regs(%rip)\n\t"
		"mov %rdx, 24+regs(%rip)\n\t"
		"mov %rdi, 32+regs(%rip)\n\t"
		"mov %rsi, 40+regs(%rip)\n\t"
		"movl $0, 48+regs(%rip)\n\t"
		"mov %rbp, 56+regs(%rip)\n\t"
		"mov %rsp, 64+regs(%rip)\n\t");
	/*asm(	"lea (%rip), %rax\n\t"
		"push %rax\n\t"
		"mov %rsp, 64+regs(%rip)\n\t");*/
	asm(	"lea (%rip), %rax\n\t" 
		"mov %rax, 72+regs(%rip)\n\t");
	//Need to save stack...

	

	//int test = 1234;
	//mainRegs[0] = test;
	//mainRegs[1] = 5678;
	
	/*int ret = fork();
	if(ret < 0) {
		//Failure!
		fprintf(stderr, "Fork failed!\n");
		exit(1);
	} else if(ret == 0) {
		//Child -> Execute stuff
		((void (*)(void*))ptr)(thread); //Casting hell, I feel like I'm running a play here
	} else {
		//Parent -> Main

	}*/

	//Keeps track of who just got kicked off
	int thread = thread_count;
	thread_count++;
	((void (*)(void*))ptr)(thread); //Casting hell, I feel like I'm running a play here

}

int main() {
	startThread(main1);
	startThread(main2);
	return 0;
}
