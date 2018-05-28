#!/bin/bash
##############################################################################
#
# start_gpfs.sh
#
#   This runs only on one of the vms.   (Would,
# for the exercise, by gpfs1)
#
##############################################################################


# start mr cluster with the primary on this host and a secondary on gpfs2
mmcrcluster -C john -p gpfs1 -s gpfs2 -R /usr/bin/scp -r /usr/bin/ssy -N /root/nodefile

# accept the license (must manually indicate yes)
mmchlicense server -N all

# start it up
mmstartup -a

# and check it
mmgetstate -a

# more details about the cluster
mmlscluster
