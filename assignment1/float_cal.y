%{
    #include <stdio.h>    
    #define YYSTYPE double // make yylval type double
%}

%token NUMBER
%token FLOAT
%token ADD SUB MUL DIV ABS
%token EOL
%token OP CP

%%

calclist:
 | calclist exp EOL { printf("= %g\n", $2); }
 | calclist EOL { }
 ;

exp: factor
 | exp ADD factor { $$ = $1 + $3; }
 | exp SUB factor { $$ = $1 - $3; }
 ;

factor: term 
 | exp MUL term { $$ = $1 * $3; }
 | exp DIV term { $$ = $1 / $3; }
 ;

term: NUMBER | FLOAT // number or float point
 | ABS term ABS { $$ = $2 >= 0 ? $2 : -$2; }
 | OP exp CP { $$ = $2;}
 ;
%%

int main(int argc, char **argv) {
    yyparse();
}

yyerror(char *s) {
    fprintf(stderr, "error: %s\n", s);
}

