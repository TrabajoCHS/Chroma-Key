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

/* funciones */
void LCD_cursor( int, int );
void LCD_text( char * );
void LCD_cursor_off( void );
void MTL_text (int, int, char *);
void MTL_box (int, int, int, int, short);

int main(void)
{
	/* Declarar los punteros a registros de I/O como volatile (volatile significa que
 	* que tanto las instrucciones de lectura como las de escritura se pueden utilizar
 	* para acceder a estas posiciones en lugar de realizar accesos a memoria
	*/

	/* mensaje a visualizar en la VGA y en el LCD */
	char text_top_row[40] = "Proyecto Chroma Key";
	char text_bottom_row[40] = "Grupo de la muerte";

	/* escribe el texto en el LCD */
	LCD_cursor (0,0);						// fija el cursor del LCD en la fila superior
	LCD_text (text_top_row);
	LCD_cursor (0,1);						// fija el cursor del LCD en la fila inferior
	LCD_text (text_bottom_row);
	LCD_cursor_off ();						// apaga el cursor del LCD


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
void MTL_box(int x1, int y1, int x2, int y2, short pixel_color)
{
	int offset, row, col;
	int SRAM_BASE_SIN_CACHE = (SRAM_BASE + 0x080000000);  //Activando el bit m�s significativo se elude la cache de datos
  	volatile short * pixel_buffer = (short *) SRAM_BASE_SIN_CACHE;	// MTL pixel buffer

  	/* se asume que las coordenadas del rectangulo son correctas */
	for (row = y1; row <= y2; row++)
	{
		col = x1;
		while (col <= x2)
		{
			offset = (row << 9) + col;
			*(pixel_buffer + offset) = pixel_color;	//procesa mitad direcciones
			++col;
		}
	}
}




