#!/bin/bash
cp src/ppmSyntactic.y ppmSyntactic.y
cp src/ppmLexic.flex ppmLexic.flex
cp src/ppm.h ppm.h
bison -yd src/ppmSyntactic.y
flex src/ppmLexic.flex
gcc y.tab.c -ll -o bin/ppm
rm lex.yy.c
rm y.tab.c
rm y.tab.h
rm ppmSyntactic.y
rm ppmLexic.flex
rm ppm.h