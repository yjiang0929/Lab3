#!/bin/bash

#Defining the constant parts of the strings throughout all calls
base="asmtest/"
post=".text.hex"
outfile="cpuout"
outfileEnd=".vcd"
call="+mem_text_fn="
callTwo=" +test_num="
callThree=" +file_out="

#Create incrementer for tests
test_num=0

#Create unique data memory instantiation
files=("bleep_vim/hanoi_func/hanoi" \
          "NINJA/fib_func/fib_func" \
          "StoreMoney/yeet" \
          "DazedAndConfused/test_1" \
          "DazedAndConfused/test_3" \
          "bleep_vim/simple/slt_test")


#Loop through the files
for i in "${files[@]}"
do
  #Combine everything into a full call
	full="$base$i$post" #Makes the first part of the call, excluding vcdout
  output="$callThree$outfile$test_num$outfileEnd" #Creates vcdout part of call
  fullcall="$call$full$callTwo$test_num$output" #puts everything together
  #Make the call
  ./cputest $fullcall
  #Print the call so you can see what they look like (commented for neatness)
  # echo $fullcall
  #Increment the test number
  test_num=$((test_num+1))
done
