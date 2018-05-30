For part 2:

1. Get addresses

2. on each vm, run "yum install ruby"

3. copy map_combiner.c to each of gpfs1, 2, and 3
   and compile on each.

4. use pullover.rb on gpfs1 to get files 0 to 33    ONTO /gpfs/gpfsfpo
   use pullover.rb on gpfs2 to get files 34 to 66    ONTO /gpfs/gpfsfpo
   use pullover.rb on gpfs3 to get files 67 to 99    ONTO /gpfs/gpfsfpo
   (could start all up with "wait" from a master PC)

5. use alphabeticDealOut.rb on gpfs1 to generate
   files a1-z1,X1    ONTO /gpfs/gpfsfpo
   use alphabeticDealOut.rb on gpfs2 to generate
   files a2-z2,X2   ONTO /gpfs/gpfsfpo
   use alphabeticDealOut.rb on gpfs3 to generate
   files a3-z3,X3   ONTO /gpfs/gpfsfpo
   (could start all up with "wait" from a master PC)

   !!! Redo this script to not do the last portion...

6. on gpfs1, for a-i, sort/merge a1/2/3 into a (for all)   ONTO /gpfs/gpfsfpo
   on gpfs2, for j-p, sort/merge j1/2/3 into j (for all)   ONTO /gpfs/gpfsfpo
   on gpfs3, for q-z,X, cat q1/2/3 into q (for all)   ONTO /gpfs/gpfsfpo
   (could start all up with "wait" from a master PC)
   !!! Extract this from alphabeticDealOut


7. on gps1, for a-i, do final combine (for all a-i)   ONTO /gpfs/gpfsfpo
   on gps2, for j-p, do final combine (for all j-p)   ONTO /gpfs/gpfsfpo
   on gps3, for q-z,X, do final combine (for all q-z,X)   ONTO /gpfs/gpfsfpo
   (could start all up with "wait" from a master PC)

Preprocessing complete.

  Now run "pickNextWord" on gps1/2/3 depending on the
  leading letter.
