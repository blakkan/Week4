#!/bin/bash
# get the ids from the file (could have queried the vs directly)
# then do the cancellation (with the response to the prompt)
cut -d' ' -f1 vs.txt | while read id
do
  yes $id | slcli vs cancel $id
done


echo "Removing the old vms from known hosts (in preparation of next start)"
# -f5 (not -f3) because there are doubles spaces in the outputs.
cut -d' ' -f5 vs.txt | while read external_ip
do
  yes yes | ssh-keygen -f ~/.ssh/known_hosts -R $external_ip
done
