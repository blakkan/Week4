#################################
#
# part_d.sh
#
#   This runs on the primary VM
#
##################################
mmcrcluster -C john -p gpfs1 -s gpfs2 -R /usr/bin/scp -r /usr/bin/ssh -N gpfs1:quorum,gpfs2,gpfs3

mmchlicense server -N all

mmstartup -a
sleep 10
mmgetstate -a
mmlscluster

#preliminary look at our own (gpfs1) disks
fdisk -l |grep Disk | grep bytes


#and make the disk aggregation
mmcrnsd -F /root/diskfile.fpo
#and make the distributed file system
mmcrfs gpfsfpo -F /root/diskfile.fpo -A yes -Q no -r 1 -R 1
# and check it...
mmlsfs all
#and mount it (on all nodes)
mmmount all -a
#and verify we have 75GB
cd /gpfs/gpfsfpo;df -h .

#and verify we can write, and read on all
cd /gpfs/gpfsfpo;touch aa'
ls -l /gpfs/gpfsfpo'
ssh gpfs2 'ls -l /gpfs/gpfsfpo'
ssh gpfs3 'ls -l /gpfs/gpfsfpo'
