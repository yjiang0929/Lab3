# Simple tests

This folder consists of a few simple tests to check if the basic commands are functioning correctly.

We used these tests before running more complicated ones.

## Expected results

`branch_test`: `$v0` = 4

`jump_test`: `$v0` = 8

`simple_sl`: `$v0` = 3

`simple_test`: `$v0` = 4

`slt_test`: `$v0` = 1

`sw_test`: `$v0` = 13

## Instructions required

`branch_test`: `addi, beq, add, j`

`jump_test`: `addi, jal, add, j, xori, jr`

`simple_sl`: `addi, sw, lw, j`

`simple_test`: `addi, j`

`slt_test`: `addi, slt, j`

`sw_test`: `addi, jal, j, add, jr, sw, lw`

(all from basic subset)
