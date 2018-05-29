/*****************************************************************
# map_combine.c
#
#  This takes sorted lines (sorted by the bigram) and combines
# based on the count.
#
# Command line argurments:
#  map_combine [-m] input_file
#
# If the -m option is given, the "year" column after the
# bigram will be stripped off prior to processing.
#
# Note this does the combining only as effectively as
# the file is already sorted.   Also note it doesn't make any
# alterations to word case.
#
*****************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <locale.h>

char current_headword[200];
char new_headword[200];
char current_tailword[200];
char new_tailword[200];
int current_count = -1;
int new_count;

int remove_year_flag = 0;

int main( int argc, char *argv[]) {

    setlocale(LC_ALL, "");

    FILE *stream;
    char *line = NULL;
    size_t len = 0;
    ssize_t nread;

    char *token;

    /* First, get the option, if we have the m flag, we'll "map away"
       the year */
    if ((argc != 2) && (argc != 3)) {
        fprintf(stderr, "Usage: %s [-m] <file>\n", argv[0]);
        exit(EXIT_FAILURE);
    }

    if ( argc == 3 ) {

      if (strcmp(argv[1],"-m")==0) {
        remove_year_flag = 1;
        stream = fopen(argv[2], "r");
      } else {
        fprintf(stderr, "Usage: %s [-m] <file>\n", argv[0]);
        exit(EXIT_FAILURE);
      }
    } else {
        stream = fopen(argv[1], "r");
    }

    /* now open the file to read */


    if (stream == NULL) {
        perror("fopen");
        exit(EXIT_FAILURE);
    }

    /* getline allocs/reallocs as needed so line points to it, includes newline
     * and is zero terminated */
    while ((nread = getline(&line, &len, stream)) != -1) {

      /* way to many problems with strtok (e.g. UTF-8...), go to sscanf */
      if ( remove_year_flag ) {
        sscanf(line, "%s %s %*d %d", new_headword, new_tailword, &new_count);
      } else {
        sscanf(line, "%s %s %d", new_headword, new_tailword, &new_count);
      }
        /* lower case it (Not for now- too much hassle with UTF-8) */
      //  for (int i = 0; new_bigram[i]; i++) {
      //    new_bigram[i] = tolower(new_bigram[i]);
      //  }


        /* now what to do...   If first line, just note. */
        if (current_count == -1 ) {
          strcpy(current_headword, new_headword);
          strcpy(current_tailword, new_tailword);
          current_count = new_count;
        } else if ( (strcmp(new_headword, current_headword) == 0) &&
                    (strcmp(new_tailword, current_tailword) == 0) ){
          current_count += new_count;
        } else {
          printf("%s %s\t%d\n", current_headword, current_tailword, current_count);
          strcpy(current_headword, new_headword);
          strcpy(current_tailword, new_tailword);
          current_count = new_count;
        }
    }

    /* output last reamaining item, unless it was fully blank input */
    if (current_count != -1) {
      printf("%s %s\t%d\n", current_headword, current_tailword, current_count);
    }

    free(line);
    fclose(stream);
    exit(EXIT_SUCCESS);
}
