/*
 * test_mtl.c
 *
 *  Created on: 20 de oct. de 2021
 *      Author: jhovarne
 */
/* Ejemplo de uso de los puertos paralelos, LCD y MTL en DE2
 * Este programa realiza lo siguiente:
 * 1. Visualiza el valor de los interruptores SW en los LED rojos LEDR
 * 2. Visualiza el valor de los pulsadores KEY[3..1] en los LED verdes LEDG
 * 3. Visualiza un patr�n que va girando en los displays 7-segmentos HEX
 * 4. Al pulsar los KEY[3..1], el valor de los interruptores SW se toma como patr�n
 * 5. Escribe un mensaje en el LCD
 * 6. Escribe un mensaje en el centro de la pantalla MTL
*/

#include "system.h"
#include <stdio.h>
#include <math.h>
#include <stdlib.h>

/* Constantes BMP Files*/
#define DATA_OFFSET_OFFSET 0x000A
#define WIDTH_OFFSET 0x0012
#define HEIGHT_OFFSET 0x0016
#define BITS_PER_PIXEL_OFFSET 0x001C
#define HEADER_SIZE 14
#define INFO_HEADER_SIZE 40
#define NO_COMPRESION 0
#define MAX_NUMBER_OF_COLORS 0
#define ALL_COLORS_REQUIRED 0

typedef unsigned int int32;
typedef short int16;
typedef unsigned char byte;

/* funciones */
void LCD_cursor( int, int );
void LCD_text( char * );
void LCD_cursor_off( void );
void MTL_text (int, int, char *);
void MTL_box (int, int, int, int, byte *);
void PrintImage(const char *);

int main(void)
{
	/* Declarar los punteros a registros de I/O como volatile (volatile significa que
 	* que tanto las instrucciones de lectura como las de escritura se pueden utilizar
 	* para acceder a estas posiciones en lugar de realizar accesos a memoria
	*/
	/*volatile int * red_LED_ptr = (int *) RED_LEDS_BASE; 	// direcci�n LED rojos
	volatile int * green_LED_ptr = (int *) GREEN_LEDS_BASE; // direcci�n LED verdes
	volatile int * HEX3_HEX0_ptr = (int *) HEX3_HEX0_BASE; 	// direcci�n HEX3_HEX0
	volatile int * HEX7_HEX4_ptr = (int *) HEX4_HEX_7_BASE; 	// direcci�n HEX7_HEX4
	volatile int * SW_switch_ptr = (int *) SWITCHES_BASE; 	// direcci�n SW
	volatile int * KEY_ptr = (int *) PUSHBUTTONS_BASE; 		// direcci�n pulsadores KEY

	int HEX_bits = 0x0000000F; 								// patr�n para los display HEX
	int SW_value, KEY_value, delay_count;*/

	printf("Hola desde Nios II\n");

	/* mensaje a visualizar en la VGA y en el LCD */
	char text_top_row[40] = "Chroma Key\0";
	char text_bottom_row[40] = "Grupo 4\0";

	/* escribe el texto en el LCD */
	LCD_cursor (0,0);						// fija el cursor del LCD en la fila superior
	LCD_text (text_top_row);
	LCD_cursor (0,1);						// fija el cursor del LCD en la fila inferior
	LCD_text (text_bottom_row);
	LCD_cursor_off ();						// apaga el cursor del LCD

	PrintImage("/mnt/rozipfs/imagen02.bmp");
	//MTL_box (0, 0, 50*8-1, 30*8-1, pixels); // Pinta de Negro toda la pantalla
}

/****************************************************************************************
 * Subrutina para mover el cursor del LCD
****************************************************************************************/
void LCD_cursor(int x, int y)
{
  	volatile char * LCD_display_ptr = (char *) CHAR_LCD_BASE;	// 16x2 character display
	char instruction;

	instruction = x;
	if (y != 0) instruction |= 0x40;			// activar el bit 6 para la fila inferior
	instruction |= 0x80;						// hay que activar el bit 7 para indicar el lugar
	*(LCD_display_ptr) = instruction;			// escribe registro de instrucciones del LCD
}

/****************************************************************************************
 * Subrutina para enviar una cadena de texto al LCD
****************************************************************************************/
void LCD_text(char * text_ptr)
{
  	volatile char * LCD_display_ptr = (char *) CHAR_LCD_BASE;	// 16x2 character display

	while ( *(text_ptr) )
	{
		*(LCD_display_ptr + 1) = *(text_ptr);	// escribe los datos en el LCD
		++text_ptr;
	}
}

/****************************************************************************************
 * Subrutina para apagar el cursor del LCD
****************************************************************************************/
void LCD_cursor_off(void)
{
  	volatile char * LCD_display_ptr = (char *) CHAR_LCD_BASE;	// 16x2 character display
	*(LCD_display_ptr) = 0x0C;										// desactiva el curso del LCD
}

/****************************************************************************************
 * Subrutina para enviar una cadena de texto a la pantalla MTL
****************************************************************************************/
void MTL_text(int x, int y, char * text_ptr)
{
	int offset;
  	volatile char * character_buffer = (char *)  MTL_CHAR_BUFFER_AVALON_CHAR_BUFFER_SLAVE_BASE;	// MTL character buffer

  	/* asume que la cadena de texto comienza en la primera fila */
	offset = (y << 6) + x;
	while ( *(text_ptr) )
	{
		*(character_buffer + offset) = *(text_ptr);	// escribe en el buffer
		++text_ptr;
		++offset;
	}
}

/****************************************************************************************
 * Dibujar un rectangulo en la pantalla MTL
****************************************************************************************/
void MTL_box(int x1, int y1, int x2, int y2, byte *pixels)
{
	int i = 0;
	int offset, row, col;
	int SRAM_BASE_SIN_CACHE = (SRAM_BASE + 0x080000000 + 0x0100000);  //Activando el bit m�s significativo se elude la cache de datos
  	volatile short * pixel_buffer = (short *) SRAM_BASE_SIN_CACHE;	// MTL pixel buffer

  	/* se asume que las coordenadas del rectangulo son correctas */
	for (row = y1; row <= y2; row++)
	{
		col = x1;
		while (col <= x2)
		{
			offset = (row << 9) + col;
			*(pixel_buffer + offset) = *(pixels + i);	//procesa mitad direcciones
			++col;
			++i;
		}
	}
}
/****************************************************************************************
 * Lee un fichero bmp imagen guardando los datos de pixel, anchura, altura y bytes por pixel
****************************************************************************************/
void PrintImage(const char *fileName)
{
	FILE *imageFile = fopen(fileName, "rb");

	int offset, row, col;
	int SRAM_BASE_SIN_CACHE = (SRAM_BASE + 0x080000000 + 0x0100000);  //Activando el bit m�s significativo se elude la cache de datos
  	volatile short * pixel_buffer = (short *) SRAM_BASE_SIN_CACHE;	// MTL pixel buffer

  	/* se asume que las coordenadas del rectangulo son correctas */
  	for(int i = 0; i < 54; i++) { getc(imageFile);}
	for (row = 239; row >= 0; row--)
	{
		for(col = 0; col <= 399; col++)
		{
			offset = (row << 9) + col;
			int r, g, b;
			r = getc(imageFile) >> 3;
			g = getc(imageFile) >> 2;
			b = getc(imageFile) >> 3;
			*(pixel_buffer + offset) = (b << 11 | g << 5 | r);	//procesa mitad direcciones
		}
	}
	fclose(imageFile);
}

/*
int32 dataOffset;
fseek(imageFile, DATA_OFFSET_OFFSET, SEEK_SET);
fread(&dataOffset, 4, 1, imageFile);
fseek(imageFile, WIDTH_OFFSET, SEEK_SET);
fread(width, 4, 1, imageFile);
fseek(imageFile, HEIGHT_OFFSET, SEEK_SET);
fread(height, 4, 1, imageFile);
int16 bitsPerPixel;
fseek(imageFile, BITS_PER_PIXEL_OFFSET, SEEK_SET);
fread(&bitsPerPixel, 2, 1, imageFile);
*bytesPerPixel = ((int32)bitsPerPixel) / 8;

int paddedRowSize = (int)(4 * ceil((float)(*width) / 4.0f))*(*bytesPerPixel);
int unpaddedRowSize = (*width)*(*bytesPerPixel);
int totalSize = unpaddedRowSize*(*height);
*pixels = (byte*)malloc(totalSize);
int i = 0;
byte *currentRowPointer = *pixels+((*height-1)*unpaddedRowSize);
for (i = 0; i < *height; i++)
{
	fseek(imageFile, dataOffset+(i*paddedRowSize), SEEK_SET);
	fread(currentRowPointer, 1, unpaddedRowSize, imageFile);
	currentRowPointer -= unpaddedRowSize;
}*/
