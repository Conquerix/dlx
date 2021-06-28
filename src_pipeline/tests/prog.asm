# Petit programme calculant les 10 premiers termes de fibo


ori $1, $0, 1
ori $2, $0, 2
ori $3, $0, 3
ori $4, $0, 4
ori $5, $0, 5

add $4, $2, $5


s: J s

debut:  ORI  $1,$0,1     # R1 = R0 | 1  (= 1)
        OR   $2,$0,$1    # R2 = R0 | R1 (= R1 = 1)
        ORI  $3,$0,10    # R3 = R0 | 10 (= 10)

boucle: ADD  $4,$1,$2    # R4 = R1 + R2
        OR   $1,$0,$2    # R1 = R2
        OR   $2,$0,$4    # R2 = R4
        ADDI $3,$3,-1    # R3 = R3 + (-1)
gg:     BNEZ $3,gg   # Si R3 != 0, on saute à boucle

fin:    J    fin         # Boucle inifinie à la fin
