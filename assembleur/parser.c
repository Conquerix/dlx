#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <ctype.h>


#include "instructions.h"
#include "parser.h"

typedef struct {
  const char* name;
  int address;
} Label;

int n_instructions = 0, n_labels = 0, label_i;

Label* label_table = NULL;

void countInstructions(FILE* file);
int label_address(const char* name);
char* remove_indents_and_comments(char* str);
int fillLabelTable(FILE* file);
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

 // printf("Table de labels (%d):\n", n_labels);
 // 
 // for(int i = 0; i < n_labels; i++) {
 //   Label* l = &label_table[i];
 //
 //   printf("%s:\t%d\n", l->name,l->address);
 // }


  // 3eme passage...
  return read_instructions(file,*list);
}


// retourne l'adresse du label
// ou -1 so le label n'est pas repertorie
int label_address(const char* name) {
  // parcours sequenciel


  for(int i = 0; i < label_i; i++) {
    Label* l = &label_table[i];

    if(!strcmp(l->name, name))
      return l->address;
  }
  return -1;
}

// retourne 1 ssi il y a eu une erreur
int label_push_back(const char* name, int instruction_pointer, int line_c) {
  
    if(label_address(name) != -1) {
      fprintf(stderr, "erreur a la ligne %d: le label '%s' est deja defini\n", line_c, name);
      return 1;
    }
  

    char* cpy = malloc(strlen(name));
    strcpy(cpy, name);

    label_table[label_i].name = cpy,
    label_table[label_i].address = instruction_pointer,
  

    label_i++;

    return 0;
}

// retourne un pointeur vers le debut de la nouvelle ligne
// et modifie str pour supprimer les commentaires
char* remove_indents_and_comments(char* str) {
  char* end = strchr(str, ';');
  
  char* begin = str;

  if(end != NULL)   *end = '\0';
  
  end = strchr(str, '\n');

  if(end != NULL)   *end = '\0';

  end = strchr(str, '#');

  if(end != NULL)   *end = '\0';

  while(*begin == ' ' || *begin == '\t')
    begin++;

  end = str + strlen(str) - 1;
  char* _end = end;
  while(*end == ' ' || *end == '\t' && end > begin)
    end--;

  if(end != _end)  
    *(end+1) = '\0';
  
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
  s = strchr(str, '\t');
  if(s) *s = 0;

  int value = 0;
  int type = OP_IMM;

  if(str[0] == '$') {
    ++str;
    type = OP_REG;
  }
  else {
    // on cherche si l'op est un label
    int _label_address = label_address(str);

    if(_label_address != -1) {// trouve ! 
      int address = _label_address - instruction_pointer;
     
      type  = OP_VAL;
      value = address;
      return make_op(value, type, line);
    }
  }

  const char* format = "%d";

  if(strlen(str) > 2 && str[0] == '0' && tolower(str[1]) == 'x') {
    format = "%x";
    str += 2;
  }

  if(!sscanf(str, format, &value)) {
    fprintf(stderr, "erreur a la ligne %d: operande '%s' invalide\n", line, str_op);
    return INVALID_OPERAND;
  }
  op_t op = make_op(value, type, line);
  return op;

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
    
    line_c++;
    char* line = remove_indents_and_comments(buffer);

    
    // lire le 1er mot de la ligne
    char firstword[512];
    int n = sscanf(line, "%s", firstword);
    
    if(n <= 0) // ligne vide
      continue;

    char* ptr = strchr(firstword, ':');

    if(ptr != NULL) {
      // label
      n_labels++;

      line = remove_indents_and_comments(line + strlen(firstword) - strlen(ptr) + 1);
      



      // il peut y avoir une instruction sur la meme ligne
      // donc on ne peut pas passer a la ligne suivante
      n = sscanf(line, "%s", firstword);
      
      if(n <= 0) // ligne vide
        continue;
    }

    // ici, la ligne contient une instruction
    n_instructions++;
  }
}

//  2emee etape de lecture du fichier
// retourn le nombre d'erreurs
int fillLabelTable(FILE* file) {
  fseek(file, 0, SEEK_SET);
    char buffer[1024];
  
  int errors = 0;

  int instruction_pointer = 0;
  int line_c = 0;
  
  while(fgets(buffer, 1023, file) != NULL) {
    line_c++;

    char* line = remove_indents_and_comments(buffer);
    
    char firstword[512];
    int n = sscanf(line, "%s", firstword);
    
    if(n <= 0) // ligne vide
      continue;



    char* ptr = strchr(firstword, ':');

    if(ptr != NULL) {
      // label
      n_labels++;


      // c'est un label
      *ptr = '\0';

      // label
      errors += label_push_back(firstword, instruction_pointer, line_c);
      // il peut y avoir une instruction sur la meme ligne
      // donc on ne peut pas passer a la ligne suivante
      line = remove_indents_and_comments(line + strlen(firstword) + 1);


      n = sscanf(line, "%s", firstword);
 
      if(n <= 0) // ligne vide
        continue;
    }

    // ici, la ligne contient une instruction
    instruction_pointer += 4;
  }

  return errors;
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
    
    char* ptr = strchr(firstword, ':');

    if(ptr != NULL) {
      // label

      // il peut y avoir une instruction sur la meme ligne
      // donc on ne peut pas passer a la ligne suivante
      line = remove_indents_and_comments(line + strlen(firstword) - strlen(ptr) + 1);
      n = sscanf(line, "%s", firstword);
      
      if(n <= 0) // ligne vide
        continue;
    }

    // ici, on a une instruction
    list[it].opname = strcpy(malloc(strlen(firstword)), firstword);
    list[it].line = line_number;

    line += strlen(firstword);
    
    /// on parse a present les arguments
    op_t ops[3];

    char* token = strtok(line, ",");

    for(int i = 0; i < 3; i++) {

      // token = NULL ssi on a deja lu tous les arguments
      // donc parse_op(NULL) renvoi NO_OPERAND
      ops[i] = parse_op(token, 4*it, line_number);

      if(ops[i] == INVALID_OPERAND)
        errors++; 


      token = strtok(NULL, ",");
    }

    list[it].op1 = ops[0];
    list[it].op2 = ops[1];
    list[it].op3 = ops[2];
    
    it++;
  }
  return errors;
}
