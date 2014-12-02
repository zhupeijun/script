#!/bin/bash

file=$1
out="${file%.*}.o"
g++ -std=c++11 $1 -o $out
if [ $? -ne 0 ] 
then
  echo "Compile Failed!"
else
  st=$(($(gdate +%s%N)/1000000))
  ./$out
  ed=$(($(gdate +%s%N)/1000000))
  echo "$ed $st" | awk '{printf "Total running time: %.5fs.\n", ($1 - $2) / 1000.0f}'
fi
