#! /bin/sh

tail testfile hi cjtail.c > tail_results
./cjtail testfile hi cjtail.c > cjtail_results
diff tail_results cjtail_results
