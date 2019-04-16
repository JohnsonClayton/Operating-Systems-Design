#include <stdio.h>
#include <pthread.h>
#include <semaphore.h>

sem_t sem;

void *statement1(void *args) {
	printf("statement1 reached\n");
	while(1) {
		printf("1\n");
	}
	return NULL;
}

void *statement2(void *args) {
	printf("statement2 reached\n");
	while(1) {
		printf("2\n");
	}
	return NULL;
}

int main(int argc, char *argv[]) {
	pthread_t a, b;

	sem_init(&sem, 0, 1);

	pthread_create(&a, NULL, statement1, NULL);
	pthread_create(&b, NULL, statement2, NULL);

	pthread_join(a, NULL);
	pthread_join(b, NULL);

	return 0;
}
