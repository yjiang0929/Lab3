start:
addi $a0, $zero, 2
addi $a1, $zero, 4
jal second

addi $v0 $v0 10

j end

third:
add $v0, $a0, $a1
jr $ra

second:
addi  $sp, $sp, -12	# Allocate three words on stack at once for three pushes
sw    $ra, 8($sp)	# Push ra on the stack (will be overwritten by Fib function calls)
sw    $s0, 4($sp)	# Push s0 onto stack
sw    $s1, 0($sp)	# Push s1 onto stack

addi $a2, $a0, 5
jal third

lw    $s1, 0($sp)	# Pop s1 from stack
lw    $s0, 4($sp)	# Pop s0 from stack
lw    $ra, 8($sp)	# Pop ra from the stack so we can return to caller
addi  $sp, $sp, 12	# Adjust stack pointer to reflect pops

addi $v0 $v0 3 
jr $ra

end:
j end