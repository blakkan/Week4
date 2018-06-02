#!/usr/bin/ruby
##############################################
#
#  Here we turn tuples with counts into structures
# of headwords keying int a list of tail words with counts.
# (and tack on a total count at the end, just to save time later)
#
#  Note we're keeping the counts with each tail word in a list,
#  not the cumulative counts.  Could make runtime a tiny bit
#  faster if we kept cumulative counts, since one integer addition
#  could be saved while walking this list.   This could be a later
#  improvement
#
# call with a list of letters
#
##############################################

require 'daybreak'

Dir.chdir("/gpfs/gpfsfpo")


ARGV.each do |letter|
 puts "making keyValue store for letter #{letter}"

 # marshel them into strings and save in dbm
 the_kvs = Daybreak::DB.new(letter)

 head_word=nil
 running_count = 0
 running_list = []
 open("combined_#{letter}.csv", "r").each_with_index do |line, index|
   if (index % 10000 == 0)
     puts "#{index}: #{head_word}"
   end
   new_head_word, new_tail_word, new_count = line.split(/\s+/)
   if head_word.nil?  #if at start
     head_word = new_head_word
     running_count = new_count.to_i
     running_list.push([new_tail_word, new_count.to_i])

   elsif new_head_word == head_word  # by construction, tailword changed
     running_count += new_count.to_i
     running_list.push([new_tail_word,  new_count.to_i])

   else #write it
     the_kvs[head_word] = [ running_count, running_list ]
     head_word = new_head_word
     running_count = new_count.to_i
     running_list.push([new_tail_word, new_count.to_i])

   end
 end # end of loop on all lines in file

 # And output any remaiing bit
  the_kvs[head_word] = [ running_count, running_list ] #write last

  the_kvs.close

 ###TODO what about blank lines....


end  #end of loop on all letters
