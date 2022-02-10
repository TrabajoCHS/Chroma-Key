#include "key_codes.h" 	// define los valores de KEY1, KEY2, KEY3
#include "system.h"
#include <stdio.h>
#include <stdint.h>
#include "sys/alt_irq.h"

extern volatile int image;

extern volatile int nivelRojo, nivelAzul;
typedef unsigned char byte;

void pushbutton_ISR( )
{
	volatile int * KEY_ptr = (int *) PUSHBUTTONS_BASE;
	volatile int * chromaProcessor_ptr = (int *) AVALON_CHROMA_PROCESS_BASE;
	int press;

	press = *(KEY_ptr + 3);					// lee el registro de los pulsadores
	*(KEY_ptr + 3) = 0; 					// borra la interrupci�n

	if (press & 0x2) // KEY1 ajusta el valor del umbral de diferencia GREEN - BLUE
		{
			// printf("KEY1");
			nivelAzul = nivelAzul + 10;
			if (nivelAzul >= 1000){
				nivelAzul = 150;
			}
			*(chromaProcessor_ptr + 1) = nivelAzul;
			printf("G - B: %d\n", *(chromaProcessor_ptr + 1));
		}
	else if (press & 0x4)//diferencia G/R
		{
			nivelRojo = nivelRojo + 10;
			if (nivelRojo >= 1000){
				nivelRojo = 150;
			}
			*(chromaProcessor_ptr) = nivelRojo;
			printf("G - R: %d\n", *(chromaProcessor_ptr));
		}
	else if (press & 0x8){
		readBMPFile(image);
		image++;
		if(image == 4) {
			image = 0;
		}
	}
	umbrales();
	return;
}

void readBMPFile(int x)
{
	FILE *fp;
	int offset, row, col;
	int SRAM_BASE_SIN_CACHE = (SRAM_BASE + 0x0100000 + 0x080000000);  //Activando el bit m�s significativo se elude la cache de datos
  	volatile short * pixel_buffer = (short *) SRAM_BASE_SIN_CACHE;	// MTL pixel buffer
  	char file[22];

  	sprintf(file, "/mnt/rozipfs/imagen0%d.bmp", x);
  	fp = fopen(file, "rb");
  	if (fp == (FILE *)0){
  	   printf("File opening error ocurred. Exiting program.\n");
  	}
  	for(int i=0;i<54;i++) getc(fp);  // strip out BMP header
  	for (row = 239; row >= 0; row--) {
  		for (col = 0; col <= 399; col++) {
  			offset = (row << 9) + col;
  			int r = getc(fp) >> 3;
  			int g = getc(fp) >> 2;
  			int b = getc(fp) >> 3;
  			*(pixel_buffer + offset) = (b << 11 | g << 5 | r);	//procesa mitad direcciones
  		}
  	}

  	fclose(fp);

}
