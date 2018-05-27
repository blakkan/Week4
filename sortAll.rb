#!/usr/bin/ruby



##################################################################
#
#  Sorts all files given by glob, with outputs having .sor file
# namd suffix.
#
##################################################################


# for each filename
Dir.glob(ARGV).each do |fn|

  next if (fn == '.' || fn == '..')
  puts fn

  system("sort #{fn} -o #{fn.split(/\//)[-1]}.sor ")

end
