ac: ac.l ac.y acfn.h
	bison -d ac.y
	flex -o ac.lex.c ac.l
	gcc -o $@ ac.tab.c ac.lex.c acfn.c -lm

clean:
	rm ac.tab.* ac ac.lex.c