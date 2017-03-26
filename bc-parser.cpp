
#include "parser.h"
#include "lexer.h"
#include "parser2.h"
#include "lexer2.h"
#include <iostream>
#include "prettyprinter.h"

using namespace std;

int main(int argc, char** argv)
{
  Function* output;
  if (argc == 1) {
    cout<<"Using parser"<<endl;
    void* scanner;
    yylex_init(&scanner);
    yyset_in(stdin, scanner);

    int rvalue = yyparse(scanner, output);
    if(rvalue == 1){

      cout<<"Parsing failed"<<endl;
      return 1;
    }
  } else {
    void* scanner;
    cout<<"Using parser2"<<endl;
    yylex_init(&scanner);
    yyset_in(stdin, scanner);

    int rvalue = yyparse(scanner, output);
    if(rvalue == 1){

      cout<<"Parsing failed"<<endl;
      return 1;
    }
  }

  std::shared_ptr<Function> func(output);

  PrettyPrinter printer;

  printer.print(*func, std::cout);

  return 0;
}
