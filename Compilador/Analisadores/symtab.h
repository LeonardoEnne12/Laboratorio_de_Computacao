#ifndef _SYMTAB_H_
#define _SYMTAB_H_

// Insere na tabela hash na primeira vez
void st_insert( char * name, int lineno, int loc, char* scope, char* typeID, char* typeData, int paramQt);

// Procura pelo nome na tabela
int st_lookup ( char * name, char* scope );

// Print da tabela no arquivo de saida
void printSymTab();

// Procura o tipo de dado na tabela
char* st_lookup_tp(char* name, char* scope);

// Procura a quantidade de parametros da funcao declarada
int st_lookup_paramQt(char *name, char *scope);

#endif
