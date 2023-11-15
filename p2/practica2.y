%{
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

extern char yylex();
void yyerror (char const*);
%}

%union{
    char element[16];
}

%locations

%token HEADER 0
%token DELIM 1
%token COMMENT 2 
%token CONTENT 3 
%token NON_VALID 4
%token <element> OPENTAG 5
%token <element> CLOSETAG 6

%type tag expr skip

%start S

%%

S : HEADER skip tag skip
    | expr error {
            yyerror("Error: No se encuentra la cabecera del archivo.");
        }
    | HEADER error {
            char err[128];
            sprintf(err, "Error en linea %d: No se encuentra etiqueta principal.", @2.first_line);
            yyerror(err);
        }
    | HEADER skip tag skip error {
            char err[128];
            sprintf(err, "Error en linea %d: No se admite contenido fuera de una pareja de etiquetas.", @5.last_line);
            yyerror(err);
        }
    | HEADER skip OPENTAG expr {
            char err[128];
            sprintf(err, "Error en linea %d: No se encuentra cierre para la etiqueta '<%s>'.",@4.last_line, $3);
            yyerror(err);
        };

skip : /*empty*/
    | skip DELIM 
    | skip COMMENT
    ;

expr : /*empty*/
    | expr tag  
    | expr DELIM  
    | expr COMMENT  
    | expr CONTENT 
    | expr NON_VALID {
            char err[128];
            sprintf(err, "Error en linea %d: Contenido no permitido.", @2.last_line);
            yyerror(err);
        };

tag : OPENTAG expr CLOSETAG {
            if (strcmp($1, $3)) {
                char err[128];
                sprintf(err, "Error en linea %d: Encontrado '</%s>', se esperaba '</%s>'.", @3.last_line, $3, $1);
                yyerror(err);
            }
        };

%%

int main() {
	if (!yyparse()) printf("Sintaxis XML correcta.\n");

	return 0;
}

void yyerror(char const *err) {
    if (strcmp(err, "syntax error")) {
        fprintf(stderr, "Sintaxis XML incorrecta. %s\n", err);
        exit(0);
    }
}