/************************************************************************
**
** NAME:        imageloader.c
**
** DESCRIPTION: CS61C Fall 2020 Project 1
**
** AUTHOR:      Dan Garcia  -  University of California at Berkeley
**              Copyright (C) Dan Garcia, 2020. All rights reserved.
**              Justin Yokota - Starter Code
**				YOUR NAME HERE
**
**
** DATE:        2020-08-15
**
**************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include <string.h>
#include "imageloader.h"

//Opens a .ppm P3 image file, and constructs an Image object. 
//You may find the function fscanf useful.
//Make sure that you close the file with fclose before returning.
Image *readData(char *filename) {
	FILE *fp = fopen(filename, "r");
	char buf[20];
	unsigned int cols, rows, num;
	int R, G, B;
	Image *image = (Image *)malloc(sizeof(Image));
	fscanf(fp, "%s %u %u %u", buf, &cols, &rows, &num);
	image->rows = rows, image->cols = cols;

	image->image = (Color **)malloc(sizeof(Color *) * rows);
	for (int i = 0; i < rows; ++i)
		image->image[i] = (Color *)malloc(sizeof(Color) * cols);

	for (int i = 0; i < rows; ++i)
		for (int j = 0; j < cols; ++j) {
			fscanf(fp, "%d %d %d", &R, &G, &B);
			image->image[i][j].R = R;
			image->image[i][j].G = G;
			image->image[i][j].B = B;
		}

	fclose(fp);
	return image;
}

//Given an image, prints to stdout (e.g. with printf) a .ppm P3 file with the image's data.
void writeData(Image *image) {
    if (!image) return;
    printf("P3\n");
    printf("%u %u\n", image->cols, image->rows);
    printf("255\n");

    for (int i = 0; i < image->rows; ++i) 
	    for (int j = 0; j < image->cols; ++j) {
            printf("%3d %3d %3d", image->image[i][j].R, image->image[i][j].G, image->image[i][j].B); 
            if (j != image->cols - 1) printf("   ");
            else printf("\n");
        }
}

//Frees an image
void freeImage(Image *image) {
    if (!image) return;
    for (int i = 0; i <image->rows; ++i) free(image->image[i]);
    free(image->image);
    free(image);
}
