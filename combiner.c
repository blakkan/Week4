#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char current_bigram[200];
char new_bigram[200];
int current_count = -1;
int new_count;

int main( int argc, char *argv[]) {

    FILE *stream;
    char *line = NULL;
    size_t len = 0;
    ssize_t nread;

    char *token;


    if (argc != 2) {
        fprintf(stderr, "Usage: %s <file>\n", argv[0]);
        exit(EXIT_FAILURE);
    }

    stream = fopen(argv[1], "r");
    if (stream == NULL) {
        perror("fopen");
        exit(EXIT_FAILURE);
    }

    /* getline allocs/reallocs as needed so line points to it, includes newline
     * and is zero terminated */
    while ((nread = getline(&line, &len, stream)) != -1) {
        printf("Retrieved line of length %zu:\n", nread);
        fwrite(line, nread, 1, stdout);

        /* tokenize */
        token = strtok(line, "\t");
        strcpy(new_bigram,token);
        printf("%s:", new_bigram);

        /* get rid of year */

        /*token = strtok(NULL, "\t");*/


        token = strtok(NULL, "\n\t");
        new_count = atoi(token);


        /* now what to do...   If first line, just note. */
        if (current_count == -1 ) {
          strcpy(current_bigram, new_bigram);
          current_count = new_count;
        } else if ( strcmp(new_bigram, current_bigram) == 0) {
          current_count += new_count;
        } else {
          printf("%s\t%d\n", current_bigram, current_count);
          strcpy(current_bigram, new_bigram);
          current_count = new_count;
        }
    }

    /* output last reamaining item, unless it was fully blank input */
    if (current_count != -1) {
      printf("%s\t%d\n", current_bigram, current_count);
      strcpy(current_bigram, new_bigram);
      current_count = new_count;
    }

    free(line);
    fclose(stream);
    exit(EXIT_SUCCESS);
}
