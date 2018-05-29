#!/usr/bin/ruby
##################################################################
#
# alphabeticDealOut.rb
#
#  Just combines removes the year, and combines sorted bigrams
# to the extent they're already sorted.   It's not guaranteed
# that they'll be sorted on the input to this, but to the extent
# they are, we'll take advantage of it.
#
#  If we like, we can take multiple input files.  But we probably
# won't want to do that for this problem.
#
##################################################################

#
# Part 1:  Re shuffle by alphabet (first character of lead word)
# all non-alpha go into file "X.alph"  (capitl X)
#

#open all the alphabetic files for append
file_handles = {}

(Array('a'..'z') +  ['X']).each do |letter|
  file_handles[letter] = open(letter + ".alp", "a")
end

puts "dealing out"
# for each filename
Dir.glob(ARGV).each do |fn|

  next if fn == '.' || fn == '..'
  puts fn

  open(fn, "r").each do |line|

    #line.downcase!  already done
    first_char = line[0]
    first_char = 'X' unless file_handles.key?(first_char)
    file_handles[first_char].puts line

  end  #end of loop on all lines


end

(Array('a'..'z') +  ['X']).each do |letter|
  file_handles[letter].close()
end

#
# Now sort them, combine them, and do final reduce
#
(Array('a'..'z') +  ['X']).each do |letter|

  puts "sorting #{letter}"
  system("sort -t'\t' #{letter}.alp > sorted_#{letter}.csv")
  system("rm #{letter}.alp")

  puts "combining #{letter}"
  system("../map_combiner sorted_#{letter}.csv > combined_#{letter}.csv")
  system("rm sorted_#{letter}.csv")


end
