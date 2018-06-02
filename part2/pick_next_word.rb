#!/usr/bin/ruby
word, flag = ARGV
letter = word[0..0]

#Dir.chdir("/gpfs/gpfsfpo")

#open just one kvm store, corresponding to the initial letter

#shouldn't ssh go self; optimize this    ###TODO
#filename = `./word2filename "#{word}"`.strip

addr = %Q!ssh root@gpfs1 'grep "^#{word} " $(./word2filename #{word})'!
if (('j'..'r').include?(letter))
  addr = %Q!ssh root@gpfs2 'grep "^#{word} " $(./word2filename #{word})'!
elsif (('s'..'z').include?(letter))
  addr = %Q!ssh root@gpfs3 'grep "^#{word} " $(./word2filename #{word})'!
end

token_list = `#{addr}`.split(/\n/)

total = token_list.inject(0){|sum,line| sum + line.split(/\s+/)[2].to_i}

#puts total

rv = rand(total)
#puts rv

#
# Note we have the count of each "tail_word", not the cumulative count.
#  we could save a tiny bit of time (one addtion * length of tail_word list)
#  if we changed the data structure to save the cumulative count.
#  That could be a later improvement.
#
running_total = 0
token_list.each do |line|
  head, tail, count =  line.split(/\s+/)
  running_total += count.to_i  #TODO note the running total could probably preprocess
  #puts running_total
  if rv < running_total
    puts tail
    break
  end
end
