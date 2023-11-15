%{
#include <string.h>
#include "practica2.tab.h"
%}

delim       [ \t\n]+
quote       \"|\'
eq          {delim}?={delim}?

comment     <!--(-?[^-])*-->
element     [a-zA-Z:_][0-9a-zA-Z:_\-.]*
entity      &{element};
content     ([^<&\n]|{entity})*

openTag     <{element}{delim}?>
closeTag    <\/{element}{delim}?>

version     {delim}version{eq}{quote}1.[0-9]+{quote}
encoding    {delim}encoding{eq}{quote}[A-Za-z]([A-Za-z0-9._]|-)*{quote}
header      <\?xml{version}{encoding}?{delim}?\?>

%%
{header} { return HEADER; }
{comment} { return COMMENT; }
{content} { return CONTENT; }

{openTag} {
    yylval.element[0] = '\0';

    strncpy(yylval.element, yytext + 1, yyleng - 2);
    yylval.element[yyleng - 2] = '\0';

    return OPENTAG;
}

{closeTag} {
    yylval.element[0] = '\0';
    
    strncpy(yylval.element, yytext + 2, yyleng - 3);
    yylval.element[yyleng - 3] = '\0';
    
    return CLOSETAG;
}

{delim}      {
    for (int i = 0; i < yyleng; i++)
        yylloc.last_line += (yytext[i] == '\n');

    return DELIM;
}

. { return NON_VALID; }
%%

int yywrap() { return 1; }
