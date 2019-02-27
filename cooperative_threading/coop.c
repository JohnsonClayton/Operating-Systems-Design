/*
 *	Clayton Johnson - Cooperative Threading Assignment
 *	Operating Systems Design
 *	2/26/2019 - Spring 
 *
 * 	Task			|	Progress
 * 	======================================================
 * 	Build Context Switch	|	Not started
 * 	 - Save registers	| 	 - Not started
 * 	 - Restore saved regs	|	 - Not started
 * 	 - Redirect Execution	| 	 - Not started
 * 	 - Keep track of threads|	 - Not started
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
	
	
	//Create space for new thread to be saved
	stack[thread_count] = malloc(6400*sizeof(__uint8_t)); // 64k stack
	regs[thread_count] = malloc(10*sizeof(__uint8_t)*8); // 10 regs
	
	((void (*)(void*))ptr)(1); //This is stupid, equivalent to calling main1(1)

}

int main() {
	startThread(main1);
	startThread(main2);
	return 0;
}
