#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>

const int MAX_BUFF_SIZE = 2000;

void tail(char *filename, int num_of_lines) {
	int fd = open(filename, O_RDONLY);
	if(fd < 0) {
		puts("An error occurred!");
	} else {
		struct stat fstats;
		if(stat(filename, &fstats) == -1) {
			puts("A file error occurred!");
		}

		char output_buffer[MAX_BUFF_SIZE + 1];
		char temp_char[2] = {'\000', '\000'}; //Used to temporarily hold the current char

		for(int i = 0; i < MAX_BUFF_SIZE + 1; i++) {
			output_buffer[i] = '\000';
		}

		//Go to char dictated by offset. If char == '\n' then increase
		//	the number of newlines seen. If new_line_count > 10, 
		//	don't add this char then exit
		int new_line_counter = 0;
		int offset = -1;
		
		lseek(fd, (off_t) offset, SEEK_END);

		while(		new_line_counter <= num_of_lines 
				&& (offset*-1 - 1) <= fstats.st_size 
				&& read(fd, &temp_char, 1) == 1) {

			if(temp_char[0] == '\n') {
				new_line_counter++;
			}

			offset--;
			lseek(fd, (off_t) offset, SEEK_END); 
		}
		if(offset < 0) {
			offset+=2;
		}
		lseek(fd, (off_t) offset, SEEK_END);
		read(fd, &output_buffer, offset * -1);

		printf("%s", output_buffer);
		close(fd);
	}

}

int main(int argc, char* argv[]) {

	char filename[251];
	int num_of_lines = 10;
	if(argc < 2) {
		puts("Usage: cjtail [filename]");
	} else {
		//Parse arguments
		for(int i = 1; i < argc; i++) {
			if(argv[i][0] == '-') {
				if(strlen(argv[i]) > 1) {
					argv[i][0] = '0';
					num_of_lines = atoi(argv[i]);
					if(num_of_lines == 0) num_of_lines = 10;
					argv[i] = "\000";
				}
			}
		}
		
		//Call tail on all files provided
		for(int i = 1; i < argc; i++) {
			if(strcmp(argv[i], "\000")) {
				strncpy(&filename, argv[i], 250);
				filename[250] = '\000';
				if(argc > 1) {
					printf("==> %s <==\n", filename);
					tail(filename, num_of_lines);
					if(i != (argc - 1)) printf("\n");
				} else tail(filename, num_of_lines);
			}
		}
	}

	return 0;
}
