all: parser.cpp lexer.cpp bc-parser.cpp parser2.cpp lexer2.cpp
	g++ -g -std=c++1y bc-parser.cpp parser.cpp lexer.cpp parser2.cpp lexer2.cpp -o bc-parser

%.cpp: %.yy
	bison --output=$*.cpp --defines=$*.h -v $*.yy

%.cpp: %.lex
	flex  --outfile=$*.cpp --header-file=$*.h $*.lex

clean: 
	rm -f lexer.cpp lexer.h parser.cpp parser.h parser.output lexer2.cpp lexer2.h parser2.cpp parser2.h parser2.output bc-parser
