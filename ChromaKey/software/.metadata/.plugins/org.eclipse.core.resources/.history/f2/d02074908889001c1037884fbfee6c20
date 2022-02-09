/*
 * HEX_PS2.c
 *
 *  Created on: 27 de oct. de 2021
 *      Author: patvalma
 */
#include "key_codes.h"
#include "system.h"
#include "key_codes.h" 	// define los valores de KEY1, KEY2, KEY3
#include "system.h"
#include "sys/alt_irq.h"

//#define BUF_SIZE 500000
//#define BUF_THRESHOLD 96

//extern volatile int tiempoHex;
//extern volatile int flagMinutos;


int HEX_PS2 (volatile int tiempoHex,volatile int flagMinutos){
	unsigned int shift_buffer, bufferPrueba, bufferH1,bufferH2, Bh1;

	int digito1;
	int digito2;
	int result;

	if(flagMinutos==0){//horas y segundos
	shift_buffer = (tiempoHex >> 16);
	bufferPrueba = shift_buffer & 0x00007F7F;

	bufferH1= bufferPrueba & 0x00007F00; //H1
	bufferH2= bufferPrueba & 0x0000007F;
	Bh1 = bufferH1 >> 8;
	} else {//minutos creo que no funciona??
			shift_buffer = (tiempoHex << 16);
			bufferPrueba = shift_buffer & 0x7F7F0000;

			bufferH1= bufferPrueba & 0x7F000000; //H1
			bufferH2= bufferPrueba & 0x007F0000;
			Bh1 = bufferH2 << 8;

	};
	switch(Bh1){
	case 0x3F : digito1=0;break;
	case 0x06 : digito1=1;break;
	case 0x5B : digito1=2;break;
	case 0x4F : digito1=3;break;
	case 0x66 : digito1=4;break;
	case 0x6D : digito1=5;break;
	case 0x7D : digito1=6;break;
	case 0x07 : digito1=7;break;
	case 0x7F : digito1=8;break;
	case 0x67 : digito1=9;break;

	default: digito1=0;
	};

	switch(bufferH2){
	case 0x3F : digito2=0;break;
	case 0x06 : digito2=1;break;
	case 0x5B : digito2=2;break;
	case 0x4F : digito2=3;break;
	case 0x66 : digito2=4;break;
	case 0x6D : digito2=5;break;
	case 0x7D : digito2=6;break;
	case 0x07 : digito2=7;break;
	case 0x7F : digito2=8;break;
	case 0x67 : digito2=9;break;
	default: digito2=0;
	};
	if(flagMinutos==0){
	result = (digito1 *10)+digito2;
	}else {
		result = (digito2*10)+digito1;
	}
	return (result);



}



