; Petit programme calculant les 10 premiers termes de fibo

debut:  ORI  $1,$0,1     ; R1 = R0 | 1  (= 1)
        OR   $2,$0,$1    ; R2 = R0 | R1 (= R1 = 1)
        ORI  $3,$0,10    ; R3 = R0 | 10 (= 10)

boucle: ADD  $4,$1,$2    ; R4 = R1 + R2
        OR   $1,$0,$2    ; R1 = R2
        OR   $2,$0,$4    ; R2 = R4
        ADDI $3,$3,-1    ; R3 = R3 + (-1)
        BNEZ $3,boucle   ; Si R3 != 0, on saute à boucle
        
fin:    J    fin         ;   Boucle inifinie à la fin

    