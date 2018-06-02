/*
 *
 *
 *
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include "crc32.h"

int
main(int argc, char **argv)
{

  char hostname[300];
  gethostname(hostname, 300);

  int i;
  for( i=1; i<argc; i++) {

    uint32_t word_crc = 17L;  /*arbitrary*/

    char substitute_string[300];

    strcpy( substitute_string, argv[i]);
    int j;
    for (j = 0; j < strlen(substitute_string); j++ ) {
      if (substitute_string[j] == '_') {
        substitute_string[j] = '\'';
      }
    }

    word_crc = crc32(word_crc, substitute_string, (size_t) strlen(substitute_string));
    word_crc = crc32(word_crc, substitute_string, (size_t) strlen(substitute_string));

    printf("/gpfs/gpfsfpo/%s-%04d.csv", hostname, hashword(substitute_string));


  }
}
