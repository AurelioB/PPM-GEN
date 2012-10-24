%{
	#include "y.tab.h"
	#include <stdio.h>
	
	int lnum = 1;
%}

DIGITO				[0-9]
ENTERO				{DIGITO}+

ID					{LETRA}({LETRA}|{DIGITO})*

REAL				{ENTERO}\.{ENTERO}

BLANCO				[ \t]
BLANCOS				{BLANCO}+

NUEVA_LINEA			\n

%%

{NUEVA_LINEA}		{ ++lnum; }
{BLANCOS}			{  }

"START"				{ return( start				); }
"FINISH"			{ return( finish			); }
"SET"				{ return( set				); }
"CANVAS"			{ return( canvas			); }
"SIZE"				{ return( bsize				); }

"COLOR"				{ return( color				); }
"BLACK"				{ return( black				); }
"LIGHT_CYAN"		{ return( light_cyan		); }
"CYAN"				{ return( cyan				); }
"BROWN"				{ return( brown				); }
"LIGHT_GRAY"		{ return( light_gray		); }
"GRAY"				{ return( gray				); }
"LIGHT_BLUE"		{ return( light_blue		); }
"BLUE"				{ return( blue				); }
"LIGHT_RED"			{ return( light_red			); }
"RED"				{ return( red				); }
"LIGHT_GREEN"		{ return( light_green		); }
"GREEN"				{ return( green				); }
"LIGHT_MAGENTA"		{ return( light_magenta		); }
"MAGENTA"			{ return( magenta			); }
"YELLOW"			{ return( yellow			); }
"WHITE"				{ return( white				); }

"DRAW"				{ return( draw				); }
"POINT"				{ return( point				); }
"LINE"				{ return( line				); }
"RECTANGLE"			{ return( rectangle			); }
"CIRCLE"			{ return( circle			); }

{ENTERO}			{ yylval.ival = atoi(yytext); return(entero); }
[\(\),]				{ return yytext[0];			}


.					{ printf(" ** LEXIC ERROR:\n	line: %i\n	message: Unexpected \"%s\"\n\n", lnum, yytext); exit(-1); }

%%
