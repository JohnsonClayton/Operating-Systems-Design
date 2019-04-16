#include <stdio.h>
#include <pthread.h>

typedef struct __myarg_t {
	int a;
	int b;
} myarg_t;

int *mythread(void *arg) {
	myarg_t *m = (myarg_t *) arg;
	printf("thread %ld: %d %d\n", pthread_self(), m->a, m->b);
	return 2;
}

void *test(void) {
	printf("Hello!\n");
}

int main(int argc, char* argv[]) {
	puts("Top of main");
	pthread_t p1, p2, p3, p4;
	int rc;

	myarg_t args;
	args.a = 10;
	args.b = 20;
	rc = pthread_create(&p1, NULL, mythread, &args); //returns zero for successful

	myarg_t args1;
	args1.a = 100;
	args1.b = 200;
	rc = pthread_create(&p2, NULL, mythread, &args1);

	myarg_t args2;
	args2.a = 1000;
	args2.b = 2000;
	rc = pthread_create(&p3, NULL, mythread, &args2);

	rc = pthread_create(&p4, NULL, test, NULL);

	pthread_join(p1, NULL);
	pthread_join(p2, NULL);
	pthread_join(p3, NULL);
	pthread_join(p4, NULL);

	puts("Start of new section!");

	//myarg_t args;
	args.a = 10;
	args.b = 20;
	rc = pthread_create(&p1, NULL, mythread, &args); //returns zero for successful

	//myarg_t args1;
	args.a = 100;
	args.b = 200;
	rc = pthread_create(&p2, NULL, mythread, &args1);

	//myarg_t args2;
	args.a = 1000;
	args.b = 2000;
	rc = pthread_create(&p3, NULL, mythread, &args2);

	rc = pthread_create(&p4, NULL, test, NULL);

	pthread_join(p1, NULL);
	//printf("Returned value = %d\n", rc); //How do we get the return value from the thread?
	pthread_join(p2, NULL);
	pthread_join(p3, NULL);
	pthread_join(p4, NULL);
	puts("Bottom of main");
	return 0;
}
