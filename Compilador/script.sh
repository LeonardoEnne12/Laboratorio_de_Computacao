cd /home/leoenne/Documentos/LAB_Comp/Compilador/Analisadores
rm -f lex.yy.c parser.tab.c parser.tab.h Exec *.o *.output
flex scanner.l
bison -v -d parser.y
gcc -Wall -c *.c -O2
gcc -Wall -g -o Exec *.o -O2
./Exec
rm -f lex.yy.c parser.tab.c parser.tab.h Exec *.o 
