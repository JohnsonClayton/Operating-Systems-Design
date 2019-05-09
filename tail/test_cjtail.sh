#! /bin/sh

tail testfile hi cjtail.c > tail_results
./cjtail testfile hi cjtail.c > cjtail_results
diff tail_results cjtail_results

tail -n4 testfile hi cjtail.c > tail_results
./cjtail -4 testfile hi cjtail.c > cjtail_results
diff tail_results cjtail_results

tail -n100 testfile hi cjtail.c > tail_results
./cjtail -100 testfile hi cjtail.c > cjtail_results
diff tail_results cjtail_results
