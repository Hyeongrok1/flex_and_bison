%{
    int chars = 0;
    int words = 0;
    int lines = 0;
%}

%%
[a-zA-Z]+ { words++; chars += strlen(yytext); } /* yytext is the string that corresponds to the pattern */
\n        { chars++; lines++; }
.         { chars++; }
%%

int main(int argc, char **argv)
{
    yylex(); /* Mathinc and working according to the pattern between %% and %% */
    printf("%8d%8d%8d\n", lines, words, chars); 
}