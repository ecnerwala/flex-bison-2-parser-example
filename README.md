# Flex/Bison 2-parser example

Here's an example of a project with 2 flex/bison parsers. Unfortunately, flex
and bison use a ton of global variables, so we can easily get linker conflicts.
The main idea is that we can separate them by changing the prefix (yy->zz) with
either command-line options to flex/bison or options in the code
(<http://stackoverflow.com/questions/1634704/multiple-flex-bison-parsers>).

This example is built on the sample 6.035 assignment code from Spring 2017 (see
the initial commit).

## Running the code

To compile the code, just `make all` (be sure to use `g++` 5 or newer).
Then, simply run `./bc-parser` to use `parser`, and `./bc-parser "any_arg"` to
use `parser2`.

## How to convert

First, we'll directly copy `lexer.lex` and `parser.yy` to `lexer2.lex` and
`parser2.yy`. (This is actually probably overkill: two distinct parsers will
probably not have all the same tokens and stuff, so we could make more generous
assumptions.) Then, make these changes:

+ Fix some references
  - `lexer2.lex`: `#include "parser.h"` -> `#include "parser2.h"`
  - `parser2.yy`: `#include "lexer.h"` -> `#include "lexer.h"`

+ Set the `zz` prefix
  - `lexer2.lex`: insert `%option prefix="zz"`
  - `parser2.yy`: insert `%define api.prefix {zz}`
  - `bc-parser.cpp`: Use `zzparse` and whatnot instead of `yyparse`.

+ Fix various macros that were hard-coded into our `parser2.yy` file:
  - `parser2.yy`: change `#define YY_DECL` line to:
    ```
    #define YY_DECL int zzlex (ZZSTYPE* yylval, ZZLTYPE* yylloc, yyscan_t yyscanner)
    ```
    (change `yylex`, `YYSTYPE`, and `YYLTYPE`).
  - `parser2.yy`: in the `yyerror` declaration, change `YYLTYPE` to `ZZLTYPE`
  - If you really care, you should add a `#undef YY_DECL` before the define to
  prevent redefining a macro. We'll do it in `parser2.yy` but leave `parser.yy`
  unchanged.
+ `parser2.yy`: rename `safe_cast` and `safe_unsigned_cast` to `safe_cast_2` and
  `safe_unsigned_cast_2`. Instead, you could make these `static`, but you'd have
  to change the forward-declaration to only reside in the `parser.cpp` file as
  well (use `%code {}` instead of `%code requires {}`).
+ The last issue is the collision of token names, which are all in the global
  scope. We can just fix this by changing the name of half the tokens (say from
  `T_int` to `T2_int`), but for the sake of example, we'll use bison's token
  prefix system.
  - `parser2.yy`: insert `%define api.token.prefix {T2_}`
  - `lexer2.lex` (not `parser2.yy`): replace `return T_foo` with `return
                                     T2_T_foo`. We could use this prefix thing
                                     in the first place to avoid this double
                                     `T2_T_` thing.

(For more details on these steps, run `diff parser.yy parser2.yy` and
`diff lexer.lex lexer2.lex` or look at the current commit).

## Other options

I'm bet there's also a clean way to do this with namespaces or static globals,
but I'm not too sure given the proliferation of macros.

I know you can also do it with C++-style flex/bison (examples
[here](http://www.jonathanbeard.io/tutorials/FlexBisonC++),
[here](http://panthema.net/2007/flex-bison-cpp-example/),
[here](https://github.com/ezaquarii/bison-flex-cpp-example),
and some other places), though this would require a massive refactor.
