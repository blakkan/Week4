#!/usr/bin/ruby
#############################################################
#
#  PartD1.rb - build the file systems; this is in ruby
#   rather than bash, since it's just too much string
#   manipulation.
#
#############################################################

# as a preliminary, identify the available disks on
# the three vms.   Each of the vms is provisioned with
# two 25GB disks (and possibly some other stoage we got
# as part of the default)  However, one of these disks
# contains a file system, mounted to "/", and obviously
# we don't want to build a gpfs on that...

# from the vx.txt file, create a hash of hashes;
# outer key is the hostname
disks = {}

File.readlines("vs.txt").each_with_index do |line, index|

  list_of_big_disks = []

  id, host_name, external_ip, internal_ip = line.split(/\s+/)

  disks[host_name] = { 'external_ip' => external_ip, 'internal_ip' => internal_ip}


  # probe to get RSA established
  system("yes yes | ssh root@#{external_ip} 'bash -s' < probe.sh > /dev/null")

  # now get the names of the disks, adding them to the list
  # under consideration for use by gpfs.  But only look at
  # those with storage size of at least a GB

  line_list = `ssh root@#{external_ip} fdisk -l`
  list_of_big_disks = line_list.split(/\n/).select{|f| f=~ /^Disk\s+\// && f=~ / GB, /}.
    map{|f| f =~ /Disk (\/[^:]+)/; $1}

    if (list_of_big_disks.length() > 2)
      puts "ERROR- saw more than two candidate disks"
      p list_of_big_disks
      exit(1)
    end

    # now get the names of any disk with something mounted on it,
    # and remove it from the above list
    # (actually, this shouldn't really need a loop)
    # And could also detect it's in use from the boot status, but
    # this is what the problem statment said to use.
    root_line = `ssh root@#{external_ip} mount | grep ' \/ '`

    if (root_line =~ /^(\/dev\/\D+)\d?\son/ )
     root_disk = $1
     list_of_big_disks.delete(root_disk)
   else
     puts "ERROR - couldn't find root disk"
     exit(1)
   end


    disks[host_name].merge!('available_disk' => list_of_big_disks[0])

end #end of loop on all vm's

#
# Ready to build the diskfile.fpo file additions.  Start with the standard
# header, then add
#

file_string=<<EOF
%pool:
pool=system
allowWriteAffinity=yes
writeAffinityDepth=1
EOF

disks.keys.sort.each_with_index do |k, index|
  file_string << "\n"
  file_string << "%nsd:\n"
  file_string << "device=#{disks[k]['available_disk']}\n"
  file_string << "servers=#{k}\n"
  file_string << "usage=dataAndMetadata\n"
  file_string << "pool=system\n"
  file_string << "failureGroup=#{index+1}\n"
end

File.open("diskfile.fpo", 'w') { |file| file.write(file_string) }
