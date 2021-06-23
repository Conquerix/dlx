#include <stdio.h>


#include "instructions.h"


void no_args() {
    printf("DLXASM 0.0.\nutilisation:\tdlxasm [entree] [sortie]\n");
    exit(0);
}

void checkargs(int argc, const char** argv);

int main(int argc, const char** argv) {
    /*
/// arguments...
    if(argc == 1)
        no_args();
    
    for(int i = 0;  i < argc; i++)
        if(!strcmp(argv[i], "-h"))
            no_args();


    if(argc != 3)
        fprintf(stderr, "erreur: mauvaise utilisation\n"); 


/// fichier source 
    FILE* input  = fopen(argv[1], "r");

    if(!input) {
        fprintf(stderr, "%s: fichier introuvable\n");
        exit(0);
    }

/// pars
    Instruction* instruction_list;
    int n_instructions;

    // 0 si tout s'est bien passe
    int result = parse(input, &instruction_list, &n_instructions);
    
    fclose(input);

    printf("parsage effectue, %d instructions lues\n", n_instructions);


    FILE* output = fopen(argv[2], "wb+");
*/
int n_instructions = 4;
Instruction instruction_list[1] = {
    {"ORI", make_op(1, OP_REG, 0), make_op(0, OP_REG), 0, make_op(10, OP_IMM, 0)},
} ;

int result = 0;
    int error = 0;

    if(!result) {
        for(int i = 0; i < n_instructions; i++) {
            instruction_t instruction = convert(instruction_list[i]);
            
            if(instruction == INVALID_INSTRUCTION) {
                
            }

            //fwrite(&i, 1,4, output);
            printf("%x",i);
        }
    }

    return 0;

}
// int parse(FILE*,Instruction** list,int*);
// *list = malloc(*n_instructions);
