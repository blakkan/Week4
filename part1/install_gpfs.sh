#!/bin/bash
##############################################################################
#
# install_gpfs_sh
#
#   This runs on the VM, to install GPFS.
#   Needs to run as root
#
##############################################################################

#First, pull over the tarfile
cd /root
curl http://1d7c9.http.dal05.cdn.softlayer.net/icp-artifacts/GPFS_4.1_STD_LSX_QSG.tar -o GPFS_4.1_STD_LSX_QSG.tar

# untar
tar -xvf GPFS_4.1_STD_LSX_QSG.tar

# run install script
./gpfs_install-4.1.0-0_x86_64 --silent

# install kernel tools, based on the January 24, 2018 errata at the top of the assignment
yum -y install "kernel-devel-uname-r == $(uname -r)"
yum -y install ksh gcc-c++ compat-libstdc++-33 redhat-lsb net-tools libaio

# setup symlink for building kernel modules

cd /lib/modules/$(uname -r)
rm -f build
ln -sf /usr/src/kernels/$(uname -r) build

# Now get our actual rpms (local install from what we've already pulled)
rpm -ivh /usr/lpp/mmfs/4.1/gpfs*.rpm

# And build the actual kernel modules
cd /usr/lpp/mmfs/src
make Autoconfig
make World
make InstallImages
