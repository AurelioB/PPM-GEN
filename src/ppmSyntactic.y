%{
	int errors = 0;
	#include 	"lex.yy.c"
	#include	"ppm.h"
	#include 	<stdio.h>
%}

%start DRAWING

%error-verbose

%token
	multi
	suma
	id
	pa
	pc
	flotante
	start 
	finish 
	set 
	canvas 
	bsize 
	color 
	black
	light_cyan
	cyan
	brown
	light_gray 
	gray 
	light_blue
	blue
	light_red
	red
	light_green
	green
	light_magenta
	magenta
	yellow
	white
	draw 
	point 
	line
	rectangle
	circle
	par_izq
	coma
	par_der

%union {
	int ival;
}

%token <ival> entero

%%

DRAWING				:	start { printf(" -- START\n"); } CANVAS_SIZE FIGURE_DEFINITION finish	{ printf(" -- FINISH \n"); }
		;

CANVAS_SIZE			:	set canvas bsize '(' entero ',' entero ')'	{ printf(" -- canvas: %i x %i \n", $5, $7); initialize($5, $7); }
		;

FIGURE_DEFINITION	:	COLOR_SETTING FIGURE_DRAWINGS |
						FIGURE_DEFINITION COLOR_SETTING FIGURE_DRAWINGS
		;

COLOR_SETTING		:	set color COLOR
		;
		
COLOR				:	black			{ printf(" -- color: %s\n", yytext); setColor(0,	0,		0	);} |
						light_cyan		{ printf(" -- color: %s\n", yytext); setColor(85,	255,	255	);} |
						cyan			{ printf(" -- color: %s\n", yytext); setColor(0,	170,	170	);} |
						brown			{ printf(" -- color: %s\n", yytext); setColor(170,	85,		0	);} |
						light_gray 		{ printf(" -- color: %s\n", yytext); setColor(170,	170,	170	);} |
						gray 			{ printf(" -- color: %s\n", yytext); setColor(85,	85,		85	);} |
						light_blue		{ printf(" -- color: %s\n", yytext); setColor(85,	85,		255	);} |
						blue			{ printf(" -- color: %s\n", yytext); setColor(0,	0,		170	);} |
						light_red		{ printf(" -- color: %s\n", yytext); setColor(255,	85,		85	);} |
						red				{ printf(" -- color: %s\n", yytext); setColor(170,	0,		0	);} |
						light_green		{ printf(" -- color: %s\n", yytext); setColor(85,	255,	85	);} |
						green			{ printf(" -- color: %s\n", yytext); setColor(0,	170,	0	);} |
						light_magenta	{ printf(" -- color: %s\n", yytext); setColor(255,	85,		255	);} |
						magenta			{ printf(" -- color: %s\n", yytext); setColor(170,	0,		170	);} |
						yellow			{ printf(" -- color: %s\n", yytext); setColor(255,	255,	85	);} |
						white			{ printf(" -- color: %s\n", yytext); setColor(255,	255,	255	);}
		;

FIGURE_DRAWINGS		:	FIGURE_DRAWING					|
						FIGURE_DRAWINGS FIGURE_DRAWING
		;

FIGURE_DRAWING		:	draw POINT_DRAWING		|
						draw LINE_DRAWING		|
						draw CIRCLE_DRAWING		|
						draw RECTANGLE_DRAWING
		;

POINT_DRAWING		:	point '(' entero ',' entero ')' { printf(" -- point: (%i, %i) \n", $3, $5); drawPoint($3, $5); }
		;
		
LINE_DRAWING		:	line '(' entero ',' entero ',' entero ',' entero ')' { printf(" -- line: (%i, %i) (%i, %i) \n", $3, $5, $7, $9); drawLine($3, $5, $7, $9); }
		;
		
CIRCLE_DRAWING		:	circle '(' entero ',' entero ',' entero ')' { printf(" -- circle: (%i, %i, %i) \n", $3, $5, $7); drawCircle($3, $5, $7); }
		;
		
RECTANGLE_DRAWING	:	rectangle '(' entero ',' entero ',' entero ',' entero ')' { printf(" -- rectangle: (%i, %i) (%i, %i) \n", $3, $5, $7, $9); drawRectangle($3, $5, $7, $9); }
		;

%%

extern int yylex();
extern int yyparse();
extern FILE *yyin;
extern int lnum;

yyerror (char *msg) {
	//puts (msg);
	
	printf(" ** SYNTAX ERROR:\n	line: %i\n	message: %s\n\n", lnum, msg);
	
	errors++;
	exit(-1);
}

yywrap() {
	return 1;
}



main (int argc, char *argv[]) {
	
	FILE *file;
	char *input;
	char *output;
	
	
	switch(argc) {
		case 3:
			input = argv[1];
			output = argv[2];
			break;
		case 2:
			input = argv[1];
			output = "output.ppm";
			break;
		case 1:
			input = "input.txt";
			output = "output.ppm";
			break;
		default:
			printf(" ** UNEXPECTED ARGUMENT NUMBER\n\n");
			exit(-1);
			break;
	}
	
	// Try to open file:
	file = fopen(input, "r");
	
	// Make sure it's a valid file:
	if (!file) {
		printf(" ** I/O ERROR: can't open input file \"%s\"\n\n", input);
		exit(-1);
	}
	// Tell flex where to read the input from
	yyin = file;

	// Parse the input until EOF
	do {
		yyparse();
	} while (!feof(yyin));
	
	// Output file only if there are no errors. Useless at this point, since we're
	// stopping execution at the moment an error is found.
	if(errors == 0) {
		toPPM(output);
	}
	fclose(file);
	
}
