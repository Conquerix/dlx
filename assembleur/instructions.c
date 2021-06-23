#include <string.h>
#include <stdio.h>
#include <stdlib.h>

#include "instructions.h"

#define N_INSTRUCTIONS 33


typedef struct {
    const char* opname;
    enum {R,I,J} format;
    uint8_t opcode;
} Icode;

Icode itable[N_INSTRUCTIONS] =  {
    {"J",   J,0x02},
    {"JAL", J,0x03},
    {"SLL", R,0x04},
    {"SRL", R,0x06},
    {"SRA", R,0x07},
    {"ADD", R,0x20},
    {"AND", R,0x24},
    {"OR",  R,0x25},
    {"SUB", R,0x22},
    {"XOR", R,0x26},
    {"SLE", R,0x2c},
    {"SEQ", R,0x28},
    {"SNE", R,0x29},
    {"SLT", R,0x2a},
    {"SUBI",I,0x0a},
    {"SW",  I,0x2b},
    {"XORI",I,0x0e},
    {"ADDI",I,0x08},
    {"ANDI",I,0x0c},
    {"LW",  I,0x23},
    {"ORI", I,0x0d},
    {"BEQZ",I,0x04},
    {"BNEZ",I,0x05},
    {"JALR",I,0x13},
    {"JR",  I,0x12},
    {"LHI", I,0x0f},
    {"SEQI",I,0x18},
    {"SLEI",I,0x1c},
    {"SLLI",I,0x14},
    {"SLTI",I,0x1a},
    {"SNEI",I,0x19},
    {"SRAI",I,0x17},
    {"SRLI",I,0x16},
};


op_t make_op(int value, int typeflag, int line) {
    op_t op = value;
    
    switch(typeflag) {
        case OP_REG: 
            if(op > 31) {
                 fprintf(stderr, "erreur a la ligne %d: registre invalide R%d \n", line, op);
                return INVALID_OPERAND;
            }
            return MAKE_REG(op);

        case OP_IMM: 
            if(op & ~0xff != 0) {
                 fprintf(stderr, "erreur a la ligne %d: immediat %d trop grand \n", line, op);
                return INVALID_OPERAND;
            }
            return MAKE_IMM(op);
        case OP_VAL: 
            op = MAKE_VAL(op);

        default: assert(0);
    }
}


Instruction normalize(Instruction i) {
    char buffer[512];

    strncpy(buffer, i.opname, 511);
    
    for(char* ptr = buffer; *ptr != '\0'; ++ptr)
        *ptr = toupper(*ptr);

    Instruction ret = {
        .opname = buffer,
        .op1    = i.op1,
        .op2    = i.op2,
        .op3    = i.op3,
    };


    return ret;
}

Icode* find(Instruction in) {
    Instruction normalised = normalize(in);


    for(int i = 0; i <= N_INSTRUCTIONS; ++i) {
        
        Instruction* it = &itable[i];

        if(!strcmp(it->opname, normalised.opname)) {
            return &it;
        }
    }
    // instruction invalide !
    return NULL;
}

instruction_t convert(Instruction in) {
    Icode* icode = find(in);

    if(!icode) {
        fprintf(stderr, "erreur a la ligne %d: operation '%s' inconnue\n", in.line, in.opname);

        return INVALID_INSTRUCTION;
    }


    switch(icode->format) {
        case R:
            if()
    }
}
