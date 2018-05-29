For part 2:

0. on each vm, run "yum install ruby"

1. copy map_combiner.c to each of gpfs1, 2, and 3
   and compile on each.

2. use pullover.rb on gpfs1 to get files 0 to 33
   use pullover.rb on gpfs2 to get files 34 to 66
   use pullover.rb on gpfs3 to get files 67 to 99

3. use alphabeticDealOut.rb on gpfs1 to generate
   files a1-z1,X1
   use alphabeticDealOut.rb on gpfs2 to generate
   files a2-z2,X2
   use alphabeticDealOut.rb on gpfs3 to generate
   files a3-z3,X3

   !!! Redo this script to not do the last portion...

4. on gpfs1, for a-h, sort/merge a1/2/3 into a (for all)
   on gpfs2, for j-p, sort/merge j1/2/3 into j (for all)
   on gpfs3, for q-z,X, cat q1/2/3 into q (for all)

   !!! Extract this from alphabeticDealOut


5. on gps1, for a-h, do final combine (for all a-h)
   on gps2, for j-p, do final combine (for all j-p)
   on gps3, for q-z,X, do final combine (for all q-z,X)

Preprocessing complete.

  Now run "pickNextWord" on gps1/2/3 depending on the
  leading letter.
