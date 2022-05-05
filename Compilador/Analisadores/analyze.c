#include "globals.h"
#include "symtab.h"
#include "analyze.h"
#include<stdbool.h>


static void typeError(TreeNode * t, char * message){ //Escreve o erro no console
    printf("ERRO SEMANTICO: %s LINHA: %d (%s)\n",t->attr.name, t->lineno, message);
    Error = TRUE;
}

static int location = 0; // variavel para contagem do local de memoria
static int tmp_param = 0; // variavel para contar os parametro das funções

// funcao recursiva para percorrer a arvore
static void traverse(TreeNode * t, void (* preProc) (TreeNode *), void (* postProc) (TreeNode *)){ 

    if (t != NULL){ 
        preProc(t);{ 
            int i;
            for (i=0; i < MAXCHILDREN; i++)
                traverse(t->child[i], preProc, postProc);
        }
        postProc(t);
        traverse(t->sibling, preProc, postProc);
    }
}

int paramCounter(TreeNode *t){ // Funcao para contar os parametros

	int tmpcount = 0;

	t = t->child[0];

	while(t != NULL){
		tmpcount++;
		t = t->sibling;
	}
	return tmpcount;
}

//funcao faz-nada (gera pre-ordem e pos-ordem)
static void nullProc(TreeNode * t){ 
    if (t==NULL) 
        return;
    else 
        return;
}

static void insertNode( TreeNode * t){ //funcao para insercao na tabela de simbolos
    
    switch (t->nodekind){ 

        case statementX:
            switch (t->kind.stmt){       
                case variableX:
                    if (st_lookup(t->attr.name, t->attr.scope) == -1 && st_lookup(t->attr.name, "global") == -1){
              
                   	if ( t->type == voidX)
                   	{
                   	typeError(t,"Declaração de variável inválida(void)");
                   	}
                   	
                   	else{
               	st_insert(t->attr.name,t->lineno,location++, t->attr.scope, "variavel", "inteiro", 0); //nova def de variavel
                    	}
                    } //variavel nao esta na tabela
                    else
                        typeError(t, "Variavel ja declarada."); 
                    break;
                
                case functionX:
                    tmp_param = paramCounter(t); //conta os parametros da funcao
                    if (st_lookup(t->attr.name, t->attr.scope) == -1 && st_lookup(t->attr.name, "global") == -1){//funcao nao esta na tabela
                        if(t->type == integerX)
                            st_insert(t->attr.name,t->lineno,location++, t->attr.scope,"funcao", "inteiro",tmp_param);//nova def func int
                        else
                            st_insert(t->attr.name,t->lineno,location++, t->attr.scope,"funcao", "void", tmp_param);//nova def func void
                    }
                    else
                        typeError(t, "Funcao ja declarada."); 
                    break;

                case callX:
                    //garante que nao ocorra erro de funcao nao declarada para a funcao output e input e verifica se as outras funcoes nao foram declaradas
                    if ((strcmp(t -> attr.name, "input") != 0 && strcmp(t -> attr.name, "output") != 0) && (st_lookup(t->attr.name, t->attr.scope) == -1 && st_lookup(t->attr.name, "global") == -1))
                        typeError(t, "Funcao nao declarada.");
                    else
                        st_insert(t->attr.name,t->lineno,location++, t->attr.scope, "chamada", "-------", paramCounter(t));//insere chamada de funcao na tabela
                    break;

                case returnX: //retorno
                    break;
                default:
                    break;
            }
            break;
      
        case expressionX:
            switch (t->kind.exp){ 
                case idX:
                    if (st_lookup(t->attr.name, t->attr.scope) == -1 && st_lookup(t->attr.name, "global") == -1) //id nao esta na tabela
                        typeError(t,"Identificador nao declarada");
                    else
                        st_insert(t->attr.name,t->lineno,0, t->attr.scope, "variavel", "inteiro", 0); //insere id na tabela
                    break;
              
                case vectorX:
                    if (st_lookup(t->attr.name, t->attr.scope) == -1 && st_lookup(t->attr.name, "global") == -1)//vetor nao esta na tabela
                        typeError(t,"Vetor nao declarado");
                    else
                        st_insert(t->attr.name,t->lineno,0, t->attr.scope, "vetor", "inteiro", 0);//insere vetor na tabela
                    break;
              
                case vectorIdX:
                    if (st_lookup(t->attr.name, t->attr.scope) == -1 && st_lookup(t->attr.name, "global") == -1)//id vetor nao esta na tabela
                        typeError(t,"Vetor nao declarado");
                    else
                        st_insert(t->attr.name,t->lineno,0, t->attr.scope, "index vetor", "inteiro", 0);//insere o id vetor na tabela
              
                case typeX:
                    break;
            
                default:
                    break;
            }
        break;
    
        default:
            break;
    }
}

bool buildSymtab(TreeNode * syntaxTree){    //cria tabela de simbolos
    traverse(syntaxTree, insertNode, nullProc); 
    if(st_lookup("main", "global") == -1)
    {
        printf("\'main\' funcao nao declarada");
        Error = TRUE; 
    }

    printSymTab();
    
    return Error;
}

static void checkNode(TreeNode * t){ // checa os tipos
    switch (t->nodekind){ 
        case expressionX:
            switch (t->kind.exp){ 
                case operationX:
                    break;
                default:
                    break;
            }
            break;

        case statementX:
            switch (t->kind.stmt){ 
                case ifX:
                    if (t->child[0]->type == integerX && t->child[1]->type == integerX) //comparacao invalida if
                        typeError(t->child[0],"\'If\' Compararacao nao Booleana");
                    break;
                
                case whileX:
                    if (t->child[0]->type == integerX && t->child[1]->type == integerX) //comparacao invalida while
                        typeError(t->child[0],"\'While\' Compararacao nao Booleana");
                    break;
                
                case assignX:
                    if (t->child[0]->type == voidX || t->child[1]->type == voidX) // Atribuir variável void
                        typeError(t->child[0],"Atribuicao invalida de dado");
                    else if(t->child[1]->kind.stmt == callX){ // Funcao retorna void
                        if(strcmp(st_lookup_tp(t->child[1]->attr.name, t->child[1]->attr.scope), "void"))
                            typeError(t->child[1],"Atribuicao invalida de dado");
                    }
                    break;
               

                case callX:
                    //erro input com parametro
                    if(strcmp(t -> attr.name, "input") == 0 && st_lookup_paramQt(t->attr.name, t->attr.scope) != 0){
                        typeError(t, "Quantidade de parametros diferente da definicao");
                    }
                    //erro output com parametro conflitante
                    else if(strcmp(t -> attr.name, "output") == 0 && st_lookup_paramQt(t->attr.name, t->attr.scope) != 1) {
                        typeError(t, "Quantidade de parametros diferente da definicao");
                    }//erro funcao com parametro diferente da declaracao
			        else if( (strcmp(t -> attr.name, "input") != 0 && strcmp(t -> attr.name, "output") != 0) && (st_lookup_paramQt(t->attr.name, t->attr.scope) != st_lookup_paramQt(t->attr.name, "global"))){
				        typeError(t, "Quantidade de parametros diferente da definicao");
			        }
		            break;
                
                default:
                    break;
            }
            break;
        
        default:
            break;
    }
}

bool typeCheck(TreeNode * syntaxTree){ // Checa os tipos na arvore de sintaxe
    traverse(syntaxTree, nullProc, checkNode);
    return Error;
}
