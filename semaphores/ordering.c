#include <stdio.h>
#include <pthread.h>
#include <semaphore.h>

sem_t s;

void *child (void *arg) {
	printf("child\n");
	sem_post(&s); // signal here: child is done
	return NULL;
}

int main(int argc, char *argv[]) {
	sem_init(&s, 0, 0);
	printf("parent: begin\n");
	pthread_t c;
	pthread_create(&c, NULL, child, NULL);
	sem_wait(&s);	// wait here for the child
	printf("parent: end\n");
	return 0;
}
