
INSTRUCCIONES: COMPILACIÓN
	
	Si se desea compilar el programa, se deben ejecutar las siguientes instrucciones desde terminal:
	
		bison -yd BisonSource.y
		flex FlexSource.flex
		gcc y.tab.c -ll -o bin/ppm
		
	Si se trabaja en un sistema basado en UNIX, se provee el archivo ejecutable "build.sh" el cuál compila el programa automáticamente.
	Lo único que se debe verificar es la bandera -ll que se pasa a gcc, ya que puede variar dependiendo del sistema operativo y de la instalación de Flex. En algunos casos es necesario utilizar -lfl
	
INSTRUCCIONES: USO

	El programa al ser ejecutado intenta leer un archivo llamado "input" en el mismo directorio.
	Este archivo es procesado y evaluado de acuerdo a la gramática indicada en el documento de la práctica.
	Si se encuentra algún error en el proceso se detendrá la ejecución del programa y se indicará la linea y el tipo de error encontrado.
	Si no se encuentra ningún error en el archivo de entrada, se generará un archivo "output.ppm" con el resultado del procesamiento semántico del archivo de entrada.
	
CONSIDERACIONES:

	- Todo intento por dibujar fuera del lienzo será descartado. Si parte de una figura se encuentra tanto dentro como fuera del lienzo, tan sólo la parte que esté dentro se dibujará, descartando lo que esté fuera.
	- Las líneas y círculos son dibujados utilizando el algoritmo de Bresenham para lograr una representación más exacta.
	- El eje horizontal incrementa de izquierda a derecha.
	- El eje vertical incrementa de arriba hacia abajo.
	- Por lo tanto, el origen se encuentra en la esquina superior izquierda.
	- El tamaño máximo de la imagen creada depende de la cantidad de memoria del equipo en que se ejecuta el programa.