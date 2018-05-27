#!/bin/bash
#############################################################
#
#  Part1A.sh - starts up 3 instances of Red Hat and gets
#  IP address and credentials into well-known file
#
#############################################################

#Part A: Provision 3 instances of Redhat
# Note1:  This won't run unatended, must answer the question about charges, so adding the y pipe
# Note2:  For our accounts, can't spin up the second VM until the first starts, so have to wait (should poll, but for now just wait)
# Note3:  Should probably poll for these completions, rather than just sleep,
#         but for as few times as this will be used, this is OK.
yes y | slcli vs create -d sjc01 --os REDHAT_6_64 --cpu 2 --memory 4096 --disk 25G --disk 25G --hostname gpfs1 --domain blakkan.org --key SECOND_KEY
sleep 2m
yes y | slcli vs create -d sjc01 --os REDHAT_6_64 --cpu 2 --memory 4096 --disk 25G --disk 25G --hostname gpfs2 --domain blakkan.org --key SECOND_KEY
sleep 2m
yes y | slcli vs create -d sjc01 --os REDHAT_6_64 --cpu 2 --memory 4096 --disk 25G --disk 25G --hostname gpfs3 --domain blakkan.org --key SECOND_KEY
sleep 8m

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
