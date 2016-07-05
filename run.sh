#!/bin/bash

file=${!#}
ext="${file##*.}"
out="${file%.*}.o"

run=1
while getopts :c opt
do
  case "$opt" in
    c)
      run=0
      ;;
    ?)
      echo "Not supported options." >&2
      exit 0
      ;;
  esac
done

if [ "$ext" == "go" ]
then
  go build -o $out $file
else
  g++ -std=c++11 $file -o $out
fi

if [ $? -ne 0 ]
then
  echo "Compile Failed!"
else
  echo "Compile Successed!"
  if [ $run -ne 0 ]
  then
    st=$(($(gdate +%s%N)/1000000))
    ./$out
    ed=$(($(gdate +%s%N)/1000000))
    echo "$ed $st" | awk '{printf "Total running time: %.5fs.\n", ($1 - $2) / 1000.0f}'
  fi
fi
