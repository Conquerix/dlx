#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <unistd.h>
#include <string.h>

#include "instructions.h"
#include "parser.h"

// la sortie doit être ecrite en hexa et non en binaire ssi out_hex=1 
int out_hex = 1;

void no_args() {
    printf("DLXASM 0.0.\nutilisation:\tdlxasm [entree] [sortie]\n");
    exit(0);
}

void checkargs(int argc, const char** argv) {
/// arguments...
    if(argc == 1)
        no_args();
    
    int n_files = argc-1;

    for(int i = 0;  i < argc; i++) {
        if(     !strcmp(argv[i], "-h"))
            no_args();
        else if(!strcmp(argv[i], "-x")) {
            out_hex = 1;
            --n_files;
        }
        else if(!strcmp(argv[i], "-b")) {
            out_hex = 0;
            --n_files;
        }
    }



    if(n_files != 2)
        fprintf(stderr, "erreur: mauvaise utilisation\n"); 

}

int main(int argc, const char** argv) {
    clock_t begin_time = clock();

    checkargs(argc,argv);

/// debut de l'assemblage
    int errors = 0;

/// parsage
    Instruction* instruction_list;
    int n_instructions;

/// fichier source 
    FILE* input  = fopen(argv[1], "r");

    if(!input) {
        fprintf(stderr, "%s: fichier introuvable\n");
        exit(0);
    }

    // 0 si tout s'est bien passe
    errors = parse(input, &instruction_list, &n_instructions);
    
    fclose(input);


    printf("parsage effectue, %d instructions lues, %d erreurs\n", n_instructions, errors);

    printf("instructions parsees (%d):\n", n_instructions);
    for(int i = 0; i < n_instructions; i++) {
        Instruction in = instruction_list[i];
        printf("%d\t%s %d %d %d\n", in.line,in.opname,in.op1,in.op2,in.op3);
    }

    if(errors)
        return 1;

// decodage et ecriture
    FILE* output;
    
    if(out_hex)   
        output = fopen(argv[2], "w+");
    else
        output = fopen(argv[2], "wb+");

    if(!errors) {
        for(int i = 0; i < n_instructions; i++) {
            instruction_t instruction = convert(instruction_list[i]);
            
            if(instruction == INVALID_INSTRUCTION) {
                errors++;
            }
            if(out_hex)
                fprintf(output, "%.4x\n", i);
            else
                fwrite(&i, 1,4, output);
            //printf("%x",i);
        }
    }
    fclose(output);

    printf("assemblage terminee (%d erreurs, %d ms)", errors, clock()-begin_time);

    return errors != 0;

}
// int parse(FILE*,Instruction** list,int*);
// *list = malloc(*n_instructions);
