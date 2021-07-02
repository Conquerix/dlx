
; R11 -> R15 : tmp

debut:
  ori $29, $0, 
cycleA:
  sw $1, $0, 8
  addi $1, $1, 2
  subi $2, $2, 1
  jal wait
  bnez $2, cycleA

  ori $1, $0, 0
  ori $2, $0, 4800
cycleB:
  sw $1, $0, 8
  addi $1, $1, 2
  subi $2, $2, 1
  jal wait
  bnez $2, cycleB
  j debut

fin:
   j fin

wait:
  ori $10, $0, 2
  slli $10, $10, 7
  slli $10, $10, 7
  slli $10, $10, 4
jmp:
  subi $10, $10, 1
  bnez $10, jmp
  jr $31


; $28: couleur
; $29: x
; $30: y
put_on_screen:
  slli $10, $29, 1
  slli $11, $30, 7
  slli $11, $11, 1

  or $10, $10, $28
  or $10, $10, $11
  
  sw $10, $0, 8

  jr $31


