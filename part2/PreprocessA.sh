#!/bin/bash
#################################################################
#
# Preprocess.sh
#
#   This pulls over the data and prepares it in three distributed
# key-value stores
#
#################################################################

# Step 1: get the IP addresses running from Part 1
# (this is just cloned from Part 1)

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

# Step 2: install toolchain on each VM
# (If we had a lot more than three, we'd run in paralled, but
# this is OK for just 3)



#loop through the vs.txt file which has lines (loops rolled like this
# to watch them run.)
cut -d' ' -f5 vs.txt

for ip_addr_p in $(cut -d' ' -f5 vs.txt)
do
 echo "install ruby on $ip_addr_p"
 ssh root@$ip_addr_p "yum -y install ruby || true"

 echo "install map_combiner on $ip_addr_p"
 scp map_combiner.c root@$ip_addr_p:/root/map_combiner.c
 ssh root@$ip_addr_p "gcc map_combiner.c -o map_combiner"

 echo "install pullover.rb script on $ip_addr_p"
 scp pullover.rb root@$ip_addr_p:/root/pullover.rb

 echo "install alphabeticDealOut.rb script on $ip_addr_p"
 scp alphabeticDealOut.rb root@$ip_addr_p:/root/alphabeticDealOut.rb

 echo "install shuffleSort.rb script on $ip_addr_p"
 scp shuffleSort.rb root@$ip_addr_p:/root/shuffleSort.rb

 echo "install reduceToKeyValueStore.rb script on $ip_addr_p"
 scp reduceToKeyValueStore.rb root@$ip_addr_p:/root/reduceToKeyValueStore.rb

 echo "install pick_next_word.rb script on $ip_addr_p"
 scp pick_next_word.rb root@$ip_addr_p:/root/pick_next_word.rb

 echo "install mumbler script on $ip_addr_p"
 scp mumbler root@$ip_addr_p:/root/mumbler

done


echo "Now ssh into all three machines in parallel to monitor"
echo "and on gpfs1 locally run pullover.rb 0 33"
echo "on gpfs2 run pullover.rb 34 66"
echo "on gpfs3 run pullover.rb 67 99"
echo ""
echo "Then run alphabeticDealOut.rb on each in parallel"
echo "on gpfs1 run alphabeticDealOut.rb data_0_33/*.csv"
echo "on gpfs2 run alphabeticDealOut.rb data_34_66/*.csv"
echo "on gpfs3 run alphabeticDealOut.rb data_67_99/*.csv"
echo ""
echo "then run shuffleSort.rb on each in parallel (inter-vm traffic here)"
echo "on gpfs1 run shuffleSort.rb a b c d e f g h i"
echo "on gpfs2 run shuffleSort.rb j k l m n o p q r"
echo "on gpfs3 run shuffleSort.rb s t u v w x y z X"
echo ""
echo "then run reduceToKeyValueStore.rb on each in parallel"
echo "on gpfs1 reduceToKeyValueStore.rb a b c d e f g h i"
echo "on gpfs2 reduceToKeyValueStore.rb j k l m n o p q r"
echo "on gpfs3 reduceToKeyValueStore.rb s t u v w x y z X"
echo ""
echo "at this point, should be able to mumbler on any vm"
