ori $1, $0, bbbb
sw $1, $0, 4
lw $2, $0, 4
jr $2

ori $4, $0, 0xdead

bbbb:
	c: j c 

