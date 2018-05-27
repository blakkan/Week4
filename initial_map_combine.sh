#!/bin/bash
# do the map/combine on all the files
for filename in $1/*.csv;
do
  echo $(basename "$filename")
  ./map_combiner -m $filename > $2/$(basename "$filename")
done
