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

require 'dbm'

Dir.chdir("/gpfs/gpfsfpo")

word = ARGV.first
letter = word[0..0]

p word
p letter

# marshel them into strings and save in dbm
the_kvs = DBM.open(letter)

p Marshal.load(the_kvs[word])
