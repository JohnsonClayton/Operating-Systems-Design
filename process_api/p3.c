#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main(int argc, char* argv[]) {
	
	printf("Hello, world (pid:%d)\n", (int)getpid());
	int rc = fork();
	if(rc < 0) {
		fprintf(stderr, "Fork failed!\n");
		exit(1);
	} else if (rc == 0) {
		printf("Hello, I am a child (pid:%d)\n", (int)getpid());
		char *myargs[3];
		myargs[0] = strdup("wc");
		myargs[1] = strdup("p3.c");
		myargs[2] = NULL;
		execvp(myargs[0], myargs);
		printf("This shouldn't print out");
	} else {
		int rc_wait = wait(NULL);
		printf("Hello, I am the parent of %d (pid:%d)\n", rc, (int)getpid());
	}

	return 0;
}
