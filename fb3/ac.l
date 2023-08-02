%option noyywrap nodefault yylineno
%{
    #include "acfn.h"
    #include "ac.tab.h"
%}

EXP ([Ee][-+]?[0-9]+)

%%

"+" |
"-" |
"*" |
"/" |
"|" |
"=" |
"," |
";" |
"(" |
")" { return yytext[0]; } /* return only character */

">" { yylval.fn = 1; return CMP; } /* comparison ops, all are a CMP token*/
"<" { yylval.fn = 2; return CMP; }
"<>" { yylval.fn = 3; return CMP; }
"==" { yylval.fn = 4; return CMP; }
">=" { yylval.fn = 5; return CMP; }
"<=" { yylval.fn = 6; return CMP; }

"if" { return IF; }
"then" { return THEN; }
"else" { return ELSE; }
"while" { return WHILE; }
"do" { return DO; }
"let" { return LET; }

"sqrt" { yylval.fn = B_sqrt; return FUNC; }
"exp" { yylval.fn = B_exp; return FUNC; }
"log" { yylval.fn = B_log; return FUNC; }
"print" { yylval.fn = B_print; return FUNC; }
"quit" { return FREE; }

[a-zA-Z][a-zA-Z0-9]* { yylval.s = lookup(yytext); return NAME; }

[0-9]+"."[0-9]*{EXP}? |
"."?[0-9]*{EXP}? { yylval.d = atof(yytext); return NUMBER; }

"//".* { }
[ \t] { }

\\n { printf("c> "); } /* ignore line continuation */
\n { return EOL; }
. { yyerror("Mystery character %c\n", *yytext); }

%%
