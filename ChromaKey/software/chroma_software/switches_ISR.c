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
	case 1:
		printf("Video Enabled\n");
		*(chromaProcessor_ptr + 3) = *(slider_switch_ptr);

		break;
	case 2:
		printf("Image Enabled\n");
		*(chromaProcessor_ptr + 3) = *(slider_switch_ptr);

		break;
	case 4:
		printf("SW2\n");
		break;
	case 8:
		printf("SW3\n");
		break;
	case 16:
		printf("SW4\n");
		break;
	case 32:
		printf("SW5\n");
		break;
	case 64:
		printf("SW6\n");
		break;
	default:
		printf("Ninguna funci�n asignada\n");
		break;
	}

	return;
}
