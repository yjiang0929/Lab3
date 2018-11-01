start:
addi $a0 $zero 3
addi $sp $sp -4
sw $a0 0($sp)

addi $a1 $zero 6

lw $v0 0($sp)
addi $sp $sp 4
j end

end:
j end