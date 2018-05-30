#!/usr/bin/ruby
##############################################
#
#  Here we turn tuples with counts into structures
# of headwords keying int a list of tail words with counts.
# (and tack on a total count at the end, just to save time later)
#
# call with a list of letters
#
##############################################

require 'dbm'

Dir.chdir("/gpfs/gpfsfpo")


ARGV.each do |letter|
 puts "making keyValue store for letter #{letter}"

 # marshel them into strings and save in dbm
 the_kvs = DBM.new(letter)

 head_word=nil
 running_count = 0
 running_list = []
 open("combined_#{letter}.csv", "r").each do |line|
   new_head_word, new_tail_word, new_count = line.split(/\s+/)
   if head_word.nil?  #if at start
     head_word = new_head_word
     running_count = new_count.to_i
     running_list.push([new_tail_word, running_count])

   elsif new_head_word == head_word_word
     running_count += new_count.to_i
     running_list.push([new_tail_word])

   else #write it
     the_kvs[head_word] = [ running_count, running_list ]
     head_word = new_head_word
     running_count = new_count.to_i
     running_count = 0
     running_list = []
   end
 end # end of loop on all lines in file

 # And output any remaiing bit
  the_kvs[head_word] = [ running_count, running_list ] #write last


 ###TODO what about blank lines....


end  #end of loop on all letters
