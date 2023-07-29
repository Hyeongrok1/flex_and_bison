%{
    #include "float_cal.tab.h"
    #include <stdio.h>
%}

%%
"+" { return ADD; }
"-" { return SUB; }
"*" { return MUL; }
"/" { return DIV; }
"|" { return ABS; }
[0-9]+ { sscanf(yytext, "%lf", &yylval); return NUMBER; }
[-+]?([0-9]*\.?[0-9]+|[0-9]+\.[0-9]*) { sscanf(yytext, "%lf", &yylval); return FLOAT; }
\n { return EOL; }
"(" { return OP; }
")" { return CP; }
"//".* {}
[ \t] {}
.   { printf("Mystery character %c\n", *yytext); }
%%
