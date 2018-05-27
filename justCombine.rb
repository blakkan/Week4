#!/usr/bin/ruby

# just put the hashes into global scope
$bigram = nil;
$count = 0;


##################################################################
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


# for each filename
ARGV.each do |fn|



  open(fn, "r").each_with_index do |line, index|

    line.downcase!


    if index == 0   #easier to check each go-around, since each_with_index is fast
                    # will do this differently when/if we re-write in c.

      $bigram, count_string = line.split("\t");
      $count = count_string.to_i


    else

      new_bigram, new_count = line.split("\t");

      if new_bigram == $bigram

        $count += new_count.to_i

      else
#        puts "saw new lead word"

        puts sprintf("%s\t%d", $bigram, $count)

        $bigram = new_bigram
        $count = new_count.to_i

      end

    end

  end  #end of loop on all lines (including first)

  # output the last item (unless we never got any data at all)
  puts sprintf("%s\t%d", $bigram, $count) unless $bigram.nil?

end
