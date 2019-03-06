#include <stdio.h>

int thread = 0;

void startThread(void *ptr) {
	//To be completed by student
	int kick_off_thread = thread;
	thread++;
	((void (*)(void*))ptr)(kick_off_thread);
}

void shareCPU(int thread) {
	//To be completed by student
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
	return 0;
}
