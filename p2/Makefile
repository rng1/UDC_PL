FUENTE = practica2
PRUEBAS = valido error_contenido_1 error_contenido_2 error_etiqueta_1 error_etiqueta_2 error_header
EXTENSION = .xml
CFLAGS = -Lfl -Ly

all: compile run_tests

compile:
	flex $(FUENTE).l
	bison -o $(FUENTE).tab.c $(FUENTE).y -yd
	gcc -o $(FUENTE) lex.yy.c $(FUENTE).tab.c $(CFLAGS)

run_tests:
	for prueba in $(PRUEBAS); do \
		echo "\n >> Running test: $$prueba$(EXTENSION)"; \
		./$(FUENTE) < ejemplos/$$prueba$(EXTENSION); \
		echo " <<"; \
	done

clean:
	rm $(FUENTE) lex.yy.c $(FUENTE).tab.c $(FUENTE).tab.h
