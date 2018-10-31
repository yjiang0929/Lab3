start:
addi $a0, $zero, 2
addi $a1, $zero, 4
jal second

add $v0, $v0, 2
j end

third:
add $v0, $a0, $a1
xori $a3, $a0, 1
jr $ra

second:
addi $a2, $a0, 5
j third

end:
j end