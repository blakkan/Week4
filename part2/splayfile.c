/*
 *
 *  splayfile.c   - splits input files into small files for linear search
 *
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include "./crc32.h"




int
main(int argc, char **argv)
{

  /* set up inputs */
  char *line = malloc(300);
  char *word = malloc(100);
  FILE *inputFile;

  /* set up output files */
  FILE* outputFile[NUM_HASH_BUCKETS];
  char file_name[300];
  char hostname[300];
  gethostname(hostname, 300);

  chdir("/gpfs/gpfsfpo");

  int i;
  for ( i= 0; i < NUM_HASH_BUCKETS; i++ ) {
    sprintf(file_name, "%s-%04d.csv", hostname, i);
    if ( ( outputFile[i] = fopen(file_name, "a+")) == NULL ) {
      printf("Failed to open %s\n", file_name);
      exit(1);
    }
  }
  printf("Opened Outputs\n");

  /*
   *  now deal the lines out
   */
  for( i=1; i<argc; i++) {


    sprintf(file_name, "combined_%s.csv", argv[i] );


    printf("Processing %s\n", file_name);

    /* for each line in the file */
    if ( ( inputFile = fopen( file_name, "r") ) == NULL ) {
      printf ( "Could not open %s\n", file_name );
      exit(1);
    }


    /* copy the line into the appropriate to its hash */
    while ( fgets(line, 299, inputFile) != NULL) {

      sscanf( line, "%s", word);
      fputs( line, outputFile[hashword(word)] );

    }
  }

  /* and close the output files */

  for ( i = 0; i < NUM_HASH_BUCKETS; i++ ) {
    fclose(outputFile[i]);
  }

}
