from anytree import Node, RenderTree

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

for pre, fill, node in RenderTree(root):
    print(pre,node.name)

