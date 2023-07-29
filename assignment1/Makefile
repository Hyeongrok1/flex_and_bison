float_cal: float_cal.l float_cal.y
	bison -d float_cal.y
	flex float_cal.l
	gcc -o $@ float_cal.tab.c lex.yy.c -lfl

clean:
	rm *.c *.h float_cal
