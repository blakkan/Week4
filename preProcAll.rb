#!/usr/bin/ruby
Dir.foreach(ARGV[0]) do |fn|
  next if fn !~ /csv$/
  fn =~ /-(\d+)\.csv$/
  nfn = $1
  puts fn
  puts nfn
  system("./mapAndCombine.rb data/#{fn} > #{ARGV[1]}/d#{$1}")
end
