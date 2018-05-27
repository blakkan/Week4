#!/usr/bin/ruby
hosts_string = "127.0.0.1\tlocalhost.localdomain localhost\n"
nodefile_string = ""

# short file, so read them in all at once.
File.readlines("vs.txt").each_with_index do |line, index|

  id, name, external_ip, internal_ip = line.split(/\s+/)

  hosts_string << internal_ip + "\t" + name + "\n"

  if (index == 0)
    nodefile_string << name + ":" + ":quorum:\n"
  else
    nodefile_string << name + "::\n"
  end

end

#write them out in the current directory
File.open("hosts", 'w') { |file| file.write(hosts_string) }
File.open("nodefile", 'w') { |file| file.write(nodefile_string) }
