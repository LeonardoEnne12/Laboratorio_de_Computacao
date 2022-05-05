#ifndef _ANALYZE_H_
#define _ANALYZE_H_
#include<stdbool.h>

bool buildSymtab(TreeNode *); // Cria tabela de simbolos

bool typeCheck(TreeNode *);  // Checa os tipos na arvore de sintaxe

#endif
