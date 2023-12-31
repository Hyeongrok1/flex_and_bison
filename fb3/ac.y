%{
    #include <stdio.h>
    #include <stdlib.h>
    #include "acfn.h"
%}

%union {
    struct ast *a;
    double d;
    struct symbol *s; 
    struct symlist *sl;
    int fn;
};

%token <d> NUMBER
%token <s> NAME
%token <fn> FUNC
%token EOL

%token IF THEN ELSE WHILE DO LET
%token FREE

%nonassoc <fn> CMP
%right '='
%left '+' '-'
%left '*' '/'
%nonassoc '|' UMINUS

%type <a> exp stmt list explist
%type <sl> symlist

%start calclist

%%

calclist: /* nothing */
 | calclist exp EOL {
    printf("= %4.4g\n", eval($2));
    treefree($2); // free
    printf("> ");
   }
 | calclist LET NAME '(' symlist ')' '=' list EOL {
    dodef($3, $5, $8); // should free this when quit
    printf("Defined %s\n> ", $3->name);
   }
 | calclist error EOL { yyerrok; printf("> "); } /* blank line or a comment */
 | calclist FREE EOL { freeall(); exit(0); }
 ;

exp: exp CMP exp { $$ = newcmp($2, $1, $3); }
 | exp '+' exp { $$ = newast('+', $1, $3); }
 | exp '-' exp { $$ = newast('-', $1, $3); }
 | exp '*' exp { $$ = newast('*', $1, $3); }
 | exp '/' exp { $$ = newast('/', $1, $3); }
 | '|' exp { $$ = newast('|', $2, NULL); }
 | '(' exp ')' { $$ = $2; }
 | '-' exp %prec UMINUS { $$ = newast('M', $2, NULL); }
 | NUMBER      { $$ = newnum($1); }
 | NAME        { $$ = newref($1); } // should free name
 | NAME '=' exp { $$ = newasgn($1, $3); } // should free 
 | FUNC '(' explist ')' { $$ = newfunc($1, $3); }
 | NAME '(' explist ')' { $$ = newcall($1, $3); }
 ;

explist: exp
 | exp ',' explist { $$ = newast('L', $1, $3); }
 ;

symlist: NAME       { $$ = newsymlist($1, NULL); }
 | NAME ',' symlist { $$ = newsymlist($1, $3); }

stmt: IF exp THEN list { $$ = newflow('I', $2, $4, NULL); }
 | IF exp THEN list ELSE list { $$ = newflow('I', $2, $4, $6); }
 | WHILE exp DO list { $$ = newflow('W', $2, $4, NULL); }
 | exp 
 ;

list: /* nothing */ { $$ = NULL; }
 | stmt ';' list { if ($3 == NULL) $$ = $1;
            else $$ = newast('L', $1, $3); 
            // $$ = $3 == NULL ? $1 : newast('L', $1, $3); 
        }
 ;
%%

