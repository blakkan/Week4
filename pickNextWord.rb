#!/usr/bin/ruby

word_as_received = ARGV.first

word = word_as_received.downcase

first_letter = word[0]
first_letter = 'X' unless first_letter =~ /[a-z]/

exit(1) if first_letter == 'X'

table = `grep '^#{word} ' combined_#{first_letter}.csv`.split(/\n/)

#add up the thir columns
total_count = table.inject(0){|sum,x| sum + x.split(/\s+/)[2].to_i}


# We don't really need to sort again to get a pdf, and we don't need to
# make a float for a random floating point number.   Just get a rand-int
# between 0 and 1-total, and walk the (not necessarily softed list),
# subtracting the counts as you go.   When your running number is below
# zero, you've found your word.
# get a random integer
the_rand = rand(total_count)

table.each do |line|

  tuple_head_word, tuple_tail_word, count_string = line.split(/\s/)
  the_rand -= count_string.to_i
  if (the_rand < 0)
    puts tuple_tail_word
    exit(0)
  end
end

exit(1) #should not get here; internal error
