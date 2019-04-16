#include <stdio.h>
#include <pthread.h>
#include <semaphore.h>

sem_t first_stmt, second_stmt, third_stmt;

void *statement1(void *args) {
	printf("1\n");
	sem_post(&first_stmt);
	sem_wait(&third_stmt);
	sem_wait(&second_stmt);
	printf("3\n");
	sem_post(&second_stmt);
	sem_post(&third_stmt);
	return NULL;
}

void *statement2(void *args) {
	printf("2\n");
	sem_post(&first_stmt);
	sem_post(&second_stmt);
	sem_wait(&third_stmt);
	printf("4\n");
	sem_post(&third_stmt);
	return NULL;
}

int main(int argc, char *argv[]) {
	pthread_t a, b;

	sem_init(&first_stmt, 0, 1);
	sem_init(&second_stmt, 0, 1);
	sem_init(&third_stmt, 0, 1);

	sem_wait(&second_stmt);
	sem_wait(&first_stmt);
	pthread_create(&a, NULL, statement1, NULL);
	sem_wait(&first_stmt);
	pthread_create(&b, NULL, statement2, NULL);

	pthread_join(a, NULL);
	pthread_join(b, NULL);

	return 0;
}
