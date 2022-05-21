#include "globals.h"
#include "util.h"
#include "parse.h"
#include "analyze.h"


FILE *yyin;
FILE *source;

TreeNode *syntaxTree;
int numlinha = 1;
int iniciolinha = 1;

int Error = FALSE;

TokenType getToken();
void Scanner();

int main()
{
    char path[100];
    int flag;
    
    printf("Caminho para o .txt que vai ser utilizado: ");
        
    flag = scanf("%s",path);

    if(flag){
    	printf("\nCaminho escrito!\n");
    }
    source = fopen(path, "r");
    yyin = source;

    printf("\nCompilador C-");
    printf("\n------------------------------------------------------\n");

    printf("\nRealizando Scanner...\n");
    Scanner();

    if(!Error){
        printf("\nScanner concluido.\n");

        rewind(yyin);
        rewind(source);
        numlinha = 1;
        iniciolinha = 1;

        printf("\nGerando Arvore Sintatica...\n");
        syntaxTree = parse();
    
        if (!Error){
            printf("\nArvore Sintatica gerada com sucesso, salva em OutParser.\n");

            printf("\nConstruindo Tabela de Simbolos...\n");
            buildSymtab(syntaxTree);
            if (!Error){
                printf("\nTabela de Simbolos construida com sucesso, salva em OutAnalyze.\n");
                printf("\nChecando semantica...\n");
                typeCheck(syntaxTree);
		if (!Error){
			printf("OPA");
			FILE *f_out = fopen("outParser.output","w+");
			printTree(syntaxTree,f_out);
			fclose(f_out);
		}
                /*
                if(!Error){
                    QuadList quadList;
                    InstructionList assemblyList;

                    printf("\nCodigo semanticamente correto.\n");

                    printf("\nGerando Codigo Intermediario...\n");
                    quadList = codeGen(syntaxTree);
                    printf("\nLista de Quadruplas gerada, salva em OutQuadList.\n");

                    printf("\nGerando Codigo Assembly...\n");
                    assemblyList = assemblyGen(quadList);
                    printf("\nLista de Instrucoes Assembly geradas, salva em OutAssemblyList.\n");

                    printf("\nGerando Codigo Executavel...\n");
                    binaryGen(assemblyList);
                    printf("\nCodigo Executavel gerado, salvo em OutBinaryList.\n");

                    printf("\n------------------------------------------------------\n");
                    printf("Compilação concluída com sucesso.\n\n");
                }*/
            }
        }
    }

    fclose(source);

    return 0;
}
