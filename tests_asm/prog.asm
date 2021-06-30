; magique
addi $7, $0, 126

; 
; 3 -> 7: buffeur graphique
; $8:  boolean = direction droite / gauche
; $9:  tmp
; $10: tmp
; $11: bouton 1
; $12: bouton 2
; $13: bouton 3
; $14: bouton 4

; $15: score gauche
; $16: score droit

; $30: it wait
; $31: addresse de retour

init:
    ori $8, $0, 0
    ori $15, $0,0
    ori $16, $0,0

boucle_jeu:
        jal get_inputs
        jal scores_output

J boucle_jeu


wait: 
      ori $30, $0, 2
      sll $30, $30, 7
      sll $30, $30, 7
      sll $30, $30, 7
    l2:
          subi $30, $30, 1
          bnez $30, l2
      jr $31


get_inputs:
      lw $9,  $0, 1
      lw $10, $0, 0
    jr $31

scores_output:
      ori $10, 4095
      or $9, $10, $16

    jr $31

; x: $21
; $8: direction (1: gauche, 0: droite)
; $7 (return) 1 ou 2 si la balle sort du plateau
move_ball:
        lw $18, $0, 5

  
;        andi $19, $18, 1
;        bnez $19, sortie_plateau_droite
;        andi $19, $18, 2048
;        bnez $19, sortie_plateau_gauche
;
;        J test
;
;    sortie_plateau_droite:
;          ori $7, $0, 1
;          jr $31
;    sortie_plateau_gauche:
;          ori $7, $0, 2
;          jr $31
    test:
          beqz $8, right

    left:
          slli $8, $0, 1
          J move_ball_update
    right:
          slri $8, $0, 1
    move_ball_update:
          sw $18, $0, 5
          jr $31



clear7:
  ori $23, $0, 5
  
  lc7:
    subi $23, $23, 1
    sw $0, $23, 3
    bnez $3, lc7
  
  jr $31
