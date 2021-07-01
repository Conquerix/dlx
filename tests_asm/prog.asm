  ori $2, $0, 7633
  ori $3, $0, 7632

debut:
  ori $1, $0, 1

cycleA:
  sw $1, $0, 8
  addi $1, $1, 2
  jal wait
  sub $4, $2, $1
  bnez $4, cycleA

  ori $1, $0, 0
cycleB:
  sw $1, $0, 8
  addi $1, $1, 2
  jal wait
  sub $5, $3, $1
  bnez $5, cycleB
  j debut

wait:
  ori $10, $0, 2
  slli $10, $10, 7
  slli $10, $10, 7
  slli $10, $10, 4
jmp:
  subi $10, $10, 1
  bnez $10, jmp
  jr $31
  