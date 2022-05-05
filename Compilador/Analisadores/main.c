#include "globals.h"
#include "util.h"
#include "parse.h"
#include "analyze.h"
#include <stdio.h>

extern FILE *yyin;
int Error = FALSE;
char filename[256];
FILE *source;

int numlinha = 1;
int iniciolinha = 1;

TokenType getToken();
void Scanner();

int main(){
    FILE *f_out = fopen("outParser.output","w+");

    TreeNode * syntaxTree;
     
    char path[100];
    int flag;
    
    printf("Caminho para o .txt que vai ser utilizado: ");
        
    flag = scanf("%s",path);

    if(flag){
    	printf("\nCaminho escrito!\n");
    }
    source = fopen(path, "r");

    yyin = source;

    printf("\nCriando Arquivo de Saida do Scanner ...\n");
    Scanner();

    rewind(yyin);
    rewind(source);
    numlinha = 1;
    iniciolinha = 1;

    printf("\nGerando Arvore Sintatico...\n");
    syntaxTree = parse();
    printTree(syntaxTree,f_out);

    printf("\nConstruindo Tabela de Simbolos...\n");
    bool Err = buildSymtab(syntaxTree);
    printf("\nChecando tipos...\n");
    bool Err2 = typeCheck(syntaxTree);

    fclose(source);
    fclose(f_out);

    return 0;
}
