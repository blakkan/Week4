#!/usr/bin/ruby
################################################3
#
# pullover.rb
#
#   First command line arguemnt - starting file number
# (zero for this problem)
#   Second command line argument - ending file number
#
#  Total files go from 0 to 99 for our problem, so we'll
# typically run this three times, once on each vs.
#
#  File names hard coded in here, could parametize for production
#
# ################################################
first, last = ARGV

system("mkdir data_#{first}_#{last}")

(first.to_i..last.to_i).each do |num|
  puts num.to_s
  num_string = num.to_s

  # pull it over
  puts "pulling image #{Time.now().to_s}"
  system("curl storage.googleapis.com/books/ngrams/books/googlebooks-eng-all-2gram-20090715-#{num_string}.csv.zip -# -o googlebooks-eng-all-2gram-20090715-#{num_string}.csv.zip")

  # unzip it
  puts "unzipping"
  system("unzip googlebooks-eng-all-2gram-20090715-#{num_string}.csv.zip")
  system("rm googlebooks-eng-all-2gram-20090715-#{num_string}.csv.zip")

  # Map and combine before downcasing (will make downcasing faster)
  puts "first map combine (prior to downcasing)"
  system("./map_combiner -m googlebooks-eng-all-2gram-20090715-#{num_string}.csv > map_precombine_#{num_string}.csv")
  system("rm googlebooks-eng-all-2gram-20090715-#{num_string}.csv")


  puts "downcasing"
  system("tr [:upper:] [:lower:] < map_precombine_#{num_string}.csv > downcase_#{num_string}.csv")
  system("rm map_precombine_#{num_string}.csv")

  puts "sorting (and puts uc/lc back together after downcasing)"
  system("sort -t'\t' downcase_#{num_string}.csv > sorted_#{num_string}.csv")
  system("rm downcase_#{num_string}.csv")

  # Do a map (basically get rid of the year and other fields, just keep tuple and count)
  # and a combine to take advantage of any preliminary sorting.
  # Note we're not guaranteed the inputs are sorted, so this is a "best efforts" combine,
  # but will greatly reduce the files size.
  puts "final combine (on fully sorted inputs)"
  system("./map_combiner sorted_#{num_string}.csv > data_#{first}_#{last}/N#{num_string}.csv")
  system("rm sorted_#{num_string}.csv")

end
