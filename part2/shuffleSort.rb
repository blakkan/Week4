#!/usr/bin/ruby
##################################################################
#
# shuffleSort.rb
#
#  Just combines removes the year, and combines sorted bigrams
# to the extent they're already sorted.   It's not guaranteed
# that they'll be sorted on the input to this, but to the extent
# they are, we'll take advantage of it.
#
#  If we like, we can take multiple input files.  But we probably
# won't want to do that for this problem.
#
#  They're already sorted, so we just need to merge; much faster
#
##################################################################

Dir.chdir("/gpfs/gpfsfpo")
ARGV.each do |letter|
 puts "sorting letter #{letter}"
 system("sort -t'\t' -m #{letter}-*.alp > sorted_#{letter}.csv")
#  system("rm #{letter}.alp")

#  puts "combining #{letter}"
 system("/root/map_combiner sorted_#{letter}.csv > combined_#{letter}.csv")
#  system("rm sorted_#{letter}.csv")


end
