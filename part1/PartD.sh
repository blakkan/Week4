##!/bin/bash
#############################################################
#
#  PartD.sh - Create a cluster, start the file system, and
#  check it.
#
#############################################################


#
# Create a cluster (on the node)
#
# For this, just need IP address of the primary
echo "***** Starting part D"
ip_addr=$(grep 'gpfs1' vs.txt | cut -d' ' -f5)
echo $ip_addr


# Run the ruby support routine to build the diskfile.fpo file
ruby generate_diskfile_fpo.rb
#copy diskfile.fpo file over to primary
yes yes | scp diskfile.fpo root@$ip_addr:/root/diskfile.fpo

# And run the cluster startup and checks

###ssh root@$ip_addr 'bash -s' < part_d.sh
#push the part d script to the primary
yes yes | scp part_d.sh root@$ip_addr:/root/part_d.sh

#and run it
echo "Now please ssh over to root@$ip_addr and run the part_d.sh script (i.e. source part_d.sh)"
#ssh root@$ip_addr 'bash part_d.sh'
