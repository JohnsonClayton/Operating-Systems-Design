#include <stdio.h>
#include <sys/timeb.h>
#include <time.h>

void time_taker(int recursions) {
	//Your purpose is to take up time
	if(recursions > 0) {
		if(recursions % 1000 == 0) {
			printf("\nRecursing");
		} else {
			printf(".");
		}
		time_taker(recursions - 1);
	} 
}

//Hand timing function address to the function being ran
void timer_func(void (*run_me)(int)) {
	//Your purpose is to run run_me and then determine how long it ran for
	//	and know all the calendar time information in case
	

	struct timeb t1, t2;
	struct tm *tdata;
	ftime(&t1);

	run_me(10000);

	ftime(&t2);
	tdata = localtime(&t1.time);
	printf("\nToday's date is %d/%d/%d\n", tdata->tm_mday, tdata->tm_mon, tdata->tm_year + 1900);
	//printf("Time before function: %lu : %u\n", t1.time, t1.millitm);
	//printf("Time after: %lu : %u\n", t2.time, t2.millitm);
	printf("Function took ");
	if(t1.time != t2.time) {
		printf("%lu seconds and ", t2.time - t1.time);
	} 
	if(t1.millitm != t2.millitm) {
		printf("%u milliseconds to execute.\n", t2.millitm - t1.millitm);
	} else {
		printf("less than a millisecond.");
	}	

}

int main() {

	//Usage found here: https://www.tutorialspoint.com/c_standard_library/c_function_time.htm
	//	and: https://pubs.opengroup.org/onlinepubs/7908799/xsh/time.h.html
	
	void* addr = &time_taker;
	timer_func(addr);

	return 0;
}
