#!/usr/bin/ruby
require 'dbm'

word = ARGV.first

Dir.chdir("/gpfs/gpfsfpo")

db_handles = {}
(Array('a'..'z') +  ['X']).each do |letter|
   db_handle_hash[letter] = DBM.open(letter)
end

#puts word
first_letter = word.split(//).first
first_char = line[0..0]
first_char = 'X' unless db_handles.key?(first_char)

#puts first_letter

begin
  total, list =  Marshal.load(db_handle_hash[first_letter][word])
rescue Exception => e  #just swallow them all (usually bad form)
  exit(1)
end

rv = rand(total)


running_total = 0
list.each do |item|
  running_total += item[1]
  if rv < running_total
    puts item[0]
    break
  end
end
