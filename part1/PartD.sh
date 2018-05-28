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

ssh root@$ip_addr 'mmcrcluster -C dima -p gpfs1 -s gpfs2 -R /usr/bin/scp -r /usr/bin/ssh -N gpfs1:quorum,gpfs2,gpfs3'

yes yes | ssh root@$ip_addr 'mmchlicense server -N all'

ssh root@$ip_addr 'mmstartup -a'
sleep 10
ssh root@$ip_addr 'mmgetstate -a'
ssh root@$ip_addr 'mmlscluster'

#preliminary look at our own (gpfs1) disks
ssh root@$ip_addr 'fdisk -l |grep Disk |grep bytes'
# Run the ruby support routine to build the diskfile.fpo file
ruby generate_diskfile_fpo.rb

#copy diskfile.fpo file over to primary
yes yes | scp diskfile.fpo root@$ip_addr:/root/diskfile.fpo

#and make the disk aggregation
ssh root@$ip_addr 'mmcrnsd -F /root/diskfile.fpo'
#and make the distributed file system
ssh root@$ip_addr 'mmcrfs gpfsfpo -F /root/diskfile.fpo -A yes -Q no -r 1 -R 1'
# and check it...
ssh root@$ip_addr 'mmlsfs all'
#and mount it (on all nodes)
ssh root@$ip_addr 'mmmount all -a'
#and verify we have 75GB
ssh root@$ip_addr 'cd /gpfs/gpfsfpo;df -h .'

#and verify we can write, and read on all
ssh root@$ip_addr 'cd /gpfs/gpfsfpo;touch aa'
ssh root@$ip_addr 'ls -l /gpfs/gpfsfpo'
ssh root@$ip_addr "ssh gpfs2 'ls -l /gpfs/gpfsfpo'"
ssh root@$ip_addr "ssh gpfs3 'ls -l /gpfs/gpfsfpo'"
