	# Test 4, jouons un peu avec les sauts
	# Stress test pipeline
	# À la fin : Aucun des registres R10 à R19 et R31 ne doit contenir 0xDEAD
	# 	     + R20 = 1 et R21 = 1

debut:
	XOR	$1, $1, $1  	# R1 = 0
	ADDI	$1, $1, 1   	# R1 = 1
	BNEZ	$1, e1		# Branchement avec dépendance sur les deux dernières instructions
	ORI	$10, $0, 0xDEAD # Branchement non effectué !
	XOR	$0, $0, $0
	XOR	$0, $0, $0
	ORI	$11, $0, 0xDEAD # Si R10 != 0xDEAD, le branchement est arrivé trop tôt !

e1:	BNEZ	$1, e2		# Branchement suivant immédiatement un branchement + dépendance WB
	ORI	$12, $0, 0xDEAD # Branchement non effectué !
	XOR	$0, $0, $0
	XOR	$0, $0, $0

e2:	ORI	$31, $0, 0xDEAD
	JAL	e3
	ORI	$13, $0, 0xDEAD # Branchement non effectué (ou retour à la mauvaise adresse) !
	ORI	$20, $0, 1
	J	e4
	ORI	$14, $0, 0xDEAD # Branchement non effectué !

e3:	ADDI	$31, $31, 4	# On modifie volontairement R31 (+ dépendance)
	JR	$31		# On doit revenir deux lignes après le JAL e3 (+ dépendance)
	ORI	$15, $0, 0xDEAD # Branchement non effectué !

e4:	ADDI	$21, $0, 1

	XOR	$0, $0, $0
	XOR	$0, $0, $0
	XOR	$0, $0, $0
	XOR	$0, $0, $0
	XOR	$0, $0, $0

end:	J	end
