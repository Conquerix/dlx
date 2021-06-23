#include <stdio.h>
#include <time.h>
#include <unistd.h>

#include "instructions.h"

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
        else if(!srtcmp(argv[i], "-x")) {
            out_hex = 1;
            --n_files;
        }
        else if(!srtcmp(argv[i], "-b")) {
            out_hex = 0;
            --n_files;
        }
    }



    if(n_files != 3)
        fprintf(stderr, "erreur: mauvaise utilisation\n"); 


/// fichier source 
    FILE* input  = fopen(argv[1], "r");

    if(!input) {
        fprintf(stderr, "%s: fichier introuvable\n");
        exit(0);
    }
}

int main(int argc, const char** argv) {
    begun_time = clock();

    checkargs(argc,argv);

/// debut de l'assemblage
    int errors = 0;

/// parsage
    Instruction* instruction_list;
    int n_instructions;


    // 0 si tout s'est bien passe
    int errors = parse(input, &instruction_list, &n_instructions);
    
    fclose(input);


    printf("parsage effectue, %d instructions lues, %d erreurs\n", n_instructions);

    if(errors)
        return 1;

// decodage et ecriture
    FILE* output;
    
    if(out_hex)   
        output = fopen(argv[2], "w+");
    else
        output = fopen(argv[2], "wb+");

    if(!result) {
        for(int i = 0; i < n_instructions; i++) {
            instruction_t instruction = convert(instruction_list[i]);
            
            if(instruction == INVALID_INSTRUCTION) {
                errors++;
            }

            fwrite(&i, 1,4, output);
            //printf("%x",i);
        }
    }
    fclose(output);

    printf("assemblage terminee (%d erreurs, %d ms)", errors, clock()-begun_time);

    return errors != 0;

}
// int parse(FILE*,Instruction** list,int*);
// *list = malloc(*n_instructions);
