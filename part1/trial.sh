#!/bin/bash

#get the list of ids running (could have harvested above, but get all here)
#Check this to make sure we waited long enough
slcli vs list > vs.txt
#in case we need them later, get the root passwords
rm -f creds.txt
cut -d' ' -f1 vs.txt | while read the_id
do
  slcli vs credentials $the_id >> creds.txt
done
#if we waited long enough, we should have three root passwords in creds.txt
echo "Done- verify VM address and root passwords assigned, below"
cat vs.txt
cat creds.txt
