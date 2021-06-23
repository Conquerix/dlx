#ifndef INSTRUCTIION_H
#define INSTRUCTIION_H

#include <inttypes.h>

/*

J:  		 J	0x02	PC += sign_extend(value)
JAL:    	 J	0x03	R31 = PC + 4 ; PC += sign_extend(value)

SLL:    	 R	0x04	Rd = Rs1 << (Rs2 % 8)
SRL:    	 R	0x06	Rd = Rs1 >> (Rs2 % 8)
SRA:    	 R	0x07	Rd = Rs1 >>> (Rs2 % 8)

ADD:    	 R	0x20	Rd = Rs1 + Rs2
AND:    	 R	0x24	Rd = Rs1 & Rs2
OR: 		 R	0x25	Rd = Rs1 | Rs2
SUB:         R	0x22	Rd = Rs1 - Rs2
XOR:    	 R	0x26	Rd = Rs1 ^ Rs2
SLE:    	 R	0x2c	Rd = (Rs1 <= Rs2 ? 1 : 0)
SEQ:    	 R	0x28	Rd = (Rs1 == Rs2 ? 1 : 0)
SNE:    	 R	0x29	Rd = (Rs1 != Rs2 ? 1 : 0)
SLT:    	 R	0x2a	Rd = (Rs1 < Rs2 ? 1 : 0)


SUBI:   	 I	0x0a	Rd = Rs1 - sign_extend(immediate)
SW: 	     I	0x2b	MEM[Rs1 + sign_extend(immediate)] = Rd
XORI:   	 I	0x0e	Rd = Rs1 ^ extend(immediate)
ADDI:   	 I	0x08	Rd = Rs1 + sign_extend(immediate)
ANDI:   	 I	0x0c	Rd = Rs1 & extend(immediate)
LW: 	     I	0x23	Rd = MEM[Rs1 + sign_extend(immediate)]
ORI:    	 I	0x0d	Rd = Rs1 | extend(immediate)
BEQZ:   	 I	0x04	PC += (Rs1 == 0 ? sign_extend(immediate) : 0)
BNEZ:   	 I	0x05	PC += (Rs1 != 0 ? sign_extend(immediate) : 0)
JALR:   	 I	0x13	R31 = PC + 4 ; PC = Rs1
JR: 	  	 I	0x12	PC = Rs1
LHI:    	 I	0x0f	Rd = extend(immediate) << 16
SEQI:   	 I	0x18	Rd = (Rs1 == sign_extend(immediate) ? 1 : 0)
SLEI:   	 I	0x1c	Rd = (Rs1 <= sign_extend(immediate) ? 1 : 0)
SLLI:   	 I	0x14	Rd = Rs1 << (extend(immediate) % 8)
SLTI:   	 I	0x1a	Rd = (Rs1 < sign_extend(immediate) ? 1 : 0)
SNEI:   	 I	0x19	Rd = (Rs1 != sign_extend(immediate) ? 1 : 0)
SRAI:   	 I	0x17	Rd = Rs1 >>> (extend(immediate) % 8)
SRLI:   	 I	0x16	Rd = Rs1 >> (extend(immediate) % 8)





//////////////////////////////////////////

*/

typedef uint32_t instruction_t;
typedef uint32_t op_t;

typedef enum {
    ADD,ADDI,AND,ANDI,BEQZ,BNEZ,
    JI,JAL,JALR,JR,LHI,LW,OR,ORI,
    SEQ,SEQI,SLE,SLEI,SLL,SLLI,SLT,
    SLTI,SNE,SNEI,SRA,SRAI,SRL,SRLI,
    SUB,SUBI,SW,XOR,XORI,
} IType;


typedef struct { 
    const char* opname;


// op1,2,3: bit 25 a 1 ssi registre
// op1,op2,op3 = NO_OPERAND s'il n,y a pas d'operandes
// op3 = NO_OPERAND s'il n'y a que 2 operandes 
    op_t op1,op2,op3;

// juste pour affichier la ligne d'une erreur
    int line;
} Instruction;



#define NO_OPERAND (op_t)-1
#define INVALID_OPERAND (op_t)-2
#define INVALID_INSTRUCTION (instruction_t)-1

// op type flag
#define OP_REG 1
#define OP_IMM 2
#define OP_VAL 4

/** 
 * retourne l'instruction binaire 
 * ou -1 s'il y a eu une erreur
 * dans ce cas, l'erreur a déjà ete affichee a l'ecran
 */
instruction_t convert(Instruction i);

/**
 * 
 * retourne l'operande de valeur value,
 * et de type typeflag.
 * 
 * si besoin, affiche une erreur en cas de depassement
 * 
 */
op_t make_op(int value, int typeflag);



#endif // INSTRUCTIION_H
