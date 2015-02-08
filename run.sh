#!/bin/bash

file=$1
ext="${file##*.}"
out="${file%.*}.o"

if [ "$ext" == "go" ]
then
  go build -o $out $1
else
  g++ -std=c++11 $1 -o $out
fi

if [ $? -ne 0 ]
then
  echo "Compile Failed!"
else
  echo "Compile Successed!"
  st=$(($(gdate +%s%N)/1000000))
  ./$out
  ed=$(($(gdate +%s%N)/1000000))
  echo "$ed $st" | awk '{printf "Total running time: %.5fs.\n", ($1 - $2) / 1000.0f}'
fi
