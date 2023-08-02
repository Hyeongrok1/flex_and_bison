#define NHASH 9997

extern int yylineno; /* from lexer */
void yyerror(char *s, ...); /* valist: variable argument list*/
/**
 * node types
 * + - * / |
 * 0-7 comparison ops, bit coded 04 equal, 02 less, 01 greater
 * M unary minus
 * L expression or statement list
 * I IF statement
 * N symbol ref
 * = assignment
 * S list of symbols
 * F built in function call
 * C userfunction call
 * 
*/

enum bifs { 
    B_sqrt = 1,
    B_exp,
    B_log,
    B_print
};

struct fncall {   /* built-in function */
    int nodetype; /* type F */
    struct ast *l;
    enum bifs functype;
};

struct ufncall { /* user function */
    int nodetype; /* type C*/
    struct ast *l; /* list of arguments */
    struct symbol *s;
};

struct flow {
    int nodetype; /* type I or W */
    struct ast *cond; /* condition */
    struct ast *tl; /* then branch or do list */
    struct ast *el; /* optional else branch */
};

/* nodes in the abstract syntax tree */
struct ast {
    int nodetype;
    struct ast *l;
    struct ast *r;
};

struct numval {
    int nodetype;   /* type K for constant */
    double number;
};

struct symref {
    int nodetype; /* type N */
    struct symbol *s;
};

struct symasgn {
    int nodetype;   /* type = */
    struct symbol *s;
    struct ast *v; /* value */
};

/* build an AST */
struct ast *newast(int nodetype, struct ast *l, struct ast *r);
struct ast *newcmp(int cmptype, struct ast *l, struct ast *r);
struct ast *newfunc(int functype, struct ast *l);
struct ast *newcall(struct symbol *s, struct ast *l);
struct ast *newref(struct symbol *s);
struct ast *newasgn(struct symbol *s, struct ast *v);
struct ast *newnum(double d);
struct ast *newflow(int nodetype, struct ast *cond, struct ast *tl, struct ast *tr);

/* evalute an AST */
double eval(struct ast *);

/* delete and free an AST */
void treefree(struct ast *);
void freeall();

struct symbol {
    char *name;     /* variable name */
    double value;
    struct ast *func; /* stmt for the function */
    struct symlist *syms; /* list of dummy args */
};


struct symbol *lookup(char *);

struct symlist {
    struct symbol *sym;
    struct symlist *next;
};

struct symlist *newsymlist(struct symbol *sym, struct symlist *next);
void dodef(struct symbol *name, struct symlist *syms, struct ast *stmts);
void symlistfree(struct symlist *sl);

