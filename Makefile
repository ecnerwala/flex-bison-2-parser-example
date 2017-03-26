all: parser.cpp lexer.cpp bc-parser.cpp
	g++ -g -std=c++1y bc-parser.cpp parser.cpp lexer.cpp -o bc-parser

parser.cpp: parser.yy
	bison --output=parser.cpp --defines=parser.h -v parser.yy

lexer.cpp: lexer.lex
	flex  --outfile=lexer.cpp --header-file=lexer.h lexer.lex

clean: 
	rm -f lexer.cpp lexer.h parser.cpp parser.h parser.output bc-parser
