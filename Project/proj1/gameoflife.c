/************************************************************************
**
** NAME:        gameoflife.c
**
** DESCRIPTION: CS61C Fall 2020 Project 1
**
** AUTHOR:      Justin Yokota - Starter Code
**				YOUR NAME HERE
**
**
** DATE:        2020-08-23
**
**************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include "imageloader.h"

//Determines what color the cell at the given row/col should be. This function allocates space for a new Color.
//Note that you will need to read the eight neighbors of the cell in question. The grid "wraps", so we treat the top row as adjacent to the bottom row
//and the left column as adjacent to the right column.
Color *evaluateOneCell(Image *image, int row, int col, uint32_t rule) {
    Color *color = (Color *)malloc(sizeof(Color));
    const int dirx[8] = {-1, -1, -1, 0, 0, 1, 1, 1};
    const int diry[8] = {-1, 0, 1, -1, 1, -1, 0, 1};
    for (int i = 0; i < 8; ++i) {
        int cntr = 0, cntg = 0, cntb = 0;
        for (int j = 0; j < 8; ++j) {
            int tox = (row + dirx[j] + image->rows) % image->rows,
                toy = (col + diry[j] + image->cols) % image->cols;
            if ((image->image[tox][toy].R >> i) & 0x01) ++cntr;
            if ((image->image[tox][toy].G >> i) & 0x01) ++cntg;
            if ((image->image[tox][toy].B >> i) & 0x01) ++cntb;
        }
        int posr_in_rule = ((image->image[row][col].R >> i) & 0x01) * 9 + cntr,
            posg_in_rule = ((image->image[row][col].G >> i) & 0x01) * 9 + cntg,
            posb_in_rule = ((image->image[row][col].B >> i) & 0x01) * 9 + cntb;
        color->R = color->R - (((color->R >> i) & 0x01) << i) + (((rule >> posr_in_rule) & 0x01) << i); 
        color->G = color->G - (((color->G >> i) & 0x01) << i) + (((rule >> posg_in_rule) & 0x01) << i); 
        color->B = color->B - (((color->B >> i) & 0x01) << i) + (((rule >> posb_in_rule) & 0x01) << i); 
    }
    return color;
}

//The main body of Life; given an image and a rule, computes one iteration of the Game of Life.
//You should be able to copy most of this from steganography.c
Image *life(Image *image, uint32_t rule) {
    Image *newimage = (Image *)malloc(sizeof(Image));
    newimage->rows = image->rows, newimage->cols = image->cols;
    newimage->image = (Color **)malloc(sizeof(Color *) * newimage->rows);
    for (int i = 0; i < newimage->rows; ++i) {
        newimage->image[i] = (Color *)malloc(sizeof(Color) * newimage->cols);
        for (int j = 0; j < newimage->cols; ++j) {
            Color *color = evaluateOneCell(image, i, j, rule);
            newimage->image[i][j] = *color;
            free(color);
        }
    }
    return newimage;
}

/*
Loads a .ppm from a file, computes the next iteration of the game of life, then prints to stdout the new image.

argc stores the number of arguments.
argv stores a list of arguments. Here is the expected input:
argv[0] will store the name of the program (this happens automatically).
argv[1] should contain a filename, containing a .ppm.
argv[2] should contain a hexadecimal number (such as 0x1808). Note that this will be a string.
You may find the function strtol useful for this conversion.
If the input is not correct, a malloc fails, or any other error occurs, you should exit with code -1.
Otherwise, you should return from main with code 0.
Make sure to free all memory before returning!

You may find it useful to copy the code from steganography.c, to start.
*/
int main(int argc, char **argv) {
    if (argc != 3) {
        printf("usage: %s filename\n",argv[0]);
		printf("filename is an ASCII PPM file (type P3) with maximum value 255.\n");
        printf("rule is a hex number beginning with 0x; Life is 0x1808.\n");
		exit(-1);
    }
    char *filename = argv[1];
    uint32_t rule;
    sscanf(argv[2], "0x%x", &rule);
    Image *image = readData(filename);
    Image *newimage = life(image, rule);
    writeData(newimage);
    freeImage(image);
    freeImage(newimage);
    return 0;
}
