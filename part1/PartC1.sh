#!/bin/bash
#############################################################
#
#  PartC1.sh - for each vm, try to communicate with all
# other VMs, just to "prime" the connectivity
#
#############################################################

#loop through the vs.txt file which has lines
cut -d' ' -f5 vs.txt | while read ip_addr
do
###echo $ip_addr
###scp tickle_all.sh root@$ip_addr:/root/tickle_all.sh
###echo "moved it"
###echo "Log into each and run it"
ssh root@$line 'bash -s' < tickle_all.sh
done
