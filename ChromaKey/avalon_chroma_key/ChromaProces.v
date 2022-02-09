

module ChromaProces(	
				input wire			iCLK27,
				input wire [9:0]	imVGA_R, 				//las parte roja del pixel de la imagen.
				input wire [9:0]	imVGA_G,					//las parte verde del pixel de la imagen.
				input wire [9:0]	imVGA_B,					//las parte roja del pixel de la imagen.

				input wire [9:0] 	iRed,						//la parte roja del pixel del video que entra.
				input wire [9:0] 	iGreen,					//la parte verde del pixel del video que entra.
				input wire [9:0] 	iBlue,					//la parte azul del pixel del video que entra.
				input wire [9:0]  thG,						//threshold solo para el verde, el reto se ajustan a la mitad.
										
				input wire videoEnable, imageEnable,	//Señales de activación de video y imagen. 
				
				output [9:0] gsRed, gsGreen, gsBlue		//Salidas del chroma RGB.
		);

					

wire isGreen;			

wire [9:0] imRed, imGreen, imBlue;

/*		ANTERIOR VERSION		*/	
/*	
//wire [9:0] threshold;

//Aquí era umbral fijo, los he puesto como entradas para que sea variable
//wire [9:0] threshold_verde;
//wire [9:0] threshold_rojo;
//wire [9:0] threshold_azul;

//wire [9:0] threshold_azul = (thG << 2);
//wire [9:0] threshold_rojo = (thG << 2);

//assign isGreen = (iGreen > threshold) & (iRed < threshold) & (iBlue < threshold);

*/

assign isGreen = (iGreen > thG) & ((iGreen - iRed) > (thG >> 2)) & ((iGreen - iBlue) > (thG >> 2)); 															//true borro false lo dejo

assign imRed = imVGA_R;
assign imGreen = imVGA_G;
assign imBlue = imVGA_B;

//Decido si imagen o video

assign gsRed = (videoEnable && imageEnable) ? (isGreen ? imRed : iRed) : (videoEnable ? iRed : (imageEnable ? imRed : 10'd2)); 						//Es verde? si, entonces pongo la imagen de fondo
assign gsGreen = (videoEnable && imageEnable) ? (isGreen ? imGreen : iGreen) : (videoEnable ? iGreen : (imageEnable ? imGreen : 10'd2)); 	 		//Lo mismo verde
assign gsBlue = (videoEnable && imageEnable) ? (isGreen ? imBlue : iBlue) : (videoEnable ? iBlue : (imageEnable ? imBlue : 10'd2)); 				//Lo mismo azul

endmodule
