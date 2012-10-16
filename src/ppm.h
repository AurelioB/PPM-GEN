#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct
{
    int r;
    int g;
    int b;
} Pixel;

void initialize();
void toPPM();
void setColor();
void drawPoint();
void drawRectangle();
void drawLine();
void drawCircle();

int width = 0;
int height = 0;

static Pixel ppmColor;
static Pixel** ppmCanvas;

void initialize(int w, int h) {
    width = w;
    height = h;
    int x, y;
    ppmCanvas = malloc(sizeof(Pixel*) * w);
    if(ppmCanvas == NULL) {
        printf(" ** MEMORY ERROR: couldn't allocate %lo bytes", sizeof(Pixel*) * w );
        exit(-1);
    }
    setColor(255,255,255);
    for(x = 0; x < w; x++) {
        ppmCanvas[x] = malloc(sizeof(Pixel) * h);
        if(ppmCanvas[x] == NULL) {
            printf(" ** MEMORY ERROR: couldn't allocate %lo bytes", sizeof(Pixel*) * h );
            exit(-1);
        }
        for(y = 0; y < h; y++) {
            drawPoint(x,y);
        }
    }
    //setColor(0,0,0);
}

void setColor(int r, int g, int b) {
    ppmColor.r = r;
    ppmColor.g = g;
    ppmColor.b = b;
}

void drawPoint(int x, int y) {
    
    //  If the point is out of the canvas, ignore it
    if(x >= width || y >= height || x < 0 || y < 0)
        return;
    //  Assign current color to the specified coordinate
    ppmCanvas[x][y] = ppmColor;
}

void drawRectangle(int x0, int y0, int x1, int y1) {
    
    //  Empty Rectangle
    drawLine(x0, y0, x1, y0);
    drawLine(x0, y1, x1, y1);
    drawLine(x0, y0, x0, y1);
    drawLine(x1, y0, x1, y1);
    
    //  Filled Rectangle
    int x;
    for(x = x0; x <= x1; x++) {
        drawLine(x, y0, x, y1);
    }
}

void drawLine(int x0, int y0, int x1, int y1) {
    
    int dx =  abs(x1 - x0);
    int sx = (x0 < x1) ? 1 : -1;
    int dy = -abs(y1 - y0);
    int sy = (y0 < y1) ? 1 : -1;
    int err = dx+dy, e2; /* error value e_xy */
    
    for(;;){  /* loop */
        drawPoint(x0, y0);
        if (x0 == x1 && y0 == y1)
            break;
        e2 = 2*err;
        if (e2 >= dy) {
            err += dy;
            x0 += sx;
        } /* e_xy+e_x > 0 */
        if (e2 <= dx) {
            err += dx;
            y0 += sy;
        } /* e_xy+e_y < 0 */
    }
}

void drawCircle(int x0, int y0, int r)
{
    int x = -r;
    int y = 0;
    int err = 2 - 2 * r; /* II. Quadrant 2 */
    
    do {
        /* Used for empty circle */
        /*drawPoint(x0 - x, y0 + y); // Quadrant 1 
        drawPoint(x0 - y, y0 - x); // Quadrant 2 
        drawPoint(x0 + x, y0 - y); // Quadrant 3 
        drawPoint(x0 + y, y0 + x); // Quadrant 4 */
        
        /* Draw filled circle */
        drawLine(x0 + x, y0 + y,x0 - x, y0 + y);
        drawLine(x0 + x, y0 - y, x0 - x, y0 - y);
        
        r = err;
        if (r <= y)
            err += ++y * 2 + 1; /* e_xy+e_y < 0 */
        if (r > x || err > y)
            err += ++x * 2 + 1; /* e_xy+e_x > 0 or no 2nd y-step */
    } while (x < 0);
}

void toPPM(char *output) {
    FILE *fp;
    fp = fopen(output, "w");
    if (!fp) {
        printf(" ** I/O ERROR: can't open output file \"%s\"\n\n", output);
        exit(-1);
    }
    int x, y;
    Pixel *tmpPixel;
    fprintf(fp, "P3\n%d %d\n255\n", width, height);
    
    for(y = 0; y < height; y++) {
        for(x = 0; x < width; x++) {
            tmpPixel = &ppmCanvas[x][y];
            fprintf(fp, "%i %i %i   ", tmpPixel->r, tmpPixel->g, tmpPixel->b);
            //free(tmpPixel);
        }
        fprintf(fp, "\n");
    }
    free(ppmCanvas);
    
    fclose(fp);

}
