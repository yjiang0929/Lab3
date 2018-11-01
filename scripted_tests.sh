#!/bin/bash

base="asmtest/"
post=".text.hex"
files=("bleep_vim/hanoi_func/hanoi" \
          "NINJA/array_loop/array_loop" \
          "NINJA/fib_func/fib_func" \
          "StoreMoney/yeet")
test_num=0
call="+mem_text_fn="
callTwo=" +test_num="

for i in "${files[@]}"
do
	full="$base$i$post"
  fullcall="$call$full$callTwo$test_num"
  ./cputest $fullcall
  echo $fullcall
  test_num=$((test_num+1))
done
