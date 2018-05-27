#!/usr/bin/ruby

# just put the hashes in gobal scope
$bigram_count = nil;
$lead_word_count = nil;

$bigram = nil;
$lead_word = nil;

##################################################################
#
#  Dump (generally when lead word changes); lead word should
# be invariate in here.
#
##################################################################
def dump_bigram_info_from_hash()

  cumulative_bigram_count = 0

  $bigram_count.keys.sort.each do |bigram|
    local_lead_word = bigram.split(/\s/)[0]   #shouldn't need to extract this each time
    cumulative_bigram_count += $bigram_count[bigram]
    cumulative_proportion = cumulative_bigram_count.to_f / $lead_word_count[local_lead_word].to_f
    puts sprintf("%s\t%f", bigram, cumulative_proportion )
  end

end


# for each filename
ARGV.each do |fn|



  open(fn, "r").each_with_index do |line, index|

    #puts index
#    puts line
#    puts index


    if index == 0   #easier to chedk each go-around, since each_with_index is fast

      $bigram_count = Hash.new(0);
      $lead_word_count = Hash.new(0);
      $bigram, year, count = line.split("\t");
      $lead_word = $bigram.split("\s")[0]

      $bigram_count[$bigram] = count.to_i
      $lead_word_count[$lead_word] = count.to_i

    else

      new_bigram, new_ear, new_count = line.split("\t");
      new_lead_word = new_bigram.split("\s")[0]

      if new_lead_word == $lead_word
#        puts "same lead word"
        #assume bigram changed... could optimize this out
        $bigram_count[$bigram = new_bigram] += new_count.to_i
        $lead_word_count[$lead_word] += new_count.to_i  #lead word unchanged...
      else
#        puts "saw new lead word"

        dump_bigram_info_from_hash()

        # reset hashes.   Let the garbage collector do its job,
        # Thats what we're paying it for.
        $bigram_count = Hash.new(0);
        $lead_word_count = Hash.new(0);
        $bigram, year, count = line.split("\t");
        $lead_word = $bigram.split("\s")[0]

        $bigram_count[$bigram] = count.to_i
        $lead_word_count[$lead_word] = count.to_i

      end

    end

  end  #end of loop on all lines (including first)

  # if there's anything leftover in the hash, deal with it
#  puts "doing final dump, if any"
  dump_bigram_info_from_hash()


end
