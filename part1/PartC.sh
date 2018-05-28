##!/bin/bash
#############################################################
#
#  PartC.sh - for each vm, install GPFS
#
#############################################################

#loop through the vs.txt file which has lines
cut -d' ' -f5 vs.txt | while read line
do
echo $line
ssh root@$line 'bash -s' < install_gpfs.sh
done
