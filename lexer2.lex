
%{

#include <string>
#include "parser2.h"
using std::string;
// You can put additional header files here.

%}

%option reentrant
%option noyywrap
%option never-interactive
%option prefix="zz"

int_const -?[0-9][0-9]*

whitespace   ([ \t\n]*)
%{
// Initial declarations
// In this section of the file, you can define named regular expressions.
// like int_const and whitespace above
//begin_student_code
%}
name	[a-zA-Z_][a-zA-Z0-9_]*


string_const ("\""[^\n\"]*"\"")

Operator     ([\%\/\<\>\;\!\?\*\-\+\,\.\:\[\]\(\)\{\}\=\|\&\^\$])


comment      ("//"[^\n]*)
%{
//end_student_code
%}

%%


{whitespace}   { /* skip */ }

{comment}      { /* skip */ }


{int_const}    { 
		//Rule to identify an integer constant. 
		//The return value indicates the type of token;
		//in this case T_int as defined in parser.yy.
		//The actual value of the constant is returned
		//in the intconst field of yylval (defined in the union
		//type in parser.yy).
			yylval->intconst = atoi(yytext);
			return T2_T_int;
		}

%{
// The rest of your lexical rules go here. 
// rules have the form 
// pattern action
// we have defined a few rules for you above, but you need
// to provide additional lexical rules for string constants, 
// operators, keywords and identifiers.
//begin_student_code
%}


{string_const}  {

			string*  tmp = new string(yytext);
			*tmp = tmp->substr(1, tmp->size() -2);
			yylval->strconst = tmp;
			return T2_T_string;
		}



"None" 		{ return T2_T_none; }
"true" 		{ return T2_T_true; }
"false"		{ return T2_T_false; }
"function"  { return T2_T_function; }
"functions" { return T2_T_functions; }
"constants" { return T2_T_constants; }
"parameter_count" { return T2_T_parameter_count; }
"local_vars" { return T2_T_local_vars; }
"local_ref_vars" { return T2_T_local_ref_vars; }
"names" { return T2_T_names; }
"free_vars" { return T2_T_free_vars; }
"instructions" { return T2_T_instructions; }

"load_const" { return T2_T_load_const; }
"load_func" { return T2_T_load_func; }
"load_local" { return T2_T_load_local; }
"store_local" { return T2_T_store_local; }
"load_global" { return T2_T_load_global; }
"store_global" { return T2_T_store_global; }
"push_ref"     { return T2_T_push_ref; }
"load_ref"     { return T2_T_load_ref; }
"store_ref"    { return T2_T_store_ref; }
"alloc_record" { return T2_T_alloc_record; }
"field_load"   { return T2_T_field_load; }
"field_store"  { return T2_T_field_store; }
"index_load"   { return T2_T_index_load; }
"index_store"  { return T2_T_index_store; }
"alloc_closure" { return T2_T_alloc_closure; }
"call"  { return T2_T_call; }
"return" { return T2_T_return; }
"add" { return T2_T_add; }
"sub" { return T2_T_sub; }
"mul" { return T2_T_mul; }
"div" { return T2_T_div; }
"neg" { return T2_T_neg; }
"gt" { return T2_T_gt; }
"geq" { return T2_T_geq; }
"eq" { return T2_T_eq; }
"and" { return T2_T_and; }
"or" { return T2_T_or; }
"not" { return T2_T_not; }
"goto" { return T2_T_goto; }
"if"  { return T2_T_if; }
"dup" { return T2_T_dup; }
"swap" { return T2_T_swap; }
"pop" {return T2_T_swap; }

{Operator} {  return yytext[0]; }

{name} 		{ 
			yylval->strconst = new std::string(yytext);
			return T2_T_ident;
		}

%{
//end_student_code
%}

%%

