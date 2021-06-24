#include <stdlib.h>
#include <stdio.h>
#include <string.h>


#include "instructions.h"
#include "parser.h"

typedef struct {
  const char* name;
  int address;
} Label;

int n_instructions = 0, n_labels = 0, label_i;

Label* label_table = NULL;

void countInstructions(FILE* file);
int label_adress(const char* name);
char* remove_indents_and_comments(char* str);
void fillLabelTable(FILE* file);
int read_instructions(FILE* file, Instruction* list);

// parse le fichier en entier,
// ecrit n = le nombre d'instructions dans le fichier
// ecrit les instructions dans list
// retourne 0 si tout s'est bien passe
// 1 s'il y a eu une erreur
int parse(FILE* file, Instruction** list, int* n){

  // 1er passage
  countInstructions(file);

  

  // on alloue maintenant les listes
  *list = malloc(sizeof(Instruction) * n_instructions);
  *n = n_instructions;
  label_i = 0;
  
  label_table = malloc(sizeof(Label) * n_labels);

  // 2eme passage...
  fillLabelTable(file);

  printf("Table de labels (%d):\n", n_labels);
  
  for(int i = 0; i < n_labels; i++) {
    Label* l = &label_table[i];

    printf("%s:\t%d\n", l->name,l->address);
  }

  // 3eme passage...
  return read_instructions(file,*list);
}


// retourne l'adresse du label
// ou -1 so le label n'est pas repertorie
int label_adress(const char* name) {
  // parcours sequenciel


  for(int i = 0; i < n_labels; i++) {
  printf("int label_adress(const char* name='%s')::i = %d;n_label=%d\n", name, i,n_labels);
    
    Label* l = &label_table[i];

  printf("int label_adress(const char* name='%s')::l = %d\n", name, l);
  printf("COMP: '%s' ; '%s'\n", l->name, name);

    if(!strcmp(l->name, name))
      return l->address;
  }
  printf("label_adress(const char* name='%s') return = %d\n", name, -1);
  return -1;
}
void label_push_back(const char* name, int instruction_pointer) {
    char* cpy = malloc(strlen(name));
    strcpy(cpy, name);

    label_table[label_i].name = cpy,
    label_table[label_i].address = instruction_pointer,
  

    label_i++;
}

// retourne un pointeur vers le debut de la nouvelle ligne
// et modifie str pour supprimer les commentaires
char* remove_indents_and_comments(char* str) {
  char* comment = strchr(str, ';');
  
  char* begin = str;

  if(comment != NULL)   *comment = '\0';

  while(*begin == ' ' || *begin == '\t')
    begin++;
  
  return begin;
}

// parse une operande
// si str = NULL, renvoie NO_OPERAND  
// s'il s'agit d'un label, retourne l'adresse RELATIVE correspondante
op_t parse_op(char* str_op, int instruction_pointer, int line) {
  if(str_op == NULL)
    return NO_OPERAND;

  
  str_op = remove_indents_and_comments(str_op);
  char* str = str_op;
  // supprimer les eventuels espaces apres l'op
  char* s = strchr(str, ' ');
  if(s) *s = 0;

  int value = 0;
  int type = OP_IMM;

  printf("parse_op(char* str_op='%s', int instruction_pointer=%d, int line=%d);\n", str_op, instruction_pointer,line); 

  if(str[0] == '$') {
    ++str;
    type = OP_REG;
  }
  else {
    // on cherche si l'op est un label

    printf("eussouuuuuuu\n");
    int _label_address = label_adress(str);
    printf("chonklooooooo\n");

    if(_label_address != -1) {// trouve ! 
      int address = _label_address - instruction_pointer;
     
      type  = OP_VAL;
      value = address;
      return make_op(value, type, line);
    }
  }
  if(!sscanf(str, "%d", &value)) {
    fprintf(stderr, "erreur a la ligne %d: operande '%s' invalide\n", line, str_op);
    return INVALID_OPERAND;
  }

  return make_op(value, type, line);

}



// lis le fichier en entier et compte les instructions, les labels etc.
//
// 1ere etape de lecture du fichier
void countInstructions(FILE* file) {
  fseek(file, 0, SEEK_SET);
  n_instructions = 0;
  n_labels = 0;
  
  char buffer[1024];
  int line_c = 0;
  
  while(fgets(buffer, 1023, file) != NULL) {
    char* line = remove_indents_and_comments(buffer);
    
    // lire le 1er mot de la ligne
    char firstword[512];
    int n = sscanf(line, "%s", firstword);
    
    if(n <= 0) // ligne vide
      continue;

    if(firstword[strlen(firstword) - 1] == ':') {
      // label
      n_labels++;

      // il peut y avoir une instruction sur la meme ligne
      // donc on ne peut pas passer a la ligne suivante
      line = remove_indents_and_comments(line + strlen(firstword));
      n = sscanf(line, "%s", firstword);
      
      if(n <= 0) // ligne vide
        continue;
    }

    // ici, la ligne contient une instruction
    n_instructions++;
  }
}

//  2emee etape de lecture du fichier
void fillLabelTable(FILE* file) {
  fseek(file, 0, SEEK_SET);
    char buffer[1024];
  

  int instruction_pointer = 0;
  
  while(fgets(buffer, 1023, file) != NULL) {
    char* line = remove_indents_and_comments(buffer);
    
    char firstword[512];
    int n = sscanf(line, "%s", firstword);
    
    if(n <= 0) // ligne vide
      continue;

    int firstword_size = strlen(firstword);

    if(firstword[firstword_size - 1] == ':') {
      // c'est un label
      firstword[firstword_size - 1] = '\0';

      // label
      label_push_back(firstword, instruction_pointer);
      // il peut y avoir une instruction sur la meme ligne
      // donc on ne peut pas passer a la ligne suivante
      line = remove_indents_and_comments(line + strlen(firstword));
      n = sscanf(line, "%s", firstword);
      
      if(n <= 0) // ligne vide
        continue;
    }

    // ici, la ligne contient une instruction
    instruction_pointer += 4;
  }
}


int read_instructions(FILE* file, Instruction* list) {
  fseek(file, 0, SEEK_SET);
  char buffer[1024];
  int it = 0;
  int line_number = 0;

  int errors = 0;

  
  while(fgets(buffer, 1023, file) != NULL) {

    line_number++;
    
    char* line = remove_indents_and_comments(buffer);
    
    char firstword[512];
    int n = sscanf(line, "%s", firstword);

    
    if(n <= 0) // ligne vide
      continue;
  // 3eme phase : on ignore les labels
    
    if(firstword[strlen(firstword) - 1] == ':') {
      // label

      // il peut y avoir une instruction sur la meme ligne
      // donc on ne peut pas passer a la ligne suivante
      line = remove_indents_and_comments(line + strlen(firstword));
      n = sscanf(line, "%s", firstword);
      
      if(n <= 0) // ligne vide
        continue;
    }

    // ici, on a une instruction
    list[it].opname = strcpy(malloc(strlen(firstword)), firstword);
    list[it].line = line_number;

    line += strlen(firstword);
    printf("eussou5: %s\n", firstword);
    
    /// on parse a present les arguments
    op_t ops[3];

    char* token = strtok(line, ",");
    
    printf("eussou6\n");

    for(int i = 0; i < 3; i++) {
      printf("BOUCLE LIGNE 283\ttoken=%s;i=%d\n", token,i);

      // token = NULL ssi on a deja lu tous les arguments
      // donc parse_op(NULL) renvoi NO_OPERAND
      ops[i] = parse_op(token, it, line_number);


      printf("????\n");


      token = strtok(NULL, ",");
      printf("zfeerv\n");
    }

    list[it].op1 = ops[0];
    list[it].op2 = ops[1];
    list[it].op3 = ops[2];

    printf("eussou7\n");


    printf("ligne %d: %s %d %d %d\n", line_number, list[it].opname, list[it].op1, list[it].op2, list[it].op3);
    
    printf("%d\n", line_number);
    
    it++;
  }

  printf("FIN D LA FONCTION\n");

  return errors;
}
