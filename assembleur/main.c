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
    printf("DLXASM 1.0\nutilisation:\tdlxasm [entree] [sortie]\n");
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



//char* printnumber(int n) {
//    static FILE* file =NULL;
//    if(!file) file = fopen("numbers.txt", "r");
//    fseek(file, 0, SEEK_SET);
//    char* ret = malloc(256);
//
//    for(int i = 0; i < n-1; i++)
//        fgets(ret, 255, file);
//    char* str = fgets(ret, 255, file);
//    char* end = strchr(str,'\n');
//    if(end) *end = 0;
//    return str;
//}

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
        fprintf(stderr, "%s: fichier introuvable\n", argv[1]);
        exit(0);
    }

    // 0 si tout s'est bien passe
    errors = parse(input, &instruction_list, &n_instructions);
    
    fclose(input);

    if(errors) {
        printf("parsage effectue, %d instructions lues, %d erreurs\n", n_instructions, errors);
        return 1;
    }



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
                fprintf(output, "%.8x\n", instruction);
            else
                fwrite(&instruction, 1,4, output);
            
        }
    }
    fclose(output);

    printf("assemblage termine (%d erreurs, %.3f ms, %d instructions lues)\n", errors, (clock()-begin_time) / 1000.f, n_instructions);

    return errors != 0;

}
// int parse(FILE*,Instruction** list,int*);
// *list = malloc(*n_instructions);
