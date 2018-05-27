#!/bin/bash
cut -d' ' -f5 vs.txt | while read line
do
# edit the bash profile to append to the $PATH
yes yes | scp root@$line:/root/.bash_profile temp$line
echo 'export PATH=$PATH:/usr/lpp/mmfs/bin' >> temp$line
yes yes | scp temp$line root@$line:/root/.bash_profile

# Copy over the keypair we used (only one)
yes yes | scp -r ~/.ssh/id_rsa root@line:/root/.ssh/id_rsa

# Generate a hosts file and overwrite on each target
#  Didn't really need to regenerate it inside the loop,
#  but only 3 instances...


done
