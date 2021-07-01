<<<<<<< HEAD
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
  
=======
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
; $17: switches
; $18: it ticks
; $19: temps d'attente de la balle

; $29: registre balle
; $30: it wait
; $31: addresse de retour

init0:
    jal clear7
    
    ori $8, $0, 1
    ori $15, $0,0
    ori $16, $0,0
  init1:
    jal k2000

    bnez $8, init1_L1
          ori $9, $0, 4
          J init1_L2
    init1_L1:
          ori $9, $0, 1
    init1_L2:
    jal init_ball_pos

    ori $19, $0, 200
    ori $18, $19, 0

boucle_jeu:
        jal get_inputs

        jal plateaux

        bnez $18, no_move

            ori $18, $19, 0
            jal bounce
            beqz $10, jeu_L1
            beqz $19, jeu_L1


                  subi $19, $19, 2
        jeu_L1:
            jal move_ball
            andi $29, $29, 63
            beqz $29, jeu_win
            J   jeu_L2
      no_move:
        subi $18, $18, 1
      jeu_L2:
        
        jal scores_output
        jal wait
    J boucle_jeu


jeu_win:  
      bnez $8, inc_score_2
          addi $15, $15, 1
          J inc_score_end
    inc_score_2:
          addi $16, $16, 1
    inc_score_end:
      jal scores_output
      jal leds_blink
      J init1

wait: 
      ori $30, $0, 8
      sll $30, $30, 7
      sll $30, $30, 7
      sll $30, $30, 6
    l2:
          subi $30, $30, 1
          bnez $30, l2
      jr $31


get_inputs:
    ; switches
      lw $17, $0, 0

    ; bouttons
      lw $9,  $0, 1
      andi $11, $9, 1
      andi $12, $9, 2
      andi $13, $9, 4
      andi $14, $9, 8
    jr $31

leds_blink:
    ori $1, $31, 0

    lw $10, $0, 2
    ori $9, $0, 5
  leds_blink_L1:
          sw $0,  $0, 2
; super wait
        ori $2,$0, 50
        leds_blink_L2:
              jal wait
              subi $2, $2, 1
              bnez $2, leds_blink_L2
          
          sw $10, $0, 2


; super wait
          ori $2, $0, 50
        leds_blink_L3:
              jal wait
              subi $2, $2, 1
              bnez $2, leds_blink_L3
          

      subi $9, $9, 1
      bnez $9, leds_blink_L1

  jr $1

scores_output:

  ; score gauche
      ori $10, $0, 0xffff
    ; shift de 10
      slli $10, $10, 7
      slli $10, $10, 3
    ; 
      srl $10,$10, $16


  ; score gauche
      ori $9, $0, 0xffff
      sll $9, $9, $15
      xori $9, $9, 0xffff

      or $9, $9, $10

  ; ecriture
      sw $9, $0, 2

    jr $31


;    $9: position initiale de la balle
;!!! $9 est modifie durant cette fonction !!!
init_ball_pos:
      ori  $29, $0, 1

  init_ball_pos_loop:
          beqz $9, init_ball_pos_loop_end
          subi $9, $9, 1
          slli  $29, $29, 1
          J init_ball_pos_loop
  init_ball_pos_loop_end:

      sw $29, $0, 5
      jr   $31

; x: $21
; $8: direction (1: gauche, 0: droite)
move_ball:
          beqz $8, right

       left:
             slli $29, $29, 1
             J move_ball_update
       right:
             srli $29, $29, 1

  move_ball_update:
          sw $29, $0, 5
          jr $31


; $ $9 = 0 ssi 
; retourne $10 = 1 ssi rebon
bounce:
        andi $9, $29, 1
        bnez $9, bounce_droite
        andi $9, $29, 32
        bnez $9, bounce_gauche
        ori $10, $0, 0
        jr $31
bounce_droite:
            beqz $14, bounce_return
            ori $8, $0, 1
            j bounce_return
bounce_gauche:
            beqz $12, bounce_return
            ori $8, $0, 0

      bounce_return:
            ori $10, $0, 1
            jr $31


plateaux:
          ori $9, $0, 0
          beqz $12, plateaux_2

          ori $9, $9, 2048 

    plateaux_2:
          beqz $14, plateaux_ret
          ori $9, $9, 1

    plateaux_ret:
          sw $9, $0, 4
          sw $9, $0, 6
          jr $31

  
clear7:
  ori $9, $0, 5
  ori $29, $0, 0
  
  lc7:
    subi $9, $9, 1
    sw $0, $9, 3
    bnez $9, lc7
  
  jr $31




k2000:
; addresse de retour
  ori $9, $31, 0

k2000_st:
          ori $1, $0, 1
          sw $1, $0, 2
          jal wait_k2000
          ori $1, $0, 3
          sw $1, $0, 2
          jal wait_k2000
          ori $1, $0, 7
          sw $1, $0, 2
          jal wait_k2000
          ori $1, $0, 15
          sw $1, $0, 2
          jal wait_k2000
          ori $1, $0, 31
          sw $1, $0, 2
          jal wait_k2000
          ori $1, $0, 63
          sw $1, $0, 2
          jal wait_k2000
          ori $1, $0, 126
          sw $1, $0, 2
          jal wait_k2000
          ori $1, $0, 252
          sw $1, $0, 2
          jal wait_k2000
          ori $1, $0, 504
          sw $1, $0, 2
          jal wait_k2000
          ori $1, $0, 992
          sw $1, $0, 2
          jal wait_k2000
          ori $1, $0, 960
          sw $1, $0, 2
          jal wait_k2000
          ori $1, $0, 896
          sw $1, $0, 2
          jal wait_k2000
          ori $1, $0, 768
          sw $1, $0, 2
          jal wait_k2000
          ori $1, $0, 512
          sw $1, $0, 2
          jal wait_k2000
          ori $1, $0, 512
          sw $1, $0, 2
          jal wait_k2000
          ori $1, $0, 768
          sw $1, $0, 2
          jal wait_k2000
          ori $1, $0, 896
          sw $1, $0, 2
          jal wait_k2000
          ori $1, $0, 960
          sw $1, $0, 2
          jal wait_k2000
          ori $1, $0, 992
          sw $1, $0, 2
          jal wait_k2000
          ori $1, $0, 504
          sw $1, $0, 2
          jal wait_k2000
          ori $1, $0, 252
          sw $1, $0, 2
          jal wait_k2000
          ori $1, $0, 126
          sw $1, $0, 2
          jal wait_k2000
          ori $1, $0, 63
          sw $1, $0, 2
          jal wait_k2000
          ori $1, $0, 31
          sw $1, $0, 2
          jal wait_k2000
          ori $1, $0, 15
          sw $1, $0, 2
          jal wait_k2000
          ori $1, $0, 7
          sw $1, $0, 2
          jal wait_k2000
          ori $1, $0, 3
          sw $1, $0, 2
          jal wait_k2000
          ori $1, $0, 1
          sw $1, $0, 2
          jal wait_k2000
          
      j k2000_st


          wait_k2000:
                  ori $30, $0, 2
                  sll $30, $30, 7
                  sll $30, $30, 7
                  sll $30, $30, 7
                lwk2:
                    subi $30, $30, 1
                    lw $10, $0, 1
                    bnez $10, kill_k2000

                    bnez $30, lwk2
                  jr $31
  kill_k2000:
         jr $9


>>>>>>> 12f2e78c26daa9f80217b323d2435fdb35dc6e98
