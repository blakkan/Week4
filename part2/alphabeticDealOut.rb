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

Dir.chdir("/gpfs/gpfsfpo")
#
# Part 1:  Re shuffle by alphabet (first character of lead word)
# all non-alpha go into file "X.alph"  (capital X)
# We'll put these in files with suffixes holding their hostnames.
#


#open all the alphabetic files for append
file_handles = {}
hostname = `hostname`.split(/\./)[0]

(Array('a'..'z') +  ['X']).each do |letter|
  file_handles[letter] = open(letter + "-" + hostname + ".alp", "a")
end

puts "dealing out"
# for each filename
Dir.glob(ARGV).each do |fn|

  next if fn == '.' || fn == '..'
  puts fn

  open(fn, "r").each do |line|

    #line.downcase!  already done
    first_char = line[0..0]
    first_char = 'X' unless file_handles.key?(first_char)
    file_handles[first_char].puts line

  end  #end of loop on all lines

  ###File.unlink(fn) #get rid of it


end

(Array('a'..'z') +  ['X']).each do |letter|
  file_handles[letter].close()
end
