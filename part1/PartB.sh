#!/bin/bash

############################################################
#
# PartB - Assuming three VMs are running (and we have
# their ipaddresses in a well-known file),
#    1) Edit the bash profile to include a specified path
#    2) Copy over the a hosts file
#
#############################################################

#loop through the vs.txt file which has lines
cut -d' ' -f5 vs.txt | while read line
do

echo ProcessingIP:$line

#
# First, just probe machine to see if connected
# (And deal with the known host prompt)
#
yes yes | ssh root@$line 'bash -s' < probe.sh

#
# edit the bash profile to append to the $PATH
#  (Note; each time this is run, it appends again)
#
yes yes | ssh root@$line 'bash -s' < update_path.sh


#
# Copy over the keypair we used
#
###yes yes | scp -r ~/.ssh/id_rsa root@$line:/root/.ssh/id_rsa
yes yes | scp ~/.ssh/id_rsa root@$line:/root/.ssh/id_rsa
yes yes | scp ~/.ssh/id_rsa.pub root@$line:/root/.ssh/id_rsa.pub

echo "chmod of rsa file"
yes yes | ssh root@$line 'bash -s' < change_rsa_protection.sh


# Generate a hosts file and overwrite on each target
#  Didn't really need to regenerate it inside the loop,
#  but only 3 instances...
echo "provision /etc/hosts and /root/nodefile"
ruby generate_hosts_and_node_file.rb
#copy them both over
yes yes | scp hosts root@$line:/etc/hosts
yes yes | scp nodefile root@$line:/root/nodefile
yes yes | ssh root@$line 'bash -s' < change_host_and_nodefile_protection.sh

done
