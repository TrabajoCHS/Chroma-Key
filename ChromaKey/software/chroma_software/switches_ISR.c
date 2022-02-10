#include "key_codes.h" 	// define los valores de KEY1, KEY2, KEY3
#include "system.h"
#include "sys/alt_irq.h"

void switches_ISR( )
{
	volatile int * slider_switch_ptr = (int *) SWITCHES_BASE;
	volatile int * chromaProcessor_ptr = (int *) AVALON_CHROMA_PROCESS_BASE;


	int valor = *(slider_switch_ptr + 3);
	*(slider_switch_ptr + 3) = 0;


	switch(valor) {
	case 1:	printf("Video\n");	*(chromaProcessor_ptr + 3) = *(slider_switch_ptr);	break;
	case 2:	printf("foto\n");	*(chromaProcessor_ptr + 3) = *(slider_switch_ptr);	break;
	case 4:	printf("sin funcion\n"); break;
	case 8:	printf("sin funcion\n"); break;
	case 16:printf("sin funcion\n"); break;
	case 32:printf("sin funcion\n"); break;
	case 64:printf("sin funcion\n"); break;
	default:printf("Sin funcion\n");break;
	}
	return;
}
