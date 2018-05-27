#!/usr/bin/ruby

word_as_received = ARGV.first

word = word_as_received.downcase
puts word

6.times do
  word = `../pickNextWord.rb #{word}`
  break if ($?.exitstatus != 0)
  puts word
end
