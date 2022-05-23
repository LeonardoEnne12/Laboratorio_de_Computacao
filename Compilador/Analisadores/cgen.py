from operator import index
from anytree import Node, RenderTree

'''
This part of the code build the tree in python
'''

def _recurse_tree(pare, depth, source):
    last_line = source.readline().rstrip()

    while last_line:
        tabs = last_line.count('\t')
        if tabs < depth:
            break
            
        node_name = last_line.strip()
        if tabs >= depth:
            node = Node(node_name, parent=pare)
            last_line = _recurse_tree(node, tabs+1, source)
    
    return last_line

inFile = open("outParser.output")
last_line = inFile.readline().rstrip()
root = Node(last_line.strip())
_recurse_tree(root, 0, inFile)


''' for pre, fill, node in RenderTree(root):
    nodeParent = node.parent
    nodeChildren = node.children
    print(len(nodeChildren))
    if(len(nodeChildren)!= 0):
        nodeChild = nodeChildren[0]
        print(nodeChild.name)
    if(nodeParent != None):
        print(nodeParent.name) '''


'''
This part of the code build the code generator python
'''

nextDec = 0
label = 0
temp = 0
flag = 0
tempAux = ""
tempAux2 = ""

def newTemp():
    global temp
    temp = (temp + 1)%17

def genStatement(tree,quadList):
    name = tree.name.split()[0]
    global label
    global flag
    global temp
    global tempAux
    global tempAux2

    if name == 'If':
        if(len(tree.children) > 0):
            cGen(tree.children[0],quadList)
        arg1 = tempAux
        arg2 = f"L{label}"
        aux1 = arg2
        arg3 = "-"
        label = label + 1
        quadList.append(f"IFF {arg1} {arg2} {arg3}")

        if(len(tree.children) > 1):
            cGen(tree.children[1],quadList)
        
        if(len(tree.children) > 2):
            arg1 = f"L{label}"
            aux2 = arg1
            arg2 = "-"
            arg3 = "-"
            label = label + 1
            quadList.append(f"GOTO {arg1} {arg2} {arg3}")

        if(len(tree.children) > 2):
            arg1 = aux1
            arg2 = "-"
            arg3 = "-"
            quadList.append(f"LABEL {arg1} {arg2} {arg3}")
            cGen(tree.children[2],quadList)

        if(len(tree.children) > 2):
            arg1 = aux2
        else:
            arg1 = aux1
        
        arg2 = "-"
        arg3 = "-"
        quadList.append(f"LABEL {arg1} {arg2} {arg3}")


    elif name == 'Atribuicao':
        if(len(tree.children) > 0):
            if(tree.children[0].name.split()[0] == 'Vetor:'):
                flag = 1
            cGen(tree.children[0],quadList)
        arg1 = tempAux
        if(len(tree.children) > 1):
            cGen(tree.children[1],quadList)
        arg2 = tempAux
        arg3 = "-"
        quadList.append(f"ASSIGN {arg1} {arg2} {arg3}")

        if(flag == 2):
            arg3 = tempAux2
            flag = 0
        
        aux1 = arg1
        if(len(tree.children) > 0):
            arg1 = tree.children[0].name.split()[1]
        arg2 = aux1
        quadList.append(f"STORE {arg1} {arg2} {arg3}")

    elif name == 'While':
        arg1 = f"L{label}"
        label = label + 1
        aux1 = arg1;
        arg2 = "-"
        arg3 = "-";
        quadList.append(f"LABEL {arg1} {arg2} {arg3}")

        if(len(tree.children) > 0):
            cGen(tree.children[0],quadList)
        arg1 = tempAux
        arg2 = f"L{label}"
        label = label + 1
        aux2 = arg2;
        arg3 = "-";
        quadList.append(f"IFF {arg1} {arg2} {arg3}")
        
        if(len(tree.children) > 1):
            cGen(tree.children[1],quadList)
        arg1 = aux1
        arg2 = "-"
        arg3 = "-";
        quadList.append(f"GOTO {arg1} {arg2} {arg3}")

        arg1 = aux2
        arg2 = "-"
        arg3 = "-";
        quadList.append(f"GOTO {arg1} {arg2} {arg3}")

    elif name == 'Variavel:': #Rever essa parte 
        arg1 = tree.name.split()[1]
        arg2 = tree.name.split()[2]
        if tree.name.split()[3] == 2:
            arg3 = tree.name.split()[4]
            quadList.append(f"ALLOC {arg1} {arg2} {arg3}")
            if arg2 == "global": 
                globalSize = tree.name.split()[4]
        else:
            arg3 = "-"
            quadList.append(f"ALLOC {arg1} {arg2} {arg3}")
            if arg2 == "global":
                globalSize = 1

    elif name == 'Funcao:':
        if (tree.parent.name.split()[1] == 'inteiro'):
            arg1 = 'int'
        else:
            arg1 = 'void'
        arg2 = tree.name.split()[1]
        arg3 = '-'
        quadList.append(f"GOTO {arg1} {arg2} {arg3}")
        if(len(tree.children) > 0):
            cGen(tree.children[0],quadList)
        if(len(tree.children) > 1):    
            cGen(tree.children[1],quadList)

        arg1 = arg2
        arg2 = '-'
        arg3 = '-'
        quadList.append(f"END {arg1} {arg2} {arg3}")

    elif name == 'Chamada':
        if(len(tree.children) > 0):
            cGen(tree.children[0],quadList)

        tempAux = f"$t{temp}"
        newTemp()
        arg1 = tempAux
        arg2 = tree.name.split()[3]
        arg3 = "param counter que não sei o é"
        quadList.append(f"CALL {arg1} {arg2} {arg3}")

    elif name == 'Return':
        if(len(tree.children) > 0):
            cGen(tree.children[0],quadList)
        arg1 = tempAux
        arg2 = '-'
        arg3 = '-'
        quadList.append(f"RET {arg1} {arg2} {arg3}")
    
    elif name == 'Parametro:':
        if tree.name.split()[3] == 1:
            arg1 = "int"
        else:
            arg1 = "int[]"
        arg2 = tree.name.split()[1]
        arg3 = tree.name.split()[2]
        quadList.append(f"ARG {arg1} {arg2} {arg3}")



def genExpression(tree,quadList):
    name = tree.name.split()[0]
    global label
    global flag
    global temp
    global tempAux
    global tempAux2

    if name == 'Operacao:':
        if(len(tree.children) > 0):
            cGen(tree.children[0],quadList)
        arg2 = tempAux
        if(len(tree.children) > 1):
            cGen(tree.children[1],quadList)
        arg3 = tempAux;
        tempAux = f"$t{temp}"
        newTemp()
        arg1 = tempAux

        if tree.name.split()[-1] == '+':
            quadList.append(f"ADD {arg1} {arg2} {arg3}")
        
        elif tree.name.split()[-1] == '-':
            quadList.append(f"SUB {arg1} {arg2} {arg3}")
        
        elif tree.name.split()[-1] == '*':
            quadList.append(f"MUL {arg1} {arg2} {arg3}")
        
        elif tree.name.split()[-1] == '/':
            quadList.append(f"DIV {arg1} {arg2} {arg3}")
         
        elif tree.name.split()[-1] == '<': 
            quadList.append(f"LT {arg1} {arg2} {arg3}")
        
        elif tree.name.split()[-1] == '<=': 
            quadList.append(f"LET {arg1} {arg2} {arg3}")
        
        elif tree.name.split()[-1] == '>': 
            quadList.append(f"GT {arg1} {arg2} {arg3}")
        
        elif tree.name.split()[-1] == '>=':
            quadList.append(f"GET {arg1} {arg2} {arg3}")
        
        elif tree.name.split()[-1] == '==':
            quadList.append(f"EQ {arg1} {arg2} {arg3}")
        
        elif tree.name.split()[-1] == '!=': 
            quadList.append(f"NEQ {arg1} {arg2} {arg3}")
        

    elif name == 'Constante:':
        tempAux = f"$t{temp}"
        newTemp()
        arg1 = tempAux
        arg2 = tree.name.split()[1]
        arg3 = "-"
        quadList.append(f"LOAD {arg1} {arg2} {arg3}")
    
    elif name == 'Id:':
        tempAux = f"$t{temp}"
        newTemp()
        arg1 = tempAux
        arg2 = tree.name.split()[1]
        arg3 = "-"
        quadList.append(f"LOAD {arg1} {arg2} {arg3}")

    elif name == 'Vetor:':
        if(len(tree.children) > 0):
            cGen(tree.children[0],quadList)
        
        arg3 = tempAux
        if (flag == 1):
            tempAux2 = arg3
            flag = 2
        
        tempAux = f"$t{temp}"
        newTemp()
        arg1 = tempAux
        arg2 = tree.name.split()[1]
        quadList.append(f"LOAD {arg1} {arg2} {arg3}")

    elif name == 'Tipo:':
        if(len(tree.children) > 0):
            cGen(tree.children[0],quadList)
    
    
def cGen(tree,quadList):

    if (tree != None):
        global nextDec 
        nextDec = nextDec + 1
        name = tree.name.split()[0]
        statem = ['If','Atribuicao','While','Variavel:','Funcao:','Chamada','Return','Parametro:']
        expre = ['Operacao:','Constante:','Id:','Vetor:','Index','Tipo:']
        if name in statem:
            genStatement(tree,quadList)
        elif name in expre:
            genExpression(tree,quadList)
    
    nextDec = nextDec - 1
    if (nextDec == 0):
        if(len(tree.children) > 1):
            cGen(tree.children[1],quadList)

quadruLista = []
cGen(root,quadruLista)

for quadrupla in quadruLista:
    print(quadrupla)


#last function to work        
def quadList(tree):
    last = 0



