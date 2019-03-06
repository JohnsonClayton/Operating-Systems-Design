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

void* stack[2][800]; //May need to reinitialize to be larger, rn each index is separated by 8 bytes which is not enough
void* regs[2][10];
//__uint64_t mainRegs[10];
void* mainRegs[10];
int thread_count = 0;
int stack_size = 0;

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
		// Save most regs
		// mov %rip, %rax
		// push %rax
		// Save %rsp
	if(thread == 0) {
		//printf("Thread is 0\n");	
		//Save stuff for current process
		asm(	"mov %rax, regs(%rip)\n\t"
			"mov %rbx, 8+regs(%rip)\n\t"
			"mov %rcx, 16+regs(%rip)\n\t"
			"mov %rdx, 24+regs(%rip)\n\t"
			"mov %rdi, 32+regs(%rip)\n\t"
			"mov %rsi, 40+regs(%rip)\n\t"
			"movl $0, 48+regs(%rip)\n\t"
			"mov %rbp, 56+regs(%rip)\n\t"
			"mov %rsp, 64+regs(%rip)\n\t");
		asm(	"lea (%rip), %rax\n\t"
			"add $50, %rax\n\t"
			"mov %rax, 72+regs(%rip)\n\t");
		
		/*asm(	"mov stack_size(%rip), %rdx #This is where I initialize the loop!\n\t"
			"mov %rsp, %rax\n\t"
			"mov (%rsp), %rbx\n\t"
			"mov 6400+stack(%rip), %rcx\n\t"
			"saveloop1:\n\t"
			"mov %rbx, %rcx #This is the top of the loop\n\t"
			"add $2, %rcx\n\t"
			"add $2, %rsp\n\t"
			"add $2, %rdx\n\t"
			"cmp %rsp, %rbp\n\t"
			"jnc saveloop1\n\t"
			"mov %rdx, stack_size(%rip)\n\t"
			"mov %rax, %rsp\n\t");*/
		
		asm(	"mov stack_size(%rip), %rdx #This is where I initialize the loop!\n\t"
			"mov %rsp, %rax\n\t"
			"mov (%rsp), %rbx\n\t"
			"lea 6400+stack(%rip), %rcx\n\t"
			"saveloop1:\n\t"
			"mov %rbx, (%rcx) #This is the top of the loop\n\t"
			"add $2, %rcx\n\t"
			"add $2, %rsp\n\t"
			"add $2, %rdx\n\t"
			"cmp %rsp, %rbp\n\t"
			"jnc saveloopStart\n\t"
			"mov %rdx, stack_size(%rip)\n\t"
			"mov %rax, %rsp\n\t");
		
		//Need to get the saved rip to the current rip
		asm(	"mov 80+regs(%rip), %rax\n\t"
			"mov 80+regs(%rip), %rbx\n\t"
			"mov 96+regs(%rip), %rcx\n\t"
			"mov 104+regs(%rip), %rdx\n\t"
			"mov 112+regs(%rip), %rdi\n\t"
			"mov 120+regs(%rip), %rsi\n\t"
			"mov 128+regs(%rip), %rbp\n\t"
			"mov 136+regs(%rip), %rbp\n\t"
			"mov 144+regs(%rip), %rsp\n\t");

		//Load up stack for new process
		asm(	"mov stack_size(%rip), %rdx\n\t"
			"mov stack(%rip), %rbx\n\t"
			"add %rdx, %rbx\n\t"
			"restoreloop1:\n\t"
			"mov %rbx, %rcx\n\t"
			"push %rcx\n\t"
			"sub $8, %rbx\n\t"
			"sub $2, %rdx\n\t"
			"cmp $0, %rdx\n\t"
			"jnz restoreloop1\n\t");

		//Switch over
		asm(	"mov 152+regs(%rip), %rax\n\t"
			"pop %rbx\n\t"
			"pop %rbp\n\t"
			"push %rax\n\t"
			"ret\n\t");
	} else {
		//printf("Thread is 1\n");	
		//Save stuff for current process
		asm(	"mov %rax, 80+regs(%rip)\n\t"
			"mov %rbx, 88+regs(%rip)\n\t"
			"mov %rcx, 96+regs(%rip)\n\t"
			"mov %rdx, 104+regs(%rip)\n\t"
			"mov %rdi, 112+regs(%rip)\n\t"
			"mov %rsi, 120+regs(%rip)\n\t"
			"movl $0, 128+regs(%rip)\n\t"
			"mov %rbp, 136+regs(%rip)\n\t"
			"mov %rsp, 144+regs(%rip)\n\t");
		asm(	"lea (%rip), %rax\n\t"
			"add $50, %rax\n\t"
			"mov %rax, 152+regs(%rip)\n\t");

		/*asm(	"mov stack_size(%rip), %rdx #This is where I initialize the loop!\n\t"
			"mov %rsp, %rax\n\t"
			"mov (%rsp), %rbx\n\t"
			"mov stack(%rip), %rcx\n\t"
			"saveloop2:\n\t"
			"mov %rbx, %rcx #This is the top of the loop\n\t"
			"add $2, %rcx\n\t"
			"add $2, %rsp\n\t"
			"add $2, %rdx\n\t"
			"cmp %rsp, %rbp\n\t"
			"jnc saveloop2\n\t"
			"mov %rdx, stack_size(%rip)\n\t"
			"mov %rax, %rsp\n\t");*/
		
		asm(	"mov stack_size(%rip), %rdx #This is where I initialize the loop!\n\t"
			"mov %rsp, %rax\n\t"
			"mov (%rsp), %rbx\n\t"
			"lea stack(%rip), %rcx\n\t"
			"saveloop2:\n\t"
			"mov %rbx, (%rcx) #This is the top of the loop\n\t"
			"add $2, %rcx\n\t"
			"add $2, %rsp\n\t"
			"add $2, %rdx\n\t"
			"cmp %rsp, %rbp\n\t"
			"jnc saveloopStart\n\t"
			"mov %rdx, stack_size(%rip)\n\t"
			"mov %rax, %rsp\n\t");
		
		
		//Need to get the saved rip to the current rip
		asm(	"mov regs(%rip), %rax\n\t"
			"mov 8+regs(%rip), %rbx\n\t"
			"mov 16+regs(%rip), %rcx\n\t"
			"mov 24+regs(%rip), %rdx\n\t"
			"mov 32+regs(%rip), %rdi\n\t"
			"mov 40+regs(%rip), %rsi\n\t"
			"mov 48+regs(%rip), %rbp\n\t"
			"mov 56+regs(%rip), %rbp\n\t"
			"mov 64+regs(%rip), %rsp\n\t");

		//Load up stack for new process
		asm(	"mov stack_size(%rip), %rdx\n\t"
			"mov 6400+stack(%rip), %rbx\n\t"
			"add %rdx, %rbx\n\t"
			"restoreloop2:\n\t"
			"mov (%rbx), %rcx\n\t"
			"push %rcx\n\t"
			"sub $2, %rbx\n\t"
			"sub $2, %rdx\n\t"
			"cmp $0, %rdx\n\t"
			"jnz restoreloop2\n\t");

		//Switch over
		asm(	"mov 72+regs(%rip), %rax\n\t"
			"push %rax\n\t"
			"ret\n\t");
	}
}

void startThread(void* ptr) {
	//To be completed by student
	printf("Entering startThread #%d\n", thread_count+1);
	
	//Create space for new thread to be saved
	//stack[thread_count] = malloc(6400*sizeof(__uint8_t)); // 64k stack
	for(int i = 0; i < 800; i++) {
		stack[thread_count][i] = malloc(sizeof(__uint8_t)*8);
	}
	//regs[thread_count] = malloc(10*sizeof(__uint8_t)*8); // 10 regs
	for(int i = 0; i < 10; i++) {
		regs[thread_count][i] = malloc(sizeof(__uint8_t)*8);	
	}
	
	//Kick off thread passed in
	
	//asm(	"leave\n\t""ret\n\t");

	//Save main registers
	asm(	"mov %rax, 80+regs(%rip)\n\t"
		"mov %rbx, 88+regs(%rip)\n\t"
		"mov %rcx, 96+regs(%rip)\n\t"
		"mov %rdx, 104+regs(%rip)\n\t"
		"mov %rdi, 112+regs(%rip)\n\t"
		"mov %rsi, 120+regs(%rip)\n\t"
		"movl $0, 128+regs(%rip)\n\t"
		"mov %rbp, 136+regs(%rip)\n\t"
		"mov %rsp, 144+regs(%rip)\n\t");
	asm(	"lea (%rip), %rax\n\t" 
		"add $101, %rax\n\t"
		"mov %rax, 152+regs(%rip)\n\t");

	//Need to save stack...
	asm(	"mov stack_size(%rip), %rdx #This is where I initialize the loop!\n\t"
		"mov %rsp, %rax\n\t"
		"mov (%rsp), %rbx\n\t"
		"lea stack(%rip), %rcx\n\t"
		"saveloopStart:\n\t"
		"pop (%rcx)\n\t"
		"add $8, %rcx\n\t"
		"add $2, %rdx\n\t"
		"cmp %rsp, %rbp\n\t"
		"jnc saveloopStart\n\t"
		"mov %rdx, stack_size(%rip)\n\t"
		"mov %rax, %rsp\n\t");

	

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
