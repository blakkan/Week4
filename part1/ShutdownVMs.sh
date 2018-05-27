#!/bin/bash
# get the ids from the file (could have queried the vs directly)
# then do the cancellation (with the response to the prompt)
cut -d' ' -f1 vs.txt | while read line
do
  yes $line | slcli vs cancel $line
done
