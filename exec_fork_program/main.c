#include <stdio.h>

int main() {
	//Based off Waterloo demonstration: https://ece.uwaterloo.ca/~dwharder/icsrts/Tutorials/fork_exec/
	char* args[3] = {"Command-line", ".", NULL};
	int pid = fork();

	if(pid != 0) {
		execvp("counter", args);
	}
	wait(1);

	printf("End of main reached\n");



	return 0;
}
